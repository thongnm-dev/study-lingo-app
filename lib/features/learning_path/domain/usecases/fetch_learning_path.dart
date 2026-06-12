import 'package:dartz/dartz.dart';

import '../../../../core/constants/learning_language.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/course_unit.dart';
import '../repositories/learning_path_repository.dart';

class FetchLearningPathUseCase
    extends UseCase<List<CourseUnit>, LearningLanguage> {
  final LearningPathRepository _repository;

  const FetchLearningPathUseCase(this._repository);

  @override
  Future<Either<Failure, List<CourseUnit>>> call(
    LearningLanguage params,
  ) async {
    try {
      final units = await _repository.fetchUnits(params);
      return Right(units);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
