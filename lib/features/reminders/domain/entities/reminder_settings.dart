import 'package:equatable/equatable.dart';

/// User's study-reminder configuration: whether reminders are on, the time of
/// day to fire, and which weekdays. [weekdays] uses Dart's convention
/// (DateTime.monday == 1 … DateTime.sunday == 7).
class ReminderSettings extends Equatable {
  const ReminderSettings({
    this.enabled = false,
    this.hour = 20,
    this.minute = 0,
    this.weekdays = const {1, 2, 3, 4, 5},
  });

  final bool enabled;
  final int hour;
  final int minute;
  final Set<int> weekdays;

  ReminderSettings copyWith({
    bool? enabled,
    int? hour,
    int? minute,
    Set<int>? weekdays,
  }) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      weekdays: weekdays ?? this.weekdays,
    );
  }

  @override
  List<Object?> get props => [enabled, hour, minute, weekdays];
}
