import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logic/guard_config.dart';
import '../../core/providers.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/screen.dart';
import '../dashboard/dashboard_providers.dart';

String _fmt(int m) => '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';

class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.clay;
    final t = Theme.of(context).textTheme;
    final g = ref.watch(guardSettingsProvider).value ?? const GuardSettings();
    final nudges = ref.watch(nudgeStatsProvider).value;
    final db = ref.read(dbProvider);
    Future<void> save(GuardSettings n) async {
      await db.setSetting('guard', n.toJson());
    }

    Widget toggle(String title, String sub, bool v, ValueChanged<bool> f) => ClayRow(title: title, subtitle: sub, trailing: ClaySwitch(value: v, onChanged: f));

    Future<void> pickRange(String title, int start, int end, void Function(int, int) set) async {
      final a = await showTimePicker(context: context, helpText: '$title start', initialTime: TimeOfDay(hour: start ~/ 60, minute: start % 60));
      if (a == null || !context.mounted) return;
      final b = await showTimePicker(context: context, helpText: '$title end', initialTime: TimeOfDay(hour: end ~/ 60, minute: end % 60));
      if (b == null) return;
      set(a.hour * 60 + a.minute, b.hour * 60 + b.minute);
    }

    return ClayScreen(title: 'Focus guard', back: true, bottomPad: 40, children: [
      ClayContainer(child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Today', style: t.labelMedium), Text('${nudges?.shown ?? 0} nudges shown · ${nudges?.obeyed ?? 0} obeyed', style: t.titleMedium), Text('${nudges?.blocked ?? 0} Shorts/Reels blocked', style: t.bodySmall)])),
        ClayButton('Test nudge', kind: ClayButtonKind.soft, expand: false, onPressed: () async {
          await ref.read(nativeSyncProvider).syncNow();
          await ref.read(bridgeProvider).testNudge();
        }),
      ])),
      const SectionTitle('Nudges'),
      toggle('Wasting-time nudges', 'Banner over entertainment/social apps in focus hours', g.nudges, (v) => save(g.copyWith(nudges: v))),
      toggle('Do not disturb', 'No nudges; reminders become silent', g.dnd, (v) => save(g.copyWith(dnd: v))),
      ClayContainer(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Nudge after ${g.afterMin} min', style: t.titleMedium),
        Slider(value: g.afterMin.toDouble(), min: 5, max: 45, divisions: 8, label: '${g.afterMin}', onChanged: (v) => save(g.copyWith(afterMin: v.round()))),
        Text('Only when a todo scoring ${g.minScore}+ is open.', style: t.bodySmall),
      ])),
      const SectionTitle('Focus hours (weekdays)'),
      for (var i = 0; i < g.focusWindows.length; i++)
        ClayRow(
          icon: Icons.schedule_rounded,
          title: '${_fmt(g.focusWindows[i].startMin)} – ${_fmt(g.focusWindows[i].endMin)}',
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () => pickRange('Focus', g.focusWindows[i].startMin, g.focusWindows[i].endMin, (s, e) {
              final l = [...g.focusWindows];
              l[i] = (startMin: s, endMin: e, days: l[i].days);
              save(g.copyWith(focusWindows: l));
            })),
            IconButton(icon: Icon(Icons.delete_outline_rounded, color: c.rose), onPressed: () { final l = [...g.focusWindows]..removeAt(i); save(g.copyWith(focusWindows: l)); }),
          ]),
        ),
      ClayButton('Add focus window', kind: ClayButtonKind.soft, icon: Icons.add_rounded, onPressed: () => pickRange('Focus', 600, 780, (s, e) => save(g.copyWith(focusWindows: [...g.focusWindows, (startMin: s, endMin: e, days: const [1, 2, 3, 4, 5])])))),
      const SectionTitle('Quiet hours'),
      ClayRow(icon: Icons.bedtime_rounded, title: '${_fmt(g.quietStartMin)} – ${_fmt(g.quietEndMin)}', subtitle: 'No nudges; reminders are silent', trailing: const Icon(Icons.edit_rounded), onTap: () => pickRange('Quiet', g.quietStartMin, g.quietEndMin, (s, e) => save(g.copyWith(quietStartMin: s, quietEndMin: e)))),
      const SectionTitle('Shorts / Reels blocker'),
      toggle('YouTube Shorts', 'Presses Back and shows a toast', g.blockYoutube, (v) => save(g.copyWith(blockYoutube: v))),
      toggle('Instagram Reels', '', g.blockInstagram, (v) => save(g.copyWith(blockInstagram: v))),
      toggle('Browsers (shorts / reel URLs)', 'Chrome, Brave, Samsung Internet, Firefox', g.blockBrowsers, (v) => save(g.copyWith(blockBrowsers: v))),
      const SectionTitle('Deny-list (never nudge over)'),
      Wrap(spacing: 8, runSpacing: 8, children: [for (final p in g.denyList) ClayChip(p.split('.').last, color: c.sky, icon: Icons.close_rounded, onTap: () { final s = {...g.denyList}..remove(p); save(g.copyWith(denyList: s)); })]),
      const SizedBox(height: 8),
      ClayButton('Add package to deny-list', kind: ClayButtonKind.soft, onPressed: () async {
        final ctrl = TextEditingController();
        final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Package name'), content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'com.example.app')), actions: [TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Add'))]));
        if (ok == true && ctrl.text.trim().isNotEmpty) save(g.copyWith(denyList: {...g.denyList, ctrl.text.trim()}));
      }),
      const SectionTitle('Advanced: screen ids'),
      Text('If an app update renames its Shorts/Reels screens, edit the ids here (comma separated). Applied without a rebuild.', style: t.bodySmall),
      const SizedBox(height: 8),
      _IdField(label: 'YouTube ids', value: g.youtubeIds, onSave: (l) => save(g.copyWith(youtubeIds: l))),
      _IdField(label: 'Instagram ids', value: g.instagramIds, onSave: (l) => save(g.copyWith(instagramIds: l))),
      _IdField(label: 'Browser address bars', value: g.browserBars, onSave: (l) => save(g.copyWith(browserBars: l))),
    ]);
  }
}

class _IdField extends StatefulWidget {
  final String label;
  final List<String> value;
  final ValueChanged<List<String>> onSave;
  const _IdField({required this.label, required this.value, required this.onSave});
  @override
  State<_IdField> createState() => _IdFieldState();
}

class _IdFieldState extends State<_IdField> {
  late final _c = TextEditingController(text: widget.value.join(', '));
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ClayTextField(label: widget.label, controller: _c, maxLines: 3, onChanged: (v) => widget.onSave(v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList())),
      );
}
