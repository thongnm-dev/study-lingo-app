part of 'japanese_vocabulary_bloc.dart';

enum JapaneseVocabularyStatus { initial, loading, success, failure }

class JapaneseVocabularyState extends Equatable {
  const JapaneseVocabularyState({
    this.status = JapaneseVocabularyStatus.initial,
    this.words = const [],
    this.jlptFilter,
    this.errorMessage,
  });

  final JapaneseVocabularyStatus status;
  final List<JapaneseVocabularyWord> words;

  /// Currently applied JLPT filter, or null for "all levels".
  final int? jlptFilter;
  final String? errorMessage;

  JapaneseVocabularyState copyWith({
    JapaneseVocabularyStatus? status,
    List<JapaneseVocabularyWord>? words,
    int? jlptFilter,
    bool clearJlptFilter = false,
    String? errorMessage,
  }) {
    return JapaneseVocabularyState(
      status: status ?? this.status,
      words: words ?? this.words,
      jlptFilter: clearJlptFilter ? null : (jlptFilter ?? this.jlptFilter),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, words, jlptFilter, errorMessage];
}
