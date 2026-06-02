import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/lessons/domain/entities/learning_language.dart';
import 'package:study_lingo/features/lessons/presentation/cubit/language_cubit.dart';

void main() {
  group('LanguageCubit', () {
    test('starts with no language selected', () {
      expect(LanguageCubit().state, isNull);
    });

    blocTest<LanguageCubit, LearningLanguage?>(
      'select then reset returns to the picker',
      build: LanguageCubit.new,
      act: (cubit) => cubit
        ..select(LearningLanguage.japanese)
        ..reset(),
      expect: () => [LearningLanguage.japanese, null],
    );
  });
}
