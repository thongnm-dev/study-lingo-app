import 'package:dartz/dartz.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure.dart';
import '../entities/japanese_lesson.dart';
import '../repositories/japanese_lessons_repository.dart';

class FetchJapaneseLessonsUseCase
    extends UseCase<List<JapaneseLesson>, String> {
  const FetchJapaneseLessonsUseCase(this._repository);

  final JapaneseLessonsRepository _repository;

  @override
  Future<Either<Failure, List<JapaneseLesson>>> call(String topicId) async {
    try {
      return Right(await _repository.fetchLessons(topicId));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
