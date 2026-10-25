import 'dart:convert';
import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/logic/categorizer.dart';
import '../../core/providers.dart';
import '../../core/services/time_service.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

String appLabel(String pkg) {
  final last = pkg.split('.').where((p) => p.isNotEmpty && p != 'android' && p != 'app' && p != 'mobile').lastOrNull ?? pkg;
  return last.isEmpty ? pkg : last[0].toUpperCase() + last.substring(1);
}

class _DayData {
  final DaySummary summary;
  final List<UsageSession> sessions;
  final List<TFocusLite> focus;
  _DayData(this.summary, this.sessions, this.focus);
}

class TFocusLite {
  final int start, end;
  TFocusLite(this.start, this.end);
}

final _dayProvider = StreamProvider.autoDispose.family<_DayData, int>((ref, dayStart) {
  final db = ref.watch(dbProvider);
  final svc = ref.watch(timeServiceProvider);
  return db.customSelect('SELECT 1', readsFrom: {db.usageSessions, db.contentItems, db.focusSessions, db.activityDaily, db.appCategories}).watch().asyncMap((_) async {
    final s = await svc.summary(dayStart, dayStart + msPerDay);
    final sess = await (db.select(db.usageSessions)..where((x) => x.startedAt.isBiggerOrEqualValue(dayStart) & x.startedAt.isSmallerThanValue(dayStart + msPerDay))..orderBy([(x) => OrderingTerm.asc(x.startedAt)])).get();
    final f = await (db.select(db.focusSessions)..where((x) => x.startedAt.isSmallerThanValue(dayStart + msPerDay))).get();
    final now = DateTime.now().millisecondsSinceEpoch;
    return _DayData(s, sess, [for (final x in f) TFocusLite(x.startedAt, x.endedAt ?? now)]);
  });
});

final _weekProvider = FutureProvider.autoDispose<List<(String, Map<String, int>)>>((ref) async {
  final db = ref.watch(dbProvider);
  ref.watch(_dayProvider(startOfDayMs(DateTime.now().millisecondsSinceEpoch)));
  final today = startOfDayMs(DateTime.now().millisecondsSinceEpoch);
  final rows = {for (final r in await db.select(db.dailyRollup).get()) r.date: r};
  return [
    for (var i = 6; i >= 0; i--)
      (
        dateKey(today - i * msPerDay),
        rows[dateKey(today - i * msPerDay)] == null
            ? <String, int>{}
            : (jsonDecode(rows[dateKey(today - i * msPerDay)]!.minutesByCategoryJson) as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as num).toInt())),
      )
  ];
});

class TimeScreen extends ConsumerStatefulWidget {
  const TimeScreen({super.key});
  @override
  ConsumerState<TimeScreen> createState() => _S();
}

