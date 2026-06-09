import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/constants/learning_skill.dart';
import '../../domain/entities/english_topic.dart';
import '../../domain/usecases/fetch_english_topics.dart';

enum EnglishTopicsStatus { loading, success, failure }

class EnglishTopicsState extends Equatable {
  const EnglishTopicsState({
    this.status = EnglishTopicsStatus.loading,
    this.topics = const [],
  });

  final EnglishTopicsStatus status;
  final List<EnglishTopic> topics;

  EnglishTopicsState copyWith({
    EnglishTopicsStatus? status,
    List<EnglishTopic>? topics,
  }) {
    return EnglishTopicsState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
    );
  }

  @override
  List<Object?> get props => [status, topics];
}

class EnglishTopicsCubit extends Cubit<EnglishTopicsState> {
  EnglishTopicsCubit(this._fetchTopics) : super(const EnglishTopicsState());

  final FetchEnglishTopicsUseCase _fetchTopics;

  Future<void> load(LearningSkill skill) async {
    emit(state.copyWith(status: EnglishTopicsStatus.loading));
    final result = await _fetchTopics(skill);
    result.fold(
      (_) => emit(state.copyWith(status: EnglishTopicsStatus.failure)),
      (topics) => emit(
        state.copyWith(status: EnglishTopicsStatus.success, topics: topics),
      ),
    );
  }
}
