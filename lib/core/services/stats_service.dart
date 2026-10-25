import 'package:drift/drift.dart';
import 'dart:convert';
import '../ai/ai_features.dart';
import '../db/database.dart';
import '../logic/money.dart';
import '../logic/pace.dart';
import '../repos/goal_repo.dart';
import '../utils/time.dart';

class Streaks {
  final int wake, deepWork, steps;
  const Streaks(this.wake, this.deepWork, this.steps);
}

class WakeDay {
  final String day;
  final int lateMin;
  final bool escalated;
  const WakeDay(this.day, this.lateMin, this.escalated);
}

class WeeklyReview {
  final List<String> insights, actions;
  final bool fromAi;
  final String weekKey;
  const WeeklyReview(this.insights, this.actions, this.fromAi, this.weekKey);
  Map<String, Object?> toJson() => {'insights': insights, 'actions': actions, 'ai': fromAi, 'week': weekKey};
  static WeeklyReview? from(Map<String, dynamic>? m) => m == null
      ? null
      : WeeklyReview((m['insights'] as List).cast<String>(), (m['actions'] as List).cast<String>(), m['ai'] == true, m['week'] as String);
}

/// ISO week key like 2026-W43.
String isoWeekKey(int ms) {
  final d = fromMs(ms);
  final thursday = d.add(Duration(days: 4 - d.weekday));
  final jan1 = DateTime.utc(thursday.year, 1, 1);
  final week = ((thursday.difference(jan1).inDays) / 7).floor() + 1;
  return '${thursday.year}-W${week.toString().padLeft(2, '0')}';
}

/// Consecutive days ending today (or yesterday if today isn't complete) where [ok] is true.
int streakOf(bool Function(String day) ok, int nowMs, {int maxDays = 365}) {
  var n = 0;
  var day = startOfDayMs(nowMs);
  if (!ok(dateKey(day))) day -= msPerDay; // today may still be in progress
  while (n < maxDays && ok(dateKey(day))) {
    n++;
    day -= msPerDay;
  }
  return n;
}

class StatsService {
  final AppDb db;
  StatsService(this.db);

  Future<List<WakeDay>> wakeHistory({int days = 60}) async {
    final rows = await (db.select(db.eventLog)..where((e) => e.source.equals('wake') & e.message.equals('Proof done'))).get();
    final out = <WakeDay>[];
    for (final r in rows) {
      final m = r.dataJson == null ? <String, dynamic>{} : jsonDecode(r.dataJson!) as Map<String, dynamic>;
      out.add(WakeDay(dateKey(r.at), (m['lateMin'] as num?)?.toInt() ?? 0, m['escalated'] == true));
    }
    return out;
  }

  Future<Streaks> streaks({int? nowMs, int stepTarget = 8000}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final wake = {for (final w in await wakeHistory()) if (w.lateMin <= 5 && !w.escalated) w.day};
    final rollups = {for (final r in await db.select(db.dailyRollup).get()) r.date: r};
    final acts = {for (final a in await db.select(db.activityDaily).get()) a.date: a};
    return Streaks(
      streakOf(wake.contains, now),
      streakOf((d) => ((rollups[d]?.workMin ?? 0) + (rollups[d]?.learningMin ?? 0)) >= 120, now),
      streakOf((d) => (acts[d]?.steps ?? 0) >= stepTarget, now),
    );
  }

  Future<int?> nudgesObeyedPct({int? sinceMs}) async {
    final since = sinceMs ?? 0;
    final rows = await (db.select(db.nudgeLog)..where((n) => n.at.isBiggerOrEqualValue(since) & n.type.isNotValue('block'))).get();
    if (rows.isEmpty) return null;
    final obeyed = rows.where((r) => r.action == 'opened').length;
    return (obeyed * 100 / rows.length).round();
  }

  Future<({int shown, int obeyed})> nudgesToday({int? nowMs}) async {
    final from = startOfDayMs(nowMs ?? DateTime.now().millisecondsSinceEpoch);
    final rows = await (db.select(db.nudgeLog)..where((n) => n.at.isBiggerOrEqualValue(from) & n.action.isNotValue('blocked'))).get();
    return (shown: rows.length, obeyed: rows.where((r) => r.action == 'opened').length);
  }

  Future<int> blockedToday({int? nowMs}) async {
    final from = startOfDayMs(nowMs ?? DateTime.now().millisecondsSinceEpoch);
    return (await (db.select(db.nudgeLog)..where((n) => n.at.isBiggerOrEqualValue(from) & n.action.equals('blocked'))).get()).length;
  }

