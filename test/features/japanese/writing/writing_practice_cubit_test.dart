import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/japanese/writing/data/repositories/in_memory_writing_repository.dart';
import 'package:study_lingo/features/japanese/writing/domain/entities/japanese_script.dart';
import 'package:study_lingo/features/japanese/writing/domain/usecases/fetch_writing_characters.dart';
import 'package:study_lingo/features/japanese/writing/presentation/bloc/writing_practice_cubit.dart';

void main() {
  group('WritingPracticeCubit', () {
    blocTest<WritingPracticeCubit, WritingPracticeState>(
      'loads hiragana characters starting at the first',
      build: () => WritingPracticeCubit(
        const FetchWritingCharactersUseCase(InMemoryWritingRepository()),
      ),
      act: (cubit) => cubit.load(JapaneseScript.hiragana),
      verify: (cubit) {
        expect(cubit.state.loaded, isTrue);
        expect(cubit.state.index, 0);
        expect(cubit.state.current?.glyph, 'あ');
        expect(cubit.state.total, greaterThan(1));
      },
    );

    blocTest<WritingPracticeCubit, WritingPracticeState>(
      'next advances but never past the last character (katakana)',
      build: () => WritingPracticeCubit(
        const FetchWritingCharactersUseCase(InMemoryWritingRepository()),
      ),
      act: (cubit) async {
        await cubit.load(JapaneseScript.katakana);
        cubit.previous(); // no-op at index 0
        cubit.next();
      },
      verify: (cubit) {
        expect(cubit.state.index, 1);
        expect(cubit.state.current?.glyph, 'イ');
      },
    );

    blocTest<WritingPracticeCubit, WritingPracticeState>(
      'kanji practice characters carry a meaning',
      build: () => WritingPracticeCubit(
        const FetchWritingCharactersUseCase(InMemoryWritingRepository()),
      ),
      act: (cubit) => cubit.load(JapaneseScript.kanji),
      verify: (cubit) {
        expect(cubit.state.current?.meaning, isNotNull);
      },
    );
  });
}
