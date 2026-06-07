import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/auth/presentation/view/auth_page.dart';
import 'package:study_lingo/features/reminders/data/repositories/in_memory_reminder_repository.dart';
import 'package:study_lingo/features/reminders/data/services/logging_reminder_scheduler.dart';
import 'package:study_lingo/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:study_lingo/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:study_lingo/features/reminders/presentation/view/reminders_page.dart';
import 'package:study_lingo/features/settings/data/repositories/in_memory_locale_repository.dart';
import 'package:study_lingo/features/settings/domain/repositories/locale_repository.dart';
import 'package:study_lingo/features/settings/presentation/cubit/locale_cubit.dart';
import 'package:study_lingo/features/settings/presentation/view/language_settings_page.dart';
import 'package:study_lingo/features/settings/presentation/view/settings_page.dart';
import 'package:study_lingo/l10n/generated/app_localizations.dart';

void main() {
  // "Cài đặt thông báo" routes to RemindersPage (shared services) and "Ngôn
  // ngữ" to LanguageSettingsPage (app-root LocaleCubit), so provide both. The
  // locale is pinned to Vietnamese, the app default.
  Widget host() => MultiRepositoryProvider(
    providers: [
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
    child: BlocProvider(
      create: (context) => LocaleCubit(context.read<LocaleRepository>()),
      child: const MaterialApp(
        locale: Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsPage(),
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
    await tester.dragUntilVisible(
      find.text('Đăng xuất'),
      find.byType(ListView),
      const Offset(0, -200),
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

  testWidgets('"Đăng xuất" resets to the auth screen', (tester) async {
    await tester.pumpWidget(host());

    await tester.dragUntilVisible(
      find.text('Đăng xuất'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.tap(find.text('Đăng xuất'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthPage), findsOneWidget);
    expect(find.byType(SettingsPage), findsNothing);
  });
}
