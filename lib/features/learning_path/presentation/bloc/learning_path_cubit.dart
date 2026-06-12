import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/learning_language.dart';
import '../../domain/entities/course_unit.dart';
import '../../domain/usecases/fetch_learning_path.dart';

enum LearningPathStatus { initial, loading, loaded, error }

class LearningPathState extends Equatable {
  final LearningPathStatus status;
  final List<CourseUnit> units;
  final String? errorMessage;

  const LearningPathState({
    this.status = LearningPathStatus.initial,
    this.units = const [],
    this.errorMessage,
  });

  LearningPathState copyWith({
    LearningPathStatus? status,
    List<CourseUnit>? units,
    String? errorMessage,
  }) {
    return LearningPathState(
      status: status ?? this.status,
      units: units ?? this.units,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  CourseUnit? get currentUnit {
    for (final unit in units) {
      for (final node in unit.nodes) {
        if (node.isCurrent) return unit;
      }
    }
    return units.isNotEmpty ? units.last : null;
  }

  @override
  List<Object?> get props => [status, units, errorMessage];
}

class LearningPathCubit extends Cubit<LearningPathState> {
  final FetchLearningPathUseCase _fetchLearningPath;

  LearningPathCubit(this._fetchLearningPath)
      : super(const LearningPathState());

  Future<void> load(LearningLanguage language) async {
    emit(state.copyWith(status: LearningPathStatus.loading));
    final result = await _fetchLearningPath(language);
    result.fold(
      (failure) => emit(state.copyWith(
        status: LearningPathStatus.error,
        errorMessage: failure.message,
      )),
      (units) => emit(state.copyWith(
        status: LearningPathStatus.loaded,
        units: units,
      )),
    );
  }
}
