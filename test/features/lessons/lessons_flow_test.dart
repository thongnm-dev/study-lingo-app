import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/lessons/data/datasources/lessons_local_data_source.dart';
import 'package:study_lingo/features/lessons/data/repositories/lessons_repository_impl.dart';
import 'package:study_lingo/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:study_lingo/features/lessons/presentation/cubit/language_cubit.dart';
import 'package:study_lingo/features/lessons/presentation/view/lessons_tab_page.dart';

void main() {
  // LanguageCubit is app-root state (shared with the vocabulary filter), so
  // the host provides it above MaterialApp like main.dart does.
  Widget host() => RepositoryProvider<LessonsRepository>(
    create: (_) => const LessonsRepositoryImpl(InMemoryLessonsDataSource()),
    child: BlocProvider(
      create: (_) => LanguageCubit(),
      child: const MaterialApp(home: LessonsTabPage()),
    ),
  );

  testWidgets('language → skill → topics flow', (tester) async {
    await tester.pumpWidget(host());

    // Step 1: language picker.
    expect(find.text('Bạn muốn học gì?'), findsOneWidget);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Step 2: the five skill tracks.
    expect(find.text('Học Tiếng Anh'), findsOneWidget);
    for (final label in ['Ngữ pháp', 'Từ vựng', 'Nghe nói', 'Đọc', 'Viết']) {
      expect(find.text(label), findsOneWidget);
    }

    // Step 3: tapping a skill shows its topics.
    await tester.tap(find.text('Từ vựng'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Từ vựng'), findsOneWidget);
    expect(find.text('Greetings'), findsOneWidget);
    expect(find.text('Food & Drink'), findsOneWidget);
  });
}
