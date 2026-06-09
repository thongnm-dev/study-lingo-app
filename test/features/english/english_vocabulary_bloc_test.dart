import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/core/usecases/usecase.dart';
import 'package:study_lingo/core/utils/failure.dart';
import 'package:study_lingo/features/english/vocabulary/domain/entities/english_vocabulary_word.dart';
import 'package:study_lingo/features/english/vocabulary/domain/usecases/fetch_english_vocabulary_words.dart';
import 'package:study_lingo/features/english/vocabulary/presentation/bloc/english_vocabulary_bloc.dart';

class MockFetchEnglishVocabularyWordsUseCase extends Mock
    implements FetchEnglishVocabularyWordsUseCase {}

void main() {
  const word = EnglishVocabularyWord(
    id: 'w_breakfast',
    english: 'breakfast',
    vietnamese: 'bữa sáng',
  );

  late MockFetchEnglishVocabularyWordsUseCase fetchWords;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    fetchWords = MockFetchEnglishVocabularyWordsUseCase();
  });

  group('EnglishVocabularyBloc', () {
    blocTest<EnglishVocabularyBloc, EnglishVocabularyState>(
      'emits [loading, success] when words load',
      setUp: () {
        when(() => fetchWords(any())).thenAnswer(
          (_) async =>
              const Right<Failure, List<EnglishVocabularyWord>>([word]),
        );
      },
      build: () => EnglishVocabularyBloc(fetchWords),
      act: (bloc) => bloc.add(const EnglishVocabularyRequested()),
      expect: () => const [
        EnglishVocabularyState(status: EnglishVocabularyStatus.loading),
        EnglishVocabularyState(
          status: EnglishVocabularyStatus.success,
          words: [word],
        ),
      ],
    );

    blocTest<EnglishVocabularyBloc, EnglishVocabularyState>(
      'emits [loading, failure] when the usecase returns Left',
      setUp: () {
        when(() => fetchWords(any())).thenAnswer(
          (_) async => const Left<Failure, List<EnglishVocabularyWord>>(
            UnknownFailure('boom'),
          ),
        );
      },
      build: () => EnglishVocabularyBloc(fetchWords),
      act: (bloc) => bloc.add(const EnglishVocabularyRequested()),
      expect: () => [
        const EnglishVocabularyState(
          status: EnglishVocabularyStatus.loading,
        ),
        isA<EnglishVocabularyState>().having(
          (s) => s.status,
          'status',
          EnglishVocabularyStatus.failure,
        ),
      ],
    );
  });
}
