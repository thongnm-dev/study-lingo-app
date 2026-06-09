import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/japanese_lesson.dart';
import '../../domain/usecases/fetch_japanese_lessons.dart';

enum JapaneseLessonsStatus { loading, success, failure }

class JapaneseLessonsState extends Equatable {
  const JapaneseLessonsState({
    this.status = JapaneseLessonsStatus.loading,
    this.lessons = const [],
  });

  final JapaneseLessonsStatus status;
  final List<JapaneseLesson> lessons;

  JapaneseLessonsState copyWith({
    JapaneseLessonsStatus? status,
    List<JapaneseLesson>? lessons,
  }) {
    return JapaneseLessonsState(
      status: status ?? this.status,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  List<Object?> get props => [status, lessons];
}

class JapaneseLessonsCubit extends Cubit<JapaneseLessonsState> {
  JapaneseLessonsCubit(this._fetchLessons)
    : super(const JapaneseLessonsState());

  final FetchJapaneseLessonsUseCase _fetchLessons;

  Future<void> load(String topicId) async {
    emit(state.copyWith(status: JapaneseLessonsStatus.loading));
    final result = await _fetchLessons(topicId);
    result.fold(
      (_) => emit(state.copyWith(status: JapaneseLessonsStatus.failure)),
      (lessons) => emit(
        state.copyWith(status: JapaneseLessonsStatus.success, lessons: lessons),
      ),
    );
  }
}
