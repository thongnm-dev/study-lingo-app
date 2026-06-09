import '../../../../../core/constants/learning_skill.dart';
import '../entities/japanese_lesson.dart';
import '../entities/japanese_topic.dart';

/// Source of Japanese learning content. Implemented in the data layer
/// (in-memory seed today; swap for a bundled JSON asset, sqlite, or a
/// CMS-backed API later).
abstract class JapaneseLessonsRepository {
  /// Topics belonging to a [skill] track (grammar, vocabulary, …).
  Future<List<JapaneseTopic>> fetchTopics(LearningSkill skill);

  /// Lessons for a single topic.
  Future<List<JapaneseLesson>> fetchLessons(String topicId);

  /// A synthetic "practice" lesson that mixes questions from across all topics,
  /// for a quick review session (the "Luyện tập" entry point).
  Future<JapaneseLesson> fetchPracticeLesson();
}
