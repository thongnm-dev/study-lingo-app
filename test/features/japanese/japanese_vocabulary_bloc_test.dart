import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/core/utils/failure.dart';
import 'package:study_lingo/features/japanese/vocabulary/domain/entities/japanese_vocabulary_word.dart';
import 'package:study_lingo/features/japanese/vocabulary/domain/usecases/fetch_japanese_vocabulary_words.dart';
import 'package:study_lingo/features/japanese/vocabulary/presentation/bloc/japanese_vocabulary_bloc.dart';

class MockFetchJapaneseVocabularyWordsUseCase extends Mock
    implements FetchJapaneseVocabularyWordsUseCase {}

void main() {
  const word = JapaneseVocabularyWord(
    id: 'w_water',
    japanese: '水',
    vietnamese: 'nước',
    furigana: 'みず',
    jlptLevel: 5,
  );

  late MockFetchJapaneseVocabularyWordsUseCase fetchWords;

  setUpAll(() {
    registerFallbackValue(const FetchJapaneseVocabularyWordsParams());
  });

  setUp(() {
    fetchWords = MockFetchJapaneseVocabularyWordsUseCase();
  });

  void stubSuccess() {
    when(() => fetchWords(any())).thenAnswer(
      (_) async =>
          const Right<Failure, List<JapaneseVocabularyWord>>([word]),
    );
  }

  group('JapaneseVocabularyBloc', () {
    blocTest<JapaneseVocabularyBloc, JapaneseVocabularyState>(
      'emits [loading, success] when words load',
      setUp: stubSuccess,
      build: () => JapaneseVocabularyBloc(fetchWords),
      act: (bloc) => bloc.add(const JapaneseVocabularyRequested()),
      expect: () => const [
        JapaneseVocabularyState(status: JapaneseVocabularyStatus.loading),
        JapaneseVocabularyState(
          status: JapaneseVocabularyStatus.success,
          words: [word],
        ),
      ],
    );

    blocTest<JapaneseVocabularyBloc, JapaneseVocabularyState>(
      'carries the JLPT filter into state and the query',
      setUp: stubSuccess,
      build: () => JapaneseVocabularyBloc(fetchWords),
      act: (bloc) =>
          bloc.add(const JapaneseVocabularyRequested(jlptLevel: 5)),
      expect: () => const [
        JapaneseVocabularyState(
          status: JapaneseVocabularyStatus.loading,
          jlptFilter: 5,
        ),
        JapaneseVocabularyState(
          status: JapaneseVocabularyStatus.success,
          jlptFilter: 5,
          words: [word],
        ),
      ],
      verify: (_) => verify(
        () => fetchWords(
          const FetchJapaneseVocabularyWordsParams(jlptLevel: 5),
        ),
      ).called(1),
    );

    blocTest<JapaneseVocabularyBloc, JapaneseVocabularyState>(
      'a request without a level clears the JLPT filter',
      setUp: stubSuccess,
      build: () => JapaneseVocabularyBloc(fetchWords),
      seed: () => const JapaneseVocabularyState(
        status: JapaneseVocabularyStatus.success,
        jlptFilter: 5,
        words: [word],
      ),
      act: (bloc) => bloc.add(const JapaneseVocabularyRequested()),
      expect: () => const [
        JapaneseVocabularyState(
          status: JapaneseVocabularyStatus.loading,
          words: [word],
        ),
        JapaneseVocabularyState(
          status: JapaneseVocabularyStatus.success,
          words: [word],
        ),
      ],
    );
  });
}
