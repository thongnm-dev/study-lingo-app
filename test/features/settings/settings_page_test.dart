import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/auth/presentation/view/auth_page.dart';
import 'package:study_lingo/features/reminders/data/repositories/in_memory_reminder_repository.dart';
import 'package:study_lingo/features/reminders/data/services/logging_reminder_scheduler.dart';
import 'package:study_lingo/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:study_lingo/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:study_lingo/features/reminders/presentation/view/reminders_page.dart';
import 'package:study_lingo/features/settings/presentation/view/settings_page.dart';

void main() {
  // "Thông báo" routes to RemindersPage, which reads these shared services.
  Widget host() => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<ReminderRepository>(
        create: (_) => InMemoryReminderRepository(),
      ),
      RepositoryProvider<ReminderScheduler>(
        create: (_) => const LoggingReminderScheduler(),
      ),
    ],
    child: const MaterialApp(home: SettingsPage()),
  );

  testWidgets('lists all settings categories', (tester) async {
    await tester.pumpWidget(host());

    expect(find.text('Cá nhân'), findsOneWidget);
    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.text('Khóa học'), findsOneWidget);
    expect(find.text('Quyền riêng tư'), findsOneWidget);
    expect(find.text('Đăng xuất'), findsOneWidget);
  });

  testWidgets('"Thông báo" opens the reminders screen', (tester) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Thông báo'));
    await tester.pumpAndSettle();

    expect(find.byType(RemindersPage), findsOneWidget);
  });

  testWidgets('"Đăng xuất" resets to the auth screen', (tester) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Đăng xuất'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthPage), findsOneWidget);
    expect(find.byType(SettingsPage), findsNothing);
  });
}
