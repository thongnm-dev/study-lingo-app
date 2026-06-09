import '../entities/japanese_vocabulary_word.dart';

/// Contract the presentation layer depends on. Implementations live in the
/// data layer.
abstract class JapaneseVocabularyRepository {
  /// Fetches the Japanese word deck. [jlptLevel] optionally filters to a
  /// single JLPT level (1–5); null returns all levels.
  Future<List<JapaneseVocabularyWord>> fetchWords({int? jlptLevel});
}
