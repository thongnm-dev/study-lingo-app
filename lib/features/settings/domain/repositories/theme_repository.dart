import '../entities/app_theme_mode.dart';

/// Persists the user's chosen theme mode. In-memory today; back it with
/// shared_preferences to survive restarts (same contract).
abstract class ThemeRepository {
  /// The saved theme mode, or null if the user never picked one.
  Future<AppThemeMode?> load();
  Future<void> save(AppThemeMode mode);
}
