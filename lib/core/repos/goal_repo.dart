import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../ai/ai_features.dart';
import '../db/database.dart';
import '../logic/money.dart';
import '../logic/pace.dart';
import '../utils/time.dart';

const _uuid = Uuid();
String newId() => _uuid.v4();

const goalColors = [0xFF7B6CF6, 0xFFFFB48F, 0xFF7ED9B4, 0xFF8CC8FF, 0xFFFFD97A, 0xFFFF8A8A];
const activeGoalLimit = 5;

class GoalView {
  final Goal goal;
  final List<Stage> stages;
  final double pct;
  final double expected;
  final GoalStatus status;
  final int daysLeftN;
  final Stage? nextStage;
  final int savedPaise;
  final int monthlyNeededPaise;
  final int thisMonthPaise;
  const GoalView(this.goal, this.stages, this.pct, this.expected, this.status, this.daysLeftN, this.nextStage,
      {this.savedPaise = 0, this.monthlyNeededPaise = 0, this.thisMonthPaise = 0});
  bool get hasOverdueStage => stages.any((s) => s.status == 'open' && s.dueAt < DateTime.now().millisecondsSinceEpoch);
  bool get canReplan => status == GoalStatus.behind || status == GoalStatus.atRisk || hasOverdueStage;
}

class GoalRepo {
  final AppDb db;
  GoalRepo(this.db);

  Stream<List<GoalView>> watchViews({int Function()? clock}) {
    final trigger = db.customSelect('SELECT 1',
        readsFrom: {db.goals, db.stages, db.todos, db.moneyEntries}).watch();
    return trigger.asyncMap((_) => views(nowMs: clock?.call()));
  }

  Future<List<GoalView>> views({int? nowMs, bool includeInactive = false}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final q = db.select(db.goals)..orderBy([(g) => OrderingTerm.asc(g.priority), (g) => OrderingTerm.asc(g.deadlineAt)]);
    if (!includeInactive) q.where((g) => g.status.isIn(['active', 'paused']));
    final goals = await q.get();
    final out = <GoalView>[];
    for (final g in goals) {
      out.add(await viewFor(g, now));
    }
    return out;
  }

  Future<GoalView> viewFor(Goal g, int now) async {
    final stages = await (db.select(db.stages)
          ..where((s) => s.goalId.equals(g.id) & s.status.isNotValue('dropped'))
          ..orderBy([(s) => OrderingTerm.asc(s.dueAt), (s) => OrderingTerm.asc(s.orderIndex)]))
        .get();
    double pct;
    var saved = 0, month = 0, need = 0;
    if (g.type == 'money' && (g.targetPaise ?? 0) > 0) {
      final entries = await (db.select(db.moneyEntries)..where((e) => e.goalId.equals(g.id))).get();
      saved = goalSaved(entries.map((e) => (kind: e.kind, amountPaise: e.amountPaise)));
      pct = moneyGoalPct(saved, g.targetPaise!);
      final d = fromMs(now);
      final monthStart = toMs(DateTime.utc(d.year, d.month, 1));
      month = goalSaved(entries.where((e) => e.date >= monthStart).map((e) => (kind: e.kind, amountPaise: e.amountPaise)));
      need = monthlyNeeded(g.targetPaise!, saved, now, g.deadlineAt);
    } else {
      final inputs = <StageInput>[];
      for (final s in stages) {
        final todos = await (db.select(db.todos)..where((t) => t.stageId.equals(s.id) & t.status.isNotValue('dropped'))).get();
        inputs.add(StageInput(
          weight: s.weight,
          done: s.status == 'done',
          todosTotal: todos.length,
          todosDone: todos.where((t) => t.status == 'done').length,
        ));
      }
      pct = g.status == 'done' ? 100 : generalGoalPct(inputs);
    }
    final exp = expectedPct(g.startAt, g.deadlineAt, now);
    final next = stages.where((s) => s.status == 'open').cast<Stage?>().firstWhere((_) => true, orElse: () => null);
    return GoalView(g, stages, pct, exp, goalStatus(pct, exp), daysLeft(g.deadlineAt, now), next,
        savedPaise: saved, monthlyNeededPaise: need, thisMonthPaise: month);
  }

  Future<int> activeCount() async =>
      (await (db.select(db.goals)..where((g) => g.status.equals('active'))).get()).length;

