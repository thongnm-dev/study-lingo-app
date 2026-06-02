part of 'vocabulary_bloc.dart';

sealed class VocabularyEvent extends Equatable {
  const VocabularyEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or reload) the word list, optionally filtered to one JLPT level.
class VocabularyRequested extends VocabularyEvent {
  const VocabularyRequested({this.jlptLevel});

  final int? jlptLevel;

  @override
  List<Object?> get props => [jlptLevel];
}
