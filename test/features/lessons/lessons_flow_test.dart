import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/lessons/data/datasources/lessons_local_data_source.dart';
import 'package:study_lingo/features/lessons/data/repositories/lessons_repository_impl.dart';
import 'package:study_lingo/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:study_lingo/features/lessons/presentation/cubit/language_cubit.dart';
import 'package:study_lingo/features/lessons/presentation/view/overview_page.dart';
import 'package:study_lingo/features/progress/data/repositories/in_memory_progress_repository.dart';
import 'package:study_lingo/features/progress/domain/repositories/progress_repository.dart';

void main() {
  // The overview reads app-root state (LanguageCubit, shared with the
  // vocabulary filter) and the shared repositories, so the host provides them
  // above MaterialApp like main.dart does. PracticePage (reached from the promo
  // banner) needs the ProgressRepository too.
  Widget host() => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<LessonsRepository>(
        create: (_) => const LessonsRepositoryImpl(InMemoryLessonsDataSource()),
      ),
      RepositoryProvider<ProgressRepository>(
        create: (_) => InMemoryProgressRepository(),
      ),
    ],
    child: BlocProvider(
      create: (_) => LanguageCubit(),
      child: const MaterialApp(home: OverviewPage()),
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
