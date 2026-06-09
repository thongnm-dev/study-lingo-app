import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:study_lingo/config/di/service_locator.dart';
import 'package:study_lingo/config/router/route_names.dart';
import 'package:study_lingo/features/auth/presentation/pages/login_page.dart';
import 'package:study_lingo/features/reminders/presentation/pages/reminders_page.dart';
import 'package:study_lingo/features/settings/domain/entities/app_theme_mode.dart';
import 'package:study_lingo/features/settings/presentation/bloc/locale_cubit.dart';
import 'package:study_lingo/features/settings/presentation/bloc/theme_cubit.dart';
import 'package:study_lingo/features/settings/presentation/pages/language_settings_page.dart';
import 'package:study_lingo/features/settings/presentation/pages/settings_page.dart';

import '../../helpers/test_di.dart';
import '../../helpers/test_router.dart';

void main() {
  setUp(useTestServiceLocator);

  // "Cài đặt thông báo" routes to RemindersPage and "Ngôn ngữ" to
  // LanguageSettingsPage — both resolve their dependencies through GetIt.
  // The display-language LocaleCubit is the app-wide singleton so we wrap
  // SettingsPage with a BlocProvider.value pointing at that same instance.
  // The test router wires the destinations Settings can push, plus an /auth
  // landing for the logout flow.
  Widget host() => MultiBlocProvider(
    providers: [
      BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
      BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
    ],
    child: materialAppRouter(
      router: buildTestRouter(
        home: const SettingsPage(),
        extraRoutes: [
          GoRoute(
            path: RouteNames.reminders,
            builder: (_, _) => const RemindersPage(),
          ),
          GoRoute(
            path: RouteNames.languageSettings,
            builder: (_, _) => const LanguageSettingsPage(),
          ),
          GoRoute(
            path: RouteNames.auth,
            builder: (_, _) => const LoginPage(),
          ),
        ],
      ),
    ),
  );

  testWidgets('lists every section and tile', (tester) async {
    await tester.pumpWidget(host());

    // Section titles.
    expect(find.text('Giao diện & ngôn ngữ'), findsOneWidget);
    // "Thông báo" doubles as the notifications section title.
    expect(find.text('Thông báo'), findsOneWidget);

    // Tile labels (the first batch is on-screen by default).
    expect(find.text('Ngôn ngữ'), findsOneWidget);
    expect(find.text('Chế độ tối'), findsOneWidget);
    expect(find.text('Cài đặt thông báo'), findsOneWidget);
    expect(find.text('Email tổng kết'), findsOneWidget);

    // The "Khác" section + logout sit below the fold on the test surface;
    // scroll the list to bring them into view before asserting.
    await tester.scrollUntilVisible(
      find.text('Đăng xuất'),
      200,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Khác'), findsOneWidget);
    expect(find.text('Chính sách bảo mật'), findsOneWidget);
    expect(find.text('Điều khoản dịch vụ'), findsOneWidget);
    expect(find.text('Đánh giá ứng dụng'), findsOneWidget);
    expect(find.text('Đăng xuất'), findsOneWidget);
  });

  testWidgets('the language tile shows the current language as trailing', (
    tester,
  ) async {
    await tester.pumpWidget(host());

    // Default locale is Vietnamese — the language row shows its autonym.
    expect(find.text('Tiếng Việt'), findsOneWidget);
  });

  testWidgets('"Cài đặt thông báo" opens the reminders screen', (tester) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Cài đặt thông báo'));
    await tester.pumpAndSettle();

    expect(find.byType(RemindersPage), findsOneWidget);
  });

  testWidgets('"Ngôn ngữ" opens the language picker', (tester) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Ngôn ngữ'));
    await tester.pumpAndSettle();

    expect(find.byType(LanguageSettingsPage), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);
  });

  testWidgets('the dark-mode switch toggles the theme cubit', (tester) async {
    await tester.pumpWidget(host());

    final cubit = getIt<ThemeCubit>();
    expect(cubit.state, AppThemeMode.light);

    // The dark-mode switch is the first Switch in document order — the
    // email-summary switch sits in the next section below it.
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(cubit.state, AppThemeMode.dark);

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(cubit.state, AppThemeMode.light);
  });

  testWidgets('"Đăng xuất" resets to the auth screen', (tester) async {
    // The settings page is longer than the default test surface, so give it
    // more vertical room so the logout tile is fully on-screen and tappable.
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Đăng xuất'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(SettingsPage), findsNothing);
  });
}
