# 03 — State management (BLoC)

State management là **`flutter_bloc`**. Ràng buộc cứng: không Provider/Riverpod/GetX/setState cho business logic.

## Bloc vs Cubit — chọn cái nào?

| Tiêu chí | Cubit | Bloc |
|---|---|---|
| Triggers | 1–2 hành động đơn giản | Nhiều event riêng biệt |
| Use case | Load list, hold settings, derive value | Form nhiều bước, quiz nhiều câu, flow OTP |
| Cấu trúc file | 1 file (`x_cubit.dart` chứa cả `XState`) | 3 file `part`: `x_bloc.dart` + `x_event.dart` + `x_state.dart` |
| Audit trail | Không cần | Cần (debug từng event) |

### Cubit hiện có

`TopicsCubit`, `LessonsCubit`, `ProgressCubit`, `RemindersCubit`, `KanjiListCubit`, `WritingPracticeCubit`, `ProfileStatsCubit`, `LocaleCubit`, `LanguageCubit`.

### Bloc hiện có

`QuizBloc`, `AuthBloc`, `ForgotPasswordBloc`, `VocabularyBloc`.

## State — một class duy nhất, immutable, có status

```dart
class VocabularyState extends Equatable {
  const VocabularyState({
    this.status = VocabularyStatus.initial,
    this.words = const [],
    this.language,
    this.jlptLevel,
    this.errorMessage,
  });

  final VocabularyStatus status;       // initial / loading / loaded / error
  final List<VocabularyWord> words;
  final LearningLanguage? language;
  final JlptLevel? jlptLevel;
  final String? errorMessage;

  VocabularyState copyWith({...});

  @override
  List<Object?> get props => [status, words, language, jlptLevel, errorMessage];
}
```

Quy tắc:

- **Một class duy nhất** cho cả Bloc (không tạo `XLoading` / `XLoaded` / `XError` thành nhiều class — dùng `status` enum).
- **`Equatable`** để `BlocBuilder` rebuild đúng lúc.
- **`copyWith`** cho mọi field.
- UI switch trên `status`, không trên `null` của field.

## Hành vi của bloc

```dart
class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  VocabularyBloc({required this.fetchWords}) : super(const VocabularyState()) {
    on<VocabularyRequested>(_onRequested);
    on<VocabularyLanguageChanged>(_onLanguageChanged);
  }

  final FetchVocabularyWordsUseCase fetchWords;

  Future<void> _onRequested(
    VocabularyRequested event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(state.copyWith(status: VocabularyStatus.loading));
    final result = await fetchWords(
      FetchVocabularyWordsParams(language: event.language, jlptLevel: event.jlptLevel),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: VocabularyStatus.error,
        errorMessage: failure.message,
      )),
      (words) => emit(state.copyWith(
        status: VocabularyStatus.loaded,
        words: words,
      )),
    );
  }
}
```

Điểm quan trọng:

- Bloc chỉ phụ thuộc **use case** — inject qua named parameter khi ≥ 3 dep.
- Mọi nhánh dùng `result.fold(...)` để chuyển `Failure` → state lỗi.
- **Không** `try/catch` quanh repository — đó là việc của use case.

## Side-effect ở UI (Listener, không Builder)

```dart
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state.status == AuthStatus.success) {
      getIt<CurrentUser>().value = state.user;
      context.go(RouteNames.overview);
    } else if (state.status == AuthStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Có lỗi')),
      );
    }
  },
  builder: (context, state) => /* form */,
);
```

Quy tắc vàng:

- Navigate / SnackBar / Dialog / write `CurrentUser` → **`BlocListener`**.
- Render UI → **`BlocBuilder`** / **`BlocSelector`**.
- **Không** đặt `context.push` trong `build`.

## Bloc app-wide vs bloc theo trang

| Loại | Đăng ký GetIt | Provide ở đâu |
|---|---|---|
| App-wide (`LocaleCubit`, `LanguageCubit`) | `registerLazySingleton` | `AppBlocProviders.providers` → bọc `MaterialApp.router` |
| Page-scope | `registerFactory` | `BlocProvider(create: (_) => getIt<XBloc>())` ngay trong page |
| Theo tham số (`QuizBloc(lesson)`) | `registerFactoryParam<Bloc, Lesson, void>` | `getIt<QuizBloc>(param1: lesson)` |

Xem chi tiết tại [04 — DI](./04-dependency-injection.md).

## Đặc thù `QuizBloc` (event-driven flow)

`QuizBloc` được seed bằng một `Lesson` + `RecordLessonCompletedUseCase`:

```
QuizAnswerSelected(choice)  ─► lock đáp án + tally đúng/sai
QuizAdvanced()              ─► sang câu kế hoặc:
                              nếu hết: status = finished
                                       + gọi RecordLessonCompletedUseCase
                                       (XP = correct × xpPerCorrectAnswer)
```

Vì `ProgressRepository` là singleton, `ProgressCubit` (Progress tab) và `ProfileStatsCubit` đang subscribe `watch()` sẽ tự nhận update — feature nói chuyện qua *state shared*, không phải qua bloc-to-bloc.

## Đặc thù tracing (writing) — state cục bộ là OK

`WritingPracticeCubit` giữ list ký tự và index hiện tại. Nhưng **các nét vẽ tay** lại là `StatefulWidget` cục bộ trong `_TracingView` — dữ liệu pointer tần suất cao **không nên** đẩy vào Cubit. Khi index đổi, `BlocConsumer.listener` xoá nét cục bộ. Đây là exception có chủ đích của quy tắc "logic luôn ở Bloc": *state UI thuần không phải business logic*.
