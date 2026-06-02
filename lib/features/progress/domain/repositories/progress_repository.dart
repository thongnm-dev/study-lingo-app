import '../entities/daily_progress.dart';

/// Tracks day-by-day study activity. Reactive: [watch] emits the current
/// snapshot immediately and again after every [recordLessonCompleted], so the
/// progress screen updates live when a quiz finishes elsewhere in the app.
///
/// A single instance must be shared app-wide (provided at the app root) — that
/// shared instance is what lets the quiz flow and the progress tab stay in sync.
abstract class ProgressRepository {
  /// Target number of lessons per day the streak/goal UI measures against.
  int get dailyGoal;

  Stream<List<DailyProgress>> watch();

  Future<void> recordLessonCompleted({required int xpEarned});
}
