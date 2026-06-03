import '../entities/app_language.dart';

/// Persists the user's chosen display language. In-memory today; back it with
/// shared_preferences to survive restarts (same contract).
abstract class LocaleRepository {
  /// The saved language, or null if the user never picked one.
  Future<AppLanguage?> load();
  Future<void> save(AppLanguage language);
}
