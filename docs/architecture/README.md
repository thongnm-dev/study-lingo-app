# Architecture — Study Lingo

Tài liệu kiến trúc cho ứng dụng học **tiếng Anh và tiếng Nhật** Study Lingo. Mục tiêu của tài liệu này là cung cấp một bản đồ rõ ràng để bất kỳ ai (cả người mới và Claude Code) có thể nhanh chóng nắm được cách codebase được tổ chức và lý do tại sao.

> Stack: **Flutter 3.41.x / Dart 3.11.x** · **BLoC** · **GetIt** · **GoRouter** · **dartz (Either/Failure)** · **Dio** · **Material 3**

## Nội dung

| Tài liệu | Mô tả |
|---|---|
| [01 — Tổng quan](./01-overview.md) | Big picture: stack, nguyên tắc, sơ đồ phụ thuộc tổng. |
| [02 — Clean Architecture & các lớp](./02-clean-architecture.md) | Cấu trúc `domain` / `data` / `presentation` của mỗi feature. |
| [03 — State management (BLoC)](./03-state-management.md) | Khi nào dùng Bloc vs Cubit, quy tắc immutable state. |
| [04 — Dependency Injection (GetIt)](./04-dependency-injection.md) | Cách register/resolve, lifetime của từng loại service. |
| [05 — Routing (GoRouter)](./05-routing.md) | Auth gate, StatefulShellRoute, typed extras. |
| [06 — Error handling (Either / Failure)](./06-error-handling.md) | Use case wraps repo → `Either<Failure, T>` → bloc fold. |
| [07 — Tính năng (feature map)](./07-feature-map.md) | Tóm tắt từng feature, cách chúng kết nối qua singleton. |
| [08 — Đa ngôn ngữ (i18n)](./08-localization.md) | App chrome (ARB) vs học liệu (data layer), `LocaleCubit`. |
| [09 — Testing](./09-testing.md) | Mock use case, GetIt test helper, GoRouter test helper. |
| [10 — Hướng dẫn thêm feature mới](./10-adding-a-feature.md) | Quy trình 8 bước từ entity → bloc → route → test. |

## Yêu cầu nền

Trước khi đọc các tài liệu chi tiết, hãy đảm bảo đã đọc [CLAUDE.md](../../CLAUDE.md) ở root project — nó là nguồn sự thật về định hướng (BLoC bắt buộc, không Provider/Riverpod, không `Navigator.push(MaterialPageRoute)`,...).

## Quy ước tài liệu

- Đường dẫn code dùng định dạng `lib/...` tính từ project root.
- Tham chiếu file kèm số dòng theo dạng `path/to/file.dart:LINE` khi cần chỉ chính xác.
- Sơ đồ Mermaid để có thể render trực tiếp trên GitHub.
