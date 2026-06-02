import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/daily_progress.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressState extends Equatable {
  const ProgressState({
    this.loaded = false,
    this.week = const [],
    this.streak = 0,
    this.todayLessons = 0,
    this.todayXp = 0,
    this.dailyGoal = 1,
  });

  final bool loaded;

  /// Exactly 7 entries, oldest first, ending today (gaps filled with zeros).
  final List<DailyProgress> week;
  final int streak;
  final int todayLessons;
  final int todayXp;
  final int dailyGoal;

  bool get goalMet => todayLessons >= dailyGoal;
  double get goalProgress =>
      dailyGoal == 0 ? 1 : (todayLessons / dailyGoal).clamp(0, 1).toDouble();

  ProgressState copyWith({
    bool? loaded,
    List<DailyProgress>? week,
    int? streak,
    int? todayLessons,
    int? todayXp,
    int? dailyGoal,
  }) {
    return ProgressState(
      loaded: loaded ?? this.loaded,
      week: week ?? this.week,
      streak: streak ?? this.streak,
      todayLessons: todayLessons ?? this.todayLessons,
      todayXp: todayXp ?? this.todayXp,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }

  @override
  List<Object?> get props => [
    loaded,
    week,
    streak,
    todayLessons,
    todayXp,
    dailyGoal,
  ];
}

/// Subscribes to the shared [ProgressRepository] stream and derives the streak,
/// today's tally, and a fixed 7-day window for the chart.
class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._repository) : super(const ProgressState()) {
    _sub = _repository.watch().listen(_onData);
  }

  final ProgressRepository _repository;
  late final StreamSubscription<List<DailyProgress>> _sub;

  static DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

  void _onData(List<DailyProgress> entries) {
    final today = _dayOf(DateTime.now());
    final byDay = {for (final e in entries) _dayOf(e.date): e};

    // Build a 7-day window ending today, filling missing days with zeros.
    final week = List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      return byDay[day] ?? DailyProgress.empty(day);
    });

    // Streak: consecutive active days counting back from today.
    var streak = 0;
    for (var i = 0; ; i++) {
      final day = today.subtract(Duration(days: i));
      final entry = byDay[day];
      if (entry != null && entry.isActive) {
        streak++;
      } else {
        break;
      }
    }

    final todayEntry = byDay[today] ?? DailyProgress.empty(today);
    emit(
      state.copyWith(
        loaded: true,
        week: week,
        streak: streak,
        todayLessons: todayEntry.lessonsCompleted,
        todayXp: todayEntry.xpEarned,
        dailyGoal: _repository.dailyGoal,
      ),
    );
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
