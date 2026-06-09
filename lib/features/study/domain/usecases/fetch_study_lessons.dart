import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/study_lesson.dart';
import '../repositories/study_topics_repository.dart';

class FetchStudyLessonsUseCase extends UseCase<List<StudyLesson>, String> {
  const FetchStudyLessonsUseCase(this._repository);

  final StudyTopicsRepository _repository;

  @override
  Future<Either<Failure, List<StudyLesson>>> call(String topicId) async {
    try {
      return Right(await _repository.fetchLessons(topicId));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
