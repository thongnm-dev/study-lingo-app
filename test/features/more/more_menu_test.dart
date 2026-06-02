import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/auth/domain/entities/auth_user.dart';
import 'package:study_lingo/features/lessons/data/datasources/lessons_local_data_source.dart';
import 'package:study_lingo/features/lessons/data/repositories/lessons_repository_impl.dart';
import 'package:study_lingo/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:study_lingo/features/lessons/presentation/view/practice_page.dart';
import 'package:study_lingo/features/more/presentation/view/more_destination_page.dart';
import 'package:study_lingo/features/more/presentation/view/more_menu.dart';
import 'package:study_lingo/features/profile/presentation/view/profile_page.dart';
import 'package:study_lingo/features/progress/data/repositories/in_memory_progress_repository.dart';
import 'package:study_lingo/features/progress/domain/repositories/progress_repository.dart';

void main() {
  const user = AuthUser(
    id: 'u1',
    provider: AuthProvider.google,
    email: 'demo@gmail.com',
    displayName: 'Demo User',
  );

  // The profile/practice routes read the shared repositories, so provide them.
  Widget host() => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<LessonsRepository>(
        create: (_) => const LessonsRepositoryImpl(InMemoryLessonsDataSource()),
      ),
      RepositoryProvider<ProgressRepository>(
        create: (_) => InMemoryProgressRepository(),
      ),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => showMoreMenu(context, user),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('the More menu shows all entries', (tester) async {
    await tester.pumpWidget(host());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ'), findsOneWidget);
    expect(find.text('Phát âm'), findsOneWidget);
    expect(find.text('Cuộc gọi video'), findsOneWidget);
    expect(find.text('Luyện tập'), findsOneWidget);
  });

  testWidgets('a placeholder entry opens its destination page', (tester) async {
    await tester.pumpWidget(host());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Phát âm'));
    await tester.pumpAndSettle();

    expect(find.byType(MoreDestinationPage), findsOneWidget);
    expect(find.text('Sắp ra mắt'), findsOneWidget);
  });

  testWidgets('"Hồ sơ" opens the profile screen with the user', (tester) async {
    await tester.pumpWidget(host());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hồ sơ'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Demo User'), findsOneWidget);
    expect(find.text('demo@gmail.com'), findsOneWidget);
    expect(find.text('Đăng nhập bằng Google'), findsOneWidget);
  });

  testWidgets('"Luyện tập" opens the practice flow', (tester) async {
    await tester.pumpWidget(host());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Luyện tập'));
    await tester.pumpAndSettle();

    expect(find.byType(PracticePage), findsOneWidget);
  });
}
