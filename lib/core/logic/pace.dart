enum GoalStatus { ahead, onTrack, behind, atRisk }

extension GoalStatusLabel on GoalStatus {
  String get label => switch (this) {
        GoalStatus.ahead => 'Ahead',
        GoalStatus.onTrack => 'On track',
        GoalStatus.behind => 'Behind',
        GoalStatus.atRisk => 'At risk',
      };
}

class StageInput {
  final int weight;
  final bool done;
  final int todosTotal;
  final int todosDone;
  const StageInput({required this.weight, required this.done, this.todosTotal = 0, this.todosDone = 0});
}

/// Done ? 1 : done/total, capped at 0.9 until marked done.
double stageProgress(StageInput s) {
  if (s.done) return 1;
  if (s.todosTotal == 0) return 0;
  final p = s.todosDone / s.todosTotal;
  return p > 0.9 ? 0.9 : p;
}

/// Σ(weight × progress) with weights normalised to 100. Returns 0..100.
double generalGoalPct(List<StageInput> stages) {
  final total = stages.fold<int>(0, (a, s) => a + s.weight);
  if (total <= 0) return 0;
  var sum = 0.0;
  for (final s in stages) {
    sum += (s.weight / total) * stageProgress(s);
  }
  return sum * 100;
}

double moneyGoalPct(int savedPaise, int targetPaise) {
  if (targetPaise <= 0) return 0;
  return (savedPaise / targetPaise * 100).clamp(0, 100).toDouble();
}

/// (today − start) / (deadline − start), as 0..100.
double expectedPct(int startMs, int deadlineMs, int nowMs) {
  final span = deadlineMs - startMs;
  if (span <= 0) return 100;
  return ((nowMs - startMs) / span * 100).clamp(0, 100).toDouble();
}

GoalStatus goalStatus(double pct, double expected) {
  final diff = pct - expected;
  if (diff >= 5) return GoalStatus.ahead;
  if (diff >= -5) return GoalStatus.onTrack;
  if (diff >= -15) return GoalStatus.behind;
  return GoalStatus.atRisk;
}

int daysLeft(int deadlineMs, int nowMs) => ((deadlineMs - nowMs) / 86400000).ceil();

/// Local replan: shift overdue open stages by their slip, keep the deadline (clamped).
/// Input: list of (id, dueMs, done). Returns id -> new due ms for changed stages.
Map<String, int> localReplan(List<({String id, int dueMs, bool done})> stages, int nowMs, int deadlineMs) {
  final out = <String, int>{};
  final open = stages.where((s) => !s.done).toList()..sort((a, b) => a.dueMs.compareTo(b.dueMs));
  var shift = 0;
  for (final s in open) {
    if (s.dueMs < nowMs) {
      final slip = nowMs - s.dueMs;
      if (slip > shift) shift = slip;
    }
  }
  if (shift == 0) return out;
  for (final s in open) {
    var d = s.dueMs + shift;
    if (d > deadlineMs) d = deadlineMs;
    if (d != s.dueMs) out[s.id] = d;
  }
  return out;
}
