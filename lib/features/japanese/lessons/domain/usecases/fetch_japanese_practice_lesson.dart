import 'package:dartz/dartz.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure.dart';
import '../entities/japanese_lesson.dart';
import '../repositories/japanese_lessons_repository.dart';

/// Builds a synthetic mixed practice lesson for the Japanese deck.
class FetchJapanesePracticeLessonUseCase
    extends UseCase<JapaneseLesson, NoParams> {
  const FetchJapanesePracticeLessonUseCase(this._repository);

  final JapaneseLessonsRepository _repository;

  @override
  Future<Either<Failure, JapaneseLesson>> call(NoParams params) async {
    try {
      return Right(await _repository.fetchPracticeLesson());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
