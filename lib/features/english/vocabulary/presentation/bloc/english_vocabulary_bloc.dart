import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/english_vocabulary_word.dart';
import '../../domain/usecases/fetch_english_vocabulary_words.dart';

part 'english_vocabulary_event.dart';
part 'english_vocabulary_state.dart';

class EnglishVocabularyBloc
    extends Bloc<EnglishVocabularyEvent, EnglishVocabularyState> {
  EnglishVocabularyBloc(this._fetchWords)
    : super(const EnglishVocabularyState()) {
    on<EnglishVocabularyRequested>(_onRequested);
  }

  final FetchEnglishVocabularyWordsUseCase _fetchWords;

  Future<void> _onRequested(
    EnglishVocabularyRequested event,
    Emitter<EnglishVocabularyState> emit,
  ) async {
    emit(state.copyWith(status: EnglishVocabularyStatus.loading));
    final result = await _fetchWords(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EnglishVocabularyStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (words) => emit(
        state.copyWith(
          status: EnglishVocabularyStatus.success,
          words: words,
        ),
      ),
    );
  }
}
