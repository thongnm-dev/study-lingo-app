import '../../../../core/constants/learning_language.dart';
import '../../domain/entities/study_lesson.dart';
import '../../domain/entities/study_topic.dart';
import '../../domain/repositories/study_topics_repository.dart';
import '../datasources/study_topics_local_data_source.dart';

class StudyTopicsRepositoryImpl implements StudyTopicsRepository {
  const StudyTopicsRepositoryImpl(this._dataSource);

  final StudyTopicsLocalDataSource _dataSource;

  @override
  Future<List<StudyTopic>> fetchTopics(LearningLanguage language) async {
    final all = await _dataSource.getTopics();
    return all.where((t) => t.language == language).toList();
  }

  @override
  Future<List<StudyLesson>> fetchLessons(String topicId) async {
    final all = await _dataSource.getLessons();
    return all.where((l) => l.topicId == topicId).toList();
  }
}
