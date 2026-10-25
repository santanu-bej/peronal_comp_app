import 'package:drift/drift.dart';
import 'package:health/health.dart';
import '../db/database.dart';
import '../native/native_bridge.dart';
import '../utils/time.dart';

/// Steps / distance / exercise from Health Connect, falling back to the native step counter.
class ActivityService {
  final AppDb db;
  final NativeBridge bridge;
  ActivityService(this.db, this.bridge);

  static const _types = [HealthDataType.STEPS, HealthDataType.DISTANCE_DELTA, HealthDataType.WORKOUT];

  Future<bool> requestHealthPermissions() async {
    try {
      final h = Health();
      await h.configure();
      return await h.requestAuthorization(_types);
    } catch (_) {
      return false;
    }
  }

  Future<void> refreshToday({int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final start = DateTime.fromMillisecondsSinceEpoch(startOfDayMs(now));
    var steps = 0, dist = 0, exercise = 0;
    var ok = false;
    try {
      final h = Health();
      await h.configure();
      if (await h.hasPermissions(_types) == true) {
        steps = await h.getTotalStepsInInterval(start, DateTime.fromMillisecondsSinceEpoch(now)) ?? 0;
        final data = await h.getHealthDataFromTypes(types: [HealthDataType.DISTANCE_DELTA, HealthDataType.WORKOUT], startTime: start, endTime: DateTime.fromMillisecondsSinceEpoch(now));
        for (final p in data) {
          if (p.type == HealthDataType.DISTANCE_DELTA) {
            dist += ((p.value as NumericHealthValue).numericValue).round();
          } else if (p.type == HealthDataType.WORKOUT) {
            exercise += p.dateTo.difference(p.dateFrom).inMinutes;
          }
        }
        ok = true;
      }
    } catch (_) {}
    if (!ok) steps = await bridge.batteryStepCount();
    if (steps <= 0 && dist == 0 && exercise == 0) return;
    await db.into(db.activityDaily).insertOnConflictUpdate(ActivityDailyCompanion.insert(
          date: dateKey(now),
          steps: Value(steps),
          distanceM: Value(dist),
          exerciseMin: Value(exercise),
        ));
  }
}
