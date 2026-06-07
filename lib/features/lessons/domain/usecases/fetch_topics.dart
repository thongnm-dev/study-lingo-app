import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/learning_skill.dart';
import '../entities/topic.dart';
import '../repositories/lessons_repository.dart';

class FetchTopicsUseCase extends UseCase<List<Topic>, LearningSkill> {
  const FetchTopicsUseCase(this._repository);

  final LessonsRepository _repository;

  @override
  Future<Either<Failure, List<Topic>>> call(LearningSkill skill) async {
    try {
      return Right(await _repository.fetchTopics(skill));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
