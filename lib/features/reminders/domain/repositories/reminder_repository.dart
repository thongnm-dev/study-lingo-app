import '../entities/reminder_settings.dart';

/// Persists the user's [ReminderSettings]. In-memory today; back it with
/// shared_preferences to survive restarts (same contract).
abstract class ReminderRepository {
  Future<ReminderSettings> load();
  Future<void> save(ReminderSettings settings);
}
