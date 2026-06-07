import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/learning_language.dart';
import '../entities/lesson.dart';
import '../repositories/lessons_repository.dart';

/// Builds a synthetic mixed practice lesson for the chosen [LearningLanguage].
class FetchPracticeLessonUseCase extends UseCase<Lesson, LearningLanguage> {
  const FetchPracticeLessonUseCase(this._repository);

  final LessonsRepository _repository;

  @override
  Future<Either<Failure, Lesson>> call(LearningLanguage language) async {
    try {
      return Right(await _repository.fetchPracticeLesson(language));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
