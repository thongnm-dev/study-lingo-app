import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../progress/domain/entities/daily_progress.dart';
import '../../../progress/domain/repositories/progress_repository.dart';

class ProfileStats extends Equatable {
  const ProfileStats({
    this.loaded = false,
    this.streak = 0,
    this.totalXp = 0,
    this.lessonsCompleted = 0,
    this.activeDays = 0,
  });

  final bool loaded;
  final int streak;
  final int totalXp;
  final int lessonsCompleted;
  final int activeDays;

  @override
  List<Object?> get props => [
    loaded,
    streak,
    totalXp,
    lessonsCompleted,
    activeDays,
  ];
}

/// Lifetime study stats for the profile screen, derived from the shared
/// [ProgressRepository] stream so they stay in sync with quizzes/practice.
class ProfileStatsCubit extends Cubit<ProfileStats> {
  ProfileStatsCubit(this._repository) : super(const ProfileStats()) {
    _sub = _repository.watch().listen(_onData);
  }

  final ProgressRepository _repository;
  late final StreamSubscription<List<DailyProgress>> _sub;

  static DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

  void _onData(List<DailyProgress> entries) {
    final totalXp = entries.fold<int>(0, (sum, e) => sum + e.xpEarned);
    final lessons = entries.fold<int>(0, (sum, e) => sum + e.lessonsCompleted);
    final activeDays = entries.where((e) => e.isActive).length;

    // Streak: consecutive active days counting back from today (same rule as
    // ProgressCubit).
    final byDay = {for (final e in entries) _dayOf(e.date): e};
    final today = _dayOf(DateTime.now());
    var streak = 0;
    for (var i = 0; ; i++) {
      final entry = byDay[today.subtract(Duration(days: i))];
      if (entry != null && entry.isActive) {
        streak++;
      } else {
        break;
      }
    }

    emit(
      ProfileStats(
        loaded: true,
        streak: streak,
        totalXp: totalXp,
        lessonsCompleted: lessons,
        activeDays: activeDays,
      ),
    );
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
