import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../ai/ai_features.dart';
import '../db/database.dart';
import '../logic/categorizer.dart';
import '../logic/time_calc.dart';
import '../native/native_bridge.dart';
import '../repos/goal_repo.dart';
import '../utils/hash.dart';
import '../utils/time.dart';

class DaySummary {
  final Map<String, double> minutes;
  final int wastedMin, workMin, learningMin;
  final List<MapEntry<String, int>> topApps; // package -> minutes
  final List<ContentItem> topContent;
  final int steps;
  const DaySummary(this.minutes, this.wastedMin, this.workMin, this.learningMin, this.topApps, this.topContent, this.steps);
}

class TimeService {
  final AppDb db;
  final NativeBridge bridge;
  TimeService(this.db, this.bridge);

  Map<String, String>? _builtIn;

  Future<Map<String, String>> builtIn() async {
    if (_builtIn != null) return _builtIn!;
    try {
      final raw = jsonDecode(await rootBundle.loadString('assets/app_categories.json')) as Map<String, dynamic>;
      _builtIn = raw.map((k, v) => MapEntry(k, v as String));
    } catch (_) {
      _builtIn = {};
    }
    return _builtIn!;
  }

  Future<Map<String, String>> userOverrides() async {
    final rows = await (db.select(db.appCategories)..where((a) => a.userSet.equals(true))).get();
    return {for (final r in rows) r.package: r.category};
  }

  Future<Map<String, String>> allCategories() async => {...await builtIn(), ...await userOverrides()};

  Future<List<ContentRuleSpec>> rules() async => [
        for (final r in await db.select(db.contentRules).get()) ContentRuleSpec(r.matchType, r.value, r.category)
      ];

