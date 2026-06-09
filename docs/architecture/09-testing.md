# 09 — Testing

Tests sống dưới `test/` mirror cấu trúc `lib/`. Hai loại chính:

- **Bloc/Cubit tests** với `bloc_test` + `mocktail`.
- **Widget tests** với `flutter_test`.

`flutter test` phải pass (66 tests hiện tại).

## Bloc/Cubit test — mock use case, không mock repo

Bloc chỉ biết use case → mock use case là đủ.

```dart
class _MockFetchTopics extends Mock implements FetchTopicsUseCase {}

void main() {
  late _MockFetchTopics fetchTopics;

  setUpAll(() {
    // Mọi Params custom phải register fallback để mocktail hiểu any()
    registerFallbackValue(const FetchTopicsParams(
      language: LearningLanguage.english,
      skill: LearningSkill.grammar,
    ));
  });

  setUp(() {
    fetchTopics = _MockFetchTopics();
  });

  blocTest<TopicsCubit, TopicsState>(
    'loads topics when requested',
    build: () {
      when(() => fetchTopics(any())).thenAnswer(
        (_) async => const Right<Failure, List<Topic>>([]),
      );
      return TopicsCubit(fetchTopics: fetchTopics);
    },
    act: (cubit) => cubit.load(
      language: LearningLanguage.english,
      skill: LearningSkill.grammar,
    ),
    expect: () => [
      const TopicsState(status: TopicsStatus.loading),
      const TopicsState(status: TopicsStatus.loaded, topics: []),
    ],
  );
}
```

Quy tắc:

- Stub `when(...).thenAnswer((_) async => Right<Failure, T>(...))` *hoặc* `Left<Failure, T>(failure)` — kiểu generic phải đầy đủ.
- `registerFallbackValue` cho **mọi** `Params` class (mỗi class một lần ở `setUpAll`).
- **Không** `try/catch` trong test — Bloc đã fold, exception ở đây = bug.

### Test lỗi

```dart
blocTest<TopicsCubit, TopicsState>(
  'emits error on failure',
  build: () {
    when(() => fetchTopics(any())).thenAnswer(
      (_) async => const Left<Failure, List<Topic>>(ServerFailure('boom')),
    );
    return TopicsCubit(fetchTopics: fetchTopics);
  },
  act: (cubit) => cubit.load(...),
  expect: () => [
    isA<TopicsState>().having((s) => s.status, 'status', TopicsStatus.loading),
    isA<TopicsState>()
      .having((s) => s.status, 'status', TopicsStatus.error)
      .having((s) => s.errorMessage, 'errorMessage', 'boom'),
  ],
);
```

## Widget test — cần GetIt + (thường) GoRouter

### 1. GetIt: dùng helper test_di

```dart
// test/helpers/test_di.dart cung cấp:
useTestServiceLocator(); // setUp + tearDown trong group/test
```

Helper này:

- Gọi `setupServiceLocator()` trước mỗi test.
- Gọi `resetServiceLocator()` trong tearDown → singleton không leak giữa test.

Dùng:

```dart
void main() {
  setUp(useTestServiceLocator);

  testWidgets('VocabularyPage shows loading', (tester) async { ... });
}
```

### 2. GoRouter: dùng `buildTestRouter` + `materialAppRouter`

Đừng dùng `appRouter` thật — auth redirect sẽ phá test. Helper tại `test/helpers/test_router.dart`:

```dart
final router = buildTestRouter(
  home: const TopicsPage(language: LearningLanguage.english, skill: LearningSkill.grammar),
  extraRoutes: [
    GoRoute(
      path: RouteNames.lessons,
      builder: (_, state) => const _FakeLessonsPage(),
    ),
  ],
);

await tester.pumpWidget(materialAppRouter(router: router));
```

`materialAppRouter` đặt sẵn:

- `locale: const Locale('vi')`.
- `localizationsDelegates` + `supportedLocales` của `AppLocalizations`.

→ Test assert trên localized string sẽ deterministic.

### 3. Override một service cho test cụ thể

Khi cần stub một bloc/use case trong widget test:

```dart
setUp(() {
  useTestServiceLocator();
  getIt.unregister<VocabularyBloc>();
  getIt.registerFactory<VocabularyBloc>(() => _FakeVocabularyBloc());
});
```

## Pattern hay dùng

| Cần | Cách |
|---|---|
| Pump 1 page có Bloc inline | `BlocProvider(create: (_) => getIt<XBloc>())` trong page; chỉ `pumpWidget(MaterialApp(home: page))` |
| Pump 1 page có dùng app-wide bloc | Bọc thêm `BlocProvider.value(value: getIt<LanguageCubit>())` ở test |
| Assert navigation đã xảy ra | `extraRoutes` chứa `_FakeNextPage` có `Key`, sau khi tap → `expect(find.byKey(...), findsOneWidget)` |
| Assert localized text | `await tester.pumpAndSettle()` trước assert; dùng đúng locale `vi` |

## Coverage

```bash
flutter test --coverage
# tạo coverage/lcov.info
```

## Khi test fail vì bloc đang loading "mãi mãi"

Thường là vì `when(() => useCase(any())).thenAnswer(...)` chưa stub đúng nhánh được gọi, hoặc `registerFallbackValue` cho `Params` bị thiếu → `any()` không match → mocktail trả `Future<void>` → bloc treo loading. Check 2 thứ đó trước.
