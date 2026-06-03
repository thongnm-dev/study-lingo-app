import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/features/settings/domain/entities/app_language.dart';
import 'package:study_lingo/features/settings/domain/repositories/locale_repository.dart';
import 'package:study_lingo/features/settings/presentation/cubit/locale_cubit.dart';

class MockLocaleRepository extends Mock implements LocaleRepository {}

void main() {
  late MockLocaleRepository repository;

  setUpAll(() => registerFallbackValue(AppLanguage.vietnamese));

  setUp(() {
    repository = MockLocaleRepository();
    when(() => repository.save(any())).thenAnswer((_) async {});
  });

  test('defaults to Vietnamese', () {
    when(() => repository.load()).thenAnswer((_) async => null);
    expect(LocaleCubit(repository).state, AppLanguage.vietnamese);
  });

  blocTest<LocaleCubit, AppLanguage>(
    'load emits the saved language',
    setUp: () => when(
      () => repository.load(),
    ).thenAnswer((_) async => AppLanguage.japanese),
    build: () => LocaleCubit(repository),
    act: (cubit) => cubit.load(),
    expect: () => [AppLanguage.japanese],
  );

  blocTest<LocaleCubit, AppLanguage>(
    'load keeps the default when nothing was saved',
    setUp: () => when(() => repository.load()).thenAnswer((_) async => null),
    build: () => LocaleCubit(repository),
    act: (cubit) => cubit.load(),
    expect: () => const <AppLanguage>[],
  );

  blocTest<LocaleCubit, AppLanguage>(
    'select emits the language and persists it',
    build: () => LocaleCubit(repository),
    act: (cubit) => cubit.select(AppLanguage.english),
    expect: () => [AppLanguage.english],
    verify: (_) => verify(() => repository.save(AppLanguage.english)).called(1),
  );
}
