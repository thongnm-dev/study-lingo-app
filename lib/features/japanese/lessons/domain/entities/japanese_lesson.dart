import 'package:equatable/equatable.dart';

import '../../../../quiz/domain/entities/quiz_question.dart';

/// A Japanese lesson belonging to a Topic. Completing its quiz is what records
/// daily progress.
class JapaneseLesson extends Equatable {
  const JapaneseLesson({
    required this.id,
    required this.topicId,
    required this.title,
    required this.questions,
  });

  final String id;
  final String topicId;
  final String title;
  final List<QuizQuestion> questions;

  int get questionCount => questions.length;

  @override
  List<Object?> get props => [id, topicId, title, questions];
}
