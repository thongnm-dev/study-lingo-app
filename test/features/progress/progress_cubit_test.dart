import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/progress/data/repositories/in_memory_progress_repository.dart';
import 'package:study_lingo/features/progress/domain/usecases/watch_progress.dart';
import 'package:study_lingo/features/progress/presentation/bloc/progress_cubit.dart';

void main() {
  group('ProgressCubit', () {
    blocTest<ProgressCubit, ProgressState>(
      'emits a loaded state with a 7-day window from the repository',
      build: () {
        final repo = InMemoryProgressRepository();
        return ProgressCubit(
          watchProgress: WatchProgressUseCase(repo),
          dailyGoal: repo.dailyGoal,
        );
      },
      wait: const Duration(milliseconds: 10),
      verify: (cubit) {
        expect(cubit.state.loaded, isTrue);
        expect(cubit.state.week.length, 7);
      },
    );
  });

  test(
    'recordLessonCompleted updates today and streak through the stream',
    () async {
      final repo = InMemoryProgressRepository();
      final cubit = ProgressCubit(
        watchProgress: WatchProgressUseCase(repo),
        dailyGoal: repo.dailyGoal,
      );
      // Let the initial snapshot arrive. Seed has 3 consecutive active days
      // ending yesterday, but today starts inactive, so the streak breaks at 0.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(cubit.state.streak, 0);

      await repo.recordLessonCompleted(xpEarned: 30);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(cubit.state.todayLessons, 1);
      expect(cubit.state.todayXp, 30);
      // Today now connects to the 3 seeded days → streak of 4.
      expect(cubit.state.streak, 4);

      await cubit.close();
      repo.dispose();
    },
  );
}
