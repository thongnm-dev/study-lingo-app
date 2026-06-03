import '../../../lessons/domain/entities/learning_language.dart';
import '../entities/vocabulary_word.dart';

/// Contract the presentation layer depends on. The Bloc talks to this
/// interface only — never to a concrete data source — so it can be unit-tested
/// against a mock. Implementations live in the data layer.
abstract class VocabularyRepository {
  /// Fetches the word list for a study deck. [language] optionally filters to
  /// the words targeting one study language (the active learning session);
  /// null returns both decks. [jlptLevel] optionally filters to a single JLPT
  /// level (1–5); null returns all levels.
  Future<List<VocabularyWord>> fetchWords({
    LearningLanguage? language,
    int? jlptLevel,
  });
}
