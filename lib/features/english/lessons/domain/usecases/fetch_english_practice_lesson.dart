import 'package:dartz/dartz.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure.dart';
import '../entities/english_lesson.dart';
import '../repositories/english_lessons_repository.dart';

/// Builds a synthetic mixed practice lesson for the English deck.
class FetchEnglishPracticeLessonUseCase
    extends UseCase<EnglishLesson, NoParams> {
  const FetchEnglishPracticeLessonUseCase(this._repository);

  final EnglishLessonsRepository _repository;

  @override
  Future<Either<Failure, EnglishLesson>> call(NoParams params) async {
    try {
      return Right(await _repository.fetchPracticeLesson());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
