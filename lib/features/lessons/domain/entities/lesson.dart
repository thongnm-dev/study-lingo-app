import 'package:equatable/equatable.dart';

import 'learning_language.dart';
import 'quiz_question.dart';

/// A lesson belonging to a [Topic]. Completing its quiz is what records daily
/// progress. Titles carry both languages so the same lesson lists correctly for
/// English- and Japanese-facing UI.
class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.topicId,
    required this.titleEn,
    required this.titleJa,
    required this.questions,
  });

  final String id;
  final String topicId;
  final String titleEn;
  final String titleJa;
  final List<QuizQuestion> questions;

  int get questionCount => questions.length;

  /// Title in the chosen study language; [subtitleIn] returns the other.
  String titleIn(LearningLanguage language) =>
      language == LearningLanguage.japanese ? titleJa : titleEn;

  String subtitleIn(LearningLanguage language) =>
      language == LearningLanguage.japanese ? titleEn : titleJa;

  /// XP awarded per correct answer; total possible is [questionCount] * this.
  static const xpPerCorrectAnswer = 10;

  @override
  List<Object?> get props => [id, topicId, titleEn, titleJa, questions];
}
