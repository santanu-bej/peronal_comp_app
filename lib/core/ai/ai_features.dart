import 'dart:convert';
import '../logic/local_scorer.dart';
import '../logic/todo_sort.dart';
import '../utils/time.dart';
import 'ai_client.dart';
import 'prompts.dart';
import 'schemas.dart';

String _j(Object o) => jsonEncode(o); // jsonEncode emits no whitespace

// ---------- A1 plan ----------
class PlanStage {
  String title;
  int dueMs;
  int weight;
  String doneWhen;
  bool selected = true;
  PlanStage(this.title, this.dueMs, this.weight, this.doneWhen);
}

class PlanTodo {
  String title;
  int stageIndex;
  int estimateMin;
  bool selected = true;
  PlanTodo(this.title, this.stageIndex, this.estimateMin);
}

class PlanResult {
  final List<PlanStage> stages;
  final List<PlanTodo> todos;
  final String digest;
  final int tokens;
  PlanResult(this.stages, this.todos, this.digest, this.tokens);
}

int? _parseDate(Object? v) {
  if (v is! String) return null;
  final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(v.trim());
  if (m == null) return null;
  return toMs(DateTime.utc(int.parse(m.group(1)!), int.parse(m.group(2)!), int.parse(m.group(3)!)));
}

/// Validates + post-processes the A1 tool input: drops invalid items, clamps dates into
/// [todayMs, deadlineMs], sorts stages, normalises weights to 100, rounds estimates.
PlanResult parsePlan(Map<String, dynamic> input, {required int todayMs, required int deadlineMs, int tokens = 0}) {
  final stages = <PlanStage>[];
  final origIndex = <int>[]; // original index per kept stage
  final rawStages = (input['stages'] as List?) ?? [];
  for (var i = 0; i < rawStages.length; i++) {
    final s = rawStages[i];
    if (s is! Map) continue;
    final t = s['t'];
    final due = _parseDate(s['due']);
    final w = s['w'];
    if (t is! String || t.trim().isEmpty || due == null || w is! num) continue;
    final clamped = due.clamp(todayMs, deadlineMs);
    stages.add(PlanStage(t.trim(), clamped, w.toInt().clamp(1, 100), (s['done_when'] as String?) ?? ''));
    origIndex.add(i);
  }
  final order = List.generate(stages.length, (i) => i)..sort((a, b) => stages[a].dueMs.compareTo(stages[b].dueMs));
  final sorted = [for (final i in order) stages[i]];
  final remap = <int, int>{for (var n = 0; n < order.length; n++) origIndex[order[n]]: n};
  final total = sorted.fold<int>(0, (a, s) => a + s.weight);
  if (total > 0) {
    var acc = 0;
    for (var i = 0; i < sorted.length; i++) {
      if (i == sorted.length - 1) {
        sorted[i].weight = 100 - acc;
      } else {
        sorted[i].weight = (sorted[i].weight * 100 / total).round().clamp(1, 100);
        acc += sorted[i].weight;
      }
    }
  }
  final todos = <PlanTodo>[];
  for (final t in (input['todos'] as List?) ?? []) {
    if (t is! Map) continue;
    final title = t['t'];
    final si = t['stage'];
    final e = t['e'];
    if (title is! String || title.trim().isEmpty || si is! int || e is! num) continue;
    final mapped = remap[si];
    if (mapped == null) continue;
    todos.add(PlanTodo(title.trim(), mapped, roundEstimate(e.toInt())));
  }
  return PlanResult(sorted, todos, (input['digest'] as String?) ?? '', tokens);
}

class AiFeatures {
  final AiClient ai;
  AiFeatures(this.ai);

