part of 'vocabulary_bloc.dart';

enum VocabularyStatus { initial, loading, success, failure }

class VocabularyState extends Equatable {
  const VocabularyState({
    this.status = VocabularyStatus.initial,
    this.words = const [],
    this.languageFilter,
    this.jlptFilter,
    this.errorMessage,
  });

  final VocabularyStatus status;
  final List<VocabularyWord> words;

  /// Study language whose deck is shown (mirrors the active learning session),
  /// or null for both decks.
  final LearningLanguage? languageFilter;

  /// Currently applied JLPT filter, or null for "all levels".
  final int? jlptFilter;
  final String? errorMessage;

  VocabularyState copyWith({
    VocabularyStatus? status,
    List<VocabularyWord>? words,
    LearningLanguage? languageFilter,
    bool clearLanguageFilter = false,
    int? jlptFilter,
    bool clearJlptFilter = false,
    String? errorMessage,
  }) {
    return VocabularyState(
      status: status ?? this.status,
      words: words ?? this.words,
      languageFilter: clearLanguageFilter
          ? null
          : (languageFilter ?? this.languageFilter),
      jlptFilter: clearJlptFilter ? null : (jlptFilter ?? this.jlptFilter),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    words,
    languageFilter,
    jlptFilter,
    errorMessage,
  ];
}
