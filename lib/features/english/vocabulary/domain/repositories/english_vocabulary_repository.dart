import '../entities/english_vocabulary_word.dart';

/// Contract the presentation layer depends on. Implementations live in the
/// data layer.
abstract class EnglishVocabularyRepository {
  Future<List<EnglishVocabularyWord>> fetchWords();
}
