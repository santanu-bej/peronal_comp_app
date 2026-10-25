import 'package:flutter_test/flutter_test.dart';
import 'package:goal_compass/core/logic/local_scorer.dart';

void main() {
  const digests = [
    'G: earn 10 lakh profit at Teqsonic via client sales and invoices. NOT helping: horse game, logo redesign, youtube browsing.',
    'G: ship chat agent MVP by December. Stage: build agent backend. Does not help: marketing site polish.',
  ];

  // (title, estimate, expectConfident, minScore, maxScore)
  final cases = <(String, int, bool, int, int)>[
    ('Send invoice to Astroremedys', 30, true, 80, 100),
    ('Collect payment from client', 30, true, 90, 100),
    ('Prepare proposal for new client', 90, false, 70, 70),
    ('Follow up with lead', 15, false, 75, 75),
    ('GST filing for September', 90, false, 65, 65),
    ('Pay ROC filing fee', 30, false, 70, 70),
    ('Deploy chat agent backend', 90, false, 50, 100),
    ('Redesign logo', 90, true, 0, 20),
    ('Refactor old utils', 90, false, 0, 45),
    ('Build horse game level 2', 2400, true, 0, 20),
    ('Buy groceries', 30, false, 40, 50),
    ('Call mom', 15, false, 40, 50),
    ('Book demo with new lead', 30, false, 75, 75),
    ('Cleanup desk', 15, false, 25, 40),
    ('Publish blog post', 60, false, 55, 65),
    ('Bank statement reconciliation', 90, false, 65, 65),
    ('Legal review of lease', 480, false, 55, 55),
    ('Watch youtube browsing', 30, true, 0, 20),
    ('Pitch deck for investor', 90, false, 70, 70),
    ('Read a novel', 60, false, 40, 40),
  ];

  for (final c in cases) {
    test('scores "${c.$1}"', () {
      final s = scoreLocally(c.$1, c.$2, digests);
      expect(s.score, inInclusiveRange(c.$4, c.$5), reason: '${s.score} ${s.reason}');
      expect(s.confident, c.$3, reason: '${s.score} ${s.reason}');
    });
  }

  test('digest overlap picks the goal', () {
    final s = scoreLocally('Build agent backend endpoints', 90, digests);
    expect(s.goalIndex, 1);
  });
  test('splitDigest', () {
    final p = splitDigest('Goal x. NOT helping: games');
    expect(p.parked.trim(), 'games');
  });
}
