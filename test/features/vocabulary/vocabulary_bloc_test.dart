import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/features/lessons/domain/entities/learning_language.dart';
import 'package:study_lingo/features/vocabulary/domain/entities/vocabulary_word.dart';
import 'package:study_lingo/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:study_lingo/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';

class MockVocabularyRepository extends Mock implements VocabularyRepository {}

void main() {
  const word = VocabularyWord(
    id: 'w_water',
    target: LearningLanguage.japanese,
    english: 'water',
    japanese: '水',
    furigana: 'みず',
    jlptLevel: 5,
  );

  late VocabularyRepository repository;

  setUpAll(() => registerFallbackValue(LearningLanguage.japanese));

  setUp(() {
    repository = MockVocabularyRepository();
  });

  group('VocabularyBloc', () {
    blocTest<VocabularyBloc, VocabularyState>(
      'emits [loading, success] when words load',
      setUp: () {
        when(
          () => repository.fetchWords(
            language: any(named: 'language'),
            jlptLevel: any(named: 'jlptLevel'),
          ),
        ).thenAnswer((_) async => [word]);
      },
      build: () => VocabularyBloc(repository),
      act: (bloc) => bloc.add(const VocabularyRequested()),
      expect: () => [
        const VocabularyState(status: VocabularyStatus.loading),
        const VocabularyState(status: VocabularyStatus.success, words: [word]),
      ],
    );

    blocTest<VocabularyBloc, VocabularyState>(
      'carries the learning-session language filter into state and the query',
      setUp: () {
        when(
          () => repository.fetchWords(language: LearningLanguage.japanese),
        ).thenAnswer((_) async => [word]);
      },
      build: () => VocabularyBloc(repository),
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
        () => repository.fetchWords(language: LearningLanguage.japanese),
      ).called(1),
    );

    blocTest<VocabularyBloc, VocabularyState>(
      'a request without a language clears the session filter',
      setUp: () {
        when(
          () => repository.fetchWords(
            language: any(named: 'language'),
            jlptLevel: any(named: 'jlptLevel'),
          ),
        ).thenAnswer((_) async => [word]);
      },
      build: () => VocabularyBloc(repository),
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
      setUp: () {
        when(
          () => repository.fetchWords(jlptLevel: 5),
        ).thenAnswer((_) async => [word]);
      },
      build: () => VocabularyBloc(repository),
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
      'emits [loading, failure] when the repository throws',
      setUp: () {
        when(
          () => repository.fetchWords(
            language: any(named: 'language'),
            jlptLevel: any(named: 'jlptLevel'),
          ),
        ).thenThrow(Exception('boom'));
      },
      build: () => VocabularyBloc(repository),
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
