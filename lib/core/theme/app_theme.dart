import 'package:flutter/material.dart';

/// Central Material 3 theme. Keep all color/typography decisions here so the
/// app stays visually consistent and theming changes happen in one place.
class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF3A6FF8);

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // Smooth, modern page transitions across platforms.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
