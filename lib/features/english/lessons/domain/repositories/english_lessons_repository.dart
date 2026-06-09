import '../../../../../core/constants/learning_skill.dart';
import '../entities/english_lesson.dart';
import '../entities/english_topic.dart';

/// Source of English learning content. Implemented in the data layer
/// (in-memory seed today; swap for a bundled JSON asset, sqlite, or a
/// CMS-backed API later).
abstract class EnglishLessonsRepository {
  /// Topics belonging to a [skill] track (grammar, vocabulary, …).
  Future<List<EnglishTopic>> fetchTopics(LearningSkill skill);

  /// Lessons for a single topic.
  Future<List<EnglishLesson>> fetchLessons(String topicId);

  /// A synthetic "practice" lesson that mixes questions from across all topics,
  /// for a quick review session (the "Luyện tập" entry point).
  Future<EnglishLesson> fetchPracticeLesson();
}
