import 'package:flutter_test/flutter_test.dart';
import 'package:goal_compass/core/logic/pace.dart';

void main() {
  test('stage progress capped at 0.9 until done', () {
    expect(stageProgress(const StageInput(weight: 10, done: false, todosTotal: 4, todosDone: 4)), 0.9);
    expect(stageProgress(const StageInput(weight: 10, done: true)), 1);
    expect(stageProgress(const StageInput(weight: 10, done: false, todosTotal: 4, todosDone: 1)), 0.25);
    expect(stageProgress(const StageInput(weight: 10, done: false)), 0);
  });
  test('general goal pct normalises weights', () {
    final p = generalGoalPct(const [
      StageInput(weight: 50, done: true),
      StageInput(weight: 50, done: false, todosTotal: 2, todosDone: 1),
    ]);
    expect(p, closeTo(75, 0.001));
    // weights 1:1 even when they don't sum to 100
    expect(generalGoalPct(const [StageInput(weight: 1, done: true), StageInput(weight: 1, done: false)]), closeTo(50, 0.001));
    expect(generalGoalPct(const []), 0);
  });
  test('money pct', () {
    expect(moneyGoalPct(250000, 1000000), 25);
    expect(moneyGoalPct(2000000, 1000000), 100);
    expect(moneyGoalPct(1, 0), 0);
  });
  test('expected pct', () {
    expect(expectedPct(0, 100, 50), 50);
    expect(expectedPct(0, 100, 200), 100);
    expect(expectedPct(0, 100, -5), 0);
  });
  test('status thresholds', () {
    expect(goalStatus(55, 50), GoalStatus.ahead);
    expect(goalStatus(54.9, 50), GoalStatus.onTrack);
    expect(goalStatus(45, 50), GoalStatus.onTrack);
    expect(goalStatus(44.9, 50), GoalStatus.behind);
    expect(goalStatus(35, 50), GoalStatus.behind);
    expect(goalStatus(34.9, 50), GoalStatus.atRisk);
  });
  test('local replan shifts overdue by slip, clamps to deadline', () {
    const day = 86400000;
    final r = localReplan([
      (id: 'a', dueMs: 10 * day, done: false),
      (id: 'b', dueMs: 20 * day, done: false),
      (id: 'c', dueMs: 5 * day, done: true),
    ], 14 * day, 30 * day);
    expect(r['a'], 14 * day);
    expect(r['b'], 24 * day);
    expect(r.containsKey('c'), false);
    final clamped = localReplan([(id: 'a', dueMs: 10 * day, done: false), (id: 'b', dueMs: 29 * day, done: false)], 14 * day, 30 * day);
    expect(clamped['b'], 30 * day);
    expect(localReplan([(id: 'a', dueMs: 20 * day, done: false)], 14 * day, 30 * day), isEmpty);
  });
}
