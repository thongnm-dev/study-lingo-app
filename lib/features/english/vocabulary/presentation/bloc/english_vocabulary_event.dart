part of 'english_vocabulary_bloc.dart';

sealed class EnglishVocabularyEvent extends Equatable {
  const EnglishVocabularyEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or reload) the English word list.
class EnglishVocabularyRequested extends EnglishVocabularyEvent {
  const EnglishVocabularyRequested();
}
