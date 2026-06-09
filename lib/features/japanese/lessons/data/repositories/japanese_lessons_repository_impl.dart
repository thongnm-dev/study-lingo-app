import '../../../../../core/constants/learning_skill.dart';
import '../../domain/entities/japanese_lesson.dart';
import '../../domain/entities/japanese_topic.dart';
import '../../domain/repositories/japanese_lessons_repository.dart';
import '../datasources/japanese_lessons_local_data_source.dart';

class JapaneseLessonsRepositoryImpl implements JapaneseLessonsRepository {
  const JapaneseLessonsRepositoryImpl(this._dataSource);

  final JapaneseLessonsLocalDataSource _dataSource;

  @override
  Future<List<JapaneseTopic>> fetchTopics(LearningSkill skill) async {
    final all = await _dataSource.getTopics();
    return all.where((t) => t.skill == skill).toList();
  }

  @override
  Future<List<JapaneseLesson>> fetchLessons(String topicId) async {
    final all = await _dataSource.getLessons();
    return all.where((l) => l.topicId == topicId).toList();
  }

  /// Max questions in a practice session.
  static const _practiceSize = 8;

  @override
  Future<JapaneseLesson> fetchPracticeLesson() async {
    final lessons = await _dataSource.getLessons();
    final firsts = lessons.map((l) => l.questions.first);
    final rest = lessons.expand((l) => l.questions.skip(1));
    final questions = [...firsts, ...rest].take(_practiceSize).toList();
    return JapaneseLesson(
      id: 'practice',
      topicId: 'practice',
      title: '練習',
      questions: questions,
    );
  }
}
