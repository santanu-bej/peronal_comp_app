class SortableTodo {
  final String id;
  final int? score;
  final int? dueMs;
  final int estimateMin;
  final String title;
  const SortableTodo(this.id, this.title, this.score, this.dueMs, this.estimateMin);
}

double _urgency(SortableTodo t, int nowMs, int todayStartMs) {
  final d = t.dueMs;
  if (d == null) return 1.0;
  final dayEnd = todayStartMs + 86400000;
  if (d < dayEnd) return 1.5; // due today
  if (d < dayEnd + 86400000) return 1.25; // tomorrow
  return 1.0;
}

/// PRD F2.3: overdue first, then score × urgency, then shortest estimate.
List<SortableTodo> sortTodos(List<SortableTodo> todos, int nowMs, int todayStartMs) {
  final out = [...todos];
  bool overdue(SortableTodo t) => t.dueMs != null && t.dueMs! < todayStartMs;
  out.sort((a, b) {
    final oa = overdue(a), ob = overdue(b);
    if (oa != ob) return oa ? -1 : 1;
    final sa = (a.score ?? 40) * _urgency(a, nowMs, todayStartMs);
    final sb = (b.score ?? 40) * _urgency(b, nowMs, todayStartMs);
    final c = sb.compareTo(sa);
    if (c != 0) return c;
    return a.estimateMin.compareTo(b.estimateMin);
  });
  return out;
}

/// F2.5: starting a todo scoring < 40 while one ≥ 75 is open.
SortableTodo? higherValueWarning(int? startingScore, Iterable<SortableTodo> open, {String? startingId}) {
  if (startingScore == null || startingScore >= 40) return null;
  SortableTodo? best;
  for (final t in open) {
    if (t.id == startingId) continue;
    if ((t.score ?? 0) >= 75 && (best == null || t.score! > best.score!)) best = t;
  }
  return best;
}

const estimateOptions = <(int, String)>[
  (15, '15 min'),
  (30, '30 min'),
  (90, '1–2 h'),
  (240, 'Half day'),
  (480, 'Day+'),
];

int roundEstimate(int min) {
  var best = estimateOptions.first.$1;
  var bd = (min - best).abs();
  for (final o in estimateOptions) {
    final d = (min - o.$1).abs();
    if (d < bd) {
      best = o.$1;
      bd = d;
    }
  }
  return best;
}

String estimateLabel(int min) => estimateOptions.firstWhere((o) => o.$1 == min, orElse: () => (min, '$min min')).$2;
