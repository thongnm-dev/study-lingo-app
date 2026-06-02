import '../entities/reminder_settings.dart';

/// Schedules/cancels the OS-level study notifications described by
/// [ReminderSettings]. Kept separate from [ReminderRepository] because storing
/// the preference and firing a notification are different concerns with
/// different real backends (shared_preferences vs. flutter_local_notifications).
abstract class ReminderScheduler {
  /// Cancel any existing reminders and (re)schedule per [settings]. A disabled
  /// settings object should result in no pending notifications.
  Future<void> sync(ReminderSettings settings);
}
