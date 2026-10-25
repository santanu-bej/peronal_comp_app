import '../native/native_models.dart';
import '../utils/time.dart';

class AlertTodo {
  final String id, title;
  final int? remindAt, score;
  final String? goalName;
  const AlertTodo(this.id, this.title, this.remindAt, this.score, this.goalName);
}

class AlertStage {
  final String id, title, goalTitle;
  final int dueAt;
  const AlertStage(this.id, this.title, this.goalTitle, this.dueAt);
}

/// Builds the full replacement list for `syncAlerts` (PRD F2.6, F7 daily focus, stage-due).
List<AlertItem> buildAlerts({
  required List<AlertTodo> openTodos,
  required List<AlertStage> openStages,
  required List<String> topThree,
  required String? focusStage,
  required int nowMs,
  String? dailyFocusHhmm,
  int stageDueHour = 9,
}) {
  final out = <AlertItem>[];
  for (final t in openTodos) {
    final r = t.remindAt;
    if (r == null || r < nowMs - 5 * 60000) continue; // missed ones are handled natively; skip very old
    out.add(AlertItem(
      id: 'todo:${t.id}',
      atMs: r,
      title: '${t.title}${t.score == null ? '' : ' · score ${t.score}'}',
      body: t.goalName ?? 'Reminder',
      kind: 'reminder',
      deepLink: 'goalcompass://todo/${t.id}',
    ));
  }
  for (final s in openStages) {
    final at = startOfDayMs(s.dueAt) + stageDueHour * 3600000;
    if (at < nowMs) continue;
    out.add(AlertItem(
      id: 'stage:${s.id}',
      atMs: at,
      title: 'Stage due today: ${s.title}',
      body: s.goalTitle,
      kind: 'stage',
      deepLink: 'goalcompass://goals',
    ));
  }
  if (dailyFocusHhmm != null && RegExp(r'^\d{1,2}:\d{2}$').hasMatch(dailyFocusHhmm)) {
    final p = dailyFocusHhmm.split(':').map(int.parse).toList();
    final today = startOfDayMs(nowMs);
    for (var i = 0; i < 7; i++) {
      final at = today + i * msPerDay + (p[0] * 60 + p[1]) * 60000;
      if (at < nowMs) continue;
      final body = [if (focusStage != null) 'Focus: $focusStage', ...topThree.map((t) => '• $t')].join('\n');
      out.add(AlertItem(
        id: 'daily:${dateKey(at)}',
        atMs: at,
        title: 'Today’s focus',
        body: body.isEmpty ? 'Open Goal Compass to plan your day.' : body,
        kind: 'daily',
        deepLink: 'goalcompass://morning',
      ));
    }
  }
  out.sort((a, b) => a.atMs.compareTo(b.atMs));
  return out;
}
