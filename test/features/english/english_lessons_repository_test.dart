import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/core/constants/learning_skill.dart';
import 'package:study_lingo/features/english/lessons/data/datasources/english_lessons_local_data_source.dart';
import 'package:study_lingo/features/english/lessons/data/repositories/english_lessons_repository_impl.dart';

void main() {
  const repository = EnglishLessonsRepositoryImpl(
    InMemoryEnglishLessonsDataSource(),
  );

  group('topics by skill', () {
    test('vocabulary returns its three topics', () async {
      final topics = await repository.fetchTopics(LearningSkill.vocabulary);
      expect(topics.map((t) => t.id), ['t_greetings', 't_food', 't_travel']);
    });

    test('every skill has at least one topic', () async {
      for (final skill in LearningSkill.values) {
        final topics = await repository.fetchTopics(skill);
        expect(topics, isNotEmpty, reason: 'skill $skill should have topics');
        expect(topics.every((t) => t.skill == skill), isTrue);
      }
    });
  });

  group('English lesson content', () {
    test('greetings lesson has English answer options', () async {
      final lessons = await repository.fetchLessons('t_greetings');
      final firstQuestion = lessons.first.questions.first;
      expect(firstQuestion.options[firstQuestion.correctIndex], 'Good morning');
    });
  });

  group('practice lesson', () {
    test('mixes questions breadth-first, capped at 8', () async {
      final practice = await repository.fetchPracticeLesson();
      expect(practice.id, 'practice');
      expect(practice.questions.length, 8);
      final first = practice.questions.first;
      expect(first.options[first.correctIndex], 'Good morning');
    });
  });
}
