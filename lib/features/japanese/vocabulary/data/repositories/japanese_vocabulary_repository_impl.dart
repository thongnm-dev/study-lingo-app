import '../../domain/entities/japanese_vocabulary_word.dart';
import '../../domain/repositories/japanese_vocabulary_repository.dart';
import '../datasources/japanese_vocabulary_local_data_source.dart';

class JapaneseVocabularyRepositoryImpl implements JapaneseVocabularyRepository {
  const JapaneseVocabularyRepositoryImpl(this._dataSource);

  final JapaneseVocabularyLocalDataSource _dataSource;

  @override
  Future<List<JapaneseVocabularyWord>> fetchWords({int? jlptLevel}) async {
    final words = await _dataSource.getWords();
    if (jlptLevel == null) return words;
    return words.where((w) => w.jlptLevel == jlptLevel).toList();
  }
}
