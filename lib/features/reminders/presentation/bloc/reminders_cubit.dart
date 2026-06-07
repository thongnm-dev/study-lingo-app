import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/reminder_settings.dart';
import '../../domain/usecases/load_reminder_settings.dart';
import '../../domain/usecases/save_reminder_settings.dart';

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

/// Holds the reminder settings. Every mutation persists AND re-syncs the OS
/// notifications via [SaveReminderSettingsUseCase].
class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({
    required LoadReminderSettingsUseCase load,
    required SaveReminderSettingsUseCase save,
  }) : _load = load,
       _save = save,
       super(const RemindersState());

  final LoadReminderSettingsUseCase _load;
  final SaveReminderSettingsUseCase _save;

  Future<void> load() async {
    final result = await _load(const NoParams());
    result.fold(
      (_) => emit(const RemindersState(loaded: true)),
      (settings) => emit(RemindersState(loaded: true, settings: settings)),
    );
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
    await _save(settings);
  }
}
