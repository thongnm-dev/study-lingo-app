import 'package:dartz/dartz.dart';

import '../../../../core/constants/learning_language.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/study_topic.dart';
import '../repositories/study_topics_repository.dart';

class FetchStudyTopicsUseCase
    extends UseCase<List<StudyTopic>, LearningLanguage> {
  const FetchStudyTopicsUseCase(this._repository);

  final StudyTopicsRepository _repository;

  @override
  Future<Either<Failure, List<StudyTopic>>> call(
    LearningLanguage language,
  ) async {
    try {
      return Right(await _repository.fetchTopics(language));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
