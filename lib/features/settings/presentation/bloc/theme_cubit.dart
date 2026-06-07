import 'package:bloc/bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/usecases/load_theme.dart';
import '../../domain/usecases/save_theme.dart';

/// Holds the app-wide theme choice (genuinely app-wide state, so it is
/// provided at the root — MaterialApp.themeMode follows it). Defaults to
/// [AppThemeMode.light] until a saved choice is loaded. Every selection
/// persists via [SaveThemeUseCase].
class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit({required LoadThemeUseCase loadTheme, required SaveThemeUseCase saveTheme})
    : _loadTheme = loadTheme,
      _saveTheme = saveTheme,
      super(AppThemeMode.light);

  final LoadThemeUseCase _loadTheme;
  final SaveThemeUseCase _saveTheme;

  Future<void> load() async {
    final result = await _loadTheme(const NoParams());
    result.fold((_) {}, (saved) {
      if (saved != null) emit(saved);
    });
  }

  Future<void> select(AppThemeMode mode) async {
    emit(mode);
    await _saveTheme(mode);
  }

  /// Toggles between light and dark; convenient for a binary switch UI.
  Future<void> toggle() =>
      select(AppThemeMode.fromIsDark(!state.isDark));
}
