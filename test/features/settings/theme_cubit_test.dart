import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/core/usecases/usecase.dart';
import 'package:study_lingo/core/utils/failure.dart';
import 'package:study_lingo/features/settings/domain/entities/app_theme_mode.dart';
import 'package:study_lingo/features/settings/domain/usecases/load_theme.dart';
import 'package:study_lingo/features/settings/domain/usecases/save_theme.dart';
import 'package:study_lingo/features/settings/presentation/bloc/theme_cubit.dart';

class MockLoadThemeUseCase extends Mock implements LoadThemeUseCase {}

class MockSaveThemeUseCase extends Mock implements SaveThemeUseCase {}

void main() {
  late MockLoadThemeUseCase loadTheme;
  late MockSaveThemeUseCase saveTheme;

  setUpAll(() {
    registerFallbackValue(AppThemeMode.light);
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    loadTheme = MockLoadThemeUseCase();
    saveTheme = MockSaveThemeUseCase();
    when(() => saveTheme(any())).thenAnswer((_) async => const Right(null));
  });

  ThemeCubit buildCubit() =>
      ThemeCubit(loadTheme: loadTheme, saveTheme: saveTheme);

  test('defaults to light', () {
    when(
      () => loadTheme(any()),
    ).thenAnswer((_) async => const Right<Failure, AppThemeMode?>(null));
    expect(buildCubit().state, AppThemeMode.light);
  });

  blocTest<ThemeCubit, AppThemeMode>(
    'load emits the saved mode',
    setUp: () => when(() => loadTheme(any())).thenAnswer(
      (_) async => const Right<Failure, AppThemeMode?>(AppThemeMode.dark),
    ),
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => [AppThemeMode.dark],
  );

  blocTest<ThemeCubit, AppThemeMode>(
    'load keeps the default when nothing was saved',
    setUp: () => when(() => loadTheme(any())).thenAnswer(
      (_) async => const Right<Failure, AppThemeMode?>(null),
    ),
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => const <AppThemeMode>[],
  );

  blocTest<ThemeCubit, AppThemeMode>(
    'select emits the mode and persists it',
    build: buildCubit,
    act: (cubit) => cubit.select(AppThemeMode.dark),
    expect: () => [AppThemeMode.dark],
    verify: (_) => verify(() => saveTheme(AppThemeMode.dark)).called(1),
  );

  blocTest<ThemeCubit, AppThemeMode>(
    'toggle flips light → dark → light and persists each step',
    build: buildCubit,
    act: (cubit) async {
      await cubit.toggle();
      await cubit.toggle();
    },
    expect: () => [AppThemeMode.dark, AppThemeMode.light],
    verify: (_) {
      verify(() => saveTheme(AppThemeMode.dark)).called(1);
      verify(() => saveTheme(AppThemeMode.light)).called(1);
    },
  );
}
