import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_compass/core/ai/ai_client.dart';
import 'package:goal_compass/core/ai/ai_features.dart';
import 'package:goal_compass/core/db/database.dart';
import 'package:goal_compass/core/logic/alert_builder.dart';
import 'package:goal_compass/core/logic/pace.dart';
import 'package:goal_compass/core/logic/recurrence.dart';
import 'package:goal_compass/core/logic/time_calc.dart';
import 'package:goal_compass/core/repos/goal_repo.dart';
import 'package:goal_compass/core/repos/money_repo.dart';
import 'package:goal_compass/core/repos/todo_repo.dart';
import 'package:goal_compass/core/utils/time.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late AppDb db;
  late GoalRepo goals;
  var aiCalls = 0;

  TodoRepo makeTodos({bool key = true}) {
    final client = MockClient((req) async {
      aiCalls++;
      final items = (jsonDecode(jsonDecode(req.body)['contents'][0]['parts'][0]['text']) as Map)['items'] as List;
      return http.Response(
          jsonEncode({
            'candidates': [
              {
                'content': {
                  'parts': [
                    {
                      'text': jsonEncode({
                        'r': [for (final i in items) {'i': i['i'], 's': 61, 'g': 'G1', 'why': 'ai says so'}]
                      })
                    }
                  ]
                },
                'finishReason': 'STOP',
              }
            ],
            'usageMetadata': {'promptTokenCount': 100, 'candidatesTokenCount': 50},
          }),
          200);
    });
    final ai = AiClient(db: db, client: client, keyProvider: () async => key ? 'k' : null, sleep: (_) async {});
    return TodoRepo(db, goals, ai: ai, features: AiFeatures(ai));
  }

  setUp(() {
    db = AppDb(NativeDatabase.memory());
    goals = GoalRepo(db);
    aiCalls = 0;
  });
  tearDown(() => db.close());

  test('same todo text twice → one AI call; 5 lines → one call', () async {
    final repo = makeTodos();
    await repo.addMany([const NewTodo('Reorganise the garage shelves')]);
    expect(aiCalls, 1);
    final ids = await repo.addMany([const NewTodo('Reorganise the garage shelves!')]);
    expect(aiCalls, 1, reason: 'normalised text hits the cache');
    final t = await (db.select(db.todos)..where((x) => x.id.equals(ids.single))).getSingle();
    expect(t.score, 61);
    await repo.addMany([for (var i = 0; i < 5; i++) NewTodo('Odd chore number $i')]);
    expect(aiCalls, 2);
  });

  test('confident local score makes no AI call; AI off falls back to rough local', () async {
    final repo = makeTodos();
    final p = await repo.score([const NewTodo('Collect payment from client', estimateMin: 30)]);
    expect(aiCalls, 0);
    expect(p.single.label, 'quick score');
    final off = makeTodos(key: false);
    final q = await off.score([const NewTodo('Water the plants')]);
    expect(aiCalls, 0);
    expect(q.single.label, 'rough');
  });

  test('recurring todo regenerates on completion', () async {
    final repo = makeTodos(key: false);
    final due = startOfDayMs(DateTime.now().millisecondsSinceEpoch) + 9 * 3600000;
    final id = (await repo.addMany([NewTodo('Daily review', dueMs: due, recurrence: Recurrence.daily)], useAi: false)).single;
    final t = await (db.select(db.todos)..where((x) => x.id.equals(id))).getSingle();
    final next = await repo.complete(t);
    expect(next, isNotNull);
    final all = await db.select(db.todos).get();
    expect(all.where((x) => x.status == 'open').single.dueAt, greaterThan(due));
  });

  test('goal view: pace and status from stages + todos, money goal feeds ring', () async {
    final now = toMs(DateTime.utc(2026, 10, 25));
    final id = await goals.create(title: 'Ship', deadlineMs: now + 100 * msPerDay, nowMs: now - 100 * msPerDay);
    final s1 = await goals.addStage(id, title: 'A', dueMs: now, weight: 50);
    await goals.addStage(id, title: 'B', dueMs: now + 50 * msPerDay, weight: 50);
    final g = await (db.select(db.goals)..where((x) => x.id.equals(id))).getSingle();
    var v = await goals.viewFor(g, now);
    expect(v.pct, 0);
    expect(v.expected, closeTo(50, 0.01));
    expect(v.status, GoalStatus.atRisk);
    await goals.setStageDone(v.stages.first, true);
    v = await goals.viewFor(g, now);
    expect(v.pct, closeTo(50, 0.01));
    expect(v.status, GoalStatus.onTrack);
    expect(s1, isNotEmpty);

    final mid = await goals.create(title: 'Profit', deadlineMs: now + 365 * msPerDay, type: 'money', targetPaise: 100000000, nowMs: now);
    await MoneyRepo(db).add(amountPaise: 25000000, kind: 'saving', goalId: mid, dateMs: now);
    final mg = await (db.select(db.goals)..where((x) => x.id.equals(mid))).getSingle();
    final mv = await goals.viewFor(mg, now);
    expect(mv.pct, 25);
    expect(mv.monthlyNeededPaise, greaterThan(0));
  });

  test('money recurring is applied once per month', () async {
    final m = MoneyRepo(db);
    await m.addRecurring(title: 'Rent', amountPaise: 1500000, kind: 'expense', day: 1);
    final now = toMs(DateTime.utc(2026, 10, 25));
    expect(await m.applyRecurring(nowMs: now), 1);
    expect(await m.applyRecurring(nowMs: now), 0);
    expect(await db.select(db.moneyEntries).get(), hasLength(1));
  });

  test('digest refresh at most once per day per goal', () async {
    final id = await goals.create(title: 'G', deadlineMs: DateTime.now().millisecondsSinceEpoch + msPerDay * 30);
    var calls = 0;
    final client = MockClient((_) async {
      calls++;
      return http.Response(jsonEncode({'candidates': [{'content': {'parts': [{'text': jsonEncode({'digest': 'd$calls'})}]}, 'finishReason': 'STOP'}], 'usageMetadata': {'promptTokenCount': 1, 'candidatesTokenCount': 1}}), 200);
    });
    final f = AiFeatures(AiClient(db: db, client: client, keyProvider: () async => 'k', sleep: (_) async {}));
    final now = DateTime.now().millisecondsSinceEpoch;
    expect(await goals.refreshStaleDigests(f, nowMs: now), 1);
    await goals.update(id, const GoalsCompanionStub().c);
    expect(await goals.refreshStaleDigests(f, nowMs: now + 3600000), 0, reason: 'stale again but < 1 day');
    expect(await goals.refreshStaleDigests(f, nowMs: now + msPerDay + 1000), 1);
    expect(calls, 1, reason: 'identical input is served from ai_cache');
  });

  test('alerts builder: reminders, stage due, 7 daily focus alerts', () {
    final now = toMs(DateTime.utc(2026, 10, 25, 7, 0));
    final a = buildAlerts(
      openTodos: [AlertTodo('1', 'Send invoice', now + 3600000, 95, 'Profit'), AlertTodo('2', 'no reminder', null, 10, null), AlertTodo('3', 'old', now - 3600000, 10, null)],
      openStages: [AlertStage('s', 'Stage', 'G', now + 2 * msPerDay)],
      topThree: ['Send invoice (95)'],
      focusStage: 'Stage',
      nowMs: now,
      dailyFocusHhmm: '08:00',
    );
    expect(a.where((x) => x.id.startsWith('todo:')).map((x) => x.id), ['todo:1']);
    expect(a.where((x) => x.kind == 'stage'), hasLength(1));
    expect(a.where((x) => x.kind == 'daily'), hasLength(7));
    expect(a.first.atMs <= a.last.atMs, true);
  });

  test('time calc: content overrides app category, sleep gaps, wasted in focus hours', () {
    final day = toMs(DateTime.utc(2026, 10, 26));
    final h = 3600000;
    final sessions = [
      TSession('yt', day + 10 * h, day + 11 * h, 'entertainment'),
      TSession('insta', day + 11 * h, day + 11 * h + 20 * 60000, 'social'),
    ];
    final content = [TContent('yt', day + 10 * h, day + 10 * h + 30 * 60000, 'learning')];
    final m = minutesByCategory(sessions, content, [], day + 8 * h, day + 12 * h);
    expect(m['learning'], closeTo(30, 0.01));
    expect(m['entertainment'], closeTo(30, 0.01));
    expect(m['social'], closeTo(20, 0.01));
    expect(m['sleep'] ?? 0, 0, reason: 'gap 8:00–10:00 is daytime');
    final night = minutesByCategory([TSession('a', day + 6 * h, day + 7 * h, 'other')], [], [], day, day + 8 * h);
    expect(night['sleep'], closeTo(420, 0.01), reason: '00:00–06:00 and 07:00–08:00 idle at night');
    expect(wastedInFocusHours(sessions, [(600, 780)], [1, 2, 3, 4, 5, 6, 7]), 80);
  });
}

class GoalsCompanionStub {
  const GoalsCompanionStub();
  GoalsCompanion get c => const GoalsCompanion();
}
