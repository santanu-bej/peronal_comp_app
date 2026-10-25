import 'nudge_rules.dart';

const defaultYoutubeIds = ['reel_recycler', 'reel_player_page_container', 'reel_watch_player', 'reel_watch_fragment_root'];
const defaultInstagramIds = ['clips_viewer_view_pager', 'clips_viewer_container', 'clips_video_container', 'root_clips_layout'];
const defaultBrowserBars = [
  'com.android.chrome:id/url_bar',
  'com.brave.browser:id/url_bar',
  'com.sec.android.app.sbrowser:id/location_bar_edit_text',
  'org.mozilla.firefox:id/mozac_browser_toolbar_url_view',
];
const contentAllowList = [
  'com.google.android.youtube', 'com.android.chrome', 'com.brave.browser', 'com.instagram.android', 'com.facebook.katana',
];
const defaultDenyList = [
  'com.google.android.dialer', 'com.android.dialer', 'com.samsung.android.dialer', 'com.android.camera', 'com.sec.android.app.camera',
  'com.google.android.apps.maps', 'com.google.android.apps.nbu.paisa.user', 'com.phonepe.app', 'net.one97.paytm', 'in.org.npci.upiapp',
  'com.google.android.apps.messaging',
];

class GuardSettings {
  final bool nudges;
  final int afterMin, snoozeMax, quietStartMin, quietEndMin, minScore;
  final List<({int startMin, int endMin, List<int> days})> focusWindows;
  final Set<String> denyList;
  final bool blockYoutube, blockInstagram, blockBrowsers, dnd;
  final List<String> youtubeIds, instagramIds, browserBars;
  const GuardSettings({
    this.nudges = true,
    this.afterMin = 15,
    this.snoozeMax = 2,
    this.quietStartMin = 23 * 60,
    this.quietEndMin = 7 * 60,
    this.minScore = 70,
    this.focusWindows = const [
      (startMin: 600, endMin: 780, days: [1, 2, 3, 4, 5]),
      (startMin: 900, endMin: 1140, days: [1, 2, 3, 4, 5]),
    ],
    this.denyList = const {...defaultDenyList},
    this.blockYoutube = true,
    this.blockInstagram = true,
    this.blockBrowsers = true,
    this.dnd = false,
    this.youtubeIds = defaultYoutubeIds,
    this.instagramIds = defaultInstagramIds,
    this.browserBars = defaultBrowserBars,
  });

  Map<String, Object?> toJson() => {
        'nudges': nudges,
        'dnd': dnd,
        'afterMin': afterMin,
        'minScore': minScore,
        'snoozeMax': snoozeMax,
        'quietStartMin': quietStartMin,
        'quietEndMin': quietEndMin,
        'focusWindows': [for (final w in focusWindows) {'start': w.startMin, 'end': w.endMin, 'days': w.days}],
        'denyList': denyList.toList(),
        'blockYoutube': blockYoutube,
        'blockInstagram': blockInstagram,
        'blockBrowsers': blockBrowsers,
        'youtubeIds': youtubeIds,
        'instagramIds': instagramIds,
        'browserBars': browserBars,
      };

  GuardSettings copyWith({
    bool? nudges, int? afterMin, int? snoozeMax, int? quietStartMin, int? quietEndMin, int? minScore,
    List<({int startMin, int endMin, List<int> days})>? focusWindows, Set<String>? denyList,
    bool? blockYoutube, bool? blockInstagram, bool? blockBrowsers, bool? dnd,
    List<String>? youtubeIds, List<String>? instagramIds, List<String>? browserBars,
  }) =>
      GuardSettings(
        nudges: nudges ?? this.nudges,
        afterMin: afterMin ?? this.afterMin,
        snoozeMax: snoozeMax ?? this.snoozeMax,
        quietStartMin: quietStartMin ?? this.quietStartMin,
        quietEndMin: quietEndMin ?? this.quietEndMin,
        minScore: minScore ?? this.minScore,
        focusWindows: focusWindows ?? this.focusWindows,
        denyList: denyList ?? this.denyList,
        blockYoutube: blockYoutube ?? this.blockYoutube,
        blockInstagram: blockInstagram ?? this.blockInstagram,
        blockBrowsers: blockBrowsers ?? this.blockBrowsers,
        dnd: dnd ?? this.dnd,
        youtubeIds: youtubeIds ?? this.youtubeIds,
        instagramIds: instagramIds ?? this.instagramIds,
        browserBars: browserBars ?? this.browserBars,
      );

  static GuardSettings fromJson(Map<String, dynamic>? m) {
    if (m == null) return const GuardSettings();
    List<String> sl(String k, List<String> d) => (m[k] as List?)?.cast<String>() ?? d;
    return GuardSettings(
      nudges: m['nudges'] as bool? ?? true,
      afterMin: m['afterMin'] as int? ?? 15,
      snoozeMax: m['snoozeMax'] as int? ?? 2,
      quietStartMin: m['quietStartMin'] as int? ?? 23 * 60,
      quietEndMin: m['quietEndMin'] as int? ?? 7 * 60,
      minScore: m['minScore'] as int? ?? 70,
      focusWindows: (m['focusWindows'] as List?)
              ?.map((w) => (startMin: w['start'] as int, endMin: w['end'] as int, days: (w['days'] as List).cast<int>()))
              .toList() ??
          const GuardSettings().focusWindows,
      denyList: (m['denyList'] as List?)?.cast<String>().toSet() ?? {...defaultDenyList},
      dnd: m['dnd'] as bool? ?? false,
      blockYoutube: m['blockYoutube'] as bool? ?? true,
      blockInstagram: m['blockInstagram'] as bool? ?? true,
      blockBrowsers: m['blockBrowsers'] as bool? ?? true,
      youtubeIds: sl('youtubeIds', defaultYoutubeIds),
      instagramIds: sl('instagramIds', defaultInstagramIds),
      browserBars: sl('browserBars', defaultBrowserBars),
    );
  }

  /// Everything the Kotlin side needs. Includes blocker toggles, ids, categories, and template variables.
  Map<String, Object?> toNative({
    required Map<String, String> categories,
    required String userName,
    String? goalTitle,
    int? goalPct,
    int? goalDays,
  }) =>
      {
        'nudgesEnabled': nudges,
        'dnd': dnd,
        'afterMin': afterMin,
        'minScore': minScore,
        'snoozeMax': snoozeMax,
        'minGapMin': 10,
        'quietStartMin': quietStartMin,
        'quietEndMin': quietEndMin,
        'focusWindows': [for (final w in focusWindows) {'start': w.startMin, 'end': w.endMin, 'days': w.days}],
        'denyList': denyList.toList(),
        'blockYoutube': blockYoutube,
        'blockInstagram': blockInstagram,
        'blockBrowsers': blockBrowsers,
        'youtubeIds': youtubeIds,
        'instagramIds': instagramIds,
        'browserBars': browserBars,
        'contentAllow': contentAllowList,
        'categories': categories,
        'user': userName,
        'goalTitle': goalTitle ?? 'your goal',
        'goalPct': goalPct ?? 0,
        'goalDays': goalDays ?? 0,
        'normalTemplates': normalTemplates,
        'escalatedTemplates': escalatedTemplates,
      };

  NudgeConfig toNudgeConfig() => NudgeConfig(
        enabled: nudges,
        afterMin: afterMin,
        focusWindows: focusWindows,
        quietStartMin: quietStartMin,
        quietEndMin: quietEndMin,
        snoozeMax: snoozeMax,
        minScore: minScore,
        denyList: denyList,
      );
}