  Future<PlanResult> plan({
    required String title,
    required String why,
    required int deadlineMs,
    required String type,
    int? targetPaise,
    String aboutMe = '',
    List<String> otherGoals = const [],
    bool confirmed = false,
    int? nowMs,
  }) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final today = startOfDayMs(now);
    final user = <String, Object?>{
      'goal': title,
      'why': why,
      'deadline': dateKey(deadlineMs),
      'type': type,
      if (targetPaise != null) 'target': targetPaise ~/ 100,
      if (aboutMe.isNotEmpty) 'ctx': aboutMe,
      if (otherGoals.isNotEmpty) 'other_goals': otherGoals,
    };
    final model = await ai.modelFor('plan');
    final r = await ai.callTool<Map<String, dynamic>>(
      feature: 'plan',
      model: model,
      system: planSystem(dateKey(now)),
      userContent: _j(user),
      tool: planTool,
      maxTokens: 1400,
      parse: (m) => m,
      confirmed: confirmed,
      estimateInput: 600,
      timeout: const Duration(seconds: 40),
    );
    final res = parsePlan(r.value, todayMs: today, deadlineMs: deadlineMs, tokens: r.usage.total);
    if (res.stages.isEmpty) {
      throw const AiException('The AI returned an empty plan. Tap retry.', retryable: true);
    }
    return res;
  }

  Future<String?> digest({
    required String goal,
    required String why,
    required int deadlineMs,
    required List<({String t, int dueMs, bool done})> stages,
    required int pct,
  }) async {
    final user = {
      'goal': goal,
      'why': why,
      'deadline': dateKey(deadlineMs),
      'stages': [for (final s in stages) {'t': s.t, 'due': dateKey(s.dueMs), 's': s.done ? 'done' : 'open'}],
      'pct': pct,
    };
    final r = await ai.callTool<String?>(
      feature: 'digest',
      model: await ai.modelFor('digest'),
      system: digestSystem,
      userContent: _j(user),
      tool: digestTool,
      maxTokens: 220,
      parse: (m) => m['digest'] is String ? m['digest'] as String : null,
      estimateInput: 500,
    );
    return r.value;
  }

  /// A3. [items] = (title, estimateMin). Returns per-item results by index; missing/invalid items are absent.
  Future<Map<int, ({int score, int? goalIndex, String reason})>> align(
    List<({String title, int estimateMin})> items,
    List<String> digests, {
    int? nowMs,
  }) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final user = {
      'today': dateKey(now),
      'items': [for (var i = 0; i < items.length; i++) {'i': i, 't': items[i].title, 'e': items[i].estimateMin}],
    };
    final r = await ai.callTool<Map<int, ({int score, int? goalIndex, String reason})>>(
      feature: 'align',
      model: await ai.modelFor('align'),
      system: alignSystem(digests),
      userContent: _j(user),
      tool: scoresTool,
      maxTokens: 60 + 70 * items.length,
      estimateInput: 250 + 40 * items.length,
      parse: (m) {
        final out = <int, ({int score, int? goalIndex, String reason})>{};
        for (final x in (m['r'] as List?) ?? []) {
          if (x is! Map) continue;
          final i = x['i'], s = x['s'];
          if (i is! int || s is! num || i < 0 || i >= items.length) continue;
          int? gi;
          final g = x['g'];
          if (g is String) {
            final mm = RegExp(r'^G(\d+)$').firstMatch(g);
            if (mm != null) {
              final n = int.parse(mm.group(1)!) - 1;
              if (n >= 0 && n < digests.length) gi = n;
            }
          }
          out[i] = (score: s.toInt().clamp(0, 100), goalIndex: gi, reason: (x['why'] as String?) ?? '');
        }
        return out;
      },
    );
    return r.value;
  }

  Future<ReplanResult> replan(Map<String, Object?> payload, {required int todayMs, required int deadlineMs}) async {
    final r = await ai.callTool<Map<String, dynamic>>(
      feature: 'replan',
      model: await ai.modelFor('replan'),
      system: replanSystem,
      userContent: _j(payload),
      tool: replanTool,
      maxTokens: 900,
      estimateInput: 700,
      parse: (m) => m,
    );
    return ReplanResult.parse(r.value, todayMs, deadlineMs);
  }

  /// A5. Returns i -> class. Items = (platform, title, channel).
  Future<Map<int, String>> classify(List<({String p, String t, String? c})> items) async {
    final user = {
      'items': [for (var i = 0; i < items.length; i++) {'i': i, 'p': items[i].p, 't': items[i].t, if (items[i].c != null) 'c': items[i].c}],
    };
    const ok = {'work', 'learning', 'entertainment', 'social', 'other'};
    final r = await ai.callTool<Map<int, String>>(
      feature: 'classify',
      model: await ai.modelFor('classify'),
      system: classifySystem,
      userContent: _j(user),
      tool: classesTool,
      maxTokens: 10 * items.length + 20,
      estimateInput: 120 + 15 * items.length,
      parse: (m) {
        final out = <int, String>{};
        for (final x in (m['r'] as List?) ?? []) {
          if (x is Map && x['i'] is int && ok.contains(x['c'])) out[x['i'] as int] = x['c'] as String;
        }
        return out;
      },
    );
    return r.value;
  }

  Future<({List<String> insights, List<String> actions})> review(Map<String, Object?> numbers) async {
    final r = await ai.callTool<({List<String> insights, List<String> actions})>(
      feature: 'review',
      model: await ai.modelFor('review'),
      system: reviewSystem,
      userContent: _j(numbers),
      tool: reviewTool,
      maxTokens: 450,
      estimateInput: 900,
      parse: (m) => (
        insights: [for (final x in (m['insights'] as List?) ?? []) if (x is String) x],
        actions: [for (final x in (m['actions'] as List?) ?? []) if (x is String) x],
      ),
    );
    return r.value;
  }
}

