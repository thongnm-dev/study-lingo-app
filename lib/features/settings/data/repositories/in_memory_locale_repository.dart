import '../../domain/entities/app_language.dart';
import '../../domain/repositories/locale_repository.dart';

/// Keeps the chosen display language in memory only — not persisted across
/// restarts. Swap for a shared_preferences-backed implementation in main.dart.
class InMemoryLocaleRepository implements LocaleRepository {
  AppLanguage? _language;

  @override
  Future<AppLanguage?> load() async => _language;

  @override
  Future<void> save(AppLanguage language) async => _language = language;
}
