import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/logic/pace.dart';
import '../../core/providers.dart';
import '../../core/services/stats_service.dart';
import '../../core/services/time_service.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/money_format.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/clay_progress.dart';
import '../../core/widgets/screen.dart';
import '../goals/goals_screen.dart';
import '../goals/goal_sheet.dart';
import 'dashboard_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _S();
}

class _S extends ConsumerState<DashboardScreen> {
  bool _regen = false;

  String _greeting() {
    final h = nowIst().hour;
    return h < 12 ? 'Good morning' : h < 17 ? 'Good afternoon' : 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final name = ref.watch(userNameProvider);
    final goals = ref.watch(goalViewsListProvider).where((g) => g.goal.status == 'active').toList();
    final today = ref.watch(todaySummaryProvider).value;
    final top = ref.watch(topTodoProvider).value;
    final money = ref.watch(monthMoneyProvider).value;
    final streaks = ref.watch(streaksProvider).value;
    final nudges = ref.watch(nudgeStatsProvider).value;
    final review = ref.watch(weeklyReviewProvider).value;
    final onTrack = goals.where((g) => g.status == GoalStatus.ahead || g.status == GoalStatus.onTrack).length;
    final status = goals.isEmpty
        ? 'Add a goal to get started.'
        : '$onTrack of ${goals.length} goal${goals.length == 1 ? '' : 's'} on track.${today == null ? '' : ' ${today.wastedMin} min wasted today.'}';
    final weekday = nowIst().weekday;

    return ClayScreen(title: '${_greeting()}, $name', children: [
      Text(status, style: t.bodyLarge?.copyWith(color: c.inkMuted)),
      const SizedBox(height: 16),
      _DoThisNow(todoId: top?.id),
      if (goals.isEmpty)
        Padding(padding: const EdgeInsets.only(top: 16), child: EmptyState(text: 'No goals yet.', buttonLabel: 'New goal', onPressed: () => showGoalSheet(context)))
      else ...[
        const SectionTitle('Goals'),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: goals.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(bottom: 12, right: 4), child: GoalCard(v: goals[i], compact: true)),
          ),
        ),
      ],
      const SectionTitle('Today'),
      _TodayCard(s: today),
      if (money != null && (money.target > 0 || money.totals.saved > 0)) ...[
        const SectionTitle('Money this month'),
        ClayContainer(
          onTap: () => context.push('/money'),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(money.target > 0 ? '${formatPaise(money.totals.saved)} saved of ${formatPaise(money.target)}' : '${formatPaise(money.totals.saved)} saved', style: t.titleMedium),
            const SizedBox(height: 10),
            ClayProgressBar(value: money.target > 0 ? money.totals.saved / money.target : 0, color: c.peach),
          ]),
        ),
      ],
      if (streaks != null) ...[
        const SectionTitle('Streaks'),
        Wrap(spacing: 10, runSpacing: 10, children: [
          ClayChip('Wake on time ${streaks.wake}d', color: c.peach, icon: Icons.alarm_rounded),
          ClayChip('Deep work ${streaks.deepWork}d', color: c.primary, icon: Icons.bolt_rounded),
          ClayChip('Steps ${streaks.steps}d', color: c.mint, icon: Icons.directions_walk_rounded),
          if (nudges?.pct != null) ClayChip('Nudges obeyed ${nudges!.pct}%', color: c.butter, icon: Icons.notifications_active_rounded),
          if ((nudges?.blocked ?? 0) > 0) ClayChip('${nudges!.blocked} Shorts blocked', color: c.rose, icon: Icons.block_rounded),
        ]),
      ],
      SectionTitle(weekday == DateTime.sunday ? 'Weekly review · today' : 'Weekly review'),
      _ReviewCard(review: review, regenerating: _regen, onGenerate: _generate),
    ]);
  }

  Future<void> _generate() async {
    setState(() => _regen = true);
    try {
      final ai = await ref.read(aiClientProvider).isEnabled();
      await ref.read(statsServiceProvider).review(ai ? ref.read(aiFeaturesProvider) : null, ref.read(goalViewsListProvider), force: true);
      ref.invalidate(weeklyReviewProvider);
    } finally {
      if (mounted) setState(() => _regen = false);
    }
  }
}

