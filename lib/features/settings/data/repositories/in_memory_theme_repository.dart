import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/theme_repository.dart';

/// Keeps the chosen theme mode in memory only — not persisted across restarts.
/// Swap for a shared_preferences-backed implementation in service_locator.dart.
class InMemoryThemeRepository implements ThemeRepository {
  AppThemeMode? _mode;

  @override
  Future<AppThemeMode?> load() async => _mode;

  @override
  Future<void> save(AppThemeMode mode) async => _mode = mode;
}
