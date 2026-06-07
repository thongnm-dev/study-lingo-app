import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/progress_repository.dart';

class RecordLessonCompletedParams extends Equatable {
  const RecordLessonCompletedParams({required this.xpEarned});
  final int xpEarned;

  @override
  List<Object?> get props => [xpEarned];
}

/// Adds a completed lesson to today's progress tally and broadcasts the new
/// snapshot through the [ProgressRepository] stream.
class RecordLessonCompletedUseCase
    extends UseCase<void, RecordLessonCompletedParams> {
  const RecordLessonCompletedUseCase(this._repository);

  final ProgressRepository _repository;

  @override
  Future<Either<Failure, void>> call(RecordLessonCompletedParams params) async {
    try {
      await _repository.recordLessonCompleted(xpEarned: params.xpEarned);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
