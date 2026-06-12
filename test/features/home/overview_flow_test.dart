import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:study_lingo/config/di/service_locator.dart';
import 'package:study_lingo/config/router/app_router.dart';
import 'package:study_lingo/config/router/route_names.dart';
import 'package:study_lingo/core/session/language_cubit.dart';
import 'package:study_lingo/features/english/lessons/presentation/pages/english_topics_page.dart';
import 'package:study_lingo/features/home/presentation/pages/overview_page.dart';
import 'package:study_lingo/features/japanese/lessons/presentation/pages/japanese_topics_page.dart';

import '../../helpers/test_di.dart';
import '../../helpers/test_router.dart';

void main() {
  setUp(useTestServiceLocator);

  // The overview reads the app-wide LanguageCubit (shared with the vocabulary
  // filter) and the per-language repositories — both resolved through GetIt.
  // The test helper registers the production stubs.
  Widget host() => BlocProvider<LanguageCubit>.value(
    value: getIt<LanguageCubit>(),
    child: materialAppRouter(
      router: buildTestRouter(
        home: const OverviewPage(),
        extraRoutes: [
          GoRoute(
            path: RouteNames.englishTopics,
            builder: (_, state) {
              final args = state.extra! as EnglishTopicsPageArgs;
              return EnglishTopicsPage(skill: args.skill);
            },
          ),
          GoRoute(
            path: RouteNames.japaneseTopics,
            builder: (_, state) {
              final args = state.extra! as JapaneseTopicsPageArgs;
              return JapaneseTopicsPage(skill: args.skill);
            },
          ),
        ],
      ),
    ),
  );

  testWidgets('pick English → skills appear → opens English topics page', (
    tester,
  ) async {
    await tester.pumpWidget(host());

    expect(
      find.text('Chọn một ngôn ngữ phía trên để bắt đầu học.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Tiếng Anh'));
    await tester.pumpAndSettle();

    expect(find.text('Kỹ năng · Tiếng Anh'), findsOneWidget);
    for (final label in ['Ngữ pháp', 'Từ vựng', 'Nghe nói', 'Đọc', 'Viết']) {
      expect(find.text(label), findsOneWidget);
    }

    await tester.ensureVisible(find.text('Từ vựng'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Từ vựng'));
    await tester.pumpAndSettle();

    expect(find.byType(EnglishTopicsPage), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Từ vựng'), findsOneWidget);
    expect(find.text('Greetings'), findsOneWidget);
    expect(find.text('Food & Drink'), findsOneWidget);
  });

  testWidgets('pick Japanese → opens Japanese topics page', (tester) async {
    await tester.pumpWidget(host());
    await tester.tap(find.text('Tiếng Nhật'));
    await tester.pumpAndSettle();

    expect(find.text('Kỹ năng · Tiếng Nhật'), findsOneWidget);

    await tester.ensureVisible(find.text('Từ vựng'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Từ vựng'));
    await tester.pumpAndSettle();

    expect(find.byType(JapaneseTopicsPage), findsOneWidget);
    expect(find.text('挨拶'), findsOneWidget);
    expect(find.text('食べ物'), findsOneWidget);
  });
}
