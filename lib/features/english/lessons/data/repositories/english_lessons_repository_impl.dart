import '../../../../../core/constants/learning_skill.dart';
import '../../domain/entities/english_lesson.dart';
import '../../domain/entities/english_topic.dart';
import '../../domain/repositories/english_lessons_repository.dart';
import '../datasources/english_lessons_local_data_source.dart';

class EnglishLessonsRepositoryImpl implements EnglishLessonsRepository {
  const EnglishLessonsRepositoryImpl(this._dataSource);

  final EnglishLessonsLocalDataSource _dataSource;

  @override
  Future<List<EnglishTopic>> fetchTopics(LearningSkill skill) async {
    final all = await _dataSource.getTopics();
    return all.where((t) => t.skill == skill).toList();
  }

  @override
  Future<List<EnglishLesson>> fetchLessons(String topicId) async {
    final all = await _dataSource.getLessons();
    return all.where((l) => l.topicId == topicId).toList();
  }

  /// Max questions in a practice session.
  static const _practiceSize = 8;

  @override
  Future<EnglishLesson> fetchPracticeLesson() async {
    final lessons = await _dataSource.getLessons();
    // Breadth first: one question from each lesson, then the remainder, capped.
    // Deterministic (no shuffle) so the set is predictable and testable.
    final firsts = lessons.map((l) => l.questions.first);
    final rest = lessons.expand((l) => l.questions.skip(1));
    final questions = [...firsts, ...rest].take(_practiceSize).toList();
    return EnglishLesson(
      id: 'practice',
      topicId: 'practice',
      title: 'Practice',
      questions: questions,
    );
  }
}
