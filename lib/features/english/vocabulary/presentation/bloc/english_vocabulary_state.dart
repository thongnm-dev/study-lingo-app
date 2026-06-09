part of 'english_vocabulary_bloc.dart';

enum EnglishVocabularyStatus { initial, loading, success, failure }

class EnglishVocabularyState extends Equatable {
  const EnglishVocabularyState({
    this.status = EnglishVocabularyStatus.initial,
    this.words = const [],
    this.errorMessage,
  });

  final EnglishVocabularyStatus status;
  final List<EnglishVocabularyWord> words;
  final String? errorMessage;

  EnglishVocabularyState copyWith({
    EnglishVocabularyStatus? status,
    List<EnglishVocabularyWord>? words,
    String? errorMessage,
  }) {
    return EnglishVocabularyState(
      status: status ?? this.status,
      words: words ?? this.words,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, words, errorMessage];
}
