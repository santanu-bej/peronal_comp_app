import 'package:flutter/material.dart';
import '../theme/clay_tokens.dart';
import 'clay_container.dart';

enum ClayButtonKind { primary, soft, danger }

class ClayButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ClayButtonKind kind;
  final IconData? icon;
  final bool expand;
  final bool busy;
  const ClayButton(this.label, {super.key, this.onPressed, this.kind = ClayButtonKind.primary, this.icon, this.expand = true, this.busy = false});

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final (bg, fg) = switch (kind) {
      ClayButtonKind.primary => (c.primary, c.onPrimary),
      ClayButtonKind.soft => (c.surface, c.ink),
      ClayButtonKind.danger => (c.rose, Colors.white),
    };
    final enabled = onPressed != null && !busy;
    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (busy)
          SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.5, color: fg))
        else if (icon != null) ...[Icon(icon, color: fg, size: 20), const SizedBox(width: 8)],
        if (!busy || label.isNotEmpty) ...[
          if (busy) const SizedBox(width: 10),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700, fontSize: 15, color: fg))),
        ],
      ],
    );
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: ClayContainer(
        color: bg,
        radius: ClayRadius.md,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        onTap: enabled ? onPressed : null,
        child: Center(child: child),
      ),
    );
  }
}

class ClayIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  const ClayIconButton(this.icon, {super.key, this.onPressed, this.tooltip, this.color});

  @override
  Widget build(BuildContext context) {
    final w = ClayContainer(
      width: 48,
      height: 48,
      radius: 24,
      padding: EdgeInsets.zero,
      onTap: onPressed,
      child: Center(child: Icon(icon, color: color ?? context.clay.ink, size: 22)),
    );
    return tooltip == null ? w : Tooltip(message: tooltip!, child: w);
  }
}

class ClayChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  const ClayChip(this.label, {super.key, this.color, this.selected = false, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    final base = color ?? c.primary;
    final fill = selected ? base : base.withValues(alpha: 0.35);
    final fg = selected ? Colors.white : c.ink;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: context.reduceMotion ? Duration.zero : ClayMotion.base,
        curve: ClayMotion.pop,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(ClayRadius.pill)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 15, color: fg), const SizedBox(width: 6)],
          Text(label, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700, fontSize: 13, color: fg)),
        ]),
      ),
    );
  }
}

class ClaySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  const ClaySwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    return Semantics(
      toggled: value,
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: AnimatedContainer(
          duration: context.reduceMotion ? Duration.zero : ClayMotion.base,
          curve: ClayMotion.smooth,
          width: 56,
          height: 32,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: value ? c.mint : c.surfaceAlt, borderRadius: BorderRadius.circular(16)),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: c.shadowDark, offset: const Offset(2, 3), blurRadius: 6)],
            ),
          ),
        ),
      ),
    );
  }
}

class ClayTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscure;
  final int maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final String? errorText;
  final Widget? suffix;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  const ClayTextField({
    super.key, this.label, this.hint, this.controller, this.onChanged, this.keyboardType, this.obscure = false,
    this.maxLines = 1, this.maxLength, this.focusNode, this.errorText, this.suffix, this.autofocus = false,
    this.textInputAction, this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.clay;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (label != null) Padding(padding: const EdgeInsets.only(bottom: 6, left: 4), child: Text(label!, style: Theme.of(context).textTheme.labelLarge)),
      ClayContainer(
        inset: true,
        depth: ClayDepth.flat,
        radius: ClayRadius.md,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          maxLength: maxLength,
          focusNode: focusNode,
          autofocus: autofocus,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: Theme.of(context).textTheme.bodyLarge,
          cursorColor: c.primary,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(color: c.inkMuted.withValues(alpha: 0.7)),
            counterText: '',
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      if (errorText != null) Padding(padding: const EdgeInsets.only(top: 4, left: 4), child: Text(errorText!, style: TextStyle(color: c.rose, fontSize: 12, fontWeight: FontWeight.w700))),
    ]);
  }
}
