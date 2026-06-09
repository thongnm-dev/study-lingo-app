import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/japanese/vocabulary/data/datasources/japanese_vocabulary_local_data_source.dart';
import 'package:study_lingo/features/japanese/vocabulary/data/repositories/japanese_vocabulary_repository_impl.dart';

void main() {
  const repository = JapaneseVocabularyRepositoryImpl(
    InMemoryJapaneseVocabularyDataSource(),
  );

  test('fetchWords returns the full deck when no filter', () async {
    final words = await repository.fetchWords();
    expect(words.length, greaterThan(0));
    expect(words.any((w) => w.japanese == '水'), isTrue);
  });

  test('fetchWords filters by JLPT level', () async {
    final n5 = await repository.fetchWords(jlptLevel: 5);
    expect(n5.every((w) => w.jlptLevel == 5), isTrue);
    expect(n5.any((w) => w.japanese == '水'), isTrue);

    final n4 = await repository.fetchWords(jlptLevel: 4);
    expect(n4.every((w) => w.jlptLevel == 4), isTrue);
    expect(n4.any((w) => w.japanese == '約束'), isTrue);
  });
}
