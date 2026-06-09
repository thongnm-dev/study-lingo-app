import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:study_lingo/config/router/app_router.dart';
import 'package:study_lingo/config/router/route_names.dart';
import 'package:study_lingo/features/japanese/writing/presentation/pages/character_tracing_page.dart';
import 'package:study_lingo/features/japanese/writing/presentation/pages/kanji_list_page.dart';
import 'package:study_lingo/features/japanese/writing/presentation/pages/writing_home_page.dart';

import '../../../helpers/test_di.dart';
import '../../../helpers/test_router.dart';

void main() {
  setUp(useTestServiceLocator);

  testWidgets('lists all three scripts', (tester) async {
    final router = buildTestRouter(home: const WritingHomePage());
    await tester.pumpWidget(materialAppRouter(router: router));

    expect(find.text('Hiragana'), findsOneWidget);
    expect(find.text('Katakana'), findsOneWidget);
    expect(find.text('Kanji'), findsOneWidget);
  });

  testWidgets('Hiragana opens the tracing flow at the first character', (
    tester,
  ) async {
    final router = buildTestRouter(
      home: const WritingHomePage(),
      extraRoutes: [
        GoRoute(
          path: RouteNames.japaneseTracing,
          builder: (_, state) {
            final args = state.extra! as CharacterTracingArgs;
            return CharacterTracingPage(
              script: args.script,
              characters: args.characters,
              title: args.title,
            );
          },
        ),
      ],
    );
    await tester.pumpWidget(materialAppRouter(router: router));

    await tester.tap(find.text('Hiragana'));
    await tester.pumpAndSettle();

    expect(find.byType(CharacterTracingPage), findsOneWidget);
    expect(find.text('a'), findsOneWidget);
  });

  testWidgets('Kanji opens the kanji list instead of tracing', (tester) async {
    final router = buildTestRouter(
      home: const WritingHomePage(),
      extraRoutes: [
        GoRoute(
          path: RouteNames.japaneseKanjiList,
          builder: (_, _) => const KanjiListPage(),
        ),
      ],
    );
    await tester.pumpWidget(materialAppRouter(router: router));

    await tester.tap(find.text('Kanji'));
    await tester.pumpAndSettle();

    expect(find.byType(KanjiListPage), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Học Hán tự'), findsOneWidget);
  });
}
