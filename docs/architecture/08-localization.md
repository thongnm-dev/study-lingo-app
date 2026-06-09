# 08 — Đa ngôn ngữ (i18n)

Trong app có **ba trục ngôn ngữ** tách biệt — đừng nhầm chúng:

| Trục | Là gì | Lưu ở đâu | Enum / hằng số |
|---|---|---|---|
| **App chrome l10n** | Nút, label, screen title của *vỏ ứng dụng* | `lib/l10n/*.arb` (gen-l10n) | `AppLanguage` (settings/domain) |
| **Learning target** | Ngôn ngữ user *đang học* (deck) | Trong data layer (seed / API) | `LearningLanguage` (lessons/domain) |
| **Mother tongue (mẹ đẻ)** | Ngôn ngữ *giải thích* — gloss, translation, prompt câu hỏi | Trong data layer, đi kèm content | Hằng `vi` (tiếng Việt) — chưa cần enum |

- `AppLanguage`: user cá nhân hoá UI (chrome có thể là vi/en/ja).
- `LearningLanguage`: deck (English hay Japanese).
- **Mother tongue**: hôm nay là **tiếng Việt cố định** — khi user học EN hoặc JA, mọi giải thích/nghĩa từ/prompt quiz đều bằng tiếng Việt, **không** phải bằng "ngôn ngữ kia trong cặp".

## Quy tắc mẹ đẻ (mother tongue rule)

Người dùng app là người Việt học ngoại ngữ. Vì vậy:

- **Vocabulary card**: dòng chính là target (EN hoặc JA), dòng phụ (gloss/nghĩa) là **tiếng Việt**. Không phải "EN nếu deck JA, JA nếu deck EN" như trước.
- **Topic / Lesson title**: dòng chính bằng target language; dòng phụ bằng **tiếng Việt**.
- **Quiz prompt + explanation**: data layer sản xuất bằng **tiếng Việt** khi giải thích về từ/cấu trúc target. Đáp án và lựa chọn vẫn ở target language (đó là cái user phải nhận diện).
- **Furigana / romaji / JLPT**: vẫn chỉ áp cho deck Nhật — chúng *bổ sung* gloss tiếng Việt, không thay thế.

### Hệ quả thiết kế entity

Schema entity content phải mang **trường tiếng Việt** song song, không dùng pattern "trường kia của cặp":

```dart
// Thay vì:
class Lesson {
  final String titleEn;
  final String titleJa;
  String titleIn(LearningLanguage l) => l == japanese ? titleJa : titleEn;
  String subtitleIn(LearningLanguage l) => l == japanese ? titleEn : titleJa; // ❌
}

// Đúng:
class Lesson {
  final String titleEn;
  final String titleJa;
  final String titleVi;                                                       // ✅
  String titleIn(LearningLanguage l) => l == japanese ? titleJa : titleEn;
  String get gloss => titleVi;
}
```

Tương tự cho `Topic`, `VocabularyWord` (cần `vietnamese`, `exampleVi`), `QuizQuestion` (prompt/explanation tiếng Việt).

> **Trạng thái hiện tại (2026-06-09)**: entities trong `lessons/domain/entities/` và `vocabulary/domain/entities/` mới có cặp EN/JA, chưa có trường tiếng Việt. Đây là gap đã biết — cần migrate khi đụng vào content schema.

## App chrome (vỏ app) — `flutter_localizations` + gen-l10n

## App chrome (vỏ app) — `flutter_localizations` + gen-l10n

