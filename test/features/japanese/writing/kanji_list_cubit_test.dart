import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/japanese/writing/data/repositories/in_memory_kanji_repository.dart';
import 'package:study_lingo/features/japanese/writing/domain/usecases/fetch_kanji_list.dart';
import 'package:study_lingo/features/japanese/writing/presentation/bloc/kanji_list_cubit.dart';

void main() {
  group('KanjiListCubit', () {
    blocTest<KanjiListCubit, KanjiListState>(
      'loads the kanji set',
      build: () => KanjiListCubit(
        const FetchKanjiListUseCase(InMemoryKanjiRepository()),
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<KanjiListState>().having(
          (s) => s.status,
          'status',
          KanjiListStatus.loading,
        ),
        isA<KanjiListState>()
            .having((s) => s.status, 'status', KanjiListStatus.success)
            .having((s) => s.kanji.length, 'count', greaterThan(5)),
      ],
    );

    test('first kanji carries meaning and both readings', () async {
      final kanji = await const InMemoryKanjiRepository().fetchAll();
      final first = kanji.first;
      expect(first.glyph, isNotEmpty);
      expect(first.meaning, isNotEmpty);
      expect(first.onyomi, isNotEmpty);
      expect(first.kunyomi, isNotEmpty);
    });
  });
}
