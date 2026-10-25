import 'dart:math';

class NudgeConfig {
  final bool enabled;
  final int afterMin;
  final List<({int startMin, int endMin, List<int> days})> focusWindows; // minutes from midnight; days 1=Mon..7=Sun
  final int quietStartMin;
  final int quietEndMin;
  final int snoozeMax;
  final int minGapMin;
  final int minScore;
  final Set<String> denyList;
  const NudgeConfig({
    this.enabled = true,
    this.afterMin = 15,
    this.focusWindows = const [
      (startMin: 600, endMin: 780, days: [1, 2, 3, 4, 5]),
      (startMin: 900, endMin: 1140, days: [1, 2, 3, 4, 5]),
    ],
    this.quietStartMin = 23 * 60,
    this.quietEndMin = 7 * 60,
    this.snoozeMax = 2,
    this.minGapMin = 10,
    this.minScore = 70,
    this.denyList = const {},
  });
}

bool inQuietHours(NudgeConfig c, int minuteOfDay) {
  if (c.quietStartMin == c.quietEndMin) return false;
  if (c.quietStartMin < c.quietEndMin) return minuteOfDay >= c.quietStartMin && minuteOfDay < c.quietEndMin;
  return minuteOfDay >= c.quietStartMin || minuteOfDay < c.quietEndMin;
}

bool inFocusHours(NudgeConfig c, int minuteOfDay, int weekday) =>
    c.focusWindows.any((w) => w.days.contains(weekday) && minuteOfDay >= w.startMin && minuteOfDay < w.endMin);

enum NudgeKind { none, normal, escalated }

class SessionState {
  final int minutesInApp;
  final int nudgesShown;
  final int snoozesUsed;
  final int? snoozedUntilMin; // absolute minute counter
  final int? lastNudgeMin;
  const SessionState({this.minutesInApp = 0, this.nudgesShown = 0, this.snoozesUsed = 0, this.snoozedUntilMin, this.lastNudgeMin});
}

/// Pure decision used by the Kotlin NudgeEngine (mirrored there) and unit-tested here.
NudgeKind decideNudge({
  required NudgeConfig config,
  required SessionState session,
  required String category,
  required String package,
  required int minuteOfDay,
  required int weekday,
  required int nowMinuteCounter,
  required int? topTaskScore,
}) {
  if (!config.enabled) return NudgeKind.none;
  if (config.denyList.contains(package)) return NudgeKind.none;
  if (category != 'entertainment' && category != 'social') return NudgeKind.none;
  if (inQuietHours(config, minuteOfDay)) return NudgeKind.none;
  if (!inFocusHours(config, minuteOfDay, weekday)) return NudgeKind.none;
  if (topTaskScore == null || topTaskScore < config.minScore) return NudgeKind.none;
  if (session.minutesInApp < config.afterMin) return NudgeKind.none;
  if (session.snoozedUntilMin != null && nowMinuteCounter < session.snoozedUntilMin!) return NudgeKind.none;
  if (session.lastNudgeMin != null && nowMinuteCounter - session.lastNudgeMin! < config.minGapMin && session.snoozesUsed == 0) {
    return NudgeKind.none;
  }
  return session.nudgesShown >= 2 ? NudgeKind.escalated : NudgeKind.normal;
}

const normalTemplates = [
  '{min} min on {app}. Urgent: {task} ({score}). Start now?',
  '{goal} is {pct}% done with {days} days left. {task} moves it. Go?',
  'Bas, {min} min ho gaya on {app}. {task} is waiting.',
  'Every 15 min here = 15 min less for {goal}. Next: {task}.',
];

const escalatedTemplates = [
  "Third reminder. You've spent {min} min on {app}. Close it and do {task} now.",
  "{user}, this is the time you said you'd work. {task} ({score}) is still open.",
];

/// Picks a template that differs from [lastIndex]; returns (index, filled text).
(int, String) renderNudge({
  required bool escalated,
  required Map<String, String> vars,
  int? lastIndex,
  Random? rng,
}) {
  final list = escalated ? escalatedTemplates : normalTemplates;
  final r = rng ?? Random();
  var i = r.nextInt(list.length);
  if (list.length > 1 && i == lastIndex) i = (i + 1) % list.length;
  var t = list[i];
  vars.forEach((k, v) => t = t.replaceAll('{$k}', v));
  return (i, t);
}

String renderMessage(String template, Map<String, String> vars) {
  var t = template;
  vars.forEach((k, v) => t = t.replaceAll('{$k}', v));
  return t;
}
