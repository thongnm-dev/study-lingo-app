import 'package:get_it/get_it.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/dio_client.dart';
import '../../core/session/current_user.dart';
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
import '../../features/auth/domain/usecases/sign_up_with_email.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/forgot_password_bloc.dart';
import '../../features/kanji/data/repositories/in_memory_kanji_repository.dart';
import '../../features/kanji/domain/repositories/kanji_repository.dart';
import '../../features/kanji/domain/usecases/fetch_kanji_list.dart';
import '../../features/kanji/presentation/bloc/kanji_list_cubit.dart';
import '../../features/lessons/data/datasources/lessons_local_data_source.dart';
import '../../features/lessons/data/repositories/lessons_repository_impl.dart';
import '../../features/lessons/domain/entities/lesson.dart';
import '../../features/lessons/domain/repositories/lessons_repository.dart';
import '../../features/lessons/domain/usecases/fetch_lessons.dart';
import '../../features/lessons/domain/usecases/fetch_practice_lesson.dart';
import '../../features/lessons/domain/usecases/fetch_topics.dart';
import '../../features/lessons/presentation/bloc/language_cubit.dart';
import '../../features/lessons/presentation/bloc/lessons_cubit.dart';
import '../../features/lessons/presentation/bloc/quiz_bloc.dart';
import '../../features/lessons/presentation/bloc/topics_cubit.dart';
import '../../features/profile/presentation/bloc/profile_stats_cubit.dart';
import '../../features/progress/data/repositories/in_memory_progress_repository.dart';
import '../../features/progress/domain/repositories/progress_repository.dart';
import '../../features/progress/domain/usecases/record_lesson_completed.dart';
import '../../features/progress/domain/usecases/watch_progress.dart';
import '../../features/progress/presentation/bloc/progress_cubit.dart';
import '../../features/reminders/data/repositories/in_memory_reminder_repository.dart';
import '../../features/reminders/data/services/logging_reminder_scheduler.dart';
import '../../features/reminders/domain/repositories/reminder_repository.dart';
import '../../features/reminders/domain/services/reminder_scheduler.dart';
import '../../features/reminders/domain/usecases/load_reminder_settings.dart';
import '../../features/reminders/domain/usecases/save_reminder_settings.dart';
import '../../features/reminders/presentation/bloc/reminders_cubit.dart';
import '../../features/settings/data/repositories/in_memory_locale_repository.dart';
import '../../features/settings/domain/repositories/locale_repository.dart';
import '../../features/settings/domain/usecases/load_locale.dart';
import '../../features/settings/domain/usecases/save_locale.dart';
import '../../features/settings/presentation/bloc/locale_cubit.dart';
import '../../features/vocabulary/data/datasources/vocabulary_local_data_source.dart';
import '../../features/vocabulary/data/repositories/vocabulary_repository_impl.dart';
import '../../features/vocabulary/domain/repositories/vocabulary_repository.dart';
import '../../features/vocabulary/domain/usecases/fetch_vocabulary_words.dart';
import '../../features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import '../../features/writing/data/repositories/in_memory_writing_repository.dart';
import '../../features/writing/domain/repositories/writing_repository.dart';
import '../../features/writing/domain/usecases/fetch_writing_characters.dart';
import '../../features/writing/presentation/bloc/writing_practice_cubit.dart';

final getIt = GetIt.instance;

