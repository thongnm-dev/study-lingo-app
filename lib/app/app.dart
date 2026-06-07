import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/provider/bloc_providers.dart';
import '../config/router/app_router.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../features/settings/domain/entities/app_language.dart';
import '../features/settings/domain/entities/app_theme_mode.dart';
import '../features/settings/presentation/bloc/locale_cubit.dart';
import '../features/settings/presentation/bloc/theme_cubit.dart';
import '../l10n/generated/app_localizations.dart';

/// Root widget. All cross-cutting dependencies (repositories, data sources)
/// are resolved through GetIt — see `config/di/service_locator.dart`. Only
/// app-wide Blocs are provided in the tree, via [AppBlocProviders].
class StudyLingoApp extends StatelessWidget {
  const StudyLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: BlocBuilder<LocaleCubit, AppLanguage>(
        builder: (context, language) =>
            BlocBuilder<ThemeCubit, AppThemeMode>(
              builder: (context, themeMode) => MaterialApp.router(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeMode.themeMode,
                locale: Locale(language.code),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: appRouter,
              ),
            ),
      ),
    );
  }
}
