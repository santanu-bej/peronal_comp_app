import 'dart:async';
import 'package:drift/drift.dart';
import '../db/database.dart';
import '../logic/alert_builder.dart';
import '../logic/guard_config.dart';
import '../native/native_bridge.dart';
import '../native/native_models.dart';
import '../native/secrets.dart';
import '../repos/goal_repo.dart';
import '../repos/routine_repo.dart';
import '../repos/todo_repo.dart';
import 'time_service.dart';

/// Pushes the whole plan into native storage: alerts, wake routines, guard config, top tasks.
/// Always full replacement (docs/ARCHITECTURE.md §7), debounced 500 ms.
class NativeSync {
  final AppDb db;
  final NativeBridge bridge;
  final GoalRepo goals;
  final TodoRepo todos;
  final RoutineRepo routines;
  final TimeService time;
  final Secrets secrets;
  Timer? _t;
  StreamSubscription? _sub;

  NativeSync(this.db, this.bridge, this.goals, this.todos, this.routines, this.time, this.secrets);

  /// Watches every table that feeds native state and syncs after changes settle.
  void start() {
    _sub?.cancel();
    _sub = db
        .tableUpdates(TableUpdateQuery.onAllTables([db.goals, db.stages, db.todos, db.routines, db.contacts, db.settings, db.appCategories]))
        .listen((_) => schedule());
    schedule();
  }

  void dispose() {
    _t?.cancel();
    _sub?.cancel();
  }

  void schedule() {
    _t?.cancel();
    _t = Timer(const Duration(milliseconds: 500), () => syncNow());
  }

  Future<void> syncNow() async {
    try {
      await _alerts();
      await _wake();
      await _guard();
      await _top();
      await _secrets();
    } catch (e) {
      await db.log('sync', 'Native sync failed: $e', level: 'error');
    }
  }

  Future<void> _alerts() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final open = await todos.open();
    final gs = {for (final g in await db.select(db.goals).get()) g.id: g};
    final stages = await (db.select(db.stages)..where((s) => s.status.equals('open'))).get();
    final top = await todos.topN(3);
    final dailyOn = (await db.getSetting<bool>('daily.enabled')) ?? true;
    final focusStage = stages.isEmpty
        ? null
        : (([...stages]..sort((a, b) => a.dueAt.compareTo(b.dueAt))).where((s) => gs[s.goalId]?.status == 'active').firstOrNull)?.title;
    final list = buildAlerts(
      openTodos: [for (final t in open) AlertTodo(t.id, t.title, t.remindAt, t.score, gs[t.goalId]?.title)],
      openStages: [
        for (final s in stages)
          if (gs[s.goalId]?.status == 'active') AlertStage(s.id, s.title, gs[s.goalId]!.title, s.dueAt)
      ],
      topThree: [for (final t in top) '${t.title} (${t.score ?? '–'})'],
      focusStage: focusStage,
      nowMs: now,
      dailyFocusHhmm: dailyOn ? ((await db.getSetting<String>('daily.time')) ?? '08:00') : null,
    );
    await bridge.syncAlerts(list);
  }

  Future<void> _wake() async => bridge.syncWake(await routines.wakeItems());

  Future<GuardSettings> guardSettings() async => GuardSettings.fromJson(await db.getSetting<Map<String, dynamic>>('guard'));

  Future<void> _guard() async {
    final g = await guardSettings();
    final views = await goals.views();
    final active = views.where((v) => v.goal.status == 'active').toList();
    final top = active.isEmpty ? null : active.first;
    final name = (await db.getSetting<String>('user.name')) ?? 'Santanu';
    await bridge.setGuardConfig(g.toNative(
      categories: await time.allCategories(),
      userName: name,
      goalTitle: top?.goal.title,
      goalPct: top?.pct.round(),
      goalDays: top?.daysLeftN,
    ));
  }

  Future<void> _top() async {
    final top = await todos.topN(5);
    await bridge.setTopTasks([for (final t in top) TopTask(t.id, t.title, t.score ?? 0)]);
  }

  Future<void> _secrets() async {
    await bridge.setSecrets(
      whatsappToken: await secrets.whatsappToken(),
      phoneNumberId: await db.getSetting<String>('wa.phoneId'),
      template: (await db.getSetting<String>('wa.template')) ?? 'wake_alert',
      lang: (await db.getSetting<String>('wa.lang')) ?? 'en',
      graphVersion: (await db.getSetting<String>('wa.graph')) ?? 'v21.0',
    );
  }
}
