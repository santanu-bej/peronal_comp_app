import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/clay_tokens.dart';

/// Thick round-cap ring. Animates from 0 only the first time it is shown.
class ClayProgressRing extends StatefulWidget {
  final double value; // 0..1
  final Color color;
  final double size;
  final double stroke;
  final Widget? center;
  const ClayProgressRing({super.key, required this.value, required this.color, this.size = 96, this.stroke = 12, this.center});

  @override
  State<ClayProgressRing> createState() => _RingState();
}

class _RingState extends State<ClayProgressRing> {
  bool _first = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => mounted ? setState(() => _first = false) : null);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final v = widget.value.clamp(0.0, 1.0);
    final begin = _first && !context.reduceMotion ? 0.0 : v;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: begin, end: v),
        duration: context.reduceMotion ? Duration.zero : ClayMotion.slow * 2,
        curve: ClayMotion.smooth,
        builder: (_, val, child) => CustomPaint(
          painter: _RingPainter(val, widget.color, c.surfaceAlt, widget.stroke),
          child: Center(child: widget.center),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double v, stroke;
  final Color color, track;
  _RingPainter(this.v, this.color, this.track, this.stroke);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(stroke / 2, stroke / 2) & Size(size.width - stroke, size.height - stroke);
    final p = Paint()..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, p..color = track);
    if (v > 0.001) canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * v, false, p..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.v != v || o.color != color || o.track != track;
}

class ClayProgressBar extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  final double? expected; // 0..1 pace tick
  final double height;
  const ClayProgressBar({super.key, required this.value, required this.color, this.expected, this.height = 14});

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    return LayoutBuilder(builder: (context, box) {
      final w = box.maxWidth;
      final v = value.clamp(0.0, 1.0);
      return SizedBox(
        height: height + 6,
        child: Stack(alignment: Alignment.centerLeft, clipBehavior: Clip.none, children: [
          Container(height: height, decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: BorderRadius.circular(height))),
          AnimatedContainer(
            duration: context.reduceMotion ? Duration.zero : ClayMotion.slow,
            curve: ClayMotion.smooth,
            width: math.max(v * w, v > 0 ? height : 0),
            height: height,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height)),
          ),
          if (expected != null)
            Positioned(left: (expected!.clamp(0.0, 1.0) * w) - 1.5, child: Container(width: 3, height: height + 6, decoration: BoxDecoration(color: c.ink.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(2)))),
        ]),
      );
    });
  }
}
