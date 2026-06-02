import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/reminder_repository.dart';
import '../../domain/services/reminder_scheduler.dart';
import '../cubit/reminders_cubit.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RemindersCubit(
        context.read<ReminderRepository>(),
        context.read<ReminderScheduler>(),
      )..load(),
      child: const _RemindersView(),
    );
  }
}

class _RemindersView extends StatelessWidget {
  const _RemindersView();

  static const _weekdayLabels = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study reminders')),
      body: BlocBuilder<RemindersCubit, RemindersState>(
        builder: (context, state) {
          if (!state.loaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final cubit = context.read<RemindersCubit>();
          final settings = state.settings;
          final time = TimeOfDay(hour: settings.hour, minute: settings.minute);
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Daily study reminder'),
                subtitle: const Text('Get a nudge to keep your streak'),
                value: settings.enabled,
                onChanged: cubit.setEnabled,
              ),
              ListTile(
                enabled: settings.enabled,
                leading: const Icon(Icons.schedule),
                title: const Text('Reminder time'),
                trailing: Text(
                  time.format(context),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (picked != null) {
                    await cubit.setTime(picked.hour, picked.minute);
                  }
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Repeat on',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (final entry in _weekdayLabels.entries)
                      FilterChip(
                        label: Text(entry.value),
                        selected: settings.weekdays.contains(entry.key),
                        onSelected: settings.enabled
                            ? (_) => cubit.toggleWeekday(entry.key)
                            : null,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
