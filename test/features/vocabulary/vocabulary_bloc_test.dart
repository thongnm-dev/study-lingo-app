import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/features/vocabulary/domain/entities/vocabulary_word.dart';
import 'package:study_lingo/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:study_lingo/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';

class MockVocabularyRepository extends Mock implements VocabularyRepository {}

void main() {
  const word = VocabularyWord(
    id: 'w_water',
    english: 'water',
    japanese: '水',
    furigana: 'みず',
    jlptLevel: 5,
  );

  late VocabularyRepository repository;

  setUp(() {
    repository = MockVocabularyRepository();
  });

  group('VocabularyBloc', () {
    blocTest<VocabularyBloc, VocabularyState>(
      'emits [loading, success] when words load',
      setUp: () {
        when(
          () => repository.fetchWords(jlptLevel: any(named: 'jlptLevel')),
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
          () => repository.fetchWords(jlptLevel: any(named: 'jlptLevel')),
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
