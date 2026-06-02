import 'dart:developer' as developer;

import '../../domain/entities/reminder_settings.dart';
import '../../domain/services/reminder_scheduler.dart';

/// Stub scheduler that only logs what it *would* schedule, so the reminders UI
/// is fully usable with no platform setup.
///
/// To fire real notifications, implement [ReminderScheduler] with
/// `flutter_local_notifications` (+ `timezone`):
///   1. Initialize the plugin once at startup and request permissions.
///   2. On [sync], call `cancelAll()`, then for each weekday in
///      [ReminderSettings.weekdays] schedule a `zonedSchedule` at hour:minute
///      with a weekly `matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime`.
///   3. Platform setup: Android needs a notification channel + (API 33+)
///      POST_NOTIFICATIONS permission; iOS needs notification permission and
///      the appropriate Info.plist entries.
class LoggingReminderScheduler implements ReminderScheduler {
  const LoggingReminderScheduler();

  @override
  Future<void> sync(ReminderSettings settings) async {
    if (!settings.enabled || settings.weekdays.isEmpty) {
      developer.log('Reminders cleared', name: 'reminders');
      return;
    }
    final time =
        '${settings.hour.toString().padLeft(2, '0')}:'
        '${settings.minute.toString().padLeft(2, '0')}';
    developer.log(
      'Would schedule study reminder at $time on weekdays ${settings.weekdays.toList()..sort()}',
      name: 'reminders',
    );
  }
}
