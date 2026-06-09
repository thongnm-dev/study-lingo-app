import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/quiz_question.dart';
import '../../domain/usecases/record_lesson_completed.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

/// Drives one quiz run. Event-driven with several distinct triggers (answer,
/// advance) → a Bloc rather than a Cubit. On finishing it records the lesson
/// via [RecordLessonCompletedUseCase], which is what feeds the streak and
/// daily-progress UI.
///
/// Language-neutral: the bloc only sees a list of [QuizQuestion]s. The english
/// and japanese lessons features each surface their own Lesson type and pass
/// its questions in.
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({
    required List<QuizQuestion> questions,
    required RecordLessonCompletedUseCase recordLessonCompleted,
  }) : _recordLessonCompleted = recordLessonCompleted,
       super(QuizState(questions: questions)) {
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizAdvanced>(_onAdvanced);
  }

  final RecordLessonCompletedUseCase _recordLessonCompleted;

  void _onAnswerSelected(QuizAnswerSelected event, Emitter<QuizState> emit) {
    if (state.isAnswered) return; // lock the answer once chosen
    final wasCorrect = state.currentQuestion.isCorrect(event.optionIndex);
    emit(
      state.copyWith(
        selectedOptionIndex: event.optionIndex,
        correctCount: wasCorrect ? state.correctCount + 1 : state.correctCount,
      ),
    );
  }

  Future<void> _onAdvanced(QuizAdvanced event, Emitter<QuizState> emit) async {
    if (!state.isAnswered) return; // must answer before advancing
    if (state.isLastQuestion) {
      emit(state.copyWith(status: QuizStatus.finished));
      await _recordLessonCompleted(
        RecordLessonCompletedParams(xpEarned: state.earnedXp),
      );
      return;
    }
    emit(
      state.copyWith(
        currentIndex: state.currentIndex + 1,
        clearSelection: true,
      ),
    );
  }
}