  // ---------- ingestion ----------
  /// Reads native usage since the cursor and stores categorised sessions. Idempotent through the cursor.
  Future<int> aggregate({int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final cursor = await db.getSetting<int>('usage.cursor') ?? startOfDayMs(now);
    final raw = await bridge.readUsage(cursor, now);
    final cats = await allCategories();
    final sessions = toSessions([for (final e in raw) (pkg: e.pkg, start: e.start, end: e.end)], (p) => cats[p] ?? 'other');
    for (final s in sessions) {
      await db.into(db.usageSessions).insert(UsageSessionsCompanion.insert(
          package: s.pkg, startedAt: s.start, endedAt: s.end, category: s.category));
    }
    final latest = raw.isEmpty ? cursor : raw.map((e) => e.end).reduce((a, b) => a > b ? a : b);
    await db.setSetting('usage.cursor', latest > cursor ? latest : cursor);
    await drainEvents();
    await updateToday(nowMs: now);
    return sessions.length;
  }

  /// Applies queued native events (content items, nudge actions, wake/escalation log, alert actions).
  Future<void> drainEvents() async {
    final cats = await allCategories();
    final rs = await rules();
    for (final e in await bridge.drainEvents()) {
      final at = (e['at'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch;
      switch (e['type']) {
        case 'content':
          final title = (e['title'] as String?) ?? '';
          if (title.isEmpty) break;
          final ch = e['channel'] as String?;
          final kind = (e['kind'] as String?) ?? 'page';
          final pkg = (e['pkg'] as String?) ?? '';
          String? cat = switch (kind) {
            'reels' || 'feed' => 'social',
            'dm' => 'communication',
            _ => categorizeContent(title: title, channelOrDomain: ch, rules: rs),
          };
          await db.into(db.contentItems).insert(ContentItemsCompanion.insert(
                package: pkg,
                title: title,
                channelOrDomain: Value(ch),
                kind: Value(kind),
                startedAt: (e['start'] as num?)?.toInt() ?? at,
                endedAt: Value((e['end'] as num?)?.toInt()),
                category: Value(cat),
                classifiedBy: Value(cat == null ? 'pending' : 'rule'),
                titleHash: normHash('${ch ?? ''}|$title'),
              ));
        case 'nudge':
          await db.into(db.nudgeLog).insert(NudgeLogCompanion.insert(
                at: at,
                type: (e['kind'] as String?) ?? 'nudge',
                package: Value(e['pkg'] as String?),
                todoId: Value(e['todoId'] as String?),
                text_: (e['text'] as String?) ?? '',
                action: (e['action'] as String?) ?? 'ignored',
              ));
        case 'todo_done':
          final id = e['todoId'] as String?;
          if (id != null) {
            await (db.update(db.todos)..where((t) => t.id.equals(id) & t.status.equals('open')))
                .write(TodosCompanion(status: const Value('done'), doneAt: Value(at)));
          }
        case 'todo_snooze':
          final id = e['todoId'] as String?;
          final until = (e['until'] as num?)?.toInt();
          if (id != null && until != null) {
            await (db.update(db.todos)..where((t) => t.id.equals(id))).write(TodosCompanion(remindAt: Value(until)));
          }
        case 'focus_stop':
          await stopFocus(at: at);
        case 'focus_start':
          await startFocus(source: (e['source'] as String?) ?? 'tile', at: at);
        case 'wake' || 'escalation' || 'alert' || 'guard':
          await db.log(e['type'] as String, (e['message'] as String?) ?? e['type'] as String,
              level: (e['level'] as String?) ?? 'info', data: {...e}..remove('type')..remove('message')..remove('level'));
      }
    }
    // channel rule learning: 3 identical AI/rule classes on a channel -> rule
    await _learnChannelRules();
    _unused(cats);
  }

  void _unused(Object _) {}

  Future<void> _learnChannelRules() async {
    final rows = await (db.select(db.contentItems)
          ..where((c) => c.channelOrDomain.isNotNull() & c.category.isNotNull() & c.classifiedBy.isIn(['ai', 'user'])))
        .get();
    final byCh = <String, List<String>>{};
    for (final r in rows) {
      byCh.putIfAbsent(r.channelOrDomain!, () => []).add(r.category!);
    }
    final existing = (await db.select(db.contentRules).get()).map((r) => '${r.matchType}:${normText(r.value)}').toSet();
    for (final e in byCh.entries) {
      final cls = channelRuleCandidate(e.value);
      if (cls != null && !existing.contains('channel:${normText(e.key)}')) {
        await db.into(db.contentRules).insert(ContentRulesCompanion.insert(matchType: 'channel', value: e.key, category: cls));
      }
    }
  }

  // ---------- classification (A5) ----------
  Future<int> classifyPending(AiFeatures? ai, {int max = 50}) async {
    final rows = await (db.select(db.contentItems)..where((c) => c.classifiedBy.equals('pending'))..limit(max * 4)).get();
    if (rows.length < 5 || ai == null) return 0;
    final seen = <String>{};
    final uniq = <ContentItem>[];
    for (final r in rows) {
      if (seen.add(r.titleHash)) uniq.add(r);
      if (uniq.length >= max) break;
    }
    final res = await ai.classify([for (final u in uniq) (p: _plat(u.package), t: u.title, c: u.channelOrDomain)]);
    var n = 0;
    for (var i = 0; i < uniq.length; i++) {
      final c = res[i];
      if (c == null) continue;
      await (db.update(db.contentItems)..where((x) => x.titleHash.equals(uniq[i].titleHash) & x.classifiedBy.equals('pending')))
          .write(ContentItemsCompanion(category: Value(c), classifiedBy: const Value('ai')));
      n++;
    }
    await _learnChannelRules();
    return n;
  }

  String _plat(String pkg) => switch (pkg) {
        'com.google.android.youtube' => 'yt',
        'com.android.chrome' || 'com.brave.browser' => 'web',
        'com.instagram.android' => 'ig',
        'com.facebook.katana' => 'fb',
        _ => 'app',
      };

  // ---------- user edits ----------
  Future<void> setAppCategory(String pkg, String label, String category) async {
    await db.into(db.appCategories).insertOnConflictUpdate(
        AppCategoriesCompanion.insert(package: pkg, label: label, category: category, userSet: const Value(true)));
    // applies to the past too
    await (db.update(db.usageSessions)..where((s) => s.package.equals(pkg))).write(UsageSessionsCompanion(category: Value(category)));
  }

  Future<void> setContentCategory(ContentItem item, String category, {bool markChannel = false}) async {
    await (db.update(db.contentItems)..where((c) => c.id.equals(item.id)))
        .write(ContentItemsCompanion(category: Value(category), classifiedBy: const Value('user')));
    if (markChannel && item.channelOrDomain != null) {
      await db.into(db.contentRules).insert(ContentRulesCompanion.insert(
          matchType: item.package.contains('youtube') ? 'channel' : 'domain', value: item.channelOrDomain!, category: category));
      await (db.update(db.contentItems)..where((c) => c.channelOrDomain.equals(item.channelOrDomain!)))
          .write(ContentItemsCompanion(category: Value(category), classifiedBy: const Value('user')));
    }
  }

  // ---------- focus sessions ----------
  Future<String?> activeFocusId() async =>
      (await (db.select(db.focusSessions)..where((f) => f.endedAt.isNull())).getSingleOrNull())?.id;

  Future<String> startFocus({String? todoId, String category = 'work', String source = 'manual', int? at}) async {
    final existing = await activeFocusId();
    if (existing != null) return existing;
    final id = newId();
    await db.into(db.focusSessions).insert(FocusSessionsCompanion.insert(
        id: id, todoId: Value(todoId), category: Value(category), startedAt: at ?? DateTime.now().millisecondsSinceEpoch, source: Value(source)));
    return id;
  }

  Future<void> stopFocus({int? at}) => (db.update(db.focusSessions)..where((f) => f.endedAt.isNull()))
      .write(FocusSessionsCompanion(endedAt: Value(at ?? DateTime.now().millisecondsSinceEpoch)));

  // ---------- summaries ----------
  Future<DaySummary> summary(int fromMs, int toMs) async {
    final ss = await (db.select(db.usageSessions)..where((s) => s.startedAt.isBiggerOrEqualValue(fromMs) & s.startedAt.isSmallerThanValue(toMs))).get();
    final cs = await (db.select(db.contentItems)..where((c) => c.startedAt.isBiggerOrEqualValue(fromMs) & c.startedAt.isSmallerThanValue(toMs))).get();
    final fs = await (db.select(db.focusSessions)..where((f) => f.startedAt.isSmallerThanValue(toMs))).get();
    final now = DateTime.now().millisecondsSinceEpoch;
    final minutes = minutesByCategory(
      [for (final s in ss) TSession(s.package, s.startedAt, s.endedAt, s.category)],
      [for (final c in cs) TContent(c.package, c.startedAt, c.endedAt ?? c.startedAt + 60000, c.category)],
      [for (final f in fs) TFocus(f.startedAt, f.endedAt ?? now, f.category)],
      fromMs,
      toMs,
    );
    final perApp = <String, int>{};
    for (final s in ss) {
      perApp[s.package] = (perApp[s.package] ?? 0) + (s.endedAt - s.startedAt);
    }
    final top = perApp.entries.map((e) => MapEntry(e.key, (e.value / 60000).round())).where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topContent = ([...cs]..sort((a, b) => ((b.endedAt ?? b.startedAt) - b.startedAt).compareTo((a.endedAt ?? a.startedAt) - a.startedAt))).take(8).toList();
    final steps = (await (db.select(db.activityDaily)..where((a) => a.date.equals(dateKey(fromMs)))).getSingleOrNull())?.steps ?? 0;
    return DaySummary(minutes, wastedMinutes(minutes), (minutes['work'] ?? 0).round(), (minutes['learning'] ?? 0).round(), top.take(10).toList(), topContent, steps);
  }

  Future<void> updateToday({int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final from = startOfDayMs(now);
    final s = await summary(from, from + msPerDay);
    await db.into(db.dailyRollup).insertOnConflictUpdate(DailyRollupCompanion.insert(
          date: dateKey(from),
          minutesByCategoryJson: Value(jsonEncode(s.minutes.map((k, v) => MapEntry(k, v.round())))),
          wastedMin: Value(s.wastedMin),
          workMin: Value(s.workMin),
          learningMin: Value(s.learningMin),
          topAppsJson: Value(jsonEncode([for (final e in s.topApps) {'pkg': e.key, 'min': e.value}])),
        ));
  }

  /// Raw rows older than 90 days → daily_rollup, then deleted. event_log 30 days, ai_cache 180 days.
  Future<void> retention({int? nowMs}) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final cutoff = startOfDayMs(now) - 90 * msPerDay;
    final old = await (db.select(db.usageSessions)..where((s) => s.startedAt.isSmallerThanValue(cutoff))).get();
    final days = <String>{for (final s in old) dateKey(s.startedAt)};
    for (final d in days) {
      final from = msFromDateKey(d);
      final s = await summary(from, from + msPerDay);
      await db.into(db.dailyRollup).insertOnConflictUpdate(DailyRollupCompanion.insert(
            date: d,
            minutesByCategoryJson: Value(jsonEncode(s.minutes.map((k, v) => MapEntry(k, v.round())))),
            wastedMin: Value(s.wastedMin),
            workMin: Value(s.workMin),
            learningMin: Value(s.learningMin),
            topAppsJson: Value(jsonEncode([for (final e in s.topApps) {'pkg': e.key, 'min': e.value}])),
          ));
    }
    await (db.delete(db.usageSessions)..where((s) => s.startedAt.isSmallerThanValue(cutoff))).go();
    await (db.delete(db.contentItems)..where((s) => s.startedAt.isSmallerThanValue(cutoff))).go();
    await (db.delete(db.eventLog)..where((e) => e.at.isSmallerThanValue(now - 30 * msPerDay))).go();
    await (db.delete(db.aiCache)..where((c) => c.createdAt.isSmallerThanValue(now - 180 * msPerDay))).go();
    await (db.delete(db.nudgeLog)..where((n) => n.at.isSmallerThanValue(cutoff))).go();
  }
}
