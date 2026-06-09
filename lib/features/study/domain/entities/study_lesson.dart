import 'package:equatable/equatable.dart';

import '../../../quiz/domain/entities/quiz_question.dart';
import 'study_lesson_focus.dart';

/// A single lesson within a Study topic. Completing the embedded quiz records
/// daily progress (via [QuizBloc] → [RecordLessonCompletedUseCase]).
class StudyLesson extends Equatable {
  const StudyLesson({
    required this.id,
    required this.topicId,
    required this.title,
    required this.focus,
    required this.questions,
  });

  final String id;
  final String topicId;
  final String title;
  final StudyLessonFocus focus;
  final List<QuizQuestion> questions;

  int get questionCount => questions.length;

  @override
  List<Object?> get props => [id, topicId, title, focus, questions];
}
