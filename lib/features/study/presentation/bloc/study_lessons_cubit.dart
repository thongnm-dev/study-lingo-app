import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/study_lesson.dart';
import '../../domain/usecases/fetch_study_lessons.dart';

enum StudyLessonsStatus { loading, success, failure }

class StudyLessonsState extends Equatable {
  const StudyLessonsState({
    this.status = StudyLessonsStatus.loading,
    this.lessons = const [],
  });

  final StudyLessonsStatus status;
  final List<StudyLesson> lessons;

  StudyLessonsState copyWith({
    StudyLessonsStatus? status,
    List<StudyLesson>? lessons,
  }) {
    return StudyLessonsState(
      status: status ?? this.status,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  List<Object?> get props => [status, lessons];
}

class StudyLessonsCubit extends Cubit<StudyLessonsState> {
  StudyLessonsCubit(this._fetchLessons) : super(const StudyLessonsState());

  final FetchStudyLessonsUseCase _fetchLessons;

  Future<void> load(String topicId) async {
    emit(state.copyWith(status: StudyLessonsStatus.loading));
    final result = await _fetchLessons(topicId);
    result.fold(
      (_) => emit(state.copyWith(status: StudyLessonsStatus.failure)),
      (lessons) => emit(
        state.copyWith(status: StudyLessonsStatus.success, lessons: lessons),
      ),
    );
  }
}
