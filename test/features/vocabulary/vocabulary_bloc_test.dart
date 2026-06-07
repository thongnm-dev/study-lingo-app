import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/core/utils/failure.dart';
import 'package:study_lingo/features/lessons/domain/entities/learning_language.dart';
import 'package:study_lingo/features/vocabulary/domain/entities/vocabulary_word.dart';
import 'package:study_lingo/features/vocabulary/domain/usecases/fetch_vocabulary_words.dart';
import 'package:study_lingo/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';

class MockFetchVocabularyWordsUseCase extends Mock
    implements FetchVocabularyWordsUseCase {}

void main() {
  const word = VocabularyWord(
    id: 'w_water',
    target: LearningLanguage.japanese,
    english: 'water',
    japanese: '水',
    furigana: 'みず',
    jlptLevel: 5,
  );

  late MockFetchVocabularyWordsUseCase fetchWords;

  setUpAll(() {
    registerFallbackValue(LearningLanguage.japanese);
    registerFallbackValue(const FetchVocabularyWordsParams());
  });

  setUp(() {
    fetchWords = MockFetchVocabularyWordsUseCase();
  });

  void stubSuccess() {
    when(
      () => fetchWords(any()),
    ).thenAnswer((_) async => const Right<Failure, List<VocabularyWord>>([word]));
  }

  group('VocabularyBloc', () {
    blocTest<VocabularyBloc, VocabularyState>(
      'emits [loading, success] when words load',
      setUp: stubSuccess,
      build: () => VocabularyBloc(fetchWords),
      act: (bloc) => bloc.add(const VocabularyRequested()),
      expect: () => [
        const VocabularyState(status: VocabularyStatus.loading),
        const VocabularyState(status: VocabularyStatus.success, words: [word]),
      ],
    );

    blocTest<VocabularyBloc, VocabularyState>(
      'carries the learning-session language filter into state and the query',
      setUp: stubSuccess,
      build: () => VocabularyBloc(fetchWords),
      act: (bloc) => bloc.add(
        const VocabularyRequested(language: LearningLanguage.japanese),
      ),
      expect: () => [
        const VocabularyState(
          status: VocabularyStatus.loading,
          languageFilter: LearningLanguage.japanese,
        ),
        const VocabularyState(
          status: VocabularyStatus.success,
          languageFilter: LearningLanguage.japanese,
          words: [word],
        ),
      ],
      verify: (_) => verify(
        () => fetchWords(
          const FetchVocabularyWordsParams(language: LearningLanguage.japanese),
        ),
      ).called(1),
    );

    blocTest<VocabularyBloc, VocabularyState>(
      'a request without a language clears the session filter',
      setUp: stubSuccess,
      build: () => VocabularyBloc(fetchWords),
      seed: () => const VocabularyState(
        status: VocabularyStatus.success,
        languageFilter: LearningLanguage.japanese,
        words: [word],
      ),
      act: (bloc) => bloc.add(const VocabularyRequested()),
      expect: () => [
        const VocabularyState(status: VocabularyStatus.loading, words: [word]),
        const VocabularyState(status: VocabularyStatus.success, words: [word]),
      ],
    );

    blocTest<VocabularyBloc, VocabularyState>(
      'carries the JLPT filter into state',
      setUp: stubSuccess,
      build: () => VocabularyBloc(fetchWords),
      act: (bloc) => bloc.add(const VocabularyRequested(jlptLevel: 5)),
      expect: () => [
        const VocabularyState(status: VocabularyStatus.loading, jlptFilter: 5),
        const VocabularyState(
          status: VocabularyStatus.success,
          jlptFilter: 5,
          words: [word],
        ),
      ],
    );

    blocTest<VocabularyBloc, VocabularyState>(
      'emits [loading, failure] when the usecase returns Left',
      setUp: () {
        when(() => fetchWords(any())).thenAnswer(
          (_) async => const Left<Failure, List<VocabularyWord>>(
            UnknownFailure('boom'),
          ),
        );
      },
      build: () => VocabularyBloc(fetchWords),
      act: (bloc) => bloc.add(const VocabularyRequested()),
      expect: () => [
        const VocabularyState(status: VocabularyStatus.loading),
        isA<VocabularyState>().having(
          (s) => s.status,
          'status',
          VocabularyStatus.failure,
        ),
      ],
    );
  });
}
