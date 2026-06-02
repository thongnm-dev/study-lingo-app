import '../entities/learning_language.dart';
import '../entities/learning_skill.dart';
import '../entities/lesson.dart';
import '../entities/topic.dart';

/// Source of learning content. Implemented in the data layer (in-memory seed
/// today; swap for a bundled JSON asset, sqlite, or a CMS-backed API later).
abstract class LessonsRepository {
  /// Topics belonging to a [skill] track (grammar, vocabulary, …).
  Future<List<Topic>> fetchTopics(LearningSkill skill);

  /// Lessons for a single topic, with quiz questions oriented to the chosen
  /// study [language].
  Future<List<Lesson>> fetchLessons(String topicId, LearningLanguage language);

  /// A synthetic "practice" lesson that mixes questions from across all topics
  /// in [language], for a quick review session (the "Luyện tập" entry point).
  Future<Lesson> fetchPracticeLesson(LearningLanguage language);
}
