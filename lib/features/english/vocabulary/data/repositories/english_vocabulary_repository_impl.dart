import '../../domain/entities/english_vocabulary_word.dart';
import '../../domain/repositories/english_vocabulary_repository.dart';
import '../datasources/english_vocabulary_local_data_source.dart';

class EnglishVocabularyRepositoryImpl implements EnglishVocabularyRepository {
  const EnglishVocabularyRepositoryImpl(this._dataSource);

  final EnglishVocabularyLocalDataSource _dataSource;

  @override
  Future<List<EnglishVocabularyWord>> fetchWords() => _dataSource.getWords();
}