  Future<String> create({
    required String title,
    String why = '',
    required int deadlineMs,
    String type = 'general',
    int? targetPaise,
    int priority = 3,
    int? color,
    int? nowMs,
  }) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final id = newId();
    final n = (await db.select(db.goals).get()).length;
    await db.into(db.goals).insert(GoalsCompanion.insert(
          id: id,
          title: title.trim(),
          why: Value(why.trim()),
          type: Value(type),
          targetPaise: Value(targetPaise),
          startAt: now,
          deadlineAt: deadlineMs,
          priority: Value(priority),
          color: color ?? goalColors[n % goalColors.length],
          createdAt: now,
          updatedAt: now,
        ));
    return id;
  }

  Future<void> update(String id, GoalsCompanion c) async {
    await (db.update(db.goals)..where((g) => g.id.equals(id))).write(c.copyWith(
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      digestStale: const Value(true),
    ));
  }

  Future<void> setStatus(String id, String status) async {
    await (db.update(db.goals)..where((g) => g.id.equals(id))).write(
        GoalsCompanion(status: Value(status), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.stages)..where((s) => s.goalId.equals(id))).go();
    await (db.update(db.todos)..where((t) => t.goalId.equals(id))).write(const TodosCompanion(goalId: Value(null), stageId: Value(null)));
    await (db.delete(db.goals)..where((g) => g.id.equals(id))).go();
  }

  Future<String> addStage(String goalId, {required String title, required int dueMs, int weight = 20, String doneWhen = '', String source = 'user', int? alignScore}) async {
    final id = newId();
    final count = (await (db.select(db.stages)..where((s) => s.goalId.equals(goalId))).get()).length;
    await db.into(db.stages).insert(StagesCompanion.insert(
          id: id,
          goalId: goalId,
          title: title.trim(),
          doneWhen: Value(doneWhen),
          dueAt: dueMs,
          weight: Value(weight),
          orderIndex: Value(count),
          source: Value(source),
          alignScore: Value(alignScore),
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));
    await _markStale(goalId);
    return id;
  }

  Future<void> updateStage(String id, StagesCompanion c, String goalId) async {
    await (db.update(db.stages)..where((s) => s.id.equals(id))).write(c);
    await _markStale(goalId);
  }

  Future<void> setStageDone(Stage s, bool done) async {
    await (db.update(db.stages)..where((x) => x.id.equals(s.id))).write(StagesCompanion(
      status: Value(done ? 'done' : 'open'),
      doneAt: Value(done ? DateTime.now().millisecondsSinceEpoch : null),
    ));
    await _markStale(s.goalId);
  }

  Future<void> deleteStage(Stage s) async {
    await (db.update(db.todos)..where((t) => t.stageId.equals(s.id))).write(const TodosCompanion(stageId: Value(null)));
    await (db.delete(db.stages)..where((x) => x.id.equals(s.id))).go();
    await _markStale(s.goalId);
  }

  Future<void> _markStale(String goalId) =>
      (db.update(db.goals)..where((g) => g.id.equals(goalId))).write(const GoalsCompanion(digestStale: Value(true)));

  /// Local replan: shift overdue open stages by their slip, keep the deadline. Returns number of stages changed.
  Future<int> localReplanGoal(Goal g, {int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final stages = await (db.select(db.stages)..where((s) => s.goalId.equals(g.id) & s.status.isNotValue('dropped'))).get();
    final changes = localReplan([for (final s in stages) (id: s.id, dueMs: s.dueAt, done: s.status == 'done')], now, g.deadlineAt);
    for (final e in changes.entries) {
      await (db.update(db.stages)..where((s) => s.id.equals(e.key))).write(StagesCompanion(dueAt: Value(e.value)));
    }
    if (changes.isNotEmpty) await _markStale(g.id);
    return changes.length;
  }

  /// Saves the selected part of an AI plan. Todos are returned via [onTodo] so the caller can score/insert them.
  Future<List<({String stageId, PlanTodo todo})>> applyPlan(String goalId, PlanResult plan, {String? digest}) async {
    final ids = <int, String>{};
    for (var i = 0; i < plan.stages.length; i++) {
      final s = plan.stages[i];
      if (!s.selected) continue;
      ids[i] = await addStage(goalId, title: s.title, dueMs: s.dueMs, weight: s.weight, doneWhen: s.doneWhen, source: 'ai');
    }
    final todos = <({String stageId, PlanTodo todo})>[];
    for (final t in plan.todos) {
      if (!t.selected) continue;
      final sid = ids[t.stageIndex];
      if (sid == null) continue;
      todos.add((stageId: sid, todo: t));
    }
    final d = digest ?? plan.digest;
    if (d.isNotEmpty) {
      await (db.update(db.goals)..where((g) => g.id.equals(goalId))).write(GoalsCompanion(
          digest: Value(d), digestStale: const Value(false), digestAt: Value(DateTime.now().millisecondsSinceEpoch)));
    }
    return todos;
  }

  Future<List<String>> activeDigests() async {
    final gs = await (db.select(db.goals)..where((g) => g.status.equals('active'))..orderBy([(g) => OrderingTerm.asc(g.createdAt)])).get();
    return [for (final g in gs) g.digest ?? '${g.title}. ${g.why}'];
  }

  Future<List<Goal>> activeGoalsOrdered() =>
      (db.select(db.goals)..where((g) => g.status.equals('active'))..orderBy([(g) => OrderingTerm.asc(g.createdAt)])).get();

  /// Regenerates stale digests, at most once per day per goal. Returns count refreshed.
  Future<int> refreshStaleDigests(AiFeatures? ai, {bool force = false, int? nowMs}) async {
    if (ai == null) return 0;
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    var n = 0;
    for (final g in await activeGoalsOrdered()) {
      if (!force && !(g.digestStale && (g.digestAt == null || now - g.digestAt! >= msPerDay))) continue;
      final v = await viewFor(g, now);
      try {
        final d = await ai.digest(
          goal: g.title,
          why: g.why,
          deadlineMs: g.deadlineAt,
          stages: [for (final s in v.stages) (t: s.title, dueMs: s.dueAt, done: s.status == 'done')],
          pct: v.pct.round(),
        );
        if (d != null && d.isNotEmpty) {
          await (db.update(db.goals)..where((x) => x.id.equals(g.id))).write(
              GoalsCompanion(digest: Value(d), digestStale: const Value(false), digestAt: Value(now)));
          n++;
        }
      } catch (_) {
        // background job: skip silently; event_log written by caller
      }
    }
    return n;
  }
}
