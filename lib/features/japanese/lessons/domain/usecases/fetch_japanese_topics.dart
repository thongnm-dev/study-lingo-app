import 'package:dartz/dartz.dart';

import '../../../../../core/constants/learning_skill.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure.dart';
import '../entities/japanese_topic.dart';
import '../repositories/japanese_lessons_repository.dart';

class FetchJapaneseTopicsUseCase
    extends UseCase<List<JapaneseTopic>, LearningSkill> {
  const FetchJapaneseTopicsUseCase(this._repository);

  final JapaneseLessonsRepository _repository;

  @override
  Future<Either<Failure, List<JapaneseTopic>>> call(LearningSkill skill) async {
    try {
      return Right(await _repository.fetchTopics(skill));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
