import '../../domain/entities/vocabulary_word.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/vocabulary_local_data_source.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  const VocabularyRepositoryImpl(this._dataSource);

  final VocabularyLocalDataSource _dataSource;

  @override
  Future<List<VocabularyWord>> fetchWords({int? jlptLevel}) async {
    final words = await _dataSource.getWords();
    if (jlptLevel == null) return words;
    return words.where((w) => w.jlptLevel == jlptLevel).toList();
  }
}
