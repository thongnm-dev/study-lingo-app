import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../progress/domain/repositories/progress_repository.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/quiz_question.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

/// Drives one quiz run. Event-driven with several distinct triggers (answer,
/// advance) → a Bloc rather than a Cubit. On finishing it records the lesson
/// against the shared [ProgressRepository], which is what feeds the streak and
/// daily-progress UI.
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({required Lesson lesson, required ProgressRepository progress})
    : _progress = progress,
      super(QuizState(questions: lesson.questions)) {
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizAdvanced>(_onAdvanced);
  }

  final ProgressRepository _progress;

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
      await _progress.recordLessonCompleted(xpEarned: state.earnedXp);
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
