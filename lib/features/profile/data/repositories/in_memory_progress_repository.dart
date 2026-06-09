import 'dart:async';

import '../../domain/entities/daily_progress.dart';
import '../../domain/repositories/progress_repository.dart';

/// Non-persistent progress store. Survives only for the app session — swap for
/// a sqlite/shared_preferences-backed implementation to persist across launches
/// (the [ProgressRepository] contract stays identical).
class InMemoryProgressRepository implements ProgressRepository {
  InMemoryProgressRepository() {
    _seedRecentDays();
  }

  @override
  final int dailyGoal = 3;

  final _controller = StreamController<List<DailyProgress>>.broadcast();
  final Map<DateTime, DailyProgress> _byDay = {};

  static DateTime _dayOf(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Seed a short streak ending yesterday so the UI has something to show.
  void _seedRecentDays() {
    final today = _dayOf(DateTime.now());
    for (final entry in const [
      // daysAgo, lessons, xp
      [3, 4, 80],
      [2, 3, 60],
      [1, 5, 110],
    ]) {
      final day = today.subtract(Duration(days: entry[0]));
      _byDay[day] = DailyProgress(
        date: day,
        lessonsCompleted: entry[1],
        xpEarned: entry[2],
      );
    }
  }

  List<DailyProgress> _snapshot() {
    final list = _byDay.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(list);
  }

  @override
  Stream<List<DailyProgress>> watch() async* {
    yield _snapshot();
    yield* _controller.stream;
  }

  @override
  Future<void> recordLessonCompleted({required int xpEarned}) async {
    final today = _dayOf(DateTime.now());
    final current = _byDay[today] ?? DailyProgress.empty(today);
    _byDay[today] = current.copyWith(
      lessonsCompleted: current.lessonsCompleted + 1,
      xpEarned: current.xpEarned + xpEarned,
    );
    _controller.add(_snapshot());
  }

  void dispose() => _controller.close();
}
