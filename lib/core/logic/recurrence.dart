import '../utils/time.dart';

enum Recurrence { none, daily, weekdays, weekly }

Recurrence recurrenceFrom(String s) => Recurrence.values.firstWhere((r) => r.name == s, orElse: () => Recurrence.none);

/// Next due time (ms) for a recurring todo completed/expired at [fromMs] with current [dueMs].
/// Keeps the time of day of [dueMs]; returns null for none.
int? nextOccurrence(Recurrence r, int dueMs, int nowMs) {
  if (r == Recurrence.none) return null;
  final today = startOfDayMs(nowMs);
  var d = fromMs(dueMs);
  do {
    d = switch (r) {
      Recurrence.weekly => d.add(const Duration(days: 7)),
      Recurrence.weekdays => _nextWeekday(d),
      _ => d.add(const Duration(days: 1)),
    };
  } while (toMs(d) < today);
  return toMs(d);
}

DateTime _nextWeekday(DateTime d) {
  var n = d.add(const Duration(days: 1));
  while (n.weekday > 5) {
    n = n.add(const Duration(days: 1));
  }
  return n;
}
