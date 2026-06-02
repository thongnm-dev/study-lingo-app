part of 'quiz_bloc.dart';

enum QuizStatus { inProgress, finished }

class QuizState extends Equatable {
  const QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.selectedOptionIndex,
    this.correctCount = 0,
    this.status = QuizStatus.inProgress,
  });

  final List<QuizQuestion> questions;
  final int currentIndex;

  /// The option chosen for the current question, or null if unanswered.
  final int? selectedOptionIndex;
  final int correctCount;
  final QuizStatus status;

  QuizQuestion get currentQuestion => questions[currentIndex];
  bool get isAnswered => selectedOptionIndex != null;
  bool get isLastQuestion => currentIndex == questions.length - 1;
  int get totalQuestions => questions.length;

  int get earnedXp => correctCount * Lesson.xpPerCorrectAnswer;

  /// Progress through the quiz as a 0–1 fraction, for a progress bar.
  double get progress =>
      questions.isEmpty ? 0 : (currentIndex + 1) / questions.length;

  QuizState copyWith({
    int? currentIndex,
    int? selectedOptionIndex,
    bool clearSelection = false,
    int? correctCount,
    QuizStatus? status,
  }) {
    return QuizState(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionIndex: clearSelection
          ? null
          : (selectedOptionIndex ?? this.selectedOptionIndex),
      correctCount: correctCount ?? this.correctCount,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    questions,
    currentIndex,
    selectedOptionIndex,
    correctCount,
    status,
  ];
}
