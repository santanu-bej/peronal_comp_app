import 'package:flutter/material.dart';

class ClayColors {
  final Color bg, surface, surfaceAlt, ink, inkMuted, primary, onPrimary;
  final Color peach, mint, sky, butter, rose;
  final Color shadowDark, shadowLight;
  final bool dark;
  const ClayColors({
    required this.bg, required this.surface, required this.surfaceAlt, required this.ink, required this.inkMuted,
    required this.primary, required this.onPrimary, required this.peach, required this.mint, required this.sky,
    required this.butter, required this.rose, required this.shadowDark, required this.shadowLight, required this.dark,
  });

  static const light = ClayColors(
    bg: Color(0xFFEFEAF8), surface: Color(0xFFF8F5FE), surfaceAlt: Color(0xFFE6E0F5), ink: Color(0xFF2D2943),
    inkMuted: Color(0xFF77728F), primary: Color(0xFF7B6CF6), onPrimary: Colors.white, peach: Color(0xFFFFB48F),
    mint: Color(0xFF7ED9B4), sky: Color(0xFF8CC8FF), butter: Color(0xFFFFD97A), rose: Color(0xFFFF8A8A),
    shadowDark: Color(0x387B6CF6), shadowLight: Color(0xE6FFFFFF), dark: false,
  );

  static Color dim(Color c) => Color.lerp(c, Colors.black, 0.1)!;

  static final dark_ = ClayColors(
    bg: const Color(0xFF1C1A2B), surface: const Color(0xFF262338), surfaceAlt: const Color(0xFF1F1D30), ink: const Color(0xFFECE9F8),
    inkMuted: const Color(0xFFA29DBD), primary: const Color(0xFF9A8CFF), onPrimary: Colors.white, peach: dim(const Color(0xFFFFB48F)),
    mint: dim(const Color(0xFF7ED9B4)), sky: dim(const Color(0xFF8CC8FF)), butter: dim(const Color(0xFFFFD97A)), rose: dim(const Color(0xFFFF8A8A)),
    shadowDark: const Color(0x8C000000), shadowLight: const Color(0x0FFFFFFF), dark: true,
  );

  Color category(String c) => switch (c) {
        'work' => primary,
        'learning' => sky,
        'entertainment' => rose,
        'social' => peach,
        'communication' => butter,
        'physical' => mint,
        'utility' => const Color(0xFFB9B4CC),
        'sleep' => const Color(0xFFA9A3C9),
        _ => const Color(0xFFD4D0E2),
      };
}

class ClayRadius {
  static const xl = 32.0, lg = 24.0, md = 18.0, pill = 999.0;
}

class ClaySpace {
  static const s4 = 4.0, s8 = 8.0, s12 = 12.0, s16 = 16.0, s20 = 20.0, s24 = 24.0, s32 = 32.0;
  static const screenPad = 20.0;
}

class ClayMotion {
  static const fast = Duration(milliseconds: 120), base = Duration(milliseconds: 200), slow = Duration(milliseconds: 320);
  static const pop = Curves.easeOutBack, smooth = Curves.easeOutCubic;
}

extension ClayContext on BuildContext {
  ClayColors get clay => Theme.of(this).extension<ClayTheme>()!.colors;
  bool get reduceMotion => MediaQuery.of(this).disableAnimations;
}

class ClayTheme extends ThemeExtension<ClayTheme> {
  final ClayColors colors;
  const ClayTheme(this.colors);
  @override
  ClayTheme copyWith({ClayColors? colors}) => ClayTheme(colors ?? this.colors);
  @override
  ClayTheme lerp(ThemeExtension<ClayTheme>? other, double t) => t < 0.5 ? this : (other as ClayTheme);
}
