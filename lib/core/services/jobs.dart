import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import '../db/database.dart';
import '../providers.dart';
import '../utils/time.dart';

const jobAggregate = 'aggregate';
const jobDaily = 'daily_maintenance';
const jobClassify = 'content_classify';
const jobWeekly = 'weekly_review';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, input) async {
    WidgetsFlutterBinding.ensureInitialized();
    final db = AppDb();
    final c = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    try {
      await runJob(c, task);
      return true;
    } catch (e) {
      await db.log('sync', 'Job $task failed: $e', level: 'error');
      return true; // don't let WorkManager back off aggressively; next run retries
    } finally {
      c.dispose();
      await db.close();
    }
  });
}

/// Idempotent job bodies (cursors live in settings).
Future<void> runJob(ProviderContainer c, String task) async {
  final db = c.read(dbProvider);
  switch (task) {
    case jobAggregate:
      final n = await c.read(timeServiceProvider).aggregate();
      await c.read(activityServiceProvider).refreshToday();
      await c.read(nativeSyncProvider).syncNow();
      if (n > 0) await db.log('sync', 'Aggregated $n usage sessions');
    case jobDaily:
      final todos = await c.read(todoRepoProvider).rollRecurring();
      final money = await c.read(moneyRepoProvider).applyRecurring();
      await c.read(timeServiceProvider).retention();
      await c.read(backupServiceProvider).snapshotNow();
      final ai = await c.read(aiClientProvider).isEnabled();
      await c.read(goalRepoProvider).refreshStaleDigests(ai ? c.read(aiFeaturesProvider) : null);
      await c.read(nativeSyncProvider).syncNow();
      await db.log('sync', 'Daily maintenance: $todos recurring todos, $money recurring money entries');
    case jobClassify:
      if (await c.read(aiClientProvider).isEnabled()) {
        final n = await c.read(timeServiceProvider).classifyPending(c.read(aiFeaturesProvider));
        await db.log('ai', 'Classified $n content titles');
      }
    case jobWeekly:
      if (fromMs(DateTime.now().millisecondsSinceEpoch).weekday == DateTime.sunday) {
        final ai = await c.read(aiClientProvider).isEnabled();
        final views = await c.read(goalRepoProvider).views();
        await c.read(statsServiceProvider).review(ai ? c.read(aiFeaturesProvider) : null, views);
        await db.log('ai', 'Weekly review ready');
      }
  }
}

Future<void> initJobs() async {
  await Workmanager().initialize(callbackDispatcher);
  final net = Constraints(networkType: NetworkType.connected);
  await Workmanager().registerPeriodicTask(jobAggregate, jobAggregate,
      frequency: const Duration(minutes: 15), existingWorkPolicy: ExistingPeriodicWorkPolicy.keep);
  await Workmanager().registerPeriodicTask(jobDaily, jobDaily,
      frequency: const Duration(hours: 24), initialDelay: _until(3, 30), existingWorkPolicy: ExistingPeriodicWorkPolicy.keep);
  await Workmanager().registerPeriodicTask(jobClassify, jobClassify,
      frequency: const Duration(hours: 24), initialDelay: _until(21, 0), constraints: net, existingWorkPolicy: ExistingPeriodicWorkPolicy.keep);
  await Workmanager().registerPeriodicTask(jobWeekly, jobWeekly,
      frequency: const Duration(hours: 24), initialDelay: _until(20, 0), constraints: net, existingWorkPolicy: ExistingPeriodicWorkPolicy.keep);
}

Duration _until(int h, int m) {
  final now = DateTime.now();
  var t = DateTime(now.year, now.month, now.day, h, m);
  if (!t.isAfter(now)) t = t.add(const Duration(days: 1));
  return t.difference(now);
}
