import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/profile/presentation/bloc/profile_stats_cubit.dart';
import 'package:study_lingo/features/progress/data/repositories/in_memory_progress_repository.dart';
import 'package:study_lingo/features/progress/domain/usecases/watch_progress.dart';

void main() {
  group('ProfileStatsCubit', () {
    test('derives lifetime totals from the seeded progress', () async {
      final repo = InMemoryProgressRepository();
      final cubit = ProfileStatsCubit(WatchProgressUseCase(repo));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Seed: 3 active days (4+3+5 lessons, 80+60+110 XP).
      expect(cubit.state.loaded, isTrue);
      expect(cubit.state.lessonsCompleted, 12);
      expect(cubit.state.totalXp, 250);
      expect(cubit.state.activeDays, 3);

      await cubit.close();
      repo.dispose();
    });

    test('recording a lesson updates the totals through the stream', () async {
      final repo = InMemoryProgressRepository();
      final cubit = ProfileStatsCubit(WatchProgressUseCase(repo));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await repo.recordLessonCompleted(xpEarned: 50);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(cubit.state.lessonsCompleted, 13);
      expect(cubit.state.totalXp, 300);
      // Today became active → 4 active days and a 4-day streak.
      expect(cubit.state.activeDays, 4);
      expect(cubit.state.streak, 4);

      await cubit.close();
      repo.dispose();
    });
  });
}
