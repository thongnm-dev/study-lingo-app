import 'package:bloc/bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/usecases/load_locale.dart';
import '../../domain/usecases/save_locale.dart';

/// Holds the app-wide display language (genuinely app-wide state, so it is
/// provided at the root — MaterialApp.locale follows it). Defaults to
/// Vietnamese until a saved choice is loaded. Every selection persists via
/// [SaveLocaleUseCase].
class LocaleCubit extends Cubit<AppLanguage> {
  LocaleCubit({required LoadLocaleUseCase loadLocale, required SaveLocaleUseCase saveLocale})
    : _loadLocale = loadLocale,
      _saveLocale = saveLocale,
      super(AppLanguage.vietnamese);

  final LoadLocaleUseCase _loadLocale;
  final SaveLocaleUseCase _saveLocale;

  Future<void> load() async {
    final result = await _loadLocale(const NoParams());
    result.fold((_) {}, (saved) {
      if (saved != null) emit(saved);
    });
  }

  Future<void> select(AppLanguage language) async {
    emit(language);
    await _saveLocale(language);
  }
}
