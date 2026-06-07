import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/learning_language.dart';
import '../entities/lesson.dart';
import '../repositories/lessons_repository.dart';

class FetchLessonsParams extends Equatable {
  const FetchLessonsParams({required this.topicId, required this.language});

  final String topicId;
  final LearningLanguage language;

  @override
  List<Object?> get props => [topicId, language];
}

class FetchLessonsUseCase extends UseCase<List<Lesson>, FetchLessonsParams> {
  const FetchLessonsUseCase(this._repository);

  final LessonsRepository _repository;

  @override
  Future<Either<Failure, List<Lesson>>> call(FetchLessonsParams params) async {
    try {
      return Right(
        await _repository.fetchLessons(params.topicId, params.language),
      );
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
