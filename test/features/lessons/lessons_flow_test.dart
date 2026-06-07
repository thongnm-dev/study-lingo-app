import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:study_lingo/config/di/service_locator.dart';
import 'package:study_lingo/config/router/app_router.dart';
import 'package:study_lingo/config/router/route_names.dart';
import 'package:study_lingo/features/lessons/presentation/bloc/language_cubit.dart';
import 'package:study_lingo/features/lessons/presentation/pages/overview_page.dart';
import 'package:study_lingo/features/lessons/presentation/pages/topics_page.dart';

import '../../helpers/test_di.dart';
import '../../helpers/test_router.dart';

void main() {
  setUp(useTestServiceLocator);

  // The overview reads the app-wide LanguageCubit (shared with the vocabulary
  // filter) and the shared repositories — both resolved through GetIt. The
  // test helper registers the production stubs. Topics route is wired so the
  // skill-card tap can drill into TopicsPage.
  Widget host() => BlocProvider<LanguageCubit>.value(
    value: getIt<LanguageCubit>(),
    child: materialAppRouter(
      router: buildTestRouter(
        home: const OverviewPage(),
        extraRoutes: [
          GoRoute(
            path: RouteNames.topics,
            builder: (_, state) {
              final args = state.extra! as TopicsPageArgs;
              return TopicsPage(language: args.language, skill: args.skill);
            },
          ),
        ],
      ),
    ),
  );

  testWidgets('pick language → skills appear → open a skill\'s topics', (
    tester,
  ) async {
    await tester.pumpWidget(host());

    // Before any language is chosen, the skills section shows a prompt.
    expect(
      find.text('Chọn một ngôn ngữ phía trên để bắt đầu học.'),
      findsOneWidget,
    );

    // Picking a language reveals the five skill tracks for it.
    await tester.tap(find.text('Tiếng Anh'));
    await tester.pumpAndSettle();

    expect(find.text('Kỹ năng · Tiếng Anh'), findsOneWidget);
    for (final label in ['Ngữ pháp', 'Từ vựng', 'Nghe nói', 'Đọc', 'Viết']) {
      expect(find.text(label), findsOneWidget);
    }

    // Tapping a skill drills into that skill's topics.
    await tester.tap(find.text('Từ vựng'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Từ vựng'), findsOneWidget);
    expect(find.text('Greetings'), findsOneWidget);
    expect(find.text('Food & Drink'), findsOneWidget);
  });
}
