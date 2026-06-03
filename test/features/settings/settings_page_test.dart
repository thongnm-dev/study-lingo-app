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
  // "Thông báo" routes to RemindersPage (shared services) and "Ngôn ngữ hiển
  // thị" to LanguageSettingsPage (app-root LocaleCubit), so provide both. The
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

  testWidgets('lists all settings categories', (tester) async {
    await tester.pumpWidget(host());

    expect(find.text('Cá nhân'), findsOneWidget);
    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.text('Khóa học'), findsOneWidget);
    expect(find.text('Ngôn ngữ hiển thị'), findsOneWidget);
    expect(find.text('Quyền riêng tư'), findsOneWidget);
    expect(find.text('Đăng xuất'), findsOneWidget);
  });

  testWidgets('"Thông báo" opens the reminders screen', (tester) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Thông báo'));
    await tester.pumpAndSettle();

    expect(find.byType(RemindersPage), findsOneWidget);
  });

  testWidgets('"Ngôn ngữ hiển thị" opens the language picker', (tester) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Ngôn ngữ hiển thị'));
    await tester.pumpAndSettle();

    expect(find.byType(LanguageSettingsPage), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);
  });

  testWidgets('"Đăng xuất" resets to the auth screen', (tester) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Đăng xuất'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthPage), findsOneWidget);
    expect(find.byType(SettingsPage), findsNothing);
  });
}
