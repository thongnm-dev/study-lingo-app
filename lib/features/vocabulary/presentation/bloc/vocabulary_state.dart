part of 'vocabulary_bloc.dart';

enum VocabularyStatus { initial, loading, success, failure }

class VocabularyState extends Equatable {
  const VocabularyState({
    this.status = VocabularyStatus.initial,
    this.words = const [],
    this.jlptFilter,
    this.errorMessage,
  });

  final VocabularyStatus status;
  final List<VocabularyWord> words;

  /// Currently applied JLPT filter, or null for "all levels".
  final int? jlptFilter;
  final String? errorMessage;

  VocabularyState copyWith({
    VocabularyStatus? status,
    List<VocabularyWord>? words,
    int? jlptFilter,
    bool clearJlptFilter = false,
    String? errorMessage,
  }) {
    return VocabularyState(
      status: status ?? this.status,
      words: words ?? this.words,
      jlptFilter: clearJlptFilter ? null : (jlptFilter ?? this.jlptFilter),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, words, jlptFilter, errorMessage];
}
