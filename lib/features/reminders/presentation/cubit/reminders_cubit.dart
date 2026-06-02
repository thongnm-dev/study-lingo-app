import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/reminder_settings.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/services/reminder_scheduler.dart';

class RemindersState extends Equatable {
  const RemindersState({
    this.loaded = false,
    this.settings = const ReminderSettings(),
  });

  final bool loaded;
  final ReminderSettings settings;

  RemindersState copyWith({bool? loaded, ReminderSettings? settings}) {
    return RemindersState(
      loaded: loaded ?? this.loaded,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [loaded, settings];
}

/// Holds the reminder settings. Every mutation persists via [ReminderRepository]
/// and re-syncs the OS notifications via [ReminderScheduler], so the two stay
/// consistent with the on-screen state.
class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit(this._repository, this._scheduler)
    : super(const RemindersState());

  final ReminderRepository _repository;
  final ReminderScheduler _scheduler;

  Future<void> load() async {
    final settings = await _repository.load();
    emit(RemindersState(loaded: true, settings: settings));
  }

  Future<void> setEnabled(bool enabled) =>
      _update(state.settings.copyWith(enabled: enabled));

  Future<void> setTime(int hour, int minute) =>
      _update(state.settings.copyWith(hour: hour, minute: minute));

  Future<void> toggleWeekday(int weekday) {
    final next = Set<int>.from(state.settings.weekdays);
    if (!next.remove(weekday)) next.add(weekday);
    return _update(state.settings.copyWith(weekdays: next));
  }

  Future<void> _update(ReminderSettings settings) async {
    emit(state.copyWith(settings: settings));
    await _repository.save(settings);
    await _scheduler.sync(settings);
  }
}
