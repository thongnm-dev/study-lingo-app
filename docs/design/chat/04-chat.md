# 04. Chat

## Phụ lục chức năng
1. [Khái quát chức năng chính](#1-khai-quat-chuc-nang-chinh)
2. [URL](#2-url)
3. [Layout](#3-layout)
4. [Thành phần UI](#4-thanh-phan-ui)
5. [Danh sách sự kiện](#5-danh-sach-su-kien)
6. [Check nhập](#6-check-nhap)
7. [Danh sách API](#7-danh-sach-api)
8. [Interface](#8-interface)
9. [Ghi Chú Thiết Kế](#9-ghi-chu-thiet-ke)

---

## 1. Khái quát chức năng chính

### Mục đích
- Mô tả ngắn gọn chức năng chính của màn hình.

### Đối tượng sử dụng
- Ai sẽ sử dụng màn hình này và trong trường hợp nào.

### Luồng nghiệp vụ chính
1. Bước 1 của luồng chính.
2. Bước 2.
3. ...

### Điều kiện truy cập
- Route nằm trong hay ngoài `MainShell`.
- Yêu cầu auth/guest.
- Redirect rules.

### Kết quả mong muốn
- Thành công: mô tả kết quả mong muốn khi thao tác hoàn tất.
- Thất bại: mô tả xử lý khi có lỗi.

## 2. URL

| STT | Tên màn hình | Route/URL | Tham số | Ghi chú |
|---|---|---|---|---|
| 1 | Tên màn hình | `/route` | Mô tả params | Ghi chú |

## 3. Layout

### Cấu trúc tổng thể
- Scaffold có/không AppBar.
- Body structure (ListView, Column, ScrollView...).
- Padding, SafeArea...

### Trạng thái hiển thị
| Mã layout | Trạng thái | Mô tả | UI hiển thị |
|---|---|---|---|
| `#L001` | Tên trạng thái | Mô tả khi nào xảy ra | Mô tả UI |

### Thứ tự hiển thị từ trên xuống
1. Component đầu tiên.
2. Component tiếp theo.
3. ...

### Responsive/Thiết bị
- Mobile layout.
- Keyboard behavior.
- Tablet/Desktop nếu có.

## 4. Thành phần UI

| STT | Component | Loại | Bắt buộc | Mô tả | State/Variant |
|---|---|---|---|---|---|
| 1 | `ComponentName` | Widget type | Có/Không | Mô tả ngắn | Default/Focused/Error/Disabled |

### Quy tắc hiển thị dữ liệu chính
| Thành phần | Quy tắc |
|---|---|
| Component | Mô tả quy tắc hiển thị |

## 5. Danh sách sự kiện

### Bảng sự kiện
| Mã event | Sự kiện | Điều kiện kích hoạt | Check nhập | API liên quan | Kết quả chính |
|---|---|---|---|---|---|
| `#E001` | Tên sự kiện | Khi nào xảy ra | `#V001` hoặc Không | `#A001` hoặc Không | Kết quả |

### Chi tiết luồng xử lý sự kiện

#### `#E001` - Tên sự kiện (`EventClassName`)

1. Điều kiện kích hoạt:
   - Mô tả điều kiện.
2. Xử lý:
   - Bước xử lý 1.
   - Bước xử lý 2.
3. Gọi API:
   - Use case / API liên quan.
   - Dữ liệu đầu vào:
     | Field | Giá trị | Nguồn | Ghi chú |
     |---|---|---|---|
     | `field` | Giá trị | UI state | Ghi chú |
4. Kết quả xử lý:
   - **Thành công**: Mô tả.
   - **Thất bại**: Mô tả.

## 6. Check nhập

| Mã check | Trường dữ liệu | Kiểu dữ liệu | Bắt buộc | Rule kiểm tra | Message lỗi (VI) |
|---|---|---|---|---|---|
| `#V001` | `fieldName` | String | Có | Rule mô tả | `Thông báo lỗi` |

### Quy tắc hiển thị lỗi validation
- Mô tả khi nào hiển thị lỗi (sau submit, realtime...).
- Mô tả cách clear lỗi.

## 7. Danh sách API

| Mã API | API | Method | Endpoint | Use Case | Thời điểm gọi |
|---|---|---|---|---|---|
| `#A001` | Tên API | `POST/GET/PUT/DELETE` | `/endpoint` | `UseCaseName` | Khi nào gọi |

### Request `#A001`
| Field | Kiểu dữ liệu | Bắt buộc | Mô tả |
|---|---|---|---|
| `field` | String | Có | Mô tả |

### Response `#A001`
| Field | Kiểu dữ liệu | Bắt buộc | Mô tả |
|---|---|---|---|
| `field` | String | Có | Mô tả |

### Xử lý lỗi API
| Loại lỗi | Exception | Failure | Xử lý UI |
|---|---|---|---|
| Mô tả lỗi | `ExceptionClass` | `FailureClass` | Mô tả xử lý UI |

### Mock data (local development)
- Mô tả mock behavior cho local dev.

## 8. Interface

### Entity

```dart
class EntityName extends Equatable {
  final String field;

  const EntityName({required this.field});
}
```

### Use Case

```dart
class UseCaseName extends UseCase<ReturnType, ParamsType> {
  final RepositoryName repository;
  UseCaseName(this.repository);

  @override
  ResultFuture<ReturnType> call(ParamsType params) {
    return repository.method(params);
  }
}
```

### BLoC Events

```dart
abstract class BlocEvent extends Equatable {
  const BlocEvent();
}

class EventName extends BlocEvent {
  const EventName();
}
```

### BLoC State

```dart
enum StatusEnum { initial, loading, loaded, failure }

class BlocState extends Equatable {
  final StatusEnum status;
  // fields...
}
```

## 9. Ghi Chú Thiết Kế

- Ghi chú kiến trúc.
- DI wiring.
- Shared widgets.
- Styling.
- Giới hạn hiện tại.
