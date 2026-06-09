import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/english_lesson.dart';
import '../../domain/usecases/fetch_english_lessons.dart';

enum EnglishLessonsStatus { loading, success, failure }

class EnglishLessonsState extends Equatable {
  const EnglishLessonsState({
    this.status = EnglishLessonsStatus.loading,
    this.lessons = const [],
  });

  final EnglishLessonsStatus status;
  final List<EnglishLesson> lessons;

  EnglishLessonsState copyWith({
    EnglishLessonsStatus? status,
    List<EnglishLesson>? lessons,
  }) {
    return EnglishLessonsState(
      status: status ?? this.status,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  List<Object?> get props => [status, lessons];
}

class EnglishLessonsCubit extends Cubit<EnglishLessonsState> {
  EnglishLessonsCubit(this._fetchLessons) : super(const EnglishLessonsState());

  final FetchEnglishLessonsUseCase _fetchLessons;

  Future<void> load(String topicId) async {
    emit(state.copyWith(status: EnglishLessonsStatus.loading));
    final result = await _fetchLessons(topicId);
    result.fold(
      (_) => emit(state.copyWith(status: EnglishLessonsStatus.failure)),
      (lessons) => emit(
        state.copyWith(status: EnglishLessonsStatus.success, lessons: lessons),
      ),
    );
  }
}
