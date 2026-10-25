import 'package:flutter/material.dart';
import '../theme/clay_tokens.dart';

enum ClayDepth { flat, raised, floating }

/// The single place where the clay look (outer shadow + highlight + inner glow) is drawn.
class ClayContainer extends StatefulWidget {
  final Widget? child;
  final Color? color;
  final double radius;
  final ClayDepth depth;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width, height;
  final bool inset; // inverted flat: pressed-in look (inputs)
  final Border? border;
  final Gradient? gradient;

  const ClayContainer({
    super.key,
    this.child,
    this.color,
    this.radius = ClayRadius.lg,
    this.depth = ClayDepth.raised,
    this.padding = const EdgeInsets.all(ClaySpace.s16),
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.inset = false,
    this.border,
    this.gradient,
  });

  @override
  State<ClayContainer> createState() => _ClayContainerState();
}

class _ClayContainerState extends State<ClayContainer> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final tappable = widget.onTap != null || widget.onLongPress != null;
    final pressed = _down && tappable;
    final depth = pressed ? ClayDepth.flat : widget.depth;
    final reduce = context.reduceMotion;
    final fill = widget.color ?? (widget.inset ? c.surfaceAlt : c.surface);

    final shadows = switch (depth) {
      ClayDepth.flat => const <BoxShadow>[],
      ClayDepth.raised => [
          BoxShadow(color: c.shadowDark, offset: const Offset(8, 10), blurRadius: 24),
          BoxShadow(color: c.shadowLight, offset: const Offset(-6, -6), blurRadius: 16),
        ],
      ClayDepth.floating => [
          BoxShadow(color: c.shadowDark, offset: const Offset(10, 14), blurRadius: 32),
          BoxShadow(color: c.shadowLight, offset: const Offset(-6, -6), blurRadius: 18),
        ],
    };

    Widget body = AnimatedContainer(
      duration: reduce ? Duration.zero : ClayMotion.fast,
      curve: ClayMotion.smooth,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.gradient == null ? fill : null,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: shadows,
        border: widget.border,
      ),
      child: CustomPaint(
        foregroundPainter: _InnerPainter(radius: widget.radius, dark: c.dark, inset: widget.inset || pressed, flat: depth == ClayDepth.flat),
        child: Padding(padding: widget.padding, child: widget.child),
      ),
    );

    if (!tappable) return body;
    body = AnimatedScale(
      scale: pressed && !reduce ? 0.97 : 1,
      duration: ClayMotion.fast,
      curve: ClayMotion.smooth,
      child: body,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: body,
    );
  }
}

/// Layer 3: inner glow top-left (white 60%) and inner shade bottom-right (black 8%), drawn as
/// gradient-masked strokes inside the rounded rect (Flutter has no inset BoxShadow).
class _InnerPainter extends CustomPainter {
  final double radius;
  final bool dark, inset, flat;
  _InnerPainter({required this.radius, required this.dark, required this.inset, required this.flat});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    canvas.save();
    canvas.clipRRect(rrect);
    final hi = dark ? const Color(0x14FFFFFF) : const Color(0x99FFFFFF);
    final lo = dark ? const Color(0x33000000) : const Color(0x14000000);
    final a = inset ? lo : hi;
    final b = inset ? hi : lo;
    final w = (flat && !inset) ? 0.0 : 8.0;
    if (w == 0) {
      canvas.restore();
      return;
    }
    final paintA = Paint()
      ..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [a, a.withValues(alpha: 0), b.withValues(alpha: 0), b], stops: const [0, 0.35, 0.65, 1])
          .createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(rrect, paintA);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InnerPainter o) => o.radius != radius || o.dark != dark || o.inset != inset || o.flat != flat;
}