  // ---------- weekly review (A6) ----------
  Future<Map<String, Object?>> weeklyNumbers(List<GoalView> goals, {int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final today = startOfDayMs(now);
    Future<Map<String, int>> cats(int from, int to) async {
      final rows = await (db.select(db.dailyRollup)..where((r) => r.date.isBiggerOrEqualValue(dateKey(from)) & r.date.isSmallerThanValue(dateKey(to)))).get();
      final out = <String, int>{};
      var wasted = 0;
      for (final r in rows) {
        (jsonDecode(r.minutesByCategoryJson) as Map<String, dynamic>).forEach((k, v) => out[k] = (out[k] ?? 0) + (v as num).toInt());
        wasted += r.wastedMin;
      }
      out['_wasted'] = wasted;
      return out;
    }

    final thisW = await cats(today - 6 * msPerDay, today + msPerDay);
    final lastW = await cats(today - 13 * msPerDay, today - 6 * msPerDay);
    final apps = <String, int>{};
    for (final r in await (db.select(db.dailyRollup)..where((r) => r.date.isBiggerOrEqualValue(dateKey(today - 6 * msPerDay)))).get()) {
      for (final a in jsonDecode(r.topAppsJson) as List) {
        apps[a['pkg'] as String] = (apps[a['pkg'] as String] ?? 0) + (a['min'] as num).toInt();
      }
    }
    final topApps = (apps.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).take(5);
    final wakeOk = (await wakeHistory()).where((w) => msFromDateKey(w.day) > today - 7 * msPerDay && w.lateMin <= 5 && !w.escalated).map((w) => w.day).toSet().length;
    final nudges = await db.select(db.nudgeLog).get();
    final weekNudges = nudges.where((n) => n.at >= today - 6 * msPerDay && n.action != 'blocked').toList();
    final acts = await (db.select(db.activityDaily)..where((a) => a.date.isBiggerOrEqualValue(dateKey(today - 6 * msPerDay)))).get();
    final done = await (db.select(db.todos)..where((t) => t.status.equals('done') & t.doneAt.isBiggerOrEqualValue(today - 6 * msPerDay))).get();
    final month = fromMs(now);
    final mStart = toMs(DateTime.utc(month.year, month.month, 1));
    final money = await (db.select(db.moneyEntries)..where((e) => e.date.isBiggerOrEqualValue(mStart))).get();
    final mt = monthTotals(money.map((e) => (kind: e.kind, amountPaise: e.amountPaise)));
    return {
      'goals': [for (final g in goals) {'g': g.goal.digest ?? g.goal.title, 'pct': g.pct.round(), 'exp': g.expected.round(), 's': g.status.label}],
      'min': thisW..remove('_wasted'),
      'minPrev': lastW..remove('_wasted'),
      'wasted': thisW['_wasted'] ?? await _wastedOf(thisW),
      'wastedPrev': lastW['_wasted'] ?? 0,
      'topApps': [for (final a in topApps) {'p': a.key, 'm': a.value}],
      'wakeOnTime': '$wakeOk/7',
      'nudges': {'shown': weekNudges.length, 'obeyed': weekNudges.where((n) => n.action == 'opened').length},
      'stepsAvg': acts.isEmpty ? 0 : acts.fold<int>(0, (a, b) => a + b.steps) ~/ acts.length,
      'moneySaved': mt.saved ~/ 100,
      'moneyTarget': ((await db.getSetting<int>('money.monthlyTargetPaise')) ?? 0) ~/ 100,
      'todosDone': {'n': done.length, 'avgScore': done.isEmpty ? 0 : done.fold<int>(0, (a, b) => a + (b.score ?? 0)) ~/ done.length},
    };
  }

  Future<int> _wastedOf(Map<String, int> m) async => (m['entertainment'] ?? 0) + (m['social'] ?? 0);

  /// Numbers-only fallback: the same metrics with arrows and the 3 biggest changes.
  WeeklyReview numbersOnlyReview(Map<String, Object?> n, String weekKey) {
    final cur = Map<String, int>.from((n['min'] as Map).map((k, v) => MapEntry(k as String, (v as num).toInt())));
    final prev = Map<String, int>.from((n['minPrev'] as Map).map((k, v) => MapEntry(k as String, (v as num).toInt())));
    final keys = {...cur.keys, ...prev.keys};
    final changes = [for (final k in keys) (k, (cur[k] ?? 0) - (prev[k] ?? 0))]..sort((a, b) => b.$2.abs().compareTo(a.$2.abs()));
    String arrow(int d) => d > 0 ? '↑' : d < 0 ? '↓' : '→';
    final insights = [
      for (final c in changes.take(3)) '${c.$1}: ${cur[c.$1] ?? 0} min ${arrow(c.$2)} ${c.$2.abs()} vs last week',
    ];
    while (insights.length < 3) {
      insights.add('Wasted ${n['wasted']} min this week (${n['wastedPrev']} last week)');
    }
    final goals = (n['goals'] as List).cast<Map>();
    final behind = goals.where((g) => g['s'] == 'Behind' || g['s'] == 'At risk').length;
    return WeeklyReview(insights, [
      behind > 0 ? '$behind goal(s) behind pace: replan or add focus time.' : 'Goals on pace: keep this week’s rhythm.',
      'Wake on time: ${n['wakeOnTime']} days.',
      'Todos done: ${(n['todosDone'] as Map)['n']}, average score ${(n['todosDone'] as Map)['avgScore']}.',
    ], false, weekKey);
  }

  Future<WeeklyReview?> cachedReview(int nowMs) async {
    final r = WeeklyReview.from(await db.getSetting<Map<String, dynamic>>('review.cache'));
    return r != null && r.weekKey == isoWeekKey(nowMs) ? r : null;
  }

  /// At most one AI call per ISO week unless [force].
  Future<WeeklyReview> review(AiFeatures? ai, List<GoalView> goals, {bool force = false, int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    if (!force) {
      final c = await cachedReview(now);
      if (c != null) return c;
    }
    final wk = isoWeekKey(now);
    final numbers = await weeklyNumbers(goals, nowMs: now);
    WeeklyReview r;
    try {
      if (ai == null) throw StateError('no ai');
      final res = await ai.review(numbers);
      if (res.insights.length < 3 || res.actions.length < 3) throw StateError('incomplete');
      r = WeeklyReview(res.insights.take(3).toList(), res.actions.take(3).toList(), true, wk);
    } catch (_) {
      r = numbersOnlyReview(numbers, wk);
    }
    await db.setSetting('review.cache', r.toJson());
    return r;
  }
}
