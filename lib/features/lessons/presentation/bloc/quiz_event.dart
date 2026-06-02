part of 'quiz_bloc.dart';

sealed class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

/// User picked an option for the current question. Ignored once the current
/// question is already answered.
class QuizAnswerSelected extends QuizEvent {
  const QuizAnswerSelected(this.optionIndex);
  final int optionIndex;

  @override
  List<Object?> get props => [optionIndex];
}

/// Advance to the next question, or finish the quiz (and record progress) when
/// on the last question.
class QuizAdvanced extends QuizEvent {
  const QuizAdvanced();
}
