import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/daily_progress.dart';
import '../repositories/progress_repository.dart';

/// Subscribes to the shared [ProgressRepository] stream of daily entries.
/// The stream is the success payload; setup errors land in Left.
class WatchProgressUseCase
    extends StreamUseCase<List<DailyProgress>, NoParams> {
  const WatchProgressUseCase(this._repository);

  final ProgressRepository _repository;

  @override
  Either<Failure, Stream<List<DailyProgress>>> call(NoParams params) {
    try {
      return Right(_repository.watch());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
