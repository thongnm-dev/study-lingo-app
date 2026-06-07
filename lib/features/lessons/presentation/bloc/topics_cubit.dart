import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/learning_skill.dart';
import '../../domain/entities/topic.dart';
import '../../domain/usecases/fetch_topics.dart';

enum TopicsStatus { loading, success, failure }

class TopicsState extends Equatable {
  const TopicsState({
    this.status = TopicsStatus.loading,
    this.topics = const [],
  });

  final TopicsStatus status;
  final List<Topic> topics;

  TopicsState copyWith({TopicsStatus? status, List<Topic>? topics}) {
    return TopicsState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
    );
  }

  @override
  List<Object?> get props => [status, topics];
}

class TopicsCubit extends Cubit<TopicsState> {
  TopicsCubit(this._fetchTopics) : super(const TopicsState());

  final FetchTopicsUseCase _fetchTopics;

  Future<void> load(LearningSkill skill) async {
    emit(state.copyWith(status: TopicsStatus.loading));
    final result = await _fetchTopics(skill);
    result.fold(
      (_) => emit(state.copyWith(status: TopicsStatus.failure)),
      (topics) =>
          emit(state.copyWith(status: TopicsStatus.success, topics: topics)),
    );
  }
}
