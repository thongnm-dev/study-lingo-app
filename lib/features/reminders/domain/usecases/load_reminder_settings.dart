import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/reminder_settings.dart';
import '../repositories/reminder_repository.dart';

class LoadReminderSettingsUseCase extends UseCase<ReminderSettings, NoParams> {
  const LoadReminderSettingsUseCase(this._repository);

  final ReminderRepository _repository;

  @override
  Future<Either<Failure, ReminderSettings>> call(NoParams params) async {
    try {
      return Right(await _repository.load());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
