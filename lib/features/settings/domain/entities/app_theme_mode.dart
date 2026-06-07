import 'package:flutter/material.dart';

/// The app-wide theme choice. Pins one of the Material 3 themes defined in
/// `AppTheme`. The UI is a binary switch — light vs. dark.
enum AppThemeMode {
  light,
  dark;

  /// Maps the persisted choice onto Flutter's [ThemeMode] for MaterialApp.
  ThemeMode get themeMode => switch (this) {
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };

  bool get isDark => this == AppThemeMode.dark;

  static AppThemeMode fromIsDark(bool isDark) =>
      isDark ? AppThemeMode.dark : AppThemeMode.light;
}
