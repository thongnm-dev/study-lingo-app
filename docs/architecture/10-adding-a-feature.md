# 10 — Hướng dẫn thêm feature mới

Checklist 8 bước để thêm một feature mới đúng pattern. Lấy `vocabulary` làm tham chiếu khi không chắc.

## Bước 1 — Scaffolding thư mục

```
lib/features/<feature>/
├── data/
│   ├── datasources/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/        ← cả Bloc và Cubit ở đây (KHÔNG tạo presentation/cubit/)
    ├── pages/
    └── widgets/
```

## Bước 2 — Domain trước

**Entity** (pure Dart, Equatable, không Flutter):

```dart
// domain/entities/foo.dart
class Foo extends Equatable {
  const Foo({required this.id, required this.title});
  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
```

**Repository interface** (trả `Future<T>` thuần, không Either):

```dart
// domain/repositories/foo_repository.dart
abstract class FooRepository {
  Future<List<Foo>> fetchAll();
}
```

## Bước 3 — Data layer

**DataSource** (in-memory stub trước, real source sau):

```dart
// data/datasources/in_memory_foo_data_source.dart
class InMemoryFooDataSource {
  Future<List<Foo>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [Foo(id: '1', title: 'Hello')];
  }
}
```

**Repository implementation**:

```dart
// data/repositories/foo_repository_impl.dart
class FooRepositoryImpl implements FooRepository {
  FooRepositoryImpl(this._ds);
  final InMemoryFooDataSource _ds;

  @override
  Future<List<Foo>> fetchAll() => _ds.fetchAll();
}
```

## Bước 4 — Use case (mỗi method repo → 1 use case)

```dart
// domain/usecases/fetch_foos_usecase.dart
class FetchFoosUseCase extends UseCase<List<Foo>, NoParams> {
  FetchFoosUseCase(this._repo);
  final FooRepository _repo;

  @override
  Future<Either<Failure, List<Foo>>> call(NoParams _) async {
    try {
      final foos = await _repo.fetchAll();
      return Right(foos);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
```

Nếu nhiều input, tạo class `FetchFoosParams extends Equatable` bên cạnh.

## Bước 5 — Bloc/Cubit (chỉ phụ thuộc use case)

Đơn giản → Cubit, nhiều event → Bloc. Xem [03 — State management](./03-state-management.md).

```dart
// presentation/bloc/foo_cubit.dart
enum FooStatus { initial, loading, loaded, error }

class FooState extends Equatable {
  const FooState({
    this.status = FooStatus.initial,
    this.foos = const [],
    this.errorMessage,
  });
  final FooStatus status;
  final List<Foo> foos;
  final String? errorMessage;

  FooState copyWith({FooStatus? status, List<Foo>? foos, String? errorMessage}) =>
      FooState(
        status: status ?? this.status,
        foos: foos ?? this.foos,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, foos, errorMessage];
}

class FooCubit extends Cubit<FooState> {
  FooCubit({required this.fetchFoos}) : super(const FooState());
  final FetchFoosUseCase fetchFoos;

  Future<void> load() async {
    emit(state.copyWith(status: FooStatus.loading));
    final result = await fetchFoos(NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: FooStatus.error, errorMessage: f.message)),
      (foos) => emit(state.copyWith(status: FooStatus.loaded, foos: foos)),
    );
  }
}
```

## Bước 6 — Page (BlocProvider page-scope)

```dart
// presentation/pages/foo_page.dart
class FooPage extends StatelessWidget {
  const FooPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FooCubit>()..load(),
      child: const _FooView(),
    );
  }
}

class _FooView extends StatelessWidget {
  const _FooView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foo')),
      body: BlocBuilder<FooCubit, FooState>(
        builder: (context, state) => switch (state.status) {
          FooStatus.loading => const Center(child: CircularProgressIndicator()),
          FooStatus.error => ErrorRetryView(
              message: state.errorMessage,
              onRetry: () => context.read<FooCubit>().load(),
            ),
          _ => ListView(children: [for (final f in state.foos) Text(f.title)]),
        },
      ),
    );
  }
}
```

