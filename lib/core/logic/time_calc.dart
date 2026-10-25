import '../utils/time.dart';
import 'categorizer.dart';

typedef Span = ({int start, int end});

class TSession {
  final String pkg;
  final int start, end;
  final String category;
  const TSession(this.pkg, this.start, this.end, this.category);
}

class TContent {
  final String pkg;
  final int start, end;
  final String? category;
  const TContent(this.pkg, this.start, this.end, this.category);
}

class TFocus {
  final int start, end;
  final String category;
  const TFocus(this.start, this.end, this.category);
}

int _overlap(int a0, int a1, int b0, int b1) {
  final s = a0 > b0 ? a0 : b0;
  final e = a1 < b1 ? a1 : b1;
  return e > s ? e - s : 0;
}

/// Minutes per category in [fromMs, toMs). App time inside a classified content span takes the
/// content's category; the rest keeps the app category. Focus sessions add their own minutes.
/// Night gaps (> 30 min with no activity between 22:00 and 08:00) count as `sleep`.
Map<String, double> minutesByCategory(
  List<TSession> sessions,
  List<TContent> content,
  List<TFocus> focus,
  int fromMs,
  int toMs,
) {
  final out = <String, double>{};
  void add(String c, int ms) {
    if (ms <= 0) return;
    out[c] = (out[c] ?? 0) + ms / 60000;
  }

  final all = <({int s, int e})>[];
  for (final s in sessions) {
    final s0 = s.start < fromMs ? fromMs : s.start;
    final s1 = s.end > toMs ? toMs : s.end;
    if (s1 <= s0) continue;
    var remaining = s1 - s0;
    for (final c in content) {
      if (c.pkg != s.pkg || c.category == null) continue;
      final o = _overlap(s0, s1, c.start, c.end);
      if (o > 0) {
        add(c.category!, o);
        remaining -= o;
      }
    }
    add(s.category, remaining < 0 ? 0 : remaining);
    all.add((s: s0, e: s1));
  }
  for (final f in focus) {
    final f0 = f.start < fromMs ? fromMs : f.start;
    final f1 = f.end > toMs ? toMs : f.end;
    if (f1 > f0) {
      add(f.category, f1 - f0);
      all.add((s: f0, e: f1));
    }
  }
  all.sort((a, b) => a.s.compareTo(b.s));
  var cursor = fromMs;
  for (final x in [...all, (s: toMs, e: toMs)]) {
    final gap = x.s - cursor;
    if (gap > 30 * 60000) add('sleep', _nightPart(cursor, x.s));
    if (x.e > cursor) cursor = x.e;
  }
  return out;
}

/// Milliseconds of [a, b) that fall between 22:00 and 08:00 IST.
int _nightPart(int a, int b) {
  var total = 0;
  var day = startOfDayMs(a);
  while (day < b) {
    total += _overlap(a, b, day, day + 8 * 3600000);
    total += _overlap(a, b, day + 22 * 3600000, day + 24 * 3600000);
    day += msPerDay;
  }
  return total;
}

int wastedMinutes(Map<String, double> byCat) =>
    byCat.entries.where((e) => isWasted(e.key)).fold<double>(0, (a, e) => a + e.value).round();

/// Wasted time restricted to focus windows. [windows] are (startMin,endMin) minutes-of-day, weekdays only.
int wastedInFocusHours(List<TSession> sessions, List<(int, int)> windows, List<int> weekdays) {
  var ms = 0;
  for (final s in sessions) {
    if (!isWasted(s.category)) continue;
    var day = startOfDayMs(s.start);
    while (day < s.end) {
      final wd = fromMs(day).weekday;
      if (weekdays.contains(wd)) {
        for (final w in windows) {
          ms += _overlap(s.start, s.end, day + w.$1 * 60000, day + w.$2 * 60000);
        }
      }
      day += msPerDay;
    }
  }
  return (ms / 60000).round();
}

/// Pairs raw native (pkg,start,end) into sessions: drops < 3 s, merges a same-package session starting within 2 s.
List<TSession> toSessions(List<({String pkg, int start, int end})> raw, String Function(String pkg) categoryOf) {
  final sorted = [...raw]..sort((a, b) => a.start.compareTo(b.start));
  final out = <TSession>[];
  for (final r in sorted) {
    if (r.end - r.start < 3000) continue;
    if (out.isNotEmpty && out.last.pkg == r.pkg && r.start - out.last.end <= 2000) {
      final l = out.removeLast();
      out.add(TSession(l.pkg, l.start, r.end, l.category));
    } else {
      out.add(TSession(r.pkg, r.start, r.end, categoryOf(r.pkg)));
    }
  }
  return out;
}
