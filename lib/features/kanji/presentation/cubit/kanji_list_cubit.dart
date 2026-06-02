import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/kanji.dart';
import '../../domain/repositories/kanji_repository.dart';

enum KanjiListStatus { loading, success, failure }

class KanjiListState extends Equatable {
  const KanjiListState({
    this.status = KanjiListStatus.loading,
    this.kanji = const [],
  });

  final KanjiListStatus status;
  final List<Kanji> kanji;

  KanjiListState copyWith({KanjiListStatus? status, List<Kanji>? kanji}) {
    return KanjiListState(
      status: status ?? this.status,
      kanji: kanji ?? this.kanji,
    );
  }

  @override
  List<Object?> get props => [status, kanji];
}

class KanjiListCubit extends Cubit<KanjiListState> {
  KanjiListCubit(this._repository) : super(const KanjiListState());

  final KanjiRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: KanjiListStatus.loading));
    try {
      final kanji = await _repository.fetchAll();
      emit(state.copyWith(status: KanjiListStatus.success, kanji: kanji));
    } catch (_) {
      emit(state.copyWith(status: KanjiListStatus.failure));
    }
  }
}
