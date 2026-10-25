import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers.dart';
import '../../core/repos/goal_repo.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/clay_progress.dart';
import '../../core/widgets/screen.dart';
import 'goal_sheet.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final views = ref.watch(goalViewsProvider).value ?? [];
    return ClayScreen(title: 'Goals', children: [
      if (views.isEmpty) EmptyState(text: 'No goals yet. Add one with a deadline and a reason.', buttonLabel: 'New goal', onPressed: () => showGoalSheet(context)),
      for (final v in views) GoalCard(v: v),
    ]);
  }
}

class GoalCard extends StatelessWidget {
  final GoalView v;
  final bool compact;
  const GoalCard({super.key, required this.v, this.compact = false});
  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final col = statusColor(c, v.status);
    final ring = ClayProgressRing(
      value: v.pct / 100,
      color: col,
      size: compact ? 72 : 88,
      stroke: compact ? 10 : 12,
      center: Text('${v.pct.round()}%', style: TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: compact ? 18 : 22, color: c.ink)),
    );
    final paused = v.goal.status == 'paused';
    final body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: Color(v.goal.color), shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text(v.goal.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.titleLarge))]),
      const SizedBox(height: 6),
      Text(paused ? 'Paused' : '${v.daysLeftN} days left · ${shortDate(v.goal.deadlineAt)}', style: t.bodySmall),
      const SizedBox(height: 8),
      if (!paused) StatusChip(v.status),
      if (!compact && v.nextStage != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Next: ${v.nextStage!.title}', maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodySmall)),
    ]);
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 0 : 16),
      child: ClayContainer(
        width: compact ? 260 : null,
        onTap: () => context.push('/goal/${v.goal.id}'),
        child: compact
            ? Row(children: [ring, const SizedBox(width: 14), Expanded(child: body)])
            : Row(children: [Expanded(child: body), const SizedBox(width: 12), ring]),
      ),
    );
  }
}
