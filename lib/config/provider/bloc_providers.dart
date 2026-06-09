import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/session/language_cubit.dart';
import '../../features/settings/presentation/bloc/locale_cubit.dart';
import '../../features/settings/presentation/bloc/theme_cubit.dart';
import '../di/service_locator.dart';

/// Blocs/Cubits that live for the whole app and are read from anywhere in the
/// widget tree. Page-scoped blocs stay at each page's own `BlocProvider`.
///
/// Listed here:
///   • [LocaleCubit] — drives `MaterialApp.locale`; selecting a display
///     language in Settings re-localizes the whole UI live.
///   • [ThemeCubit] — drives `MaterialApp.themeMode`; selecting a theme in
///     Settings re-themes the whole UI live.
///   • [LanguageCubit] — the *learning-session* language; other features
///     (e.g. the vocabulary deck filter) react to the same session, so the
///     instance must be shared root-down.
class AppBlocProviders {
  const AppBlocProviders._();

  static List<BlocProvider> get providers => [
    BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
    BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
    BlocProvider<LanguageCubit>.value(value: getIt<LanguageCubit>()),
  ];
}
