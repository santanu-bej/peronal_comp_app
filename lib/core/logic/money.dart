class MonthTotals {
  final int income;
  final int expense;
  final int saved;
  const MonthTotals(this.income, this.expense, this.saved);
}

MonthTotals monthTotals(Iterable<({String kind, int amountPaise})> entries) {
  var i = 0, e = 0, s = 0;
  for (final x in entries) {
    switch (x.kind) {
      case 'income':
        i += x.amountPaise;
      case 'expense':
        e += x.amountPaise;
      case 'saving':
        s += x.amountPaise;
    }
  }
  return MonthTotals(i, e, s);
}

/// Net saved toward a goal: savings only (income/expense don't count unless saved).
int goalSaved(Iterable<({String kind, int amountPaise})> entries) =>
    entries.where((e) => e.kind == 'saving').fold(0, (a, e) => a + e.amountPaise);

/// Paise needed per remaining month to hit the target. Months remaining is at least 1.
int monthlyNeeded(int targetPaise, int savedPaise, int nowMs, int deadlineMs) {
  final remaining = targetPaise - savedPaise;
  if (remaining <= 0) return 0;
  final months = ((deadlineMs - nowMs) / (86400000 * 30.4375)).ceil().clamp(1, 100000);
  return (remaining / months).ceil();
}

String entriesToCsv(List<({String date, String kind, int amountPaise, String category, String? note})> rows) {
  String q(String s) => '"${s.replaceAll('"', '""')}"';
  final b = StringBuffer('date,kind,amount_rupees,category,note\n');
  for (final r in rows) {
    final rupees = '${r.amountPaise ~/ 100}.${(r.amountPaise % 100).toString().padLeft(2, '0')}';
    b.writeln('${r.date},${r.kind},$rupees,${q(r.category)},${q(r.note ?? '')}');
  }
  return b.toString();
}
