import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/config/di/service_locator.dart';
import 'package:study_lingo/features/lessons/domain/entities/learning_language.dart';
import 'package:study_lingo/features/lessons/presentation/bloc/language_cubit.dart';
import 'package:study_lingo/features/vocabulary/presentation/pages/vocabulary_page.dart';
import 'package:study_lingo/l10n/generated/app_localizations.dart';

import '../../helpers/test_di.dart';

void main() {
  late LanguageCubit languageCubit;

  setUp(() {
    useTestServiceLocator();
    // LanguageCubit is the app-wide singleton in production; resolve the same
    // instance here so the page and the test share state.
    languageCubit = getIt<LanguageCubit>();
  });

  // The word list's scrollable (not the horizontal filter bar's).
  final wordList = find.descendant(
    of: find.byType(ListView),
    matching: find.byType(Scrollable),
  );

  // Mirrors main.dart: LanguageCubit (the learning session) is provided above
  // the page. Locale pinned to Vietnamese for deterministic finders.
  Widget host() => BlocProvider.value(
    value: languageCubit,
    child: const MaterialApp(
      locale: Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: VocabularyPage(),
    ),
  );

  testWidgets('without a session shows both decks and the JLPT bar', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    expect(find.text('水'), findsOneWidget); // Japanese-target word
    expect(find.text('Tất cả'), findsOneWidget); // JLPT bar visible
    expect(find.textContaining('Đang học'), findsNothing);

    // The English deck is in the same list, further down.
    await tester.scrollUntilVisible(
      find.text('breakfast'),
      200,
      scrollable: wordList,
    );
    expect(find.text('breakfast'), findsOneWidget);
  });

  testWidgets('a Japanese session filters to the Japanese deck', (
    tester,
  ) async {
    languageCubit.select(LearningLanguage.japanese);
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    expect(find.text('Đang học: Tiếng Nhật'), findsOneWidget);
    expect(find.text('水'), findsOneWidget);
    expect(find.text('breakfast'), findsNothing);

    // JLPT chips still narrow the Japanese deck. (The N4 badge on a card has
    // the same text, so target the chip explicitly.)
    await tester.tap(find.widgetWithText(ChoiceChip, 'N4'));
    await tester.pumpAndSettle();

    expect(find.text('約束'), findsOneWidget);
    expect(find.text('水'), findsNothing);
  });

  testWidgets('an English session filters the deck and hides the JLPT bar', (
    tester,
  ) async {
    languageCubit.select(LearningLanguage.english);
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    expect(find.text('Đang học: Tiếng Anh'), findsOneWidget);
    expect(find.text('breakfast'), findsOneWidget);
    expect(find.text('水'), findsNothing);
    expect(find.text('Tất cả'), findsNothing); // JLPT is Japanese-only
  });

  testWidgets('changing the session re-filters the live list', (tester) async {
    languageCubit.select(LearningLanguage.japanese);
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();
    expect(find.text('水'), findsOneWidget);

    languageCubit.select(LearningLanguage.english);
    await tester.pumpAndSettle();

    expect(find.text('breakfast'), findsOneWidget);
    expect(find.text('水'), findsNothing);

    languageCubit.reset();
    await tester.pumpAndSettle();

    expect(find.text('水'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('breakfast'),
      200,
      scrollable: wordList,
    );
    expect(find.text('breakfast'), findsOneWidget);
  });
}