class ReplanResult {
  final String summary;
  final List<({int stage, int? dueMs, String? title, bool drop})> changes;
  final List<({String title, int dueMs, int weight})> add;
  final List<({String title, int stage, int estimateMin})> newTodos;
  final int? moveDeadlineMs;
  ReplanResult(this.summary, this.changes, this.add, this.newTodos, this.moveDeadlineMs);

  static ReplanResult parse(Map<String, dynamic> m, int todayMs, int deadlineMs) {
    final changes = <({int stage, int? dueMs, String? title, bool drop})>[];
    for (final c in (m['changes'] as List?) ?? []) {
      if (c is! Map || c['stage'] is! int) continue;
      final d = _parseDate(c['due']);
      changes.add((stage: c['stage'] as int, dueMs: d?.clamp(todayMs, deadlineMs), title: c['t'] as String?, drop: c['drop'] == true));
    }
    final add = <({String title, int dueMs, int weight})>[];
    for (final a in ((m['add'] as List?) ?? []).take(2)) {
      if (a is! Map || a['t'] is! String) continue;
      final d = _parseDate(a['due']);
      if (d == null) continue;
      add.add((title: a['t'] as String, dueMs: d.clamp(todayMs, deadlineMs), weight: ((a['w'] as num?) ?? 10).toInt().clamp(1, 100)));
    }
    final todos = <({String title, int stage, int estimateMin})>[];
    for (final t in ((m['new_todos'] as List?) ?? []).take(4)) {
      if (t is! Map || t['t'] is! String || t['stage'] is! int) continue;
      todos.add((title: t['t'] as String, stage: t['stage'] as int, estimateMin: roundEstimate(((t['e'] as num?) ?? 30).toInt())));
    }
    return ReplanResult((m['summary'] as String?) ?? '', changes, add, todos, _parseDate(m['move_deadline']));
  }
}

/// Local-first routing for todo scoring (PRD F2.2). [aiAlign] is invoked only for items the local scorer isn't sure about.
class ScoredItem {
  final int score;
  final String source; // cache | rule | ai
  final String reason;
  final int? goalIndex;
  final bool rough;
  const ScoredItem(this.score, this.source, this.reason, this.goalIndex, {this.rough = false});
}

Future<List<ScoredItem>> scoreBatch({
  required List<({String title, int estimateMin})> items,
  required List<String> digests,
  required Future<ScoredItem?> Function(String title)? cacheLookup,
  required Future<Map<int, ({int score, int? goalIndex, String reason})>> Function(List<({String title, int estimateMin})>)? aiAlign,
}) async {
  final out = List<ScoredItem?>.filled(items.length, null);
  final pending = <int>[];
  final locals = <int, LocalScore>{};
  for (var i = 0; i < items.length; i++) {
    final c = cacheLookup == null ? null : await cacheLookup(items[i].title);
    if (c != null) {
      out[i] = c;
      continue;
    }
    final l = scoreLocally(items[i].title, items[i].estimateMin, digests);
    locals[i] = l;
    if (l.confident) {
      out[i] = ScoredItem(l.score, 'rule', l.reason, l.goalIndex);
    } else {
      pending.add(i);
    }
  }
  if (pending.isNotEmpty && aiAlign != null) {
    try {
      final res = await aiAlign([for (final i in pending) items[i]]);
      for (var k = 0; k < pending.length; k++) {
        final r = res[k];
        final i = pending[k];
        if (r != null) out[i] = ScoredItem(r.score, 'ai', r.reason, r.goalIndex);
      }
    } on AiException {
      // fall through to rough local scores
    }
  }
  for (var i = 0; i < items.length; i++) {
    out[i] ??= ScoredItem(locals[i]!.score, 'rule', locals[i]!.reason, locals[i]!.goalIndex, rough: true);
  }
  return out.cast<ScoredItem>();
}
