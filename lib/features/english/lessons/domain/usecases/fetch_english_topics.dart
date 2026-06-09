import 'package:dartz/dartz.dart';

import '../../../../../core/constants/learning_skill.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure.dart';
import '../entities/english_topic.dart';
import '../repositories/english_lessons_repository.dart';

class FetchEnglishTopicsUseCase
    extends UseCase<List<EnglishTopic>, LearningSkill> {
  const FetchEnglishTopicsUseCase(this._repository);

  final EnglishLessonsRepository _repository;

  @override
  Future<Either<Failure, List<EnglishTopic>>> call(LearningSkill skill) async {
    try {
      return Right(await _repository.fetchTopics(skill));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