> Side-effect (navigate/snackbar) phải qua `BlocListener`, **không** trong `build`.

## Bước 7 — Đăng ký GetIt

```dart
// lib/config/di/service_locator.dart
Future<void> setupServiceLocator() async {
  // ... existing

  // 3. Data sources
  getIt.registerLazySingleton(() => InMemoryFooDataSource());

  // 4. Repositories (LAZY SINGLETON — không factory!)
  getIt.registerLazySingleton<FooRepository>(() => FooRepositoryImpl(getIt()));

  // 5. Use cases (factory)
  getIt.registerFactory(() => FetchFoosUseCase(getIt()));

  // 7. Page-scoped Bloc (factory)
  getIt.registerFactory(() => FooCubit(fetchFoos: getIt()));
}
```

Quy tắc: repository **luôn** `lazySingleton`. Xem [04 — DI](./04-dependency-injection.md) để biết vì sao.

## Bước 8 — Route

```dart
// lib/config/router/route_names.dart
abstract final class RouteNames {
  // ... existing
  static const foo = '/foo';
}

// lib/config/router/app_router.dart
GoRoute(
  path: RouteNames.foo,
  builder: (context, state) => const FooPage(),
),
```

Nếu route có argument:

```dart
// app_router.dart
class FooPageArgs {
  const FooPageArgs({required this.id});
  final String id;
}

GoRoute(
  path: RouteNames.fooDetail,
  builder: (context, state) {
    final args = state.extra! as FooPageArgs;
    return FooDetailPage(id: args.id);
  },
),

// callsite
context.push(RouteNames.fooDetail, extra: const FooPageArgs(id: '42'));
```

## Bước 9 (bonus) — Test mirror

```
test/features/<feature>/
├── domain/usecases/fetch_foos_usecase_test.dart
└── presentation/bloc/foo_cubit_test.dart
```

Mock use case (không mock repo). Pattern:

```dart
class _MockFetchFoos extends Mock implements FetchFoosUseCase {}

setUpAll(() => registerFallbackValue(NoParams()));

blocTest<FooCubit, FooState>(
  'loads foos',
  build: () {
    final m = _MockFetchFoos();
    when(() => m(any())).thenAnswer((_) async => const Right<Failure, List<Foo>>([]));
    return FooCubit(fetchFoos: m);
  },
  act: (c) => c.load(),
  expect: () => [
    const FooState(status: FooStatus.loading),
    const FooState(status: FooStatus.loaded),
  ],
);
```

Xem chi tiết tại [09 — Testing](./09-testing.md).

## Bước 10 (i18n) — nếu UI mới có text

**Chrome (vỏ UI)**: thêm key vào `app_vi.arb` (template) + `app_en.arb` + `app_ja.arb`, build lại, dùng `AppLocalizations.of(context)!.fooTitle`. **Đừng** thêm string literal mới.

**Content (học liệu)**: nếu feature mới sinh ra content được giải thích cho người học (lesson text, quiz prompt, vocab gloss…), entity phải có **trường tiếng Việt** (mẹ đẻ) song song với cặp target EN/JA. Đừng dùng pattern `subtitleIn(language)` trả về *ngôn ngữ kia trong cặp* — luôn dùng tiếng Việt làm gloss. Xem [08 — i18n](./08-localization.md).

## Self-review checklist

- [ ] Bloc inject **use case** (không phải repository).
- [ ] State là **một class duy nhất** với `status` enum + `copyWith`.
- [ ] Repository đăng ký **`lazySingleton`**, không `factory`.
- [ ] Use case bắt exception → map sang `Failure` → `Either<Failure, T>`.
- [ ] Bloc dùng `result.fold(...)`, không `try/catch`.
- [ ] Navigation qua `context.push/go` + typed `…Args`, không `Navigator.push(MaterialPageRoute)`.
- [ ] Page-scope Bloc provide trong page, không root.
- [ ] Strings UI chrome mới đi qua ARB, không hardcode.
- [ ] Content entity (nếu có) mang trường tiếng Việt làm gloss (không dùng "ngôn ngữ kia trong cặp").
- [ ] `flutter analyze` clean, `flutter test` pass.
