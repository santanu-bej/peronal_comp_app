import '../utils/hash.dart';

class LocalScore {
  final int score;
  final bool confident;
  final String reason;
  final int? goalIndex; // index into the digests list passed in
  const LocalScore(this.score, this.confident, this.reason, {this.goalIndex});
}

class KeywordGroup {
  final String name;
  final int points;
  final List<String> words;
  const KeywordGroup(this.name, this.points, this.words);
}

const defaultKeywordGroups = <KeywordGroup>[
  KeywordGroup('money-in', 35, ['invoice', 'payment', 'collect', 'balance', 'retainer', 'payout']),
  KeywordGroup('sales', 30, ['client', 'proposal', 'quote', 'lead', 'outreach', 'follow up', 'followup', 'demo', 'pitch']),
  KeywordGroup('deliver', 20, ['deliver', 'publish', 'deploy', 'launch', 'finish', 'ship']),
  KeywordGroup('must-do', 25, ['ca', 'gst', 'roc', 'filing', 'tax', 'bank', 'lease', 'legal']),
  KeywordGroup('polish', -10, ['logo', 'redesign', 'refactor', 'cleanup', 'clean up']),
];

const _stop = {
  'the', 'a', 'an', 'to', 'of', 'for', 'and', 'or', 'in', 'on', 'at', 'with', 'my', 'is', 'it', 'be', 'by', 'from', 'this', 'that', 'new', 'do', 'get',
};

Set<String> _words(String s) => normText(s).split(' ').where((w) => w.length > 2 && !_stop.contains(w)).toSet();

bool _hasWord(String normalized, String kw) => RegExp('(^| )${RegExp.escape(kw)}( |\$)').hasMatch(normalized);

/// Splits a digest into (helpful part, "does NOT help" part). The marker is case-insensitive.
({String helps, String parked}) splitDigest(String digest) {
  final m = RegExp(r'(does not help|not helping|not help|distractions?)\s*[:\-]?', caseSensitive: false).firstMatch(digest);
  if (m == null) return (helps: digest, parked: '');
  return (helps: digest.substring(0, m.start), parked: digest.substring(m.end));
}

/// PRD/AI.md §5. [digests] are the active goals' digests (index = goalIndex).
LocalScore scoreLocally(
  String title,
  int estimateMin,
  List<String> digests, {
  List<KeywordGroup> groups = defaultKeywordGroups,
}) {
  final n = normText(title);
  var score = 40;
  final matched = <String>[];
  var anyGroup = false;

  for (final g in groups) {
    if (g.words.any((w) => _hasWord(n, normText(w)))) {
      score += g.points;
      matched.add(g.name);
      anyGroup = true;
    }
  }

  final tw = _words(title);
  int? bestGoal;
  var bestOverlap = 0;
  var parkedHit = false;
  for (var i = 0; i < digests.length; i++) {
    final parts = splitDigest(digests[i]);
    final helpW = _words(parts.helps);
    final overlap = tw.intersection(helpW).length;
    if (overlap > bestOverlap) {
      bestOverlap = overlap;
      bestGoal = i;
    }
    final parkedW = _words(parts.parked);
    if (tw.intersection(parkedW).isNotEmpty) parkedHit = true;
  }
  if (bestOverlap >= 2) {
    score += 10;
    matched.add('matches goal');
    anyGroup = true;
  } else if (bestOverlap == 1) {
    // single-word overlap with a digest: gives the goal link but isn't a score signal
  } else {
    bestGoal = null;
  }
  if (parkedHit) {
    score -= 35;
    matched.add('listed as not helping');
    anyGroup = true;
  }

  if (estimateMin >= 480 && score < 70) score -= 10;
  if (estimateMin <= 30 && score >= 50) score += 5;

  score = score.clamp(0, 100);
  final confident = (score - 50).abs() >= 30 && anyGroup;
  final reason = matched.isEmpty ? 'No clear link to your goals.' : 'Matched: ${matched.join(', ')}.';
  return LocalScore(score, confident, reason, goalIndex: bestGoal);
}
