import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/core/usecases/usecase.dart';
import 'package:study_lingo/core/utils/failure.dart';
import 'package:study_lingo/features/settings/domain/entities/app_language.dart';
import 'package:study_lingo/features/settings/domain/usecases/load_locale.dart';
import 'package:study_lingo/features/settings/domain/usecases/save_locale.dart';
import 'package:study_lingo/features/settings/presentation/bloc/locale_cubit.dart';

class MockLoadLocaleUseCase extends Mock implements LoadLocaleUseCase {}

class MockSaveLocaleUseCase extends Mock implements SaveLocaleUseCase {}

void main() {
  late MockLoadLocaleUseCase loadLocale;
  late MockSaveLocaleUseCase saveLocale;

  setUpAll(() {
    registerFallbackValue(AppLanguage.vietnamese);
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    loadLocale = MockLoadLocaleUseCase();
    saveLocale = MockSaveLocaleUseCase();
    when(() => saveLocale(any())).thenAnswer((_) async => const Right(null));
  });

  LocaleCubit buildCubit() =>
      LocaleCubit(loadLocale: loadLocale, saveLocale: saveLocale);

  test('defaults to Vietnamese', () {
    when(
      () => loadLocale(any()),
    ).thenAnswer((_) async => const Right<Failure, AppLanguage?>(null));
    expect(buildCubit().state, AppLanguage.vietnamese);
  });

  blocTest<LocaleCubit, AppLanguage>(
    'load emits the saved language',
    setUp: () => when(() => loadLocale(any())).thenAnswer(
      (_) async => const Right<Failure, AppLanguage?>(AppLanguage.japanese),
    ),
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => [AppLanguage.japanese],
  );

  blocTest<LocaleCubit, AppLanguage>(
    'load keeps the default when nothing was saved',
    setUp: () => when(() => loadLocale(any())).thenAnswer(
      (_) async => const Right<Failure, AppLanguage?>(null),
    ),
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => const <AppLanguage>[],
  );

  blocTest<LocaleCubit, AppLanguage>(
    'select emits the language and persists it',
    build: buildCubit,
    act: (cubit) => cubit.select(AppLanguage.english),
    expect: () => [AppLanguage.english],
    verify: (_) => verify(() => saveLocale(AppLanguage.english)).called(1),
  );
}
