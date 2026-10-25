import 'package:drift/drift.dart';
import '../db/database.dart';
import '../logic/money.dart';
import '../utils/time.dart';
import 'goal_repo.dart';

class MoneyRepo {
  final AppDb db;
  MoneyRepo(this.db);

  Stream<List<MoneyEntry>> watchMonth(int year, int month) {
    final from = toMs(DateTime.utc(year, month, 1));
    final to = toMs(DateTime.utc(month == 12 ? year + 1 : year, month == 12 ? 1 : month + 1, 1));
    return (db.select(db.moneyEntries)
          ..where((e) => e.date.isBiggerOrEqualValue(from) & e.date.isSmallerThanValue(to))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .watch();
  }

  Future<void> add({
    required int amountPaise,
    required String kind,
    String category = 'general',
    String? note,
    int? dateMs,
    String? goalId,
    String? recurringId,
  }) =>
      db.into(db.moneyEntries).insert(MoneyEntriesCompanion.insert(
            id: newId(),
            goalId: Value(goalId),
            date: dateMs ?? startOfDayMs(DateTime.now().millisecondsSinceEpoch),
            amountPaise: amountPaise,
            kind: kind,
            category: Value(category),
            note: Value(note),
            recurringId: Value(recurringId),
          ));

  Future<void> delete(String id) => (db.delete(db.moneyEntries)..where((e) => e.id.equals(id))).go();

  Stream<List<MoneyRecurringData>> watchRecurring() => db.select(db.moneyRecurring).watch();

  Future<void> addRecurring({required String title, required int amountPaise, required String kind, String category = 'general', required int day, String? goalId}) =>
      db.into(db.moneyRecurring).insert(MoneyRecurringCompanion.insert(
          id: newId(), title: title, amountPaise: amountPaise, kind: kind, category: Value(category), dayOfMonth: day, goalId: Value(goalId)));

  Future<void> deleteRecurring(String id) => (db.delete(db.moneyRecurring)..where((r) => r.id.equals(id))).go();

  Future<void> setRecurringEnabled(String id, bool on) =>
      (db.update(db.moneyRecurring)..where((r) => r.id.equals(id))).write(MoneyRecurringCompanion(enabled: Value(on)));

  /// Adds this month's entry for each enabled recurring item whose day has arrived (idempotent per month).
  Future<int> applyRecurring({int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final d = fromMs(now);
    final monthStart = toMs(DateTime.utc(d.year, d.month, 1));
    var n = 0;
    for (final r in await (db.select(db.moneyRecurring)..where((r) => r.enabled.equals(true))).get()) {
      if (d.day < r.dayOfMonth) continue;
      final exists = await (db.select(db.moneyEntries)..where((e) => e.recurringId.equals(r.id) & e.date.isBiggerOrEqualValue(monthStart))).get();
      if (exists.isNotEmpty) continue;
      final day = r.dayOfMonth.clamp(1, 28);
      await add(
          amountPaise: r.amountPaise,
          kind: r.kind,
          category: r.category,
          note: r.title,
          dateMs: toMs(DateTime.utc(d.year, d.month, day)),
          goalId: r.goalId,
          recurringId: r.id);
      n++;
    }
    return n;
  }

  Future<String> csv() async {
    final rows = await (db.select(db.moneyEntries)..orderBy([(e) => OrderingTerm.asc(e.date)])).get();
    return entriesToCsv([for (final r in rows) (date: dateKey(r.date), kind: r.kind, amountPaise: r.amountPaise, category: r.category, note: r.note)]);
  }

  Future<int> monthlyTarget() async => ((await db.getSetting<int>('money.monthlyTargetPaise')) ?? 0);
}
