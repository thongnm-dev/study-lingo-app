part of 'vocabulary_bloc.dart';

sealed class VocabularyEvent extends Equatable {
  const VocabularyEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or reload) the word list, optionally filtered to the deck of one
/// study [language] (the active learning session) and/or one JLPT level.
class VocabularyRequested extends VocabularyEvent {
  const VocabularyRequested({this.language, this.jlptLevel});

  final LearningLanguage? language;
  final int? jlptLevel;

  @override
  List<Object?> get props => [language, jlptLevel];
}
