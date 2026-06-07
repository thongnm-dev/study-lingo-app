import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_lingo/l10n/generated/app_localizations.dart';

/// Wraps a widget under test in a `MaterialApp.router` whose router knows
/// about [extraRoutes] in addition to the entry route. The default route
/// `/` builds [home] — equivalent to the old `MaterialApp(home: ...)`
/// pattern, but compatible with `context.push` / `context.go` calls inside
/// the widget under test.
///
/// Pass [extraRoutes] for any destinations the page may navigate to during
/// the test (e.g. `/profile`, `/practice`).
GoRouter buildTestRouter({
  required Widget home,
  List<RouteBase> extraRoutes = const [],
  String initialLocation = '/',
}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/', builder: (_, _) => home),
      ...extraRoutes,
    ],
  );
}

/// Convenience wrapper: builds the same `MaterialApp.router` the production
/// app uses (locale-pinned to Vietnamese for deterministic finders).
MaterialApp materialAppRouter({
  required GoRouter router,
  Locale locale = const Locale('vi'),
}) {
  return MaterialApp.router(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: router,
  );
}
