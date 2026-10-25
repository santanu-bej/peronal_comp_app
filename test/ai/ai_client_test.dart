import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_compass/core/ai/ai_client.dart';
import 'package:goal_compass/core/ai/ai_features.dart';
import 'package:goal_compass/core/ai/token_budget.dart';
import 'package:goal_compass/core/db/database.dart';
import 'package:goal_compass/core/utils/time.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response toolResp(Map<String, dynamic> input, {int inTok = 400, int outTok = 300, String stop = 'tool_use'}) => http.Response(
      jsonEncode({
        'content': [
          {'type': 'tool_use', 'name': 'x', 'input': input}
        ],
        'stop_reason': stop,
        'usage': {'input_tokens': inTok, 'output_tokens': outTok},
      }),
      200,
    );

void main() {
  late AppDb db;
  setUp(() => db = AppDb(NativeDatabase.memory()));
  tearDown(() => db.close());

  AiClient make(MockClient c, {String? key = 'sk-test'}) =>
      AiClient(db: db, client: c, keyProvider: () async => key, sleep: (_) async {});

  final deadline = toMs(DateTime.utc(2027, 10, 31));
  final today = toMs(DateTime.utc(2026, 10, 26));

  test('plan: parses tool_use, drops invalid items, clamps dates, normalises weights', () async {
    var calls = 0;
    final c = MockClient((req) async {
      calls++;
      expect(req.headers['x-api-key'], 'sk-test');
      final b = jsonDecode(req.body) as Map;
      expect(b['tool_choice'], {'type': 'tool', 'name': 'save_plan'});
      expect(b['max_tokens'], 1400);
      return toolResp({
        'stages': [
          {'t': 'Late', 'due': '2030-01-01', 'w': 30, 'done_when': 'x'},
          {'t': 'Early', 'due': '2026-11-15', 'w': 30, 'done_when': 'y'},
          {'t': '', 'due': '2026-12-01', 'w': 10, 'done_when': 'bad'},
          {'t': 'Mid', 'due': 'not-a-date', 'w': 10, 'done_when': 'bad'},
          {'t': 'Mid2', 'due': '2027-03-01', 'w': 40, 'done_when': 'z'},
        ],
        'todos': [
          {'t': 'First', 'stage': 1, 'e': 20}, // original index 1 = Early -> 0 after sort
          {'t': 'Orphan', 'stage': 2, 'e': 30}, // pointed at dropped stage
          {'t': 'Last', 'stage': 0, 'e': 500},
        ],
        'digest': 'd',
      });
    });
    final f = AiFeatures(make(c));
    final r = await f.plan(title: 'g', why: 'w', deadlineMs: deadline, type: 'general', nowMs: today + 1000);
    expect(calls, 1);
    expect([for (final s in r.stages) s.title], ['Early', 'Mid2', 'Late']);
    expect(r.stages.last.dueMs, deadline);
    expect(r.stages.fold<int>(0, (a, s) => a + s.weight), 100);
    expect([for (final t in r.todos) (t.title, t.stageIndex, t.estimateMin)], [('First', 0, 15), ('Last', 2, 480)]);
    expect(r.tokens, 700);
    final usage = await db.select(db.aiUsage).get();
    expect(usage.single.feature, 'plan');
    expect(usage.single.inputTokens, 400);
  });

  test('429 retries once then succeeds; second 429 fails', () async {
    var n = 0;
    final ok = MockClient((_) async => ++n == 1 ? http.Response('{}', 429) : toolResp({'digest': 'hi'}));
    expect(await AiFeatures(make(ok)).digest(goal: 'g', why: '', deadlineMs: deadline, stages: [], pct: 0), 'hi');
    expect(n, 2);
    n = 0;
    final bad = MockClient((_) async {
      n++;
      return http.Response('{}', 429);
    });
    await expectLater(AiFeatures(make(bad)).digest(goal: 'g2', why: '', deadlineMs: deadline, stages: [], pct: 0), throwsA(isA<AiException>()));
    expect(n, 2);
  });

  test('401 reports key rejected; no key throws; network error is retryable', () async {
    final c401 = MockClient((_) async => http.Response('{}', 401));
    try {
      await AiFeatures(make(c401)).digest(goal: 'g', why: '', deadlineMs: deadline, stages: [], pct: 0);
      fail('should throw');
    } on AiException catch (e) {
      expect(e.keyRejected, true);
    }
    expect(AiFeatures(make(c401, key: null)).digest(goal: 'g', why: '', deadlineMs: deadline, stages: [], pct: 0), throwsA(isA<AiException>()));
    final net = MockClient((_) async => throw http.ClientException('offline'));
    try {
      await AiFeatures(make(net)).digest(goal: 'g', why: '', deadlineMs: deadline, stages: [], pct: 0);
      fail('should throw');
    } on AiException catch (e) {
      expect(e.retryable, true);
    }
  });

  test('align: cached on second identical call (1 network call)', () async {
    var n = 0;
    final c = MockClient((_) async {
      n++;
      return toolResp({
        'r': [
          {'i': 0, 's': 88, 'g': 'G1', 'why': 'Brings money'},
          {'i': 7, 's': 10, 'g': null, 'why': 'out of range, dropped'},
        ]
      });
    });
    final f = AiFeatures(make(c));
    final items = [(title: 'Send invoice', estimateMin: 30)];
    final a = await f.align(items, ['digest one'], nowMs: today);
    final b = await f.align(items, ['digest one'], nowMs: today);
    expect(n, 1);
    expect(a[0]!.score, 88);
    expect(a[0]!.goalIndex, 0);
    expect(a.length, 1);
    expect(b[0]!.score, 88);
  });

  test('batched align: 5 items = 1 call', () async {
    var n = 0;
    final c = MockClient((req) async {
      n++;
      final items = (jsonDecode(jsonDecode(req.body)['messages'][0]['content']) as Map)['items'] as List;
      return toolResp({
        'r': [for (final i in items) {'i': i['i'], 's': 50, 'g': null, 'why': 'ok'}]
      });
    });
    final r = await AiFeatures(make(c)).align([for (var i = 0; i < 5; i++) (title: 't$i', estimateMin: 30)], ['d']);
    expect(n, 1);
    expect(r.length, 5);
  });

  test('budget: 80% stops background, 100% blocks, plan asks to confirm', () {
    expect(budgetDecision(feature: 'digest', usedTokens: 320000, estimate: 100, cap: 400000), BudgetDecision.blocked);
    expect(budgetDecision(feature: 'align', usedTokens: 320000, estimate: 100, cap: 400000), BudgetDecision.ok);
    expect(budgetDecision(feature: 'align', usedTokens: 399990, estimate: 100, cap: 400000), BudgetDecision.blocked);
    expect(budgetDecision(feature: 'plan', usedTokens: 399990, estimate: 100, cap: 400000), BudgetDecision.needsConfirm);
    expect(budgetDecision(feature: 'review', usedTokens: 0, estimate: 100, cap: 400000), BudgetDecision.ok);
  });

  test('budget blocks real call at 80% for background feature', () async {
    await db.setSetting('ai.budget', 1000);
    await db.into(db.aiUsage).insert(AiUsageCompanion.insert(at: DateTime.now().millisecondsSinceEpoch, feature: 'plan', model: 'm'));
    await (db.update(db.aiUsage)).write(const AiUsageCompanion());
    await db.customStatement('UPDATE ai_usage SET input_tokens = 900');
    var n = 0;
    final c = MockClient((_) async {
      n++;
      return toolResp({'digest': 'x'});
    });
    await expectLater(AiFeatures(make(c)).digest(goal: 'g', why: '', deadlineMs: deadline, stages: [], pct: 0), throwsA(isA<AiException>()));
    expect(n, 0);
  });

  test('max_tokens truncation is not cached', () async {
    var n = 0;
    final c = MockClient((_) async {
      n++;
      return toolResp({'r': [{'i': 0, 's': 50, 'g': null, 'why': 'a'}]}, stop: 'max_tokens');
    });
    final f = AiFeatures(make(c));
    await f.align([(title: 'x', estimateMin: 30)], ['d']);
    await f.align([(title: 'x', estimateMin: 30)], ['d']);
    expect(n, 2);
  });

  test('scoreBatch: local confident skips AI; unsure goes to one AI call; failure falls back rough', () async {
    var aiCalls = 0;
    final items = [
      (title: 'Collect payment from client', estimateMin: 30), // confident
      (title: 'Buy groceries', estimateMin: 30), // unsure
      (title: 'Call mom', estimateMin: 30), // unsure
    ];
    final res = await scoreBatch(
      items: items,
      digests: const ['x'],
      cacheLookup: null,
      aiAlign: (pending) async {
        aiCalls++;
        expect(pending.length, 2);
        return {0: (score: 20, goalIndex: null, reason: 'a'), 1: (score: 30, goalIndex: null, reason: 'b')};
      },
    );
    expect(aiCalls, 1);
    expect([for (final r in res) r.source], ['rule', 'ai', 'ai']);
    final offline = await scoreBatch(
      items: items,
      digests: const ['x'],
      cacheLookup: null,
      aiAlign: (_) async => throw const AiException('x', retryable: true),
    );
    expect(offline[1].rough, true);
    expect(offline[0].rough, false);
  });

  test('testKey', () async {
    final ok = MockClient((req) async {
      expect((jsonDecode(req.body) as Map)['max_tokens'], 1);
      return http.Response('{}', 200);
    });
    expect(await make(ok).testKey('k'), null);
    expect(await make(MockClient((_) async => http.Response('', 401))).testKey('k'), contains('rejected'));
  });
}
