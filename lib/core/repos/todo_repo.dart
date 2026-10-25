import 'dart:convert';
import 'package:drift/drift.dart';
import '../ai/ai_client.dart';
import '../ai/ai_features.dart';
import '../db/database.dart';
import '../logic/recurrence.dart';
import '../logic/todo_sort.dart';
import '../utils/hash.dart';
import '../utils/time.dart';
import 'goal_repo.dart';

class NewTodo {
  final String title;
  final int estimateMin;
  final int? dueMs;
  final int? remindMs;
  final String? goalId;
  final String? stageId;
  final Recurrence recurrence;
  const NewTodo(this.title, {this.estimateMin = 30, this.dueMs, this.remindMs, this.goalId, this.stageId, this.recurrence = Recurrence.none});
}

class ScorePreview {
  final int score;
  final String label; // quick score | AI score | rough
  final String reason;
  final String? goalId;
  final String source;
  const ScorePreview(this.score, this.label, this.reason, this.goalId, this.source);
}

class TodoRepo {
  final AppDb db;
  final GoalRepo goals;
  final AiClient? ai;
  final AiFeatures? features;
  TodoRepo(this.db, this.goals, {this.ai, this.features});

  Stream<List<Todo>> watchAll() => db.select(db.todos).watch();

  Future<List<Todo>> open() => (db.select(db.todos)..where((t) => t.status.equals('open'))).get();

  List<SortableTodo> asSortable(List<Todo> t) =>
      [for (final x in t) SortableTodo(x.id, x.title, x.score, x.dueAt, x.estimateMin)];

  Future<Todo?> topTodo({int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final list = await open();
    if (list.isEmpty) return null;
    final sorted = sortTodos(asSortable(list), now, startOfDayMs(now));
    return list.firstWhere((t) => t.id == sorted.first.id);
  }

  Future<List<Todo>> topN(int n, {int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final list = await open();
    final sorted = sortTodos(asSortable(list), now, startOfDayMs(now));
    return [for (final s in sorted.take(n)) list.firstWhere((t) => t.id == s.id)];
  }

  Future<ScoreItemCache?> _cached(String title) async {
    final h = normHash(title);
    final row = await (db.select(db.aiCache)..where((c) => c.key.equals('score:$h'))).getSingleOrNull();
    if (row == null) return null;
    final m = jsonDecode(row.responseJson) as Map<String, dynamic>;
    return ScoreItemCache(m['s'] as int, m['g'] as int?, (m['r'] as String?) ?? '');
  }

  Future<void> _putCache(String title, ScoredItem s) async {
    if (s.rough) return;
    final h = normHash(title);
    await db.into(db.aiCache).insertOnConflictUpdate(AiCacheCompanion.insert(
          key: 'score:$h',
          kind: 'score',
          responseJson: jsonEncode({'s': s.score, 'g': s.goalIndex, 'r': s.reason}),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          expiresAt: Value(DateTime.now().millisecondsSinceEpoch + 180 * msPerDay),
        ));
  }

  /// Scores [items] with the order: cache → local rules → ONE batched AI call. [useAi] false = local only.
  Future<List<ScorePreview>> score(List<NewTodo> items, {bool useAi = true}) async {
    final digests = await goals.activeDigests();
    final goalList = await goals.activeGoalsOrdered();
    final aiOn = useAi && ai != null && features != null && await ai!.isEnabled();
    final res = await scoreBatch(
      items: [for (final i in items) (title: i.title, estimateMin: i.estimateMin)],
      digests: digests,
      cacheLookup: (t) async {
        final c = await _cached(t);
        return c == null ? null : ScoredItem(c.score, 'cache', c.reason, c.goalIndex);
      },
      aiAlign: aiOn ? (p) => features!.align(p, digests) : null,
    );
    final out = <ScorePreview>[];
    for (var i = 0; i < items.length; i++) {
      final r = res[i];
      await _putCache(items[i].title, r);
      final gid = r.goalIndex != null && r.goalIndex! < goalList.length ? goalList[r.goalIndex!].id : null;
      final label = r.source == 'ai' ? 'AI score' : r.rough ? 'rough' : 'quick score';
      out.add(ScorePreview(r.score, label, r.reason, gid, r.source));
    }
    return out;
  }

  Future<List<String>> addMany(List<NewTodo> items, {List<ScorePreview>? scores, bool useAi = true}) async {
    final sc = scores ?? await score(items, useAi: useAi);
    final ids = <String>[];
    final now = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < items.length; i++) {
      final t = items[i];
      final s = sc[i];
      final id = newId();
      await db.into(db.todos).insert(TodosCompanion.insert(
            id: id,
            title: t.title.trim(),
            normHash: normHash(t.title),
            goalId: Value(t.goalId ?? s.goalId),
            stageId: Value(t.stageId),
            estimateMin: Value(t.estimateMin),
            dueAt: Value(t.dueMs),
            remindAt: Value(t.remindMs),
            recurrence: Value(t.recurrence.name),
            score: Value(s.score),
            scoreSource: Value(s.source),
            reason: Value(s.reason),
            createdAt: now,
          ));
      ids.add(id);
    }
    return ids;
  }

  Future<void> update(String id, TodosCompanion c) => (db.update(db.todos)..where((t) => t.id.equals(id))).write(c);

  Future<void> delete(String id) => (db.delete(db.todos)..where((t) => t.id.equals(id))).go();

  /// Marks done; for recurring todos creates the next instance. Returns the new todo id if any.
  Future<String?> complete(Todo t, {int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    await update(t.id, TodosCompanion(status: const Value('done'), doneAt: Value(now)));
    return _spawnNext(t, now);
  }

  Future<void> reopen(String id) => update(id, const TodosCompanion(status: Value('open'), doneAt: Value(null)));

  Future<String?> _spawnNext(Todo t, int now) async {
    final r = recurrenceFrom(t.recurrence);
    if (r == Recurrence.none) return null;
    final base = t.dueAt ?? startOfDayMs(now) + 9 * 3600000;
    final next = nextOccurrence(r, base, now);
    if (next == null) return null;
    final shift = next - base;
    final id = newId();
    await db.into(db.todos).insert(TodosCompanion.insert(
          id: id,
          title: t.title,
          normHash: t.normHash,
          goalId: Value(t.goalId),
          stageId: Value(t.stageId),
          estimateMin: Value(t.estimateMin),
          dueAt: Value(next),
          remindAt: Value(t.remindAt == null ? null : t.remindAt! + shift),
          recurrence: Value(t.recurrence),
          score: Value(t.score),
          scoreSource: Value(t.scoreSource),
          reason: Value(t.reason),
          createdAt: now,
        ));
    return id;
  }

  /// Daily maintenance: open recurring todos whose day has passed spawn the next instance (once).
  Future<int> rollRecurring({int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final today = startOfDayMs(now);
    final all = await db.select(db.todos).get();
    var n = 0;
    for (final t in all) {
      if (t.status != 'open' || t.recurrence == 'none' || t.dueAt == null || t.dueAt! >= today) continue;
      final dup = all.any((o) => o.id != t.id && o.status == 'open' && o.normHash == t.normHash && o.recurrence != 'none' && (o.dueAt ?? 0) >= today);
      await update(t.id, const TodosCompanion(status: Value('dropped')));
      if (!dup) {
        await _spawnNext(t, now);
        n++;
      }
    }
    return n;
  }
}

class ScoreItemCache {
  final int score;
  final int? goalIndex;
  final String reason;
  ScoreItemCache(this.score, this.goalIndex, this.reason);
}
