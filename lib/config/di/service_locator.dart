import 'package:get_it/get_it.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/dio_client.dart';
import '../../core/session/current_user.dart';
import '../../core/session/language_cubit.dart';
import '../../features/auth/data/repositories/fake_auth_repository.dart';
import '../../features/auth/data/repositories/fake_password_reset_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/password_reset_repository.dart';
import '../../features/auth/domain/usecases/request_otp.dart';
import '../../features/auth/domain/usecases/reset_password.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_in_with_facebook.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/domain/usecases/sign_up_with_email.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/forgot_password_bloc.dart';
import '../../features/english/lessons/data/datasources/english_lessons_local_data_source.dart';
import '../../features/english/lessons/data/repositories/english_lessons_repository_impl.dart';
import '../../features/english/lessons/domain/repositories/english_lessons_repository.dart';
import '../../features/english/lessons/domain/usecases/fetch_english_lessons.dart';
import '../../features/english/lessons/domain/usecases/fetch_english_practice_lesson.dart';
import '../../features/english/lessons/domain/usecases/fetch_english_topics.dart';
import '../../features/english/lessons/presentation/bloc/english_lessons_cubit.dart';
import '../../features/english/lessons/presentation/bloc/english_topics_cubit.dart';
import '../../features/english/vocabulary/data/datasources/english_vocabulary_local_data_source.dart';
import '../../features/english/vocabulary/data/repositories/english_vocabulary_repository_impl.dart';
import '../../features/english/vocabulary/domain/repositories/english_vocabulary_repository.dart';
import '../../features/english/vocabulary/domain/usecases/fetch_english_vocabulary_words.dart';
import '../../features/english/vocabulary/presentation/bloc/english_vocabulary_bloc.dart';
import '../../features/japanese/lessons/data/datasources/japanese_lessons_local_data_source.dart';
import '../../features/japanese/lessons/data/repositories/japanese_lessons_repository_impl.dart';
import '../../features/japanese/lessons/domain/repositories/japanese_lessons_repository.dart';
import '../../features/japanese/lessons/domain/usecases/fetch_japanese_lessons.dart';
import '../../features/japanese/lessons/domain/usecases/fetch_japanese_practice_lesson.dart';
import '../../features/japanese/lessons/domain/usecases/fetch_japanese_topics.dart';
import '../../features/japanese/lessons/presentation/bloc/japanese_lessons_cubit.dart';
import '../../features/japanese/lessons/presentation/bloc/japanese_topics_cubit.dart';
import '../../features/japanese/vocabulary/data/datasources/japanese_vocabulary_local_data_source.dart';
import '../../features/japanese/vocabulary/data/repositories/japanese_vocabulary_repository_impl.dart';
import '../../features/japanese/vocabulary/domain/repositories/japanese_vocabulary_repository.dart';
import '../../features/japanese/vocabulary/domain/usecases/fetch_japanese_vocabulary_words.dart';
import '../../features/japanese/vocabulary/presentation/bloc/japanese_vocabulary_bloc.dart';
import '../../features/japanese/writing/data/repositories/in_memory_kanji_repository.dart';
import '../../features/japanese/writing/data/repositories/in_memory_writing_repository.dart';
import '../../features/japanese/writing/domain/repositories/kanji_repository.dart';
import '../../features/japanese/writing/domain/repositories/writing_repository.dart';
import '../../features/japanese/writing/domain/usecases/fetch_kanji_list.dart';
import '../../features/japanese/writing/domain/usecases/fetch_writing_characters.dart';
import '../../features/japanese/writing/presentation/bloc/kanji_list_cubit.dart';
import '../../features/japanese/writing/presentation/bloc/writing_practice_cubit.dart';
import '../../features/profile/presentation/bloc/edit_profile_cubit.dart';
import '../../features/profile/presentation/bloc/profile_stats_cubit.dart';
import '../../features/progress/data/repositories/in_memory_progress_repository.dart';
import '../../features/progress/domain/repositories/progress_repository.dart';
import '../../features/progress/domain/usecases/record_lesson_completed.dart';
import '../../features/progress/domain/usecases/watch_progress.dart';
import '../../features/quiz/domain/entities/quiz_question.dart';
import '../../features/quiz/presentation/bloc/quiz_bloc.dart';
import '../../features/reminders/data/repositories/in_memory_reminder_repository.dart';
import '../../features/reminders/data/services/logging_reminder_scheduler.dart';
import '../../features/reminders/domain/repositories/reminder_repository.dart';
import '../../features/reminders/domain/services/reminder_scheduler.dart';
import '../../features/reminders/domain/usecases/load_reminder_settings.dart';
import '../../features/reminders/domain/usecases/save_reminder_settings.dart';
import '../../features/reminders/presentation/bloc/reminders_cubit.dart';
import '../../features/settings/data/repositories/in_memory_locale_repository.dart';
import '../../features/settings/data/repositories/in_memory_theme_repository.dart';
import '../../features/settings/domain/repositories/locale_repository.dart';
import '../../features/settings/domain/repositories/theme_repository.dart';
import '../../features/settings/domain/usecases/load_locale.dart';
import '../../features/settings/domain/usecases/load_theme.dart';
import '../../features/settings/domain/usecases/save_locale.dart';
import '../../features/settings/domain/usecases/save_theme.dart';
import '../../features/settings/presentation/bloc/locale_cubit.dart';
import '../../features/settings/presentation/bloc/theme_cubit.dart';
import '../../features/study/data/datasources/study_topics_local_data_source.dart';
import '../../features/study/data/repositories/study_topics_repository_impl.dart';
import '../../features/study/domain/repositories/study_topics_repository.dart';
import '../../features/study/domain/usecases/fetch_study_lessons.dart';
import '../../features/study/domain/usecases/fetch_study_topics.dart';
import '../../features/study/presentation/bloc/study_lessons_cubit.dart';
import '../../features/study/presentation/bloc/study_topics_cubit.dart';

