import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/kanji.dart';
import '../../domain/usecases/fetch_kanji_list.dart';

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
  KanjiListCubit(this._fetchKanjiList) : super(const KanjiListState());

  final FetchKanjiListUseCase _fetchKanjiList;

  Future<void> load() async {
    emit(state.copyWith(status: KanjiListStatus.loading));
    final result = await _fetchKanjiList(const NoParams());
    result.fold(
      (_) => emit(state.copyWith(status: KanjiListStatus.failure)),
      (kanji) =>
          emit(state.copyWith(status: KanjiListStatus.success, kanji: kanji)),
    );
  }
}
