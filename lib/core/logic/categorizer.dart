import '../utils/hash.dart';

const categories = ['work', 'learning', 'entertainment', 'social', 'communication', 'physical', 'utility', 'other'];

const defaultContentKeywords = <String, List<String>>{
  'learning': ['tutorial', 'course', 'how to', 'learn', 'flutter', 'laravel', 'interview', 'lecture', 'explained', 'riverpod', 'dart', 'kotlin', 'robotics', 'documentation', 'crash course'],
  'work': ['invoice', 'dashboard', 'admin', 'github', 'jira', 'docs', 'pull request', 'figma', 'console'],
  'entertainment': ['funny', 'comedy', 'trailer', 'highlights', 'cricket', 'meme', 'prank', 'song', 'music video', 'vlog', 'reaction', 'movie', 'web series'],
  'social': ['reels', 'story', 'stories', 'feed', 'timeline'],
};

class ContentRuleSpec {
  final String matchType; // keyword | channel | domain
  final String value;
  final String category;
  const ContentRuleSpec(this.matchType, this.value, this.category);
}

/// Returns a category or null when unknown (queued for AI).
/// Order: channel/domain overrides → user keyword rules → built-in keywords.
String? categorizeContent({
  required String title,
  String? channelOrDomain,
  List<ContentRuleSpec> rules = const [],
  Map<String, List<String>> keywords = defaultContentKeywords,
}) {
  final t = normText(title);
  final c = channelOrDomain == null ? '' : normText(channelOrDomain);
  for (final r in rules) {
    if ((r.matchType == 'channel' || r.matchType == 'domain') && c.isNotEmpty && c == normText(r.value)) return r.category;
  }
  for (final r in rules) {
    if (r.matchType == 'keyword' && t.contains(normText(r.value))) return r.category;
  }
  for (final e in keywords.entries) {
    for (final k in e.value) {
      if (RegExp('(^| )${RegExp.escape(normText(k))}( |\$)').hasMatch(t)) return e.key;
    }
  }
  return null;
}

/// Category for an app: user override → built-in map → 'other'.
String categorizeApp(String pkg, Map<String, String> userOverrides, Map<String, String> builtIn) =>
    userOverrides[pkg] ?? builtIn[pkg] ?? 'other';

/// Counts class votes per channel; returns the class if it reached [threshold] identical votes.
String? channelRuleCandidate(List<String> classesForChannel, {int threshold = 3}) {
  final counts = <String, int>{};
  for (final c in classesForChannel) {
    counts[c] = (counts[c] ?? 0) + 1;
    if (counts[c]! >= threshold) return c;
  }
  return null;
}

bool isWasted(String category) => category == 'entertainment' || category == 'social';
