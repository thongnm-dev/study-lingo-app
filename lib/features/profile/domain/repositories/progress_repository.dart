import '../entities/daily_progress.dart';

/// Tracks day-by-day study activity. Reactive: [watch] emits the current
/// snapshot immediately and again after every [recordLessonCompleted], so the
/// profile stats update live when a quiz finishes elsewhere in the app.
///
/// A single instance must be shared app-wide (registered as a singleton in
/// GetIt) — that shared instance is what lets the quiz flow (writer) and the
/// profile stats (reader) stay in sync.
abstract class ProgressRepository {
  /// Target number of lessons per day the streak/goal UI measures against.
  int get dailyGoal;

  Stream<List<DailyProgress>> watch();

  Future<void> recordLessonCompleted({required int xpEarned});
}
