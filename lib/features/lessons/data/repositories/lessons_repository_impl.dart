import '../../domain/entities/learning_language.dart';
import '../../domain/entities/learning_skill.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/topic.dart';
import '../../domain/repositories/lessons_repository.dart';
import '../datasources/lessons_local_data_source.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  const LessonsRepositoryImpl(this._dataSource);

  final LessonsLocalDataSource _dataSource;

  @override
  Future<List<Topic>> fetchTopics(LearningSkill skill) async =>
      seedTopics.where((t) => t.skill == skill).toList();

  @override
  Future<List<Lesson>> fetchLessons(
    String topicId,
    LearningLanguage language,
  ) async {
    final all = await _dataSource.getLessons(language);
    return all.where((l) => l.topicId == topicId).toList();
  }

  /// Max questions in a practice session.
  static const _practiceSize = 8;

  @override
  Future<Lesson> fetchPracticeLesson(LearningLanguage language) async {
    final lessons = await _dataSource.getLessons(language);
    // Breadth first: one question from each lesson, then the remainder, capped.
    // Deterministic (no shuffle) so the set is predictable and testable.
    final firsts = lessons.map((l) => l.questions.first);
    final rest = lessons.expand((l) => l.questions.skip(1));
    final questions = [...firsts, ...rest].take(_practiceSize).toList();
    return Lesson(
      id: 'practice',
      topicId: 'practice',
      titleEn: 'Practice',
      titleJa: '練習',
      questions: questions,
    );
  }
}
