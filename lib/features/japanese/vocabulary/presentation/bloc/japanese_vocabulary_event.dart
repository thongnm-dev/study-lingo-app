part of 'japanese_vocabulary_bloc.dart';

sealed class JapaneseVocabularyEvent extends Equatable {
  const JapaneseVocabularyEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or reload) the Japanese word list, optionally filtered to a single
/// JLPT level.
class JapaneseVocabularyRequested extends JapaneseVocabularyEvent {
  const JapaneseVocabularyRequested({this.jlptLevel});

  final int? jlptLevel;

  @override
  List<Object?> get props => [jlptLevel];
}
