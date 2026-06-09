import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure.dart';
import '../entities/japanese_vocabulary_word.dart';
import '../repositories/japanese_vocabulary_repository.dart';

class FetchJapaneseVocabularyWordsParams extends Equatable {
  const FetchJapaneseVocabularyWordsParams({this.jlptLevel});

  final int? jlptLevel;

  @override
  List<Object?> get props => [jlptLevel];
}

class FetchJapaneseVocabularyWordsUseCase
    extends
        UseCase<List<JapaneseVocabularyWord>, FetchJapaneseVocabularyWordsParams> {
  const FetchJapaneseVocabularyWordsUseCase(this._repository);

  final JapaneseVocabularyRepository _repository;

  @override
  Future<Either<Failure, List<JapaneseVocabularyWord>>> call(
    FetchJapaneseVocabularyWordsParams params,
  ) async {
    try {
      final words = await _repository.fetchWords(jlptLevel: params.jlptLevel);
      return Right(words);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
