import '../../../lessons/domain/entities/learning_language.dart';
import '../../domain/entities/vocabulary_word.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/vocabulary_local_data_source.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  const VocabularyRepositoryImpl(this._dataSource);

  final VocabularyLocalDataSource _dataSource;

  @override
  Future<List<VocabularyWord>> fetchWords({
    LearningLanguage? language,
    int? jlptLevel,
  }) async {
    final words = await _dataSource.getWords();
    return words
        .where((w) => language == null || w.target == language)
        .where((w) => jlptLevel == null || w.jlptLevel == jlptLevel)
        .toList();
  }
}