class _S extends ConsumerState<TimeScreen> {
  bool _week = false;

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final day = startOfDayMs(DateTime.now().millisecondsSinceEpoch);
    final data = ref.watch(_dayProvider(day)).value;
    final svc = ref.read(timeServiceProvider);
    final focusOn = data?.focus.any((f) => f.end >= DateTime.now().millisecondsSinceEpoch - 1000) == true;
    return ClayScreen(
      title: 'Time',
      onRefresh: () async { await svc.aggregate(); },
      children: [
        Row(children: [
          ClayChip('Today', selected: !_week, onTap: () => setState(() => _week = false)),
          const SizedBox(width: 8),
          ClayChip('Week', selected: _week, onTap: () => setState(() => _week = true)),
        ]),
        const SizedBox(height: 16),
        ClayButton(focusOn ? 'Stop focus session' : 'Start focus session', icon: focusOn ? Icons.stop_rounded : Icons.play_arrow_rounded, kind: focusOn ? ClayButtonKind.danger : ClayButtonKind.primary, onPressed: () async {
          if (focusOn) {
            await svc.stopFocus();
            await ref.read(bridgeProvider).startFocusNotification(false);
          } else {
            await svc.startFocus();
            await ref.read(bridgeProvider).startFocusNotification(true, title: 'Focus session running');
          }
        }),
        const SizedBox(height: 16),
        if (_week) const _Week() else if (data == null) const Center(child: CircularProgressIndicator()) else _Today(data: data, day: day),
        if (!_week && data != null && data.summary.minutes.isEmpty)
          Padding(padding: const EdgeInsets.only(top: 12), child: Text('No usage yet. Turn on Usage access in Setup, then pull down to refresh.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.inkMuted))),
      ],
    );
  }
}

class _Today extends ConsumerWidget {
  final _DayData data;
  final int day;
  const _Today({required this.data, required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final s = data.summary;
    final cats = s.minutes.entries.where((e) => e.value >= 1).toList()..sort((a, b) => b.value.compareTo(a.value));
    final total = cats.where((e) => e.key != 'sleep').fold<double>(0, (a, e) => a + e.value);
    String hm(double m) => m >= 60 ? '${(m / 60).floor()}h ${(m % 60).round()}m' : '${m.round()}m';
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ClayContainer(
        child: Row(children: [
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(alignment: Alignment.center, children: [
              PieChart(PieChartData(sectionsSpace: 2, centerSpaceRadius: 44, sections: [
                if (cats.isEmpty) PieChartSectionData(value: 1, color: c.surfaceAlt, radius: 20, showTitle: false),
                for (final e in cats) PieChartSectionData(value: e.value, color: c.category(e.key), radius: 20, showTitle: false),
              ])),
              Column(mainAxisSize: MainAxisSize.min, children: [Text(hm(total), style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 18)), Text('tracked', style: t.bodySmall)]),
            ]),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final e in cats.take(6)) Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: c.category(e.key), shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text(e.key)), Text(hm(e.value), style: t.bodySmall)])),
          ])),
        ]),
      ),
      const SectionTitle('Timeline'),
      _Timeline(sessions: data.sessions, focus: data.focus, day: day),
      const SectionTitle('Steps'),
      ClayContainer(child: Row(children: [
        Icon(Icons.directions_walk_rounded, color: c.mint),
        const SizedBox(width: 12),
        Text('${s.steps}', style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 28)),
        const SizedBox(width: 8),
        Text('of 8,000', style: t.bodySmall),
      ])),
      const SectionTitle('Top apps'),
      if (s.topApps.isEmpty) Text('Nothing yet.', style: t.bodySmall),
      for (final e in s.topApps.take(8)) _AppRow(pkg: e.key, minutes: e.value),
      const SectionTitle('Top content'),
      if (s.topContent.isEmpty) Text('Content is captured only in YouTube, Chrome, Brave, Instagram and Facebook, with Accessibility on.', style: t.bodySmall),
      for (final i in s.topContent) _ContentRow(item: i),
    ]);
  }
}

class _AppRow extends ConsumerWidget {
  final String pkg;
  final int minutes;
  const _AppRow({required this.pkg, required this.minutes});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.clay;
    final cats = ref.watch(_catsProvider).value ?? {};
    final cat = cats[pkg] ?? 'other';
    return ClayRow(
      title: appLabel(pkg),
      subtitle: pkg,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [ClayChip(cat, color: c.category(cat)), const SizedBox(width: 8), Text('${minutes}m')]),
      onTap: () => _pick(context, ref, pkg, cat),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref, String pkg, String current) async {
    final r = await ClaySheet.show<String>(context, title: 'Category for ${appLabel(pkg)}', child: Wrap(spacing: 8, runSpacing: 8, children: [
      for (final k in categories) ClayChip(k, color: context.clay.category(k), selected: k == current, onTap: () => Navigator.pop(context, k)),
    ]));
    if (r != null) {
      await ref.read(timeServiceProvider).setAppCategory(pkg, appLabel(pkg), r);
      ref.invalidate(_catsProvider);
    }
  }
}

final _catsProvider = FutureProvider.autoDispose<Map<String, String>>((ref) {
  ref.watch(dbProvider).appCategories;
  return ref.watch(timeServiceProvider).allCategories();
});

