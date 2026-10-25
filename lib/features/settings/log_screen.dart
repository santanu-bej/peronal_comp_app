import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';

final _logProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.eventLog)..orderBy([(e) => OrderingTerm.desc(e.at)])..limit(300)).watch();
});

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(_logProvider).value ?? [];
    final c = context.clay;
    return ClayScreen(title: 'Activity log', back: true, bottomPad: 40, children: [
      if (rows.isEmpty) const EmptyState(text: 'Nothing logged yet.'),
      for (final r in rows)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ClayContainer(
            padding: const EdgeInsets.all(12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 6, right: 10), decoration: BoxDecoration(color: r.level == 'error' ? c.rose : r.level == 'warn' ? c.butter : c.mint, shape: BoxShape.circle)),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.message, style: Theme.of(context).textTheme.bodyMedium),
                Text('${r.source} · ${shortDate(r.at)} ${timeLabel(r.at)}', style: Theme.of(context).textTheme.bodySmall),
              ])),
            ]),
          ),
        ),
    ]);
  }
}
