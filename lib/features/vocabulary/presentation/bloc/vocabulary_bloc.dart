import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/vocabulary_word.dart';
import '../../domain/repositories/vocabulary_repository.dart';

part 'vocabulary_event.dart';
part 'vocabulary_state.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  VocabularyBloc(this._repository) : super(const VocabularyState()) {
    on<VocabularyRequested>(_onRequested);
  }

  final VocabularyRepository _repository;

  Future<void> _onRequested(
    VocabularyRequested event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(
      state.copyWith(
        status: VocabularyStatus.loading,
        jlptFilter: event.jlptLevel,
        clearJlptFilter: event.jlptLevel == null,
      ),
    );
    try {
      final words = await _repository.fetchWords(jlptLevel: event.jlptLevel);
      emit(state.copyWith(status: VocabularyStatus.success, words: words));
    } catch (e) {
      emit(
        state.copyWith(
          status: VocabularyStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
