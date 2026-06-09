import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/japanese_vocabulary_word.dart';
import '../../domain/usecases/fetch_japanese_vocabulary_words.dart';

part 'japanese_vocabulary_event.dart';
part 'japanese_vocabulary_state.dart';

class JapaneseVocabularyBloc
    extends Bloc<JapaneseVocabularyEvent, JapaneseVocabularyState> {
  JapaneseVocabularyBloc(this._fetchWords)
    : super(const JapaneseVocabularyState()) {
    on<JapaneseVocabularyRequested>(_onRequested);
  }

  final FetchJapaneseVocabularyWordsUseCase _fetchWords;

  Future<void> _onRequested(
    JapaneseVocabularyRequested event,
    Emitter<JapaneseVocabularyState> emit,
  ) async {
    emit(
      state.copyWith(
        status: JapaneseVocabularyStatus.loading,
        jlptFilter: event.jlptLevel,
        clearJlptFilter: event.jlptLevel == null,
      ),
    );
    final result = await _fetchWords(
      FetchJapaneseVocabularyWordsParams(jlptLevel: event.jlptLevel),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: JapaneseVocabularyStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (words) => emit(
        state.copyWith(
          status: JapaneseVocabularyStatus.success,
          words: words,
        ),
      ),
    );
  }
}
