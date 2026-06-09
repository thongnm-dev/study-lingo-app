import 'package:equatable/equatable.dart';

/// One day's study tally. [date] is normalized to local midnight so entries can
/// be compared by day.
class DailyProgress extends Equatable {
  const DailyProgress({
    required this.date,
    required this.lessonsCompleted,
    required this.xpEarned,
  });

  factory DailyProgress.empty(DateTime date) =>
      DailyProgress(date: date, lessonsCompleted: 0, xpEarned: 0);

  final DateTime date;
  final int lessonsCompleted;
  final int xpEarned;

  bool get isActive => lessonsCompleted > 0;

  DailyProgress copyWith({int? lessonsCompleted, int? xpEarned}) {
    return DailyProgress(
      date: date,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      xpEarned: xpEarned ?? this.xpEarned,
    );
  }

  @override
  List<Object?> get props => [date, lessonsCompleted, xpEarned];
}
