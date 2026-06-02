import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/lessons/data/datasources/lessons_local_data_source.dart';
import 'package:study_lingo/features/lessons/data/repositories/lessons_repository_impl.dart';
import 'package:study_lingo/features/lessons/domain/entities/learning_language.dart';
import 'package:study_lingo/features/lessons/domain/entities/learning_skill.dart';

void main() {
  const repository = LessonsRepositoryImpl(InMemoryLessonsDataSource());

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

  group('LessonsRepository content direction', () {
    test('Japanese-target questions offer Japanese answer options', () async {
      final lessons = await repository.fetchLessons(
        't_greetings',
        LearningLanguage.japanese,
      );
      final firstQuestion = lessons.first.questions.first;
      // Correct answer for "Good morning" is a Japanese word.
      expect(firstQuestion.options[firstQuestion.correctIndex], 'おはよう');
    });

    test('English-target questions offer English answer options', () async {
      final lessons = await repository.fetchLessons(
        't_greetings',
        LearningLanguage.english,
      );
      final firstQuestion = lessons.first.questions.first;
      // Same lesson id, but the answer is now the English word.
      expect(firstQuestion.options[firstQuestion.correctIndex], 'Good morning');
    });

    test('both directions expose the same lessons for a topic', () async {
      final ja = await repository.fetchLessons(
        't_greetings',
        LearningLanguage.japanese,
      );
      final en = await repository.fetchLessons(
        't_greetings',
        LearningLanguage.english,
      );
      expect(ja.map((l) => l.id).toList(), en.map((l) => l.id).toList());
    });
  });

  group('practice lesson', () {
    test('mixes questions across topics, capped at 8, in the language', () async {
      final practice = await repository.fetchPracticeLesson(
        LearningLanguage.english,
      );
      expect(practice.id, 'practice');
      expect(practice.questions.length, 8);
      // Breadth-first: the first question is the first lesson's first question,
      // in the English direction.
      final first = practice.questions.first;
      expect(first.options[first.correctIndex], 'Good morning');
    });

    test('respects the chosen language', () async {
      final practice = await repository.fetchPracticeLesson(
        LearningLanguage.japanese,
      );
      final first = practice.questions.first;
      expect(first.options[first.correctIndex], 'おはよう');
    });
  });
}
