import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/japanese_script.dart';
import '../entities/writing_character.dart';
import '../repositories/writing_repository.dart';

/// Loads the practice character set for a [JapaneseScript].
class FetchWritingCharactersUseCase
    extends UseCase<List<WritingCharacter>, JapaneseScript> {
  const FetchWritingCharactersUseCase(this._repository);

  final WritingRepository _repository;

  @override
  Future<Either<Failure, List<WritingCharacter>>> call(
    JapaneseScript script,
  ) async {
    try {
      final characters = await _repository.charactersFor(script);
      return Right(characters);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
