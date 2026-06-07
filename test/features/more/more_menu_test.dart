import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:study_lingo/config/router/route_names.dart';
import 'package:study_lingo/features/auth/domain/entities/auth_user.dart';
import 'package:study_lingo/features/lessons/presentation/pages/practice_page.dart';
import 'package:study_lingo/features/more/presentation/model/more_menu_entry.dart';
import 'package:study_lingo/features/more/presentation/pages/more_destination_page.dart';
import 'package:study_lingo/features/more/presentation/pages/more_menu.dart';
import 'package:study_lingo/features/profile/presentation/pages/profile_page.dart';

import '../../helpers/test_di.dart';
import '../../helpers/test_router.dart';

void main() {
  setUp(useTestServiceLocator);

  const user = AuthUser(
    id: 'u1',
    provider: AuthProvider.google,
    email: 'demo@gmail.com',
    displayName: 'Demo User',
  );

  // Profile/Practice/MoreDestination routes resolve their dependencies from
  // GetIt; the test service locator (see test_di.dart) registers the same
  // stub repositories. The test router wires the routes the More menu pushes.
  Widget host() => materialAppRouter(
    router: buildTestRouter(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showMoreMenu(context, user),
              child: const Text('open'),
            ),
          ),
        ),
      ),
      extraRoutes: [
        GoRoute(
          path: RouteNames.profile,
          builder: (_, state) =>
              ProfilePage(user: state.extra! as AuthUser),
        ),
        GoRoute(
          path: RouteNames.practice,
          builder: (_, _) => const PracticePage(),
        ),
        GoRoute(
          path: RouteNames.moreDestination,
          builder: (_, state) =>
              MoreDestinationPage(entry: state.extra! as MoreMenuEntry),
        ),
      ],
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
