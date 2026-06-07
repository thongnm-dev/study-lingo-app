import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:study_lingo/config/router/app_router.dart';
import 'package:study_lingo/config/router/route_names.dart';
import 'package:study_lingo/features/writing/presentation/pages/character_tracing_page.dart';
import 'package:study_lingo/features/writing/presentation/pages/writing_home_page.dart';

import '../../helpers/test_di.dart';
import '../../helpers/test_router.dart';

void main() {
  setUp(useTestServiceLocator);

  testWidgets('lists scripts and opens tracing for the first character', (
    tester,
  ) async {
    final router = buildTestRouter(
      home: const WritingHomePage(),
      extraRoutes: [
        GoRoute(
          path: RouteNames.characterTracing,
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

    expect(find.text('Hiragana'), findsOneWidget);
    expect(find.text('Kanji'), findsOneWidget);

    await tester.tap(find.text('Hiragana'));
    await tester.pumpAndSettle();

    expect(find.byType(CharacterTracingPage), findsOneWidget);
    // First hiragana reading is shown.
    expect(find.text('a'), findsOneWidget);
  });
}
