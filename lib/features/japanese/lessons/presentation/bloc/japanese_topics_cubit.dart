import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/constants/learning_skill.dart';
import '../../domain/entities/japanese_topic.dart';
import '../../domain/usecases/fetch_japanese_topics.dart';

enum JapaneseTopicsStatus { loading, success, failure }

class JapaneseTopicsState extends Equatable {
  const JapaneseTopicsState({
    this.status = JapaneseTopicsStatus.loading,
    this.topics = const [],
  });

  final JapaneseTopicsStatus status;
  final List<JapaneseTopic> topics;

  JapaneseTopicsState copyWith({
    JapaneseTopicsStatus? status,
    List<JapaneseTopic>? topics,
  }) {
    return JapaneseTopicsState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
    );
  }

  @override
  List<Object?> get props => [status, topics];
}

class JapaneseTopicsCubit extends Cubit<JapaneseTopicsState> {
  JapaneseTopicsCubit(this._fetchTopics) : super(const JapaneseTopicsState());

  final FetchJapaneseTopicsUseCase _fetchTopics;

  Future<void> load(LearningSkill skill) async {
    emit(state.copyWith(status: JapaneseTopicsStatus.loading));
    final result = await _fetchTopics(skill);
    result.fold(
      (_) => emit(state.copyWith(status: JapaneseTopicsStatus.failure)),
      (topics) => emit(
        state.copyWith(status: JapaneseTopicsStatus.success, topics: topics),
      ),
    );
  }
}