final getIt = GetIt.instance;

/// Demo credentials prefilled on the login screen so the fake auth flow can
/// be smoke-tested with a single tap. Any password other than `'wrong'`
/// succeeds against [FakeAuthRepository]; remove these when swapping in a
/// real backend.
const String kDevLoginEmail = 'demo@studylingo.app';
const String kDevLoginPassword = 'password123';

/// Wires every cross-cutting service. Called once from `main()` before
/// `runApp`. Stub/in-memory implementations are registered today — swap a
/// single line here to point at a live API or persistence layer.
///
/// Repositories are **singletons** (not factories) because some of them hold
/// state that must be shared app-wide: a single `ProgressRepository` instance
/// is what keeps the quiz flow and the Profile stats in sync via its `watch()`
/// stream. Treat that constraint as load-bearing.
void setupServiceLocator() {
  // ── Session ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<CurrentUser>(() => CurrentUser());

  // ── Network ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: AppConstants.apiBaseUrl),
  );

  // ── Data sources ───────────────────────────────────────────────────────
  getIt.registerLazySingleton<EnglishLessonsLocalDataSource>(
    () => const InMemoryEnglishLessonsDataSource(),
  );
  getIt.registerLazySingleton<JapaneseLessonsLocalDataSource>(
    () => const InMemoryJapaneseLessonsDataSource(),
  );
  getIt.registerLazySingleton<EnglishVocabularyLocalDataSource>(
    () => const InMemoryEnglishVocabularyDataSource(),
  );
  getIt.registerLazySingleton<JapaneseVocabularyLocalDataSource>(
    () => const InMemoryJapaneseVocabularyDataSource(),
  );
  getIt.registerLazySingleton<StudyTopicsLocalDataSource>(
    () => const InMemoryStudyTopicsDataSource(),
  );

  // ── Repositories (singletons; some hold shared in-memory state) ───────
  getIt.registerLazySingleton<AuthRepository>(
    () => const FakeAuthRepository(),
  );
  getIt.registerLazySingleton<PasswordResetRepository>(
    () => FakePasswordResetRepository(),
  );
  getIt.registerLazySingleton<EnglishLessonsRepository>(
    () => EnglishLessonsRepositoryImpl(getIt<EnglishLessonsLocalDataSource>()),
  );
  getIt.registerLazySingleton<JapaneseLessonsRepository>(
    () =>
        JapaneseLessonsRepositoryImpl(getIt<JapaneseLessonsLocalDataSource>()),
  );
  getIt.registerLazySingleton<ProgressRepository>(
    () => InMemoryProgressRepository(),
  );
  getIt.registerLazySingleton<ReminderRepository>(
    () => InMemoryReminderRepository(),
  );
  getIt.registerLazySingleton<ReminderScheduler>(
    () => const LoggingReminderScheduler(),
  );
  getIt.registerLazySingleton<LocaleRepository>(
    () => InMemoryLocaleRepository(),
  );
  getIt.registerLazySingleton<ThemeRepository>(
    () => InMemoryThemeRepository(),
  );
  getIt.registerLazySingleton<EnglishVocabularyRepository>(
    () => EnglishVocabularyRepositoryImpl(
      getIt<EnglishVocabularyLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<JapaneseVocabularyRepository>(
    () => JapaneseVocabularyRepositoryImpl(
      getIt<JapaneseVocabularyLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<KanjiRepository>(
    () => const InMemoryKanjiRepository(),
  );
  getIt.registerLazySingleton<WritingRepository>(
    () => const InMemoryWritingRepository(),
  );
  getIt.registerLazySingleton<StudyTopicsRepository>(
    () => StudyTopicsRepositoryImpl(getIt<StudyTopicsLocalDataSource>()),
  );

  // ── Use cases ──────────────────────────────────────────────────────────
  // auth
  getIt.registerFactory(() => SignInWithEmailUseCase(getIt()));
  getIt.registerFactory(() => SignUpWithEmailUseCase(getIt()));
  getIt.registerFactory(() => SignInWithGoogleUseCase(getIt()));
  getIt.registerFactory(() => SignInWithFacebookUseCase(getIt()));
  getIt.registerFactory(() => SignOutUseCase(getIt()));
  getIt.registerFactory(() => RequestOtpUseCase(getIt()));
  getIt.registerFactory(() => VerifyOtpUseCase(getIt()));
  getIt.registerFactory(() => ResetPasswordUseCase(getIt()));
  // english lessons
  getIt.registerFactory(() => FetchEnglishTopicsUseCase(getIt()));
  getIt.registerFactory(() => FetchEnglishLessonsUseCase(getIt()));
  getIt.registerFactory(() => FetchEnglishPracticeLessonUseCase(getIt()));
  // japanese lessons
  getIt.registerFactory(() => FetchJapaneseTopicsUseCase(getIt()));
  getIt.registerFactory(() => FetchJapaneseLessonsUseCase(getIt()));
  getIt.registerFactory(() => FetchJapanesePracticeLessonUseCase(getIt()));
  // progress
  getIt.registerFactory(() => WatchProgressUseCase(getIt()));
  getIt.registerFactory(() => RecordLessonCompletedUseCase(getIt()));
  // reminders
  getIt.registerFactory(() => LoadReminderSettingsUseCase(getIt()));
  getIt.registerFactory(
    () => SaveReminderSettingsUseCase(getIt(), getIt()),
  );
  // settings (locale + theme)
  getIt.registerFactory(() => LoadLocaleUseCase(getIt()));
  getIt.registerFactory(() => SaveLocaleUseCase(getIt()));
  getIt.registerFactory(() => LoadThemeUseCase(getIt()));
  getIt.registerFactory(() => SaveThemeUseCase(getIt()));
  // vocabulary / kanji / writing
  getIt.registerFactory(() => FetchEnglishVocabularyWordsUseCase(getIt()));
  getIt.registerFactory(() => FetchJapaneseVocabularyWordsUseCase(getIt()));
  getIt.registerFactory(() => FetchKanjiListUseCase(getIt()));
  getIt.registerFactory(() => FetchWritingCharactersUseCase(getIt()));
  // study (themed topics)
  getIt.registerFactory(() => FetchStudyTopicsUseCase(getIt()));
  getIt.registerFactory(() => FetchStudyLessonsUseCase(getIt()));

  // ── App-wide Blocs (single instance for the whole app lifetime) ───────
  // LocaleCubit drives MaterialApp.locale; ThemeCubit drives
  // MaterialApp.themeMode; LanguageCubit is the learning-session language
  // other features (vocabulary deck) filter by.
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(loadLocale: getIt(), saveLocale: getIt())..load(),
  );
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(loadTheme: getIt(), saveTheme: getIt())..load(),
  );
  getIt.registerLazySingleton<LanguageCubit>(() => LanguageCubit());

  // ── Page-scoped Blocs/Cubits (new instance per page) ──────────────────
  // AuthBloc is mode-scoped: LoginPage resolves with `AuthMode.login`,
  // RegisterPage with `AuthMode.register`. The mode picks which submit
  // path runs (signInWithEmail vs signUpWithEmail) and enables the
  // confirm-password gate in `canSubmit`. Login mode is seeded with demo
  // creds so the fake auth flow can be exercised with a single tap; strip
  // the defaults when wiring a real backend.
  getIt.registerFactoryParam<AuthBloc, AuthMode, void>(
    (mode, _) => AuthBloc(
      signInWithEmail: getIt(),
      signUpWithEmail: getIt(),
      signInWithGoogle: getIt(),
      signInWithFacebook: getIt(),
      signOut: getIt(),
      initialMode: mode,
      initialEmail: mode == AuthMode.login ? kDevLoginEmail : '',
      initialPassword: mode == AuthMode.login ? kDevLoginPassword : '',
    ),
  );
  getIt.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(
      requestOtp: getIt(),
      verifyOtp: getIt(),
      resetPassword: getIt(),
    ),
  );
  getIt.registerFactory<EnglishTopicsCubit>(
    () => EnglishTopicsCubit(getIt()),
  );
  getIt.registerFactory<EnglishLessonsCubit>(
    () => EnglishLessonsCubit(getIt()),
  );
  getIt.registerFactory<JapaneseTopicsCubit>(
    () => JapaneseTopicsCubit(getIt()),
  );
  getIt.registerFactory<JapaneseLessonsCubit>(
    () => JapaneseLessonsCubit(getIt()),
  );
  // QuizBloc binds to a specific question list at construction. Use
  // `getIt<QuizBloc>(param1: questions)` from the route builder.
  getIt.registerFactoryParam<QuizBloc, List<QuizQuestion>, void>(
    (questions, _) => QuizBloc(
      questions: questions,
      recordLessonCompleted: getIt(),
    ),
  );
  getIt.registerFactory<ProfileStatsCubit>(
    () => ProfileStatsCubit(getIt()),
  );
  // EditProfileCubit seeds its form from the signed-in user. Resolve with
  // `getIt<EditProfileCubit>(param1: user)`.
  getIt.registerFactoryParam<EditProfileCubit, AuthUser, void>(
    (user, _) => EditProfileCubit(user),
  );
  getIt.registerFactory<EnglishVocabularyBloc>(
    () => EnglishVocabularyBloc(getIt()),
  );
  getIt.registerFactory<JapaneseVocabularyBloc>(
    () => JapaneseVocabularyBloc(getIt()),
  );
  getIt.registerFactory<RemindersCubit>(
    () => RemindersCubit(load: getIt(), save: getIt()),
  );
  getIt.registerFactory<KanjiListCubit>(() => KanjiListCubit(getIt()));
  getIt.registerFactory<WritingPracticeCubit>(
    () => WritingPracticeCubit(getIt()),
  );
  getIt.registerFactory<StudyTopicsCubit>(() => StudyTopicsCubit(getIt()));
  getIt.registerFactory<StudyLessonsCubit>(() => StudyLessonsCubit(getIt()));
}

/// Resets the locator between widget tests. Without this, the second test in
/// a file would see singletons from the first test.
Future<void> resetServiceLocator() async {
  await getIt.reset();
}
