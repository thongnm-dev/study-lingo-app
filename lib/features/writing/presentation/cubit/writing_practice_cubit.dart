import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/japanese_script.dart';
import '../../domain/entities/writing_character.dart';
import '../../domain/repositories/writing_repository.dart';

class WritingPracticeState extends Equatable {
  const WritingPracticeState({
    this.loaded = false,
    this.characters = const [],
    this.index = 0,
  });

  final bool loaded;
  final List<WritingCharacter> characters;
  final int index;

  WritingCharacter? get current =>
      characters.isEmpty ? null : characters[index];
  bool get isLast => index >= characters.length - 1;
  int get total => characters.length;
  double get progress =>
      characters.isEmpty ? 0 : (index + 1) / characters.length;

  WritingPracticeState copyWith({
    bool? loaded,
    List<WritingCharacter>? characters,
    int? index,
  }) {
    return WritingPracticeState(
      loaded: loaded ?? this.loaded,
      characters: characters ?? this.characters,
      index: index ?? this.index,
    );
  }

  @override
  List<Object?> get props => [loaded, characters, index];
}

/// Walks through the characters of a [JapaneseScript] for tracing. The drawn
/// strokes themselves are transient UI state kept in the canvas widget — this
/// cubit only owns the character list and which one is current.
class WritingPracticeCubit extends Cubit<WritingPracticeState> {
  WritingPracticeCubit(this._repository) : super(const WritingPracticeState());

  final WritingRepository _repository;

  Future<void> load(JapaneseScript script) async {
    final characters = await _repository.charactersFor(script);
    emit(WritingPracticeState(loaded: true, characters: characters));
  }

  /// Practice an explicit set (e.g. a single kanji opened from its detail page).
  void setCharacters(List<WritingCharacter> characters) {
    emit(WritingPracticeState(loaded: true, characters: characters));
  }

  void next() {
    if (!state.isLast) emit(state.copyWith(index: state.index + 1));
  }

  void previous() {
    if (state.index > 0) emit(state.copyWith(index: state.index - 1));
  }
}