class _DoThisNow extends ConsumerWidget {
  final String? todoId;
  const _DoThisNow({required this.todoId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final todo = (ref.watch(todosProvider).value ?? []).where((x) => x.id == todoId).firstOrNull;
    if (todo == null) {
      return ClayContainer(child: Row(children: [Icon(Icons.celebration_rounded, color: c.mint), const SizedBox(width: 12), Expanded(child: Text('Nothing open. Add a todo or enjoy the quiet.', style: t.bodyLarge))]));
    }
    return ClayContainer(
      color: c.primary.withValues(alpha: c.dark ? 0.35 : 0.18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Do this now', style: t.labelMedium),
        const SizedBox(height: 6),
        Row(children: [Expanded(child: Text(todo.title, style: t.headlineMedium)), const SizedBox(width: 8), ScoreBadge(todo.score)]),
        if (todo.reason != null && todo.reason!.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text(todo.reason!, style: t.bodySmall)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: ClayButton('Start focus', icon: Icons.play_arrow_rounded, onPressed: () => startFocusFor(context, ref, todo.id, todo.score))),
          const SizedBox(width: 12),
          Expanded(child: ClayButton('Done', icon: Icons.check_rounded, kind: ClayButtonKind.soft, onPressed: () => ref.read(todoRepoProvider).complete(todo))),
        ]),
      ]),
    );
  }
}

/// F2.5: warn when starting a low-score todo while a ≥ 75 one is open.
Future<void> startFocusFor(BuildContext context, WidgetRef ref, String todoId, int? score) async {
  final repo = ref.read(todoRepoProvider);
  final open = await repo.open();
  final warn = higherValueWarningFor(score, open, todoId);
  if (warn != null && context.mounted) {
    final ok = await confirm(context, 'Higher-value work', 'You have higher-value work: ${warn.title} (${warn.score}). Continue anyway?', yes: 'Continue');
    if (!ok) return;
  }
  await ref.read(timeServiceProvider).startFocus(todoId: todoId);
  await ref.read(bridgeProvider).startFocusNotification(true, title: 'Focus session running');
  if (context.mounted) toast(context, 'Focus started. Stop it from Time.');
}

class _TodayCard extends StatelessWidget {
  final DaySummary? s;
  const _TodayCard({required this.s});
  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final mins = s?.minutes ?? {};
    final cats = mins.entries.where((e) => e.value >= 1 && e.key != 'sleep').toList();
    final total = cats.fold<double>(0, (a, e) => a + e.value);
    final wl = ((s?.workMin ?? 0) + (s?.learningMin ?? 0)) / 60;
    return ClayContainer(
      onTap: () => context.go('/time'),
      child: Column(children: [
        Row(children: [
          SizedBox(
            width: 120,
            height: 120,
            child: total == 0
                ? Center(child: Text('No data yet', style: t.bodySmall))
                : PieChart(PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 34,
                    sections: [for (final e in cats) PieChartSectionData(value: e.value, color: c.category(e.key), radius: 18, showTitle: false)],
                  )),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${wl.toStringAsFixed(1)} h', style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 36)),
              Text('work + learning', style: t.bodySmall),
            ]),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          _Pill(label: 'wasted', value: '${s?.wastedMin ?? 0} min', color: c.rose),
          const SizedBox(width: 10),
          _Pill(label: 'steps', value: '${s?.steps ?? 0}', color: c.mint),
        ]),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Pill({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(ClayRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 20)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      );
}

class _ReviewCard extends StatelessWidget {
  final WeeklyReview? review;
  final bool regenerating;
  final VoidCallback onGenerate;
  const _ReviewCard({required this.review, required this.regenerating, required this.onGenerate});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ClayContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (review == null) Text('No review for this week yet. It is generated on Sunday evening, or tap below.', style: t.bodyMedium),
        if (review != null) ...[
          Text(review!.fromAi ? 'Insights' : 'Numbers', style: t.labelMedium),
          for (final i in review!.insights) Padding(padding: const EdgeInsets.only(top: 6), child: Text('• $i')),
          const SizedBox(height: 10),
          Text('Next week', style: t.labelMedium),
          for (final a in review!.actions) Padding(padding: const EdgeInsets.only(top: 6), child: Text('→ $a')),
        ],
        const SizedBox(height: 12),
        ClayButton(review == null ? 'Generate review' : 'Regenerate', kind: ClayButtonKind.soft, busy: regenerating, onPressed: onGenerate),
      ]),
    );
  }
}
