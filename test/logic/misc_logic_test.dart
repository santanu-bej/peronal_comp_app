import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_compass/core/logic/categorizer.dart';
import 'package:goal_compass/core/logic/money.dart';
import 'package:goal_compass/core/logic/nudge_rules.dart';
import 'package:goal_compass/core/logic/recurrence.dart';
import 'package:goal_compass/core/logic/todo_sort.dart';
import 'package:goal_compass/core/utils/money_format.dart';
import 'package:goal_compass/core/utils/time.dart';

void main() {
  group('money format', () {
    test('indian grouping', () {
      expect(indianGroup(123456), '1,23,456');
      expect(indianGroup(1000000), '10,00,000');
      expect(indianGroup(999), '999');
      expect(indianGroup(1000), '1,000');
      expect(indianGroup(-123456), '-1,23,456');
    });
    test('paise', () {
      expect(formatPaise(12345600), '₹1,23,456');
      expect(formatPaise(150), '₹1.50');
      expect(parseRupeesToPaise('1,234.5'), 123450);
      expect(parseRupeesToPaise('abc'), null);
    });
  });

  group('money maths', () {
    test('month totals and csv', () {
      final t = monthTotals([(kind: 'income', amountPaise: 500000), (kind: 'expense', amountPaise: 120050), (kind: 'saving', amountPaise: 100000)]);
      expect((t.income, t.expense, t.saved), (500000, 120050, 100000));
      expect(entriesToCsv([(date: '2026-10-01', kind: 'expense', amountPaise: 120050, category: 'rent', note: 'a "b"')]),
          contains('2026-10-01,expense,1200.50,"rent","a ""b"""'));
    });
    test('monthly needed', () {
      const day = 86400000;
      // 10L target, 0 saved, ~12 months
      final need = monthlyNeeded(100000000, 0, 0, (365.25 * day).round());
      expect(need, closeTo(100000000 / 12, 100000000 / 12 * 0.02));
      expect(monthlyNeeded(100, 100, 0, day), 0);
    });
  });

  group('recurrence', () {
    test('daily keeps time and lands today or later', () {
      final due = toMs(DateTime.utc(2026, 10, 20, 9, 30));
      final now = toMs(DateTime.utc(2026, 10, 25, 12, 0));
      final n = nextOccurrence(Recurrence.daily, due, now)!;
      expect(fromMs(n).day, 25);
      expect(fromMs(n).hour, 9);
    });
    test('weekdays skip weekend', () {
      final fri = toMs(DateTime.utc(2026, 10, 23, 9, 0)); // Friday
      final n = nextOccurrence(Recurrence.weekdays, fri, fri)!;
      expect(fromMs(n).weekday, 1);
    });
    test('weekly', () {
      final d = toMs(DateTime.utc(2026, 10, 20, 9, 0));
      expect(fromMs(nextOccurrence(Recurrence.weekly, d, d)!).day, 27);
      expect(nextOccurrence(Recurrence.none, d, d), null);
    });
  });

  group('todo sort', () {
    final today = toMs(DateTime.utc(2026, 10, 25));
    final now = today + 3600000;
    test('overdue first, then score × urgency, then shortest', () {
      final r = sortTodos([
        SortableTodo('a', 'a', 90, null, 30),
        SortableTodo('b', 'b', 50, today - 1000, 30),
        SortableTodo('c', 'c', 70, today + 1000, 30), // due today ×1.5 = 105
        SortableTodo('d', 'd', 90, null, 15),
      ], now, today);
      expect([for (final t in r) t.id], ['b', 'c', 'd', 'a']);
    });
    test('higher value warning', () {
      final open = [SortableTodo('x', 'Send invoice', 85, null, 30), SortableTodo('y', 'meh', 30, null, 30)];
      expect(higherValueWarning(30, open, startingId: 'y')?.title, 'Send invoice');
      expect(higherValueWarning(60, open), null);
      expect(higherValueWarning(30, [SortableTodo('z', 'z', 74, null, 30)]), null);
    });
    test('estimate rounding', () {
      expect(roundEstimate(20), 15);
      expect(roundEstimate(100), 90);
      expect(roundEstimate(2400), 480);
    });
  });

  group('nudges', () {
    const cfg = NudgeConfig();
    NudgeKind d({int min = 20, int nudges = 0, String cat = 'entertainment', int tod = 11 * 60, int wd = 2, int? score = 95, String pkg = 'com.instagram.android', SessionState? s}) =>
        decideNudge(
          config: cfg,
          session: s ?? SessionState(minutesInApp: min, nudgesShown: nudges),
          category: cat,
          package: pkg,
          minuteOfDay: tod,
          weekday: wd,
          nowMinuteCounter: 1000,
          topTaskScore: score,
        );
    test('fires in focus hours', () => expect(d(), NudgeKind.normal));
    test('too short', () => expect(d(min: 10), NudgeKind.none));
    test('work app', () => expect(d(cat: 'work'), NudgeKind.none));
    test('quiet hours', () => expect(d(tod: 23 * 60 + 30), NudgeKind.none));
    test('outside focus hours', () => expect(d(tod: 14 * 60), NudgeKind.none));
    test('weekend', () => expect(d(wd: 6), NudgeKind.none));
    test('low score task', () => expect(d(score: 60), NudgeKind.none));
    test('third is escalated', () => expect(d(nudges: 2), NudgeKind.escalated));
    test('snoozed', () => expect(d(s: const SessionState(minutesInApp: 30, snoozedUntilMin: 1003)), NudgeKind.none));
    test('quiet hours across midnight', () {
      expect(inQuietHours(cfg, 2 * 60), true);
      expect(inQuietHours(cfg, 12 * 60), false);
    });
    test('templates rotate', () {
      final (i, t) = renderNudge(escalated: false, vars: {'min': '20', 'app': 'Instagram', 'task': 'Invoice', 'score': '95', 'goal': 'G', 'pct': '5', 'days': '9'}, rng: Random(1));
      final (j, _) = renderNudge(escalated: false, vars: {}, lastIndex: i, rng: Random(1));
      expect(j, isNot(i));
      expect(t.contains('{'), false);
    });
  });

  group('categorizer', () {
    test('content rules', () {
      expect(categorizeContent(title: 'Flutter Riverpod 3 full course'), 'learning');
      expect(categorizeContent(title: 'Funniest cricket moments 2026'), 'entertainment');
      expect(categorizeContent(title: 'xyz abc'), null);
      expect(categorizeContent(title: 'xyz', channelOrDomain: 'Code With Andrea', rules: [const ContentRuleSpec('channel', 'code with andrea', 'learning')]), 'learning');
    });
    test('channel rule learning', () {
      expect(channelRuleCandidate(['learning', 'learning']), null);
      expect(channelRuleCandidate(['learning', 'other', 'learning', 'learning']), 'learning');
    });
  });
}
