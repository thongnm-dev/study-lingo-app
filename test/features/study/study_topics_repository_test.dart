import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/core/constants/learning_language.dart';
import 'package:study_lingo/features/study/data/datasources/study_topics_local_data_source.dart';
import 'package:study_lingo/features/study/data/repositories/study_topics_repository_impl.dart';

void main() {
  const repository = StudyTopicsRepositoryImpl(
    InMemoryStudyTopicsDataSource(),
  );

  test('English topics are tagged with the English language', () async {
    final topics = await repository.fetchTopics(LearningLanguage.english);
    expect(topics, isNotEmpty);
    expect(topics.every((t) => t.language == LearningLanguage.english), isTrue);
    expect(topics.map((t) => t.id), contains('en_daily_conversation'));
  });

  test('Japanese topics are tagged with the Japanese language', () async {
    final topics = await repository.fetchTopics(LearningLanguage.japanese);
    expect(topics, isNotEmpty);
    expect(topics.every((t) => t.language == LearningLanguage.japanese), isTrue);
    expect(topics.map((t) => t.id), contains('ja_daily_conversation'));
  });

  test('every topic resolves to at least one lesson', () async {
    for (final language in LearningLanguage.values) {
      final topics = await repository.fetchTopics(language);
      for (final topic in topics) {
        final lessons = await repository.fetchLessons(topic.id);
        expect(
          lessons,
          isNotEmpty,
          reason: 'topic ${topic.id} should have lessons',
        );
        expect(lessons.every((l) => l.topicId == topic.id), isTrue);
        expect(lessons.every((l) => l.questions.isNotEmpty), isTrue);
      }
    }
  });
}
