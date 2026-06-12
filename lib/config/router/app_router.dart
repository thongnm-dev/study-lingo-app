import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/main_shell.dart';
import '../../core/constants/learning_language.dart';
import '../../core/constants/learning_skill.dart';
import '../../core/session/current_user.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/english/lessons/domain/entities/english_topic.dart';
import '../../features/english/lessons/presentation/pages/english_lessons_page.dart';
import '../../features/english/lessons/presentation/pages/english_topics_page.dart';
import '../../features/home/presentation/pages/overview_page.dart';
import '../../features/home/presentation/pages/practice_page.dart';
import '../../features/learning_path/presentation/bloc/learning_path_cubit.dart';
import '../../features/learning_path/presentation/pages/learning_path_page.dart';
import '../../features/japanese/lessons/domain/entities/japanese_topic.dart';
import '../../features/japanese/lessons/presentation/pages/japanese_lessons_page.dart';
import '../../features/japanese/lessons/presentation/pages/japanese_topics_page.dart';
import '../../features/japanese/writing/domain/entities/japanese_script.dart';
import '../../features/japanese/writing/domain/entities/kanji.dart';
import '../../features/japanese/writing/domain/entities/writing_character.dart';
import '../../features/japanese/writing/presentation/pages/character_tracing_page.dart';
import '../../features/japanese/writing/presentation/pages/kanji_detail_page.dart';
import '../../features/japanese/writing/presentation/pages/kanji_list_page.dart';
import '../../features/japanese/writing/presentation/pages/writing_home_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/quiz/domain/entities/quiz_question.dart';
import '../../features/quiz/presentation/bloc/quiz_bloc.dart';
import '../../features/quiz/presentation/pages/quiz_page.dart';
import '../../features/reminders/presentation/pages/reminders_page.dart';
import '../../features/settings/presentation/pages/language_settings_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/settings_placeholder_page.dart';
import '../../features/study/domain/entities/study_topic.dart';
import '../../features/study/presentation/pages/study_lessons_page.dart';
import '../../features/study/presentation/pages/study_page.dart';
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

/// Type-safe payload for the EnglishTopicsPage route.
class EnglishTopicsPageArgs {
  const EnglishTopicsPageArgs({required this.skill});
  final LearningSkill skill;
}

/// Type-safe payload for the EnglishLessonsPage route.
class EnglishLessonsPageArgs {
  const EnglishLessonsPageArgs({required this.topic});
  final EnglishTopic topic;
}

/// Type-safe payload for the JapaneseTopicsPage route.
class JapaneseTopicsPageArgs {
  const JapaneseTopicsPageArgs({required this.skill});
  final LearningSkill skill;
}

/// Type-safe payload for the JapaneseLessonsPage route.
class JapaneseLessonsPageArgs {
  const JapaneseLessonsPageArgs({required this.topic});
  final JapaneseTopic topic;
}

/// Type-safe payload for the StudyLessonsPage route (themed Study tab).
class StudyLessonsPageArgs {
  const StudyLessonsPageArgs({required this.topic});
  final StudyTopic topic;
}

/// Type-safe payload for the LearningPathPage route.
class LearningPathPageArgs {
  const LearningPathPageArgs({required this.language});
  final LearningLanguage language;
}

/// Type-safe payload for the QuizPage route. The questions are wired into the
/// scoped QuizBloc; the title is shown in the app bar.
class QuizPageArgs {
  const QuizPageArgs({required this.questions, required this.lessonTitle});
  final List<QuizQuestion> questions;
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
        state.matchedLocation == RouteNames.register ||
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
      builder: (_, _) => const LoginPage(),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (_, _) => const RegisterPage(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (_, _) => const ForgotPasswordPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
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
              path: RouteNames.study,
              builder: (_, _) => const StudyPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.chat,
              builder: (_, _) => const ChatPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.profile,
              builder: (_, _) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.englishTopics,
      builder: (_, state) {
        final args = state.extra! as EnglishTopicsPageArgs;
        return EnglishTopicsPage(skill: args.skill);
      },
    ),
    GoRoute(
      path: RouteNames.englishLessons,
      builder: (_, state) {
        final args = state.extra! as EnglishLessonsPageArgs;
        return EnglishLessonsPage(topic: args.topic);
      },
    ),
    GoRoute(
      path: RouteNames.japaneseTopics,
      builder: (_, state) {
        final args = state.extra! as JapaneseTopicsPageArgs;
        return JapaneseTopicsPage(skill: args.skill);
      },
    ),
    GoRoute(
      path: RouteNames.japaneseLessons,
      builder: (_, state) {
        final args = state.extra! as JapaneseLessonsPageArgs;
        return JapaneseLessonsPage(topic: args.topic);
      },
    ),
    GoRoute(
      path: RouteNames.studyLessons,
      builder: (_, state) {
        final args = state.extra! as StudyLessonsPageArgs;
        return StudyLessonsPage(topic: args.topic);
      },
    ),
    GoRoute(
      path: RouteNames.learningPath,
      builder: (_, state) {
        final args = state.extra! as LearningPathPageArgs;
        return BlocProvider(
          create: (_) => getIt<LearningPathCubit>(),
          child: LearningPathPage(language: args.language),
        );
      },
    ),
    GoRoute(
      path: RouteNames.quiz,
      builder: (_, state) {
        final args = state.extra! as QuizPageArgs;
        return BlocProvider(
          create: (_) => getIt<QuizBloc>(param1: args.questions),
          child: QuizPage(lessonTitle: args.lessonTitle),
        );
      },
    ),
    GoRoute(
      path: RouteNames.practice,
      builder: (_, _) => const PracticePage(),
    ),
    GoRoute(
      path: RouteNames.editProfile,
      builder: (_, _) => const EditProfilePage(),
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
      path: RouteNames.japaneseWritingHome,
      builder: (_, _) => const WritingHomePage(),
    ),
    GoRoute(
      path: RouteNames.japaneseTracing,
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
      path: RouteNames.japaneseKanjiList,
      builder: (_, _) => const KanjiListPage(),
    ),
    GoRoute(
      path: RouteNames.japaneseKanjiDetail,
      builder: (_, state) {
        final kanji = state.extra! as Kanji;
        return KanjiDetailPage(kanji: kanji);
      },
    ),
  ],
);
