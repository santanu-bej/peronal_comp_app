import 'package:flutter/material.dart';
import '../../core/logic/pace.dart';
import '../../core/theme/clay_tokens.dart';
import '../../core/widgets/clay_container.dart';
import '../../core/widgets/clay_controls.dart';
import '../../core/widgets/clay_misc.dart';
import '../../core/widgets/clay_progress.dart';
import '../../core/widgets/screen.dart';

/// Debug gallery of every Clay widget.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});
  @override
  State<GalleryScreen> createState() => _S();
}

class _S extends State<GalleryScreen> {
  bool sw = true;
  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    return ClayScreen(title: 'Gallery', back: true, bottomPad: 40, children: [
      const SectionTitle('Containers'),
      const ClayContainer(child: Text('Raised')),
      const SizedBox(height: 12),
      const ClayContainer(depth: ClayDepth.floating, child: Text('Floating')),
      const SizedBox(height: 12),
      const ClayContainer(depth: ClayDepth.flat, inset: true, child: Text('Inset / flat')),
      const SectionTitle('Buttons'),
      ClayButton('Primary', onPressed: () {}),
      const SizedBox(height: 10),
      ClayButton('Soft', kind: ClayButtonKind.soft, icon: Icons.star_rounded, onPressed: () {}),
      const SizedBox(height: 10),
      ClayButton('Danger', kind: ClayButtonKind.danger, onPressed: () {}),
      const SizedBox(height: 10),
      const Row(children: [ClayIconButton(Icons.add_rounded)]),
      const SectionTitle('Chips & badges'),
      Wrap(spacing: 8, runSpacing: 8, children: [
        const ClayChip('Chip'),
        const ClayChip('Selected', selected: true),
        for (final s in GoalStatus.values) StatusChip(s),
        for (final s in [90, 60, 30, 10]) ScoreBadge(s),
      ]),
      const SectionTitle('Progress'),
      Row(children: [ClayProgressRing(value: 0.42, color: c.sky, center: const Text('42%')), const SizedBox(width: 20), Expanded(child: ClayProgressBar(value: 0.6, color: c.mint, expected: 0.5))]),
      const SectionTitle('Inputs'),
      const ClayTextField(label: 'Label', hint: 'Hint'),
      const SizedBox(height: 12),
      ClaySwitch(value: sw, onChanged: (v) => setState(() => sw = v)),
      const SectionTitle('Sheet & empty'),
      ClayButton('Open sheet', kind: ClayButtonKind.soft, onPressed: () => ClaySheet.show(context, title: 'Sheet', child: const Text('Hello'))),
      const EmptyState(text: 'Nothing here', buttonLabel: 'Do it'),
    ]);
  }
}
