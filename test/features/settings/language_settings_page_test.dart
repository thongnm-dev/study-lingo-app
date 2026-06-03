import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_lingo/features/settings/data/repositories/in_memory_locale_repository.dart';
import 'package:study_lingo/features/settings/domain/entities/app_language.dart';
import 'package:study_lingo/features/settings/presentation/cubit/locale_cubit.dart';
import 'package:study_lingo/features/settings/presentation/view/language_settings_page.dart';
import 'package:study_lingo/l10n/generated/app_localizations.dart';

void main() {
  late InMemoryLocaleRepository repository;

  setUp(() => repository = InMemoryLocaleRepository());

  // Mirrors the main.dart wiring: MaterialApp.locale follows the root
  // LocaleCubit, so picking a language re-localizes the UI live.
  Widget host() => BlocProvider(
    create: (_) => LocaleCubit(repository),
    child: BlocBuilder<LocaleCubit, AppLanguage>(
      builder: (context, language) => MaterialApp(
        locale: Locale(language.code),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LanguageSettingsPage(),
      ),
    ),
  );

  testWidgets('lists every language by its native name with the current one '
      'checked', (tester) async {
    await tester.pumpWidget(host());

    expect(find.text('Ngôn ngữ hiển thị'), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);

    final checked = tester.widget<ListTile>(
      find.widgetWithText(ListTile, 'Tiếng Việt'),
    );
    expect(checked.trailing, isNotNull);
  });

  testWidgets(
    'picking a language re-localizes the UI and persists the choice',
    (tester) async {
      await tester.pumpWidget(host());

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      // The screen title now renders from the English ARB.
      expect(find.text('Display language'), findsOneWidget);
      expect(find.text('Ngôn ngữ hiển thị'), findsNothing);
      expect(await repository.load(), AppLanguage.english);

      await tester.tap(find.text('日本語'));
      await tester.pumpAndSettle();

      expect(find.text('表示言語'), findsOneWidget);
      expect(await repository.load(), AppLanguage.japanese);
    },
  );
}
