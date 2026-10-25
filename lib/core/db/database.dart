import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'migrations.dart';
import 'tables.dart';

part 'database.g.dart';

const allTableNames = [
  'goals', 'stages', 'todos', 'focus_sessions', 'routines', 'contacts', 'app_categories', 'usage_sessions',
  'content_items', 'content_rules', 'activity_daily', 'money_entries', 'money_recurring', 'nudge_log',
  'event_log', 'ai_cache', 'ai_usage', 'daily_rollup', 'settings',
];

@DriftDatabase(tables: [
  Goals, Stages, Todos, FocusSessions, Routines, Contacts, AppCategories, UsageSessions, ContentItems,
  ContentRules, ActivityDaily, MoneyEntries, MoneyRecurring, NudgeLog, EventLog, AiCache, AiUsage,
  DailyRollup, Settings,
])
class AppDb extends _$AppDb {
  AppDb([QueryExecutor? e]) : super(e ?? driftDatabase(name: 'goal_compass'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: migrate,
      );

  // ---- settings helper ----
  Future<T?> getSetting<T>(String key) async {
    final row = await (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    return jsonDecode(row.valueJson) as T?;
  }

  Future<void> setSetting(String key, Object? value) =>
      into(settings).insertOnConflictUpdate(SettingsCompanion.insert(key: key, valueJson: jsonEncode(value)));

  Stream<T?> watchSetting<T>(String key) => (select(settings)..where((s) => s.key.equals(key)))
      .watchSingleOrNull()
      .map((r) => r == null ? null : jsonDecode(r.valueJson) as T?);

  // ---- event log ----
  Future<void> log(String source, String message, {String level = 'info', Map<String, Object?>? data}) =>
      into(eventLog).insert(EventLogCompanion.insert(
        at: DateTime.now().millisecondsSinceEpoch,
        source: source,
        level: Value(level),
        message: message,
        dataJson: Value(data == null ? null : jsonEncode(data)),
      ));

  // ---- backup helpers ----
  Future<Map<String, dynamic>> exportAll() async {
    final out = <String, dynamic>{'schema': schemaVersion, 'tables': <String, dynamic>{}};
    for (final t in allTables) {
      final rows = await select(t).get();
      (out['tables'] as Map<String, dynamic>)[t.actualTableName] =
          rows.map((r) => (r as dynamic).toJson()).toList();
    }
    return out;
  }
}