/// Wires every cross-cutting service. Called once from `main()` before
/// `runApp`. Stub/in-memory implementations are registered today — swap a
/// single line here to point at a live API or persistence layer.
///
/// Repositories are **singletons** (not factories) because some of them hold
/// state that must be shared app-wide: a single `ProgressRepository` instance
/// is what keeps the quiz flow and the Progress tab in sync via its `watch()`
/// stream. Treat that constraint as load-bearing.
void setupServiceLocator() {
  // ── Session ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<CurrentUser>(() => CurrentUser());

  // ── Network ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: AppConstants.apiBaseUrl),
  );

  // ── Data sources ───────────────────────────────────────────────────────
  getIt.registerLazySingleton<LessonsLocalDataSource>(
    () => const InMemoryLessonsDataSource(),
  );
  getIt.registerLazySingleton<VocabularyLocalDataSource>(
    () => const InMemoryVocabularyDataSource(),
  );

  // ── Repositories (singletons; some hold shared in-memory state) ───────
  getIt.registerLazySingleton<AuthRepository>(
    () => const FakeAuthRepository(),
  );
  getIt.registerLazySingleton<PasswordResetRepository>(
    () => FakePasswordResetRepository(),
  );
  getIt.registerLazySingleton<LessonsRepository>(
    () => LessonsRepositoryImpl(getIt<LessonsLocalDataSource>()),
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
  getIt.registerLazySingleton<VocabularyRepository>(
    () => VocabularyRepositoryImpl(getIt<VocabularyLocalDataSource>()),
  );
  getIt.registerLazySingleton<KanjiRepository>(
    () => const InMemoryKanjiRepository(),
  );
  getIt.registerLazySingleton<WritingRepository>(
    () => const InMemoryWritingRepository(),
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
  // lessons
  getIt.registerFactory(() => FetchTopicsUseCase(getIt()));
  getIt.registerFactory(() => FetchLessonsUseCase(getIt()));
  getIt.registerFactory(() => FetchPracticeLessonUseCase(getIt()));
  // progress
  getIt.registerFactory(() => WatchProgressUseCase(getIt()));
  getIt.registerFactory(() => RecordLessonCompletedUseCase(getIt()));
  // reminders
  getIt.registerFactory(() => LoadReminderSettingsUseCase(getIt()));
  getIt.registerFactory(
    () => SaveReminderSettingsUseCase(getIt(), getIt()),
  );
  // settings (locale)
  getIt.registerFactory(() => LoadLocaleUseCase(getIt()));
  getIt.registerFactory(() => SaveLocaleUseCase(getIt()));
  // vocabulary / kanji / writing
  getIt.registerFactory(() => FetchVocabularyWordsUseCase(getIt()));
  getIt.registerFactory(() => FetchKanjiListUseCase(getIt()));
  getIt.registerFactory(() => FetchWritingCharactersUseCase(getIt()));

  // ── App-wide Blocs (single instance for the whole app lifetime) ───────
  // LocaleCubit drives MaterialApp.locale; LanguageCubit is the
  // learning-session language other features (vocabulary deck) filter by.
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(loadLocale: getIt(), saveLocale: getIt())..load(),
  );
  getIt.registerLazySingleton<LanguageCubit>(() => LanguageCubit());

  // ── Page-scoped Blocs/Cubits (new instance per page) ──────────────────
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInWithEmail: getIt(),
      signUpWithEmail: getIt(),
      signInWithGoogle: getIt(),
      signInWithFacebook: getIt(),
      signOut: getIt(),
    ),
  );
  getIt.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(
      requestOtp: getIt(),
      verifyOtp: getIt(),
      resetPassword: getIt(),
    ),
  );
  getIt.registerFactory<TopicsCubit>(() => TopicsCubit(getIt()));
  getIt.registerFactory<LessonsCubit>(() => LessonsCubit(getIt()));
  // QuizBloc binds to a specific Lesson at construction. Use
  // `getIt<QuizBloc>(param1: lesson)` from the page.
  getIt.registerFactoryParam<QuizBloc, Lesson, void>(
    (lesson, _) => QuizBloc(
      lesson: lesson,
      recordLessonCompleted: getIt(),
    ),
  );
  getIt.registerFactory<ProgressCubit>(
    () => ProgressCubit(
      watchProgress: getIt(),
      dailyGoal: getIt<ProgressRepository>().dailyGoal,
    ),
  );
  getIt.registerFactory<ProfileStatsCubit>(
    () => ProfileStatsCubit(getIt()),
  );
  getIt.registerFactory<VocabularyBloc>(() => VocabularyBloc(getIt()));
  getIt.registerFactory<RemindersCubit>(
    () => RemindersCubit(load: getIt(), save: getIt()),
  );
  getIt.registerFactory<KanjiListCubit>(() => KanjiListCubit(getIt()));
  getIt.registerFactory<WritingPracticeCubit>(
    () => WritingPracticeCubit(getIt()),
  );
}

/// Resets the locator between widget tests. Without this, the second test in
/// a file would see singletons from the first test.
Future<void> resetServiceLocator() async {
  await getIt.reset();
}
