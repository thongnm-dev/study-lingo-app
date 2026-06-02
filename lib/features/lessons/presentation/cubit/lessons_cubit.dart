import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/learning_language.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lessons_repository.dart';

enum LessonsStatus { loading, success, failure }

class LessonsState extends Equatable {
  const LessonsState({
    this.status = LessonsStatus.loading,
    this.lessons = const [],
  });

  final LessonsStatus status;
  final List<Lesson> lessons;

  LessonsState copyWith({LessonsStatus? status, List<Lesson>? lessons}) {
    return LessonsState(
      status: status ?? this.status,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  List<Object?> get props => [status, lessons];
}

class LessonsCubit extends Cubit<LessonsState> {
  LessonsCubit(this._repository) : super(const LessonsState());

  final LessonsRepository _repository;

  Future<void> load(String topicId, LearningLanguage language) async {
    emit(state.copyWith(status: LessonsStatus.loading));
    try {
      final lessons = await _repository.fetchLessons(topicId, language);
      emit(state.copyWith(status: LessonsStatus.success, lessons: lessons));
    } catch (_) {
      emit(state.copyWith(status: LessonsStatus.failure));
    }
  }
}
