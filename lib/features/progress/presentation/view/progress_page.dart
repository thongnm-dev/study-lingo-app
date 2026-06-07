import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/icons/app_icons.dart';
import '../../domain/entities/daily_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../cubit/progress_cubit.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgressCubit(context.read<ProgressRepository>()),
      child: const _ProgressView(),
    );
  }
}

class _ProgressView extends StatelessWidget {
  const _ProgressView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tiến độ')),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          if (!state.loaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StreakCard(streak: state.streak),
              const SizedBox(height: 16),
              _DailyGoalCard(state: state),
              const SizedBox(height: 16),
              Text('Tuần này', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _WeeklyChart(week: state.week),
            ],
          );
        },
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              AppIcons.fire,
              size: 40,
              color: Colors.orange,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$streak ngày', style: theme.textTheme.headlineMedium),
                Text(
                  'Chuỗi ngày hiện tại',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({required this.state});

  final ProgressState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              height: 56,
              width: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: state.goalProgress,
                    strokeWidth: 6,
                  ),
                  if (state.goalMet)
                    Icon(AppIcons.check, color: theme.colorScheme.primary),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mục tiêu hôm nay', style: theme.textTheme.titleMedium),
                  Text(
                    '${state.todayLessons} / ${state.dailyGoal} bài  ·  ${state.todayXp} XP',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.week});

  final List<DailyProgress> week;

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxLessons = week
        .map((d) => d.lessonsCompleted)
        .fold<int>(1, (m, v) => v > m ? v : m);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final day in week)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${day.lessonsCompleted}',
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      _Bar(fraction: day.lessonsCompleted / maxLessons),
                      const SizedBox(height: 6),
                      Text(
                        _weekdayLabels[day.date.weekday - 1],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 18,
      height: (80 * fraction).clamp(4, 80).toDouble(),
      decoration: BoxDecoration(
        color: fraction == 0
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
