import 'package:flutter/material.dart';
import '../logic/pace.dart';
import '../theme/clay_tokens.dart';
import 'clay_container.dart';
import 'clay_controls.dart';

Color scoreColor(ClayColors c, int? s) {
  if (s == null) return c.surfaceAlt;
  if (s >= 75) return c.mint;
  if (s >= 50) return c.butter;
  if (s >= 25) return const Color(0xFFB9B4CC);
  return c.rose;
}

class ScoreBadge extends StatelessWidget {
  final int? score;
  const ScoreBadge(this.score, {super.key});
  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    return Semantics(
      label: 'Score ${score ?? 'none'}',
      child: Container(
        width: 40,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: scoreColor(c, score), borderRadius: BorderRadius.circular(10)),
        child: Text(score?.toString() ?? '–', style: const TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF2D2943))),
      ),
    );
  }
}

Color statusColor(ClayColors c, GoalStatus s) => switch (s) {
      GoalStatus.ahead => c.mint,
      GoalStatus.onTrack => c.sky,
      GoalStatus.behind => c.butter,
      GoalStatus.atRisk => c.rose,
    };

class StatusChip extends StatelessWidget {
  final GoalStatus status;
  const StatusChip(this.status, {super.key});
  @override
  Widget build(BuildContext context) => ClayChip(status.label, color: statusColor(context.clay, status), selected: false);
}

class ClaySheet extends StatelessWidget {
  final String? title;
  final Widget child;
  const ClaySheet({super.key, this.title, required this.child});

  static Future<T?> show<T>(BuildContext context, {String? title, required Widget child}) => showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ClaySheet(title: title, child: child),
      );

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: ClayContainer(
        radius: ClayRadius.xl,
        depth: ClayDepth.floating,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Center(child: Container(width: 44, height: 5, margin: const EdgeInsets.only(bottom: 14), decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: BorderRadius.circular(3)))),
            if (title != null) Padding(padding: const EdgeInsets.only(bottom: 14), child: Text(title!, style: Theme.of(context).textTheme.headlineMedium)),
            child,
          ]),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String text;
  final String? buttonLabel;
  final VoidCallback? onPressed;
  const EmptyState({super.key, required this.text, this.buttonLabel, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: 120,
          height: 90,
          child: CustomPaint(painter: _ShapesPainter([c.primary, c.peach, c.mint, c.sky])),
        ),
        const SizedBox(height: 16),
        Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: c.inkMuted)),
        if (buttonLabel != null) ...[const SizedBox(height: 16), ClayButton(buttonLabel!, onPressed: onPressed, expand: false)],
      ]),
    );
  }
}

class _ShapesPainter extends CustomPainter {
  final List<Color> colors;
  _ShapesPainter(this.colors);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint();
    canvas.drawCircle(Offset(s.width * 0.3, s.height * 0.55), 28, p..color = colors[0].withValues(alpha: 0.7));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s.width * 0.45, s.height * 0.25, 54, 54), const Radius.circular(18)), p..color = colors[1].withValues(alpha: 0.8));
    canvas.drawCircle(Offset(s.width * 0.7, s.height * 0.75), 16, p..color = colors[2].withValues(alpha: 0.9));
    canvas.drawCircle(Offset(s.width * 0.15, s.height * 0.2), 10, p..color = colors[3]);
  }

  @override
  bool shouldRepaint(_ShapesPainter o) => false;
}

/// Simple section title used on screens.
class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionTitle(this.text, {super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
        child: Row(children: [Expanded(child: Text(text, style: Theme.of(context).textTheme.titleLarge)), ?trailing]),
      );
}

/// Tabular row used in settings-like lists.
class ClayRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final IconData? icon;
  const ClayRow({super.key, required this.title, this.subtitle, this.trailing, this.onTap, this.icon});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClayContainer(
        onTap: onTap,
        child: Row(children: [
          if (icon != null) ...[Icon(icon, color: context.clay.primary), const SizedBox(width: 12)],
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: t.titleMedium),
            if (subtitle != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(subtitle!, style: t.bodySmall)),
          ])),
          ?trailing,
        ]),
      ),
    );
  }
}
