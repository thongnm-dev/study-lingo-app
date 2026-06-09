import '../../../../core/constants/learning_language.dart';
import '../entities/study_lesson.dart';
import '../entities/study_topic.dart';

/// Source of themed study content (Daily Conversation, Office, Health…).
/// Implemented in the data layer (in-memory seed today; back with a remote DB
/// or bundled JSON later without touching callers).
abstract class StudyTopicsRepository {
  /// Topics scoped to one [language].
  Future<List<StudyTopic>> fetchTopics(LearningLanguage language);

  /// Lessons inside a single topic.
  Future<List<StudyLesson>> fetchLessons(String topicId);
}
