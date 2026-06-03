import 'package:bloc/bloc.dart';

import '../../domain/entities/app_language.dart';
import '../../domain/repositories/locale_repository.dart';

/// Holds the app-wide display language (genuinely app-wide state, so it is
/// provided at the root in main.dart — MaterialApp.locale follows it). Defaults
/// to Vietnamese until a saved choice is loaded. Every selection persists via
/// [LocaleRepository].
class LocaleCubit extends Cubit<AppLanguage> {
  LocaleCubit(this._repository) : super(AppLanguage.vietnamese);

  final LocaleRepository _repository;

  Future<void> load() async {
    final saved = await _repository.load();
    if (saved != null) emit(saved);
  }

  Future<void> select(AppLanguage language) async {
    emit(language);
    await _repository.save(language);
  }
}
