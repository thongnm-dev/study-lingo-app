import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/learning_language.dart';
import '../../domain/entities/study_topic.dart';
import '../../domain/usecases/fetch_study_topics.dart';

enum StudyTopicsStatus { initial, loading, success, failure }

class StudyTopicsState extends Equatable {
  const StudyTopicsState({
    this.status = StudyTopicsStatus.initial,
    this.language,
    this.topics = const [],
  });

  final StudyTopicsStatus status;
  final LearningLanguage? language;
  final List<StudyTopic> topics;

  StudyTopicsState copyWith({
    StudyTopicsStatus? status,
    LearningLanguage? language,
    List<StudyTopic>? topics,
  }) {
    return StudyTopicsState(
      status: status ?? this.status,
      language: language ?? this.language,
      topics: topics ?? this.topics,
    );
  }

  @override
  List<Object?> get props => [status, language, topics];
}

class StudyTopicsCubit extends Cubit<StudyTopicsState> {
  StudyTopicsCubit(this._fetchTopics) : super(const StudyTopicsState());

  final FetchStudyTopicsUseCase _fetchTopics;

  Future<void> load(LearningLanguage language) async {
    emit(
      state.copyWith(
        status: StudyTopicsStatus.loading,
        language: language,
        topics: const [],
      ),
    );
    final result = await _fetchTopics(language);
    result.fold(
      (_) => emit(state.copyWith(status: StudyTopicsStatus.failure)),
      (topics) => emit(
        state.copyWith(status: StudyTopicsStatus.success, topics: topics),
      ),
    );
  }
}