- ARB files: `lib/l10n/app_vi.arb` (template/default), `app_en.arb`, `app_ja.arb`.
- Config: `l10n.yaml` ở root.
- Generated: `lib/l10n/generated/` (regenerate khi `flutter gen-l10n` hoặc bất kỳ build nào — `generate: true` trong pubspec).
- Cách dùng trong widget:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ...
Text(AppLocalizations.of(context)!.navOverview);
```

### Đã localize cho đến hiện tại

- Bottom nav.
- Settings + placeholder.
- More menu (label qua `MoreMenuEntry.labelOf`).
- Profile.
- Vocabulary chrome.

### Quy tắc khi đụng vào màn hình **chưa** localize

> Khi sửa một màn hình còn hardcode tiếng Việt, **migrate sang ARB ngay khi đụng vào** — đừng thêm string literal mới.

## `LocaleCubit` — state app-wide

`LocaleCubit` (`Cubit<AppLanguage>`, default `AppLanguage.vietnamese`) là app-wide state thật sự nên đăng ký **lazy singleton** trong GetIt:

```dart
// service_locator.dart
getIt.registerLazySingleton<LocaleCubit>(
  () => LocaleCubit(loadLocale: getIt(), saveLocale: getIt())..load(),
);
```

`..load()` chạy ngay khi resolve lần đầu để app phục hồi ngôn ngữ đã chọn trước khi `MaterialApp.router` render.

Expose vào widget tree qua `AppBlocProviders`:

```dart
// config/provider/bloc_providers.dart
abstract final class AppBlocProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
    BlocProvider<LanguageCubit>.value(value: getIt<LanguageCubit>()),
  ];
}
```

`StudyLingoApp` có `BlocBuilder<LocaleCubit, AppLanguage>` feed thẳng `locale` vào `MaterialApp.router`:

```dart
BlocBuilder<LocaleCubit, AppLanguage>(
  builder: (context, lang) => MaterialApp.router(
    locale: lang.toLocale(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: appRouter,
  ),
);
```

Đổi ngôn ngữ trong `Settings → Ngôn ngữ hiển thị` = **toàn bộ UI re-localize live**.

## Persist trên đĩa

Hôm nay: `InMemoryLocaleRepository` (mất khi restart).

Đi live: viết `SharedPreferencesLocaleRepository` (hoặc tương tự) implement `LocaleRepository` → đổi đăng ký trong `service_locator.dart`. UC/Cubit/UI không cần sửa.

## Learning content — không nhầm với chrome

Học liệu (từ, câu, lesson) **không** đi qua ARB. Chúng ở data layer như bất kỳ data nào khác:

- `VocabularyWord` có field target (EN/JA) + **tiếng Việt** (mẹ đẻ) + furigana/romaji cho deck Nhật.
- `Topic` / `Lesson` có `titleIn(language)` (target) và gloss tiếng Việt là dòng phụ.
- Seed data chia theo `LearningLanguage` (`_japaneseTargetLessons` / `_englishTargetLessons`), trong mỗi entry đều kèm tiếng Việt.

→ Khi nhúng vào ARB, sẽ rất khó scale (mỗi từ vựng mới = mỗi key ARB).

## Đặc thù tiếng Nhật cần lo từ đầu

- Furigana (annotation lên kanji): render trong `VocabularyCard` cho JA (bổ sung cho gloss tiếng Việt, không thay thế).
- JLPT level: tag từ vựng (`JlptLevel?`); filter ở `FetchVocabularyWordsUseCase`.
- Stroke order: dữ liệu trong `stroke_order_data.dart`, dùng ở writing/tracing.
- Font hỗ trợ CJK: được set trong theme (`core/theme/app_theme.dart`).

→ Đừng tách "thêm Japanese sau" — retrofit cả ba thứ trên rất đắt.

## Tương lai — khi mẹ đẻ cần cấu hình

Hôm nay mẹ đẻ là hằng `vi`. Nếu sau này muốn hỗ trợ người Khmer/Thái học EN/JA, hãy:

1. Tạo `MotherTongue` enum trong `core/` (hoặc `settings/domain/`).
2. Thêm `MotherTongueCubit` app-wide (lazySingleton, persist như `LocaleCubit`).
3. Content entity đổi `titleVi` → `Map<MotherTongue, String> gloss` hoặc tách trường theo ngôn ngữ.
4. Use case fetch content nhận thêm `MotherTongue` param.

Nhưng đừng làm sớm — `AppLanguage` cố ý không trùng `MotherTongue` (user Việt có thể đặt UI bằng English mà vẫn muốn gloss tiếng Việt). YAGNI cho đến khi xuất khẩu thật.

## Trong test

Mọi widget test pump page đã localize **phải**:

```dart
testWidgets('...', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('vi'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const PageUnderTest(),
    ),
  );
});
```

`buildTestRouter(...)` + `materialAppRouter(...)` đã đặt sẵn — xem [09 — Testing](./09-testing.md).
