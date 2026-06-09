import 'package:dartz/dartz.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure.dart';
import '../entities/english_lesson.dart';
import '../repositories/english_lessons_repository.dart';

class FetchEnglishLessonsUseCase
    extends UseCase<List<EnglishLesson>, String> {
  const FetchEnglishLessonsUseCase(this._repository);

  final EnglishLessonsRepository _repository;

  @override
  Future<Either<Failure, List<EnglishLesson>>> call(String topicId) async {
    try {
      return Right(await _repository.fetchLessons(topicId));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
