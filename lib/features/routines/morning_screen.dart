import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

class MorningScreen extends ConsumerWidget {
  const MorningScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final name = ref.watch(userNameProvider);
    final todos = (ref.watch(todosProvider).value ?? []);
    final views = (ref.watch(goalViewsProvider).value ?? []).where((v) => v.goal.status == 'active').toList();
    final open = todos.where((x) => x.status == 'open').toList()..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
    final stages = views.expand((v) => v.stages.where((s) => s.status == 'open').map((s) => (v, s))).toList()..sort((a, b) => a.$2.dueAt.compareTo(b.$2.dueAt));
    return ClayScreen(title: 'Good morning, $name', children: [
      if (stages.isNotEmpty) ...[
        const SectionTitle('Today’s focus stage'),
        ClayContainer(color: context.clay.primary.withValues(alpha: 0.2), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(stages.first.$2.title, style: t.titleLarge), Text('${stages.first.$1.goal.title} · due ${shortDate(stages.first.$2.dueAt)}', style: t.bodySmall)])),
      ],
      const SectionTitle('Top 3 todos'),
      if (open.isEmpty) const EmptyState(text: 'No open todos.'),
      for (final x in open.take(3)) ClayRow(title: x.title, subtitle: x.reason, trailing: ScoreBadge(x.score)),
      const SizedBox(height: 16),
      ClayButton('Start', icon: Icons.play_arrow_rounded, onPressed: () async {
        if (open.isNotEmpty) await ref.read(timeServiceProvider).startFocus(todoId: open.first.id);
        if (context.mounted) context.go('/home');
      }),
    ]);
  }
}
