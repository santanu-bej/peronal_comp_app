import 'package:flutter/material.dart';
import 'clay_tokens.dart';

TextTheme _text(ClayColors c) {
  TextStyle f(double s, FontWeight w, {Color? color, String family = 'Nunito'}) => TextStyle(
      fontFamily: family, fontSize: s, fontWeight: w, color: color ?? c.ink, fontFeatures: const [FontFeature.tabularFigures()]);
  return TextTheme(
    headlineLarge: f(28, FontWeight.w600, family: 'Fredoka'),
    headlineMedium: f(22, FontWeight.w600, family: 'Fredoka'),
    titleLarge: f(18, FontWeight.w600, family: 'Fredoka'),
    titleMedium: f(16, FontWeight.w700),
    bodyLarge: f(15, FontWeight.w500),
    bodyMedium: f(15, FontWeight.w500),
    labelLarge: f(13, FontWeight.w700),
    labelMedium: f(13, FontWeight.w500, color: c.inkMuted),
    bodySmall: f(12, FontWeight.w500, color: c.inkMuted),
  );
}

ThemeData buildClayTheme(ClayColors c) {
  final base = ThemeData(
    useMaterial3: true,
    brightness: c.dark ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: c.primary, brightness: c.dark ? Brightness.dark : Brightness.light).copyWith(
      primary: c.primary, onPrimary: c.onPrimary, surface: c.surface, onSurface: c.ink, error: c.rose,
    ),
    scaffoldBackgroundColor: c.bg,
    fontFamily: 'Nunito',
  );
  return base.copyWith(
    textTheme: _text(c),
    extensions: [ClayTheme(c)],
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: c.ink),
    dividerColor: c.surfaceAlt,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.ink,
      contentTextStyle: TextStyle(color: c.bg, fontFamily: 'Nunito', fontWeight: FontWeight.w700),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ClayRadius.md)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
    }),
  );
}
