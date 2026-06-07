import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../lessons/domain/entities/learning_language.dart';
import '../../domain/entities/vocabulary_word.dart';
import '../../domain/usecases/fetch_vocabulary_words.dart';

part 'vocabulary_event.dart';
part 'vocabulary_state.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  VocabularyBloc(this._fetchWords) : super(const VocabularyState()) {
    on<VocabularyRequested>(_onRequested);
  }

  final FetchVocabularyWordsUseCase _fetchWords;

  Future<void> _onRequested(
    VocabularyRequested event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(
      state.copyWith(
        status: VocabularyStatus.loading,
        languageFilter: event.language,
        clearLanguageFilter: event.language == null,
        jlptFilter: event.jlptLevel,
        clearJlptFilter: event.jlptLevel == null,
      ),
    );
    final result = await _fetchWords(
      FetchVocabularyWordsParams(
        language: event.language,
        jlptLevel: event.jlptLevel,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: VocabularyStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (words) =>
          emit(state.copyWith(status: VocabularyStatus.success, words: words)),
    );
  }
}
