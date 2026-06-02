import 'package:equatable/equatable.dart';

/// A single multiple-choice quiz question. Language-neutral: [prompt] and
/// [options] are already-localized display strings produced by the data layer,
/// so the quiz UI works the same whether the lesson teaches English or Japanese.
class QuizQuestion extends Equatable {
  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  bool isCorrect(int index) => index == correctIndex;

  @override
  List<Object?> get props => [id, prompt, options, correctIndex, explanation];
}
