import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/bloc/app_bloc_observer.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/view/auth_page.dart';
import 'features/lessons/data/datasources/lessons_local_data_source.dart';
import 'features/lessons/data/repositories/lessons_repository_impl.dart';
import 'features/lessons/domain/repositories/lessons_repository.dart';
import 'features/lessons/presentation/cubit/language_cubit.dart';
import 'features/progress/data/repositories/in_memory_progress_repository.dart';
import 'features/progress/domain/repositories/progress_repository.dart';
import 'features/reminders/data/repositories/in_memory_reminder_repository.dart';
import 'features/reminders/data/services/logging_reminder_scheduler.dart';
import 'features/reminders/domain/repositories/reminder_repository.dart';
import 'features/reminders/domain/services/reminder_scheduler.dart';
import 'features/settings/data/repositories/in_memory_locale_repository.dart';
import 'features/settings/domain/entities/app_language.dart';
import 'features/settings/domain/repositories/locale_repository.dart';
import 'features/settings/presentation/cubit/locale_cubit.dart';
import 'l10n/generated/app_localizations.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(const StudyLingoApp());
}

class StudyLingoApp extends StatelessWidget {
  const StudyLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Shared, app-wide repositories. A single ProgressRepository instance is
    // what keeps the quiz flow and the Progress tab in sync. Swap these
    // concrete implementations (in-memory / stub) for real ones in one place.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LessonsRepository>(
          create: (_) =>
              const LessonsRepositoryImpl(InMemoryLessonsDataSource()),
        ),
        RepositoryProvider<ProgressRepository>(
          create: (_) => InMemoryProgressRepository(),
        ),
        RepositoryProvider<ReminderRepository>(
          create: (_) => InMemoryReminderRepository(),
        ),
        RepositoryProvider<ReminderScheduler>(
          create: (_) => const LoggingReminderScheduler(),
        ),
        RepositoryProvider<LocaleRepository>(
          create: (_) => InMemoryLocaleRepository(),
        ),
      ],
      // App-wide Blocs. LocaleCubit drives MaterialApp.locale (the display
      // language picked in Settings re-localizes the whole UI). LanguageCubit
      // is the *learning-session* language: it lives at the root (not just the
      // lessons tab) so other features — e.g. the vocabulary deck filter —
      // react to the same session.
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LocaleCubit(context.read<LocaleRepository>())..load(),
          ),
          BlocProvider(create: (_) => LanguageCubit()),
        ],
        child: BlocBuilder<LocaleCubit, AppLanguage>(
          builder: (context, language) => MaterialApp(
            title: 'StudyLingo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: ThemeMode.system,
            locale: Locale(language.code),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AuthPage(),
          ),
        ),
      ),
    );
  }
}
