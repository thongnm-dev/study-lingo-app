import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/features/lessons/domain/entities/lesson.dart';
import 'package:study_lingo/features/lessons/domain/entities/quiz_question.dart';
import 'package:study_lingo/features/lessons/presentation/bloc/quiz_bloc.dart';
import 'package:study_lingo/features/progress/domain/repositories/progress_repository.dart';

class MockProgressRepository extends Mock implements ProgressRepository {}

void main() {
  const lesson = Lesson(
    id: 'l1',
    topicId: 't1',
    titleEn: 'Test',
    titleJa: 'テスト',
    questions: [
      QuizQuestion(
        id: 'q1',
        prompt: 'A?',
        options: ['right', 'wrong'],
        correctIndex: 0,
      ),
      QuizQuestion(
        id: 'q2',
        prompt: 'B?',
        options: ['wrong', 'right'],
        correctIndex: 1,
      ),
    ],
  );

  late ProgressRepository progress;

  setUp(() {
    progress = MockProgressRepository();
    when(
      () => progress.recordLessonCompleted(xpEarned: any(named: 'xpEarned')),
    ).thenAnswer((_) async {});
  });

  QuizBloc build() => QuizBloc(lesson: lesson, progress: progress);

  group('QuizBloc', () {
    blocTest<QuizBloc, QuizState>(
      'locks the answer and counts a correct pick',
      build: build,
      act: (bloc) => bloc
        ..add(const QuizAnswerSelected(0))
        ..add(const QuizAnswerSelected(1)), // ignored: already answered
      expect: () => [
        isA<QuizState>()
            .having((s) => s.selectedOptionIndex, 'selected', 0)
            .having((s) => s.correctCount, 'correct', 1),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'does not advance before an answer is selected',
      build: build,
      act: (bloc) => bloc.add(const QuizAdvanced()),
      expect: () => const <QuizState>[],
    );

    blocTest<QuizBloc, QuizState>(
      'finishes after the last question and records progress with XP',
      build: build,
      act: (bloc) => bloc
        ..add(const QuizAnswerSelected(0)) // q1 correct
        ..add(const QuizAdvanced()) // -> q2
        ..add(const QuizAnswerSelected(1)) // q2 correct
        ..add(const QuizAdvanced()), // finish
      verify: (bloc) {
        expect(bloc.state.status, QuizStatus.finished);
        expect(bloc.state.correctCount, 2);
        // 2 correct * 10 XP each
        verify(() => progress.recordLessonCompleted(xpEarned: 20)).called(1);
      },
    );
  });
}
