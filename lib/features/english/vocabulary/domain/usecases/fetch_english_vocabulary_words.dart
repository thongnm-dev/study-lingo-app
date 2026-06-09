import 'package:dartz/dartz.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure.dart';
import '../entities/english_vocabulary_word.dart';
import '../repositories/english_vocabulary_repository.dart';

class FetchEnglishVocabularyWordsUseCase
    extends UseCase<List<EnglishVocabularyWord>, NoParams> {
  const FetchEnglishVocabularyWordsUseCase(this._repository);

  final EnglishVocabularyRepository _repository;

  @override
  Future<Either<Failure, List<EnglishVocabularyWord>>> call(
    NoParams params,
  ) async {
    try {
      return Right(await _repository.fetchWords());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
