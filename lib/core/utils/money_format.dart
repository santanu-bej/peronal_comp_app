/// Indian digit grouping: 123456 -> 1,23,456.
String indianGroup(int n) {
  final neg = n < 0;
  final s = n.abs().toString();
  if (s.length <= 3) return neg ? '-$s' : s;
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '${neg ? '-' : ''}${parts.join(',')},$last3';
}

/// Formats paise as ₹1,23,456 (decimals only when non-zero).
String formatPaise(int paise) {
  final neg = paise < 0;
  final a = paise.abs();
  final rupees = a ~/ 100;
  final p = a % 100;
  final base = '₹${indianGroup(rupees)}${p == 0 ? '' : '.${p.toString().padLeft(2, '0')}'}';
  return neg ? '-$base' : base;
}

/// Parses "1234.50" or "1,234" into paise. Returns null on bad input.
int? parseRupeesToPaise(String s) {
  final t = s.replaceAll(',', '').replaceAll('₹', '').trim();
  if (t.isEmpty) return null;
  final m = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(t);
  if (m == null) return null;
  final r = int.parse(m.group(1)!);
  final p = m.group(2) == null ? 0 : int.parse(m.group(2)!.padRight(2, '0'));
  return r * 100 + p;
}
