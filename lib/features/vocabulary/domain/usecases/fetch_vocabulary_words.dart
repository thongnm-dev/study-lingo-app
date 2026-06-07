import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../../../lessons/domain/entities/learning_language.dart';
import '../entities/vocabulary_word.dart';
import '../repositories/vocabulary_repository.dart';

class FetchVocabularyWordsParams extends Equatable {
  const FetchVocabularyWordsParams({this.language, this.jlptLevel});

  final LearningLanguage? language;
  final int? jlptLevel;

  @override
  List<Object?> get props => [language, jlptLevel];
}

/// Loads the vocabulary deck, optionally filtered by study [language] and
/// JLPT level (Japanese deck only).
class FetchVocabularyWordsUseCase
    extends UseCase<List<VocabularyWord>, FetchVocabularyWordsParams> {
  const FetchVocabularyWordsUseCase(this._repository);

  final VocabularyRepository _repository;

  @override
  Future<Either<Failure, List<VocabularyWord>>> call(
    FetchVocabularyWordsParams params,
  ) async {
    try {
      final words = await _repository.fetchWords(
        language: params.language,
        jlptLevel: params.jlptLevel,
      );
      return Right(words);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
