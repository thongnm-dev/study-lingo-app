import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/reminder_settings.dart';
import '../repositories/reminder_repository.dart';
import '../services/reminder_scheduler.dart';

/// Persists the reminder settings AND re-syncs the OS notifications. Both
/// side-effects must succeed for the change to be considered applied.
class SaveReminderSettingsUseCase extends UseCase<void, ReminderSettings> {
  const SaveReminderSettingsUseCase(this._repository, this._scheduler);

  final ReminderRepository _repository;
  final ReminderScheduler _scheduler;

  @override
  Future<Either<Failure, void>> call(ReminderSettings settings) async {
    try {
      await _repository.save(settings);
      await _scheduler.sync(settings);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