class _ContentRow extends ConsumerWidget {
  final ContentItem item;
  const _ContentRow({required this.item});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.clay;
    final cat = item.category ?? 'pending';
    final mins = (((item.endedAt ?? item.startedAt) - item.startedAt) / 60000).round();
    return ClayRow(
      title: item.title,
      subtitle: [if (item.channelOrDomain != null) item.channelOrDomain!, '${mins}m'].join(' · '),
      trailing: ClayChip(cat, color: c.category(cat == 'pending' ? 'other' : cat)),
      onTap: () async {
        final r = await ClaySheet.show<(String, bool)>(context, title: 'Re-categorise', child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [for (final k in ['work', 'learning', 'entertainment', 'social', 'other']) ClayChip(k, color: c.category(k), onTap: () => Navigator.pop(context, (k, false)))]),
          if (item.channelOrDomain != null) ...[
            const SizedBox(height: 14),
            Text('Always for ${item.channelOrDomain}:', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final k in ['work', 'learning', 'entertainment', 'social', 'other']) ClayChip(k, color: c.category(k), selected: true, onTap: () => Navigator.pop(context, (k, true)))]),
          ],
        ]));
        if (r != null) await ref.read(timeServiceProvider).setContentCategory(item, r.$1, markChannel: r.$2);
      },
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<UsageSession> sessions;
  final List<TFocusLite> focus;
  final int day;
  const _Timeline({required this.sessions, required this.focus, required this.day});
  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    return ClayContainer(
      child: Column(children: [
        SizedBox(
          height: 36,
          child: CustomPaint(
            size: const Size(double.infinity, 36),
            painter: _TimelinePainter(sessions, focus, day, c),
          ),
        ),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [for (final h in ['12a', '6a', '12p', '6p', '12a']) Text(h, style: Theme.of(context).textTheme.bodySmall)]),
      ]),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final List<UsageSession> sessions;
  final List<TFocusLite> focus;
  final int day;
  final ClayColors c;
  _TimelinePainter(this.sessions, this.focus, this.day, this.c);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(10)), Paint()..color = c.surfaceAlt);
    double x(int ms) => ((ms - day) / msPerDay).clamp(0.0, 1.0) * size.width;
    for (final s in sessions) {
      canvas.drawRect(Rect.fromLTRB(x(s.startedAt), 0, x(s.endedAt) < x(s.startedAt) + 1.5 ? x(s.startedAt) + 1.5 : x(s.endedAt), size.height), Paint()..color = c.category(s.category));
    }
    for (final f in focus) {
      canvas.drawRect(Rect.fromLTRB(x(f.start), size.height - 6, x(f.end), size.height), Paint()..color = c.primary);
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter o) => true;
}

class _Week extends ConsumerWidget {
  const _Week();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.clay;
    final days = ref.watch(_weekProvider).value;
    if (days == null) return const Center(child: CircularProgressIndicator());
    final order = ['work', 'learning', 'physical', 'communication', 'utility', 'social', 'entertainment', 'other'];
    final maxY = days.map((d) => d.$2.entries.where((e) => e.key != 'sleep').fold<int>(0, (a, e) => a + e.value)).fold<int>(60, (a, b) => a > b ? a : b).toDouble();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ClayContainer(
        child: SizedBox(
          height: 220,
          child: BarChart(BarChartData(
            maxY: maxY * 1.1,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                final d = days[v.toInt()].$1;
                return Padding(padding: const EdgeInsets.only(top: 6), child: Text(d.substring(8), style: const TextStyle(fontSize: 11)));
              })),
            ),
            barGroups: [
              for (var i = 0; i < days.length; i++)
                BarChartGroupData(x: i, barRods: [
                  () {
                    var acc = 0.0;
                    final items = <BarChartRodStackItem>[];
                    for (final k in order) {
                      final v = (days[i].$2[k] ?? 0).toDouble();
                      if (v <= 0) continue;
                      items.add(BarChartRodStackItem(acc, acc + v, c.category(k)));
                      acc += v;
                    }
                    return BarChartRodData(toY: acc, width: 22, borderRadius: BorderRadius.circular(8), rodStackItems: items, color: c.surfaceAlt);
                  }()
                ]),
            ],
          )),
        ),
      ),
      const SectionTitle('Wasted time'),
      Text('Wasted = entertainment + social. Days are rolled up nightly and when the app opens.', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 8),
      for (final d in days.reversed)
        ClayRow(title: d.$1, trailing: Text('${(d.$2['entertainment'] ?? 0) + (d.$2['social'] ?? 0)} min wasted · ${(d.$2['work'] ?? 0) + (d.$2['learning'] ?? 0)} min work+learn')),
    ]);
  }
}
