import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/learning_skill.dart';
import '../../domain/entities/topic.dart';
import '../../domain/repositories/lessons_repository.dart';

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

/// Loads the list of topics. Simple, single-trigger state → Cubit (see the
/// quiz, which is event-driven → Bloc).
class TopicsCubit extends Cubit<TopicsState> {
  TopicsCubit(this._repository) : super(const TopicsState());

  final LessonsRepository _repository;

  Future<void> load(LearningSkill skill) async {
    emit(state.copyWith(status: TopicsStatus.loading));
    try {
      final topics = await _repository.fetchTopics(skill);
      emit(state.copyWith(status: TopicsStatus.success, topics: topics));
    } catch (_) {
      emit(state.copyWith(status: TopicsStatus.failure));
    }
  }
}
