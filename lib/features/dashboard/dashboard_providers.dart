import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/providers.dart';
import '../../core/repos/goal_repo.dart';
import '../../core/services/stats_service.dart';
import '../../core/services/time_service.dart';
import '../../core/logic/money.dart';
import '../../core/logic/todo_sort.dart';
import '../../core/utils/time.dart';

Stream<void> _tick(AppDb db, Set<dynamic> tables) => db.customSelect('SELECT 1', readsFrom: {...tables}).watch().map((_) {});

final todaySummaryProvider = StreamProvider<DaySummary>((ref) {
  final db = ref.watch(dbProvider);
  final svc = ref.watch(timeServiceProvider);
  return _tick(db, {db.usageSessions, db.contentItems, db.focusSessions, db.activityDaily}).asyncMap((_) {
    final from = startOfDayMs(DateTime.now().millisecondsSinceEpoch);
    return svc.summary(from, from + msPerDay);
  });
});

final monthMoneyProvider = StreamProvider<({MonthTotals totals, int target})>((ref) {
  final db = ref.watch(dbProvider);
  return _tick(db, {db.moneyEntries, db.settings}).asyncMap((_) async {
    final d = nowIst();
    final from = toMs(DateTime.utc(d.year, d.month, 1));
    final rows = await (db.select(db.moneyEntries)..where((e) => e.date.isBiggerOrEqualValue(from))).get();
    return (
      totals: monthTotals(rows.map((e) => (kind: e.kind, amountPaise: e.amountPaise))),
      target: (await db.getSetting<int>('money.monthlyTargetPaise')) ?? 0,
    );
  });
});

final streaksProvider = StreamProvider<Streaks>((ref) {
  final db = ref.watch(dbProvider);
  final svc = ref.watch(statsServiceProvider);
  return _tick(db, {db.dailyRollup, db.eventLog, db.activityDaily}).asyncMap((_) => svc.streaks());
});

final nudgeStatsProvider = StreamProvider<({int shown, int obeyed, int blocked, int? pct})>((ref) {
  final db = ref.watch(dbProvider);
  final svc = ref.watch(statsServiceProvider);
  return _tick(db, {db.nudgeLog}).asyncMap((_) async {
    final t = await svc.nudgesToday();
    return (shown: t.shown, obeyed: t.obeyed, blocked: await svc.blockedToday(), pct: await svc.nudgesObeyedPct());
  });
});

final topTodoProvider = StreamProvider<Todo?>((ref) {
  final db = ref.watch(dbProvider);
  final repo = ref.watch(todoRepoProvider);
  return _tick(db, {db.todos}).asyncMap((_) => repo.topTodo());
});

final weeklyReviewProvider = FutureProvider.autoDispose<WeeklyReview?>((ref) {
  return ref.watch(statsServiceProvider).cachedReview(DateTime.now().millisecondsSinceEpoch);
});

final goalViewsListProvider = Provider<List<GoalView>>((ref) => ref.watch(goalViewsProvider).value ?? const []);

({String title, int score})? higherValueWarningFor(int? startingScore, List<Todo> open, String startingId) {
  final w = higherValueWarning(startingScore, [for (final t in open) SortableTodo(t.id, t.title, t.score, t.dueAt, t.estimateMin)], startingId: startingId);
  return w == null ? null : (title: w.title, score: w.score ?? 0);
}
