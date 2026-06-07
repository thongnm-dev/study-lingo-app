import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/main_shell.dart';
import '../../core/session/current_user.dart';
import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/kanji/domain/entities/kanji.dart';
import '../../features/kanji/presentation/pages/kanji_detail_page.dart';
import '../../features/kanji/presentation/pages/kanji_list_page.dart';
import '../../features/lessons/domain/entities/learning_language.dart';
import '../../features/lessons/domain/entities/learning_skill.dart';
import '../../features/lessons/domain/entities/lesson.dart';
import '../../features/lessons/domain/entities/topic.dart';
import '../../features/lessons/presentation/bloc/quiz_bloc.dart';
import '../../features/lessons/presentation/pages/lessons_page.dart';
import '../../features/lessons/presentation/pages/overview_page.dart';
import '../../features/lessons/presentation/pages/practice_page.dart';
import '../../features/lessons/presentation/pages/quiz_page.dart';
import '../../features/lessons/presentation/pages/topics_page.dart';
import '../../features/more/presentation/model/more_menu_entry.dart';
import '../../features/more/presentation/pages/more_destination_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/reminders/presentation/pages/reminders_page.dart';
import '../../features/settings/presentation/pages/language_settings_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/settings_placeholder_page.dart';
import '../../features/vocabulary/presentation/pages/vocabulary_page.dart';
import '../../features/writing/domain/entities/japanese_script.dart';
import '../../features/writing/domain/entities/writing_character.dart';
import '../../features/writing/presentation/pages/character_tracing_page.dart';
import '../../features/writing/presentation/pages/writing_home_page.dart';
import '../di/service_locator.dart';
import 'route_names.dart';

/// Type-safe payload for the SettingsPlaceholderPage route's `extra`.
class SettingsPlaceholderArgs {
  const SettingsPlaceholderArgs({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

/// Type-safe payload for the CharacterTracingPage route's `extra`. Either
/// [script] or [characters] must be non-null (the page asserts that).
class CharacterTracingArgs {
  const CharacterTracingArgs({this.script, this.characters, this.title});
  final JapaneseScript? script;
  final List<WritingCharacter>? characters;
  final String? title;
}

/// Type-safe payload for the LessonsPage route.
class LessonsPageArgs {
  const LessonsPageArgs({required this.topic, required this.language});
  final Topic topic;
  final LearningLanguage language;
}

/// Type-safe payload for the TopicsPage route.
class TopicsPageArgs {
  const TopicsPageArgs({required this.language, required this.skill});
  final LearningLanguage language;
  final LearningSkill skill;
}

/// Type-safe payload for the QuizPage route. The lesson is wired into the
/// scoped QuizBloc; the title is shown in the app bar.
class QuizPageArgs {
  const QuizPageArgs({required this.lesson, required this.lessonTitle});
  final Lesson lesson;
  final String lessonTitle;
}

/// App-wide router. Auth gate via `redirect`: routes under `/home/*` (and the
/// page-stack pushed on top of the shell) require a signed-in user; otherwise
/// the user is bounced back to `/auth`.
final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.auth,
  redirect: (context, state) {
    final isSignedIn = getIt<CurrentUser>().value != null;
    final goingToAuth =
        state.matchedLocation == RouteNames.auth ||
        state.matchedLocation == RouteNames.forgotPassword;
    if (!isSignedIn && !goingToAuth) return RouteNames.auth;
    if (isSignedIn && state.matchedLocation == RouteNames.auth) {
      return RouteNames.overview;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: RouteNames.auth,
      builder: (_, _) => const AuthPage(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (_, _) => const ForgotPasswordPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainShell(
        navigationShell: navigationShell,
        user: getIt<CurrentUser>().value!,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.overview,
              builder: (_, _) => const OverviewPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.progress,
              builder: (_, _) => const ProgressPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.vocabulary,
              builder: (_, _) => const VocabularyPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.topics,
      builder: (_, state) {
        final args = state.extra! as TopicsPageArgs;
        return TopicsPage(language: args.language, skill: args.skill);
      },
    ),
    GoRoute(
      path: RouteNames.lessons,
      builder: (_, state) {
        final args = state.extra! as LessonsPageArgs;
        return LessonsPage(topic: args.topic, language: args.language);
      },
    ),
    GoRoute(
      path: RouteNames.quiz,
      builder: (_, state) {
        final args = state.extra! as QuizPageArgs;
        return BlocProvider(
          create: (_) => getIt<QuizBloc>(param1: args.lesson),
          child: QuizPage(lessonTitle: args.lessonTitle),
        );
      },
    ),
    GoRoute(
      path: RouteNames.practice,
      builder: (_, _) => const PracticePage(),
    ),
    GoRoute(
      path: RouteNames.profile,
      builder: (_, state) {
        final user = (state.extra ?? getIt<CurrentUser>().value!) as AuthUser;
        return ProfilePage(user: user);
      },
    ),
    GoRoute(
      path: RouteNames.settings,
      builder: (_, _) => const SettingsPage(),
    ),
    GoRoute(
      path: RouteNames.languageSettings,
      builder: (_, _) => const LanguageSettingsPage(),
    ),
    GoRoute(
      path: RouteNames.settingsPlaceholder,
      builder: (_, state) {
        final args = state.extra! as SettingsPlaceholderArgs;
        return SettingsPlaceholderPage(title: args.title, icon: args.icon);
      },
    ),
    GoRoute(
      path: RouteNames.reminders,
      builder: (_, _) => const RemindersPage(),
    ),
    GoRoute(
      path: RouteNames.writingHome,
      builder: (_, _) => const WritingHomePage(),
    ),
    GoRoute(
      path: RouteNames.characterTracing,
      builder: (_, state) {
        final args = state.extra! as CharacterTracingArgs;
        return CharacterTracingPage(
          script: args.script,
          characters: args.characters,
          title: args.title,
        );
      },
    ),
    GoRoute(
      path: RouteNames.kanjiList,
      builder: (_, _) => const KanjiListPage(),
    ),
    GoRoute(
      path: RouteNames.kanjiDetail,
      builder: (_, state) {
        final kanji = state.extra! as Kanji;
        return KanjiDetailPage(kanji: kanji);
      },
    ),
    GoRoute(
      path: RouteNames.moreDestination,
      builder: (_, state) {
        final entry = state.extra! as MoreMenuEntry;
        return MoreDestinationPage(entry: entry);
      },
    ),
  ],
);
