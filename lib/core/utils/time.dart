/// IST helpers. Times are stored as UTC epoch ms and shown in Asia/Kolkata (UTC+5:30, no DST).
const istOffset = Duration(hours: 5, minutes: 30);

DateTime fromMs(int ms) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).add(istOffset);

/// Treats the fields of [ist] as IST wall-clock and returns epoch ms.
int toMs(DateTime ist) =>
    DateTime.utc(ist.year, ist.month, ist.day, ist.hour, ist.minute, ist.second)
        .subtract(istOffset)
        .millisecondsSinceEpoch;

DateTime nowIst([int? nowMs]) => fromMs(nowMs ?? DateTime.now().millisecondsSinceEpoch);

int startOfDayMs(int ms) {
  final d = fromMs(ms);
  return toMs(DateTime.utc(d.year, d.month, d.day));
}

String dateKey(int ms) {
  final d = fromMs(ms);
  return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

int msFromDateKey(String key) {
  final p = key.split('-').map(int.parse).toList();
  return toMs(DateTime.utc(p[0], p[1], p[2]));
}

const msPerDay = 86400000;

int daysBetween(int fromMsV, int toMsV) => ((toMsV - fromMsV) / msPerDay).ceil();

String hhmm(int h, int m) => '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

const _months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
String shortDate(int ms) {
  final d = fromMs(ms);
  return '${d.day} ${_months[d.month - 1]}';
}

String longDate(int ms) {
  final d = fromMs(ms);
  return '${d.day} ${_months[d.month - 1]} ${d.year}';
}

String timeLabel(int ms) {
  final d = fromMs(ms);
  final h12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  return '$h12:${d.minute.toString().padLeft(2, '0')} ${d.hour < 12 ? 'AM' : 'PM'}';
}
