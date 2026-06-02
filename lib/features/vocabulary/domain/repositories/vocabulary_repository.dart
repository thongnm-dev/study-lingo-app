import '../entities/vocabulary_word.dart';

/// Contract the presentation layer depends on. The Bloc talks to this
/// interface only — never to a concrete data source — so it can be unit-tested
/// against a mock. Implementations live in the data layer.
abstract class VocabularyRepository {
  /// Fetches the word list for a study deck. [jlptLevel] optionally filters to
  /// a single JLPT level (1–5); null returns all levels.
  Future<List<VocabularyWord>> fetchWords({int? jlptLevel});
}
