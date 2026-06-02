import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/writing/presentation/view/character_tracing_page.dart';
import 'package:study_lingo/features/writing/presentation/view/writing_home_page.dart';

void main() {
  testWidgets('lists scripts and opens tracing for the first character', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WritingHomePage()));

    expect(find.text('Hiragana'), findsOneWidget);
    expect(find.text('Kanji'), findsOneWidget);

    await tester.tap(find.text('Hiragana'));
    await tester.pumpAndSettle();

    expect(find.byType(CharacterTracingPage), findsOneWidget);
    // First hiragana reading is shown.
    expect(find.text('a'), findsOneWidget);
  });
}
