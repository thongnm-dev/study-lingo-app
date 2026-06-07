---
name: flutter-clean-bloc
description: |
  Develop professional mobile applications with Flutter using Clean Architecture + BLoC pattern. 
  Use this skill whenever the user needs to:
  - Generate complete project structures following Clean Architecture (presentation, domain, data layers)
  - Implement BLoC pattern for state management with best practices
  - Create repositories, use cases, entities, and models with proper dependency injection
  - Build feature-based architecture with modular, scalable design
  - Generate boilerplate code for new features (screens, BLoCs, repositories)
  - Refactor existing Flutter code to follow Clean Architecture + BLoC
  - Troubleshoot architecture or state management issues
  - Implement Equatable, Freezed, or other essential packages
  
  Trigger for any request involving Flutter architecture patterns, BLoC state management, 
  clean code principles, project structure, feature modules, or scaffolding new screens/features.
---

# # Flutter Clean Architecture + BLoC Development
> This skill enables you to scaffold, develop, and maintain Flutter applications with professional architecture. It covers the complete stack: from project initialization through feature development with Clean Architecture and BLoC pattern. Use this skill whenever you need to generate code, structure projects, or implement features following best practices in Flutter development.

## Table of Contents
1. [Project Structure Overview](#project-structure-overview)
2. [Layer Architecture](#layer-architecture)
3. [BLoC Implementation Patterns](#bloc-implementation-patterns)
4. [Dependency Injection](#dependency-injection)
5. [Common Patterns & Best Practices](#common-patterns--best-practices)
6. [Feature Scaffolding](#feature-scaffolding)

---

## Project Structure Overview

### Standard Flutter Clean Architecture Structure

```
lib/
├── app/
│   ├── app.dart                       # Root Widget
│   └── main_shell.dart                # ShellRoute, Bottom Nav
|
├── core/
|   ├── exceptions/                     # Custom exceptions
|   |   └──app_exceptions.dart
|   |
|   ├── network/                        # Dio client, Interceptors
|   |   └── dio_client.dart
|   |
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── colors.dart
|   |
│   ├── utils/                         # Helper functions, Base classes
|   |   ├── failure.dart
|   |   └── string_utils.dart
|   |
│   └── theme/                         # AppColors, AppTheme
|       ├── app_colors.dart
|       └── app_theme.dart
|
├── shared/
│   └── widgets/                       # Reusable UI (Buttons, Inputs, Dialogs)
|
├── features/                          # Feature-first modules
|    └── [feature_name]/
|        ├── data/
|        │   ├── models/                # DTOs & Mappers
|        │   └── repositories/          # Implementation
|        │
|        ├── domain/
|        │   ├── entities/              # Business Objects
|        │   ├── repositories/          # Interfaces
|        │   └── usecases/              # Single business logic units
|        │
|        └── presentation/
|            ├── bloc/                  # State & Event management
|            └── pages/                 # Screens & Feature-specific widgets
|
├── config/
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
|   |
│   ├── di/
│   │   └── service_locator.dart        # Service locator setup
|   |
│   └── providers/                      # BlocProviders, Provider setup
|       └── bloc_providers.dart
│
└── main.dart                      # Entry point
```

---

## Stack

| Layer | Công nghệ | Phiên bản tối thiểu |
|---|---|---|
| Framework | Flutter | 3.11.1+ |
| Ngôn ngữ | Dart | 3.3+ |
| State Management | flutter_bloc | 9.1.1+ |
| HTTP Client | Dio | 5.9.0+ |
| Dependency Injection | GetIt | 9.2.1+ |
| Navigation | GoRouter | 17.1.0+ |
| Form Validation | Formz | 0.8.0+ |
| Serialization | Freezed + Json Serializable | latest |
| UI Components | Flutter Material 3 | built-in |
| CI/CD | GitHub Actions | latest |

---

## Layer Architecture

### Clean Architecture Layers

### 1. **Presentation Layer** (UI + State Management) - `presentation`
Responsible for displaying data and capturing user interactions. Uses BLoC for state management.

**Key Files:**
- `*_bloc.dart` - Main BLoC class
- `*_event.dart` - Events (user actions)
- `*_state.dart` - States (UI states)
- `*_page.dart` - Full screen UI
- `*_widget.dart` - Reusable widgets

**Responsibilities:**
- Display UI components
- Capture user interactions as events
- Listen to BLoC states and rebuild UI
- No business logic, no data fetching

### 2. **Domain Layer** (Entities + Use Cases) - `domain`
Contains pure business logic independent of UI or frameworks.

**Key Files:**
- `*_entity.dart` - Core business objects (immutable)
- `*_repository.dart` - Abstract repository interface
- `*_usecase.dart` - Business logic encapsulation

**Responsibilities:**
- No Flutter imports
- Framework-agnostic
- Single responsibility
- Testable

### 3. **Data Layer** (Models + Repositories + Data Sources) - `data`
Handles data fetching from remote APIs, local database, or cache.

**Key Files:**
- `*_model.dart` - Data objects (extends entity, includes JSON mapping)
- `*_datasource.dart` - Data source interfaces and implementations
- `*_repository_impl.dart` - Repository implementation

**Responsibilities:**
- Remote: API calls
- Local: SQLite, Hive, SharedPreferences
- Cache: In-memory

## BLoC Implementation Patterns

### 1. **DIAGRAM ARCHITECTURE**

```
┌─────────────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                            │
│                  (UI + State Management)                        │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │   Page/      │  │   BLoC       │  │ BlocBuilder/ │           │
│  │   Widget     │─→│   Events     │──→ BlocListener │           │
│  │              │  │   States     │  │              │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
│         ▲               ▲                    ▲                  │
│         └───────────────┼────────────────────┘ (Depends on)     │
│                         │                                       │
└─────────────────────────┼───────────────────────────────────────┘
                          │
                          │ Uses (inject via constructor)
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                                │
│                  (Business Logic)                               │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │  Entity      │  │ Repository   │  │  UseCase     │           │
│  │ (Models +    │  │ (Interface)  │  │ (Business    │           │
│  │  Equatable)  │  │              │  │  Operations) │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
│         ▲                  ▲                    ▲               │
│         └──────────────────┼────────────────────┘               │
│                            │ No frameworks, Pure Dart           │
│                            │ Testable, Reusable                 │
└─────────────────────────────┼───────────────────────────────────┘
                              │
                              │ Uses (inject)
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DATA LAYER                                 │
│              (External Data Sources)                            │
│                                                                 │
│  ┌──────────────────────┐  ┌─────────────────────────────┐      │
│  │  Model               │  │  DataSource                 │      │
│  │ (JSON serializable)  │  │  ┌─────────────────────┐    │      │
│  │  - fromJson()        │  │  │ Remote              │    │      │
│  │  - toJson()          │  │  │ (API calls via Dio) │    │      │
│  └──────────────────────┘  │  └─────────────────────┘    │      │
│           ▲                │  ┌─────────────────────┐    │      │
│           │                │  │ Local               │    │      │
│    toEntity()              │  │ (Hive, Shared       │    │      │
│           │                │  │  Preferences)       │    │      │
│  ┌──────────────────────┐  │  └─────────────────────┘    │      │
│  │ Repository           │  │  ┌─────────────────────┐    │      │
│  │ Implementation       │──→  │ Cache               │    │      │
│  │ (Orchestrates        │  │  │ (In-memory)         │    │      │
│  │  data sources)       │  │  └─────────────────────┘    │      │
│  └──────────────────────┘  └─────────────────────────────┘      │
│         ▲                            ▲                          │
│         └────────────────────────────┘                          │
│            (Implementation of         (Provides data)           │
│             Domain interface)                                   │
└─────────────────────────────────────────────────────────────────┘
                              ▲
                              │ Calls API, Database
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   EXTERNAL SERVICES                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │  REST API    │  │   Database   │  │   Cache      │           │
│  │              │  │  (Firebase)  │  │  (Redis)     │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
└─────────────────────────────────────────────────────────────────┘
```

### 2. **BLoC Event Flow**

```
User Action (UI Event)
        │
        ▼
    ┌────────────┐
    │  BLoC      │
    │  receives  │───→ Emit Loading State
    │  Event     │
    └────────────┘
        │
        ├──────────────────┐
        │                  │
        ▼                  │
    Use Case               │
    Business Logic         │
        │                  │
        ├──────────────────┼──→ Success ──→ Emit Success State
        │                  │                  with data
        │                  │
        │                  └──→ Failure ──→ Emit Error State
        │                                    with message
        ▼
    Repository
    Data Orchestration
        │
        ├──────────────────────────────┐
        │                              │
        ▼                              ▼
    Remote DataSource            Local DataSource
    (API call via Dio)           (Cache/Database)
        │                              │
        ▼                              ▼
    Network Response              Cached Data
        │                              │
        └──────────────────┬───────────┘
                           │
                      Return Result
                      Either<Failure, T>
                           │
                ┌──────────┴──────────┐
                │                    │
                ▼                    ▼
            Left (Failure)      Right (Data)
                │                    │
                │                    └──→ Map to Entity
                │                         │
                └────────────┬────────────┘
                             │
                             ▼
                      Emit State (UI)
                             │
                             ▼
                    BlocBuilder rebuild
                      Show new data
```

## Dependency Injection
   - DI: Tất cả UseCase và Repository phải được đăng ký trong config/di/service_locator.dart
   - BLoC: Đăng ký BLoC tại config/provider/bloc_providers.dart (nếu dùng Global) hoặc cung cấp trực tiếp tại Page bằng BlocProvide
   - Routes: Tất cả màn hình mới phải có tên route trong config/router/router.dart

### 1. Service Locator Setup

```dart
// config/di/service_locator.dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Network & HTTP
  getIt.registerSingleton<DioClient>(
    DioClient(baseUrl: 'https://api.example.com'),
  );
  
  // Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );
  
  // Repositories
  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );
  
  // Use Cases
  getIt.registerFactory<LoginUseCase>(
    () => LoginUseCase(repository: getIt<AuthRepository>()),
  );
  
  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}

// main.dart
void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

```
### 2. BLoC Provider Setup

```dart
// app/config/provider/bloc_providers.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/config/di/service_locator.dart';
class BlocProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<AuthBloc>(
      create: (_) => getIt<AuthBloc>(),
    ),
    // Add more BLoCs here
  ];
}
```

---

## Common Patterns & Best Practices

### 1. Error Handling with Either (Dartz)
```dart
// Luôn return Either<Failure, Success> từ UseCase
import 'package:dartz/dartz.dart';  // or use Result package

Future<Either<Failure, List<User>>> call() async {
  try {
    final data = await dataSource.getUsers();
    return Right(data);
  } catch (e) {
    return Left(Failure(e.toString()));
  }
}
```
### 2. Reusable Use Case Base Class

```dart
// core/use_cases/usecase.dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();
  
  @override
  List<Object?> get props => [];
}
```

### 3. API Exception Handling

```dart
// core/exceptions/app_exceptions.dart
class AppException implements Exception {
  final String message;
  final int? statusCode;
  
  AppException({
    required this.message,
    this.statusCode,
  });
  
  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException({required String message, int? statusCode})
    : super(message: message, statusCode: statusCode);
}

class NetworkException extends AppException {
  NetworkException({String message = 'Network error'})
    : super(message: message);
}

class ValidationException extends AppException {
  ValidationException({required String message})
    : super(message: message);
}
```

## Feature Scaffolding
When adding a new feature like `posts`:

1. **Create directory structure:**
   ```
   features/posts/
   ├── presentation/
   │   ├── bloc/
   │   ├── pages/
   │   └── widgets/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── data/
       ├── datasources/
       ├── models/
       └── repositories/
   ```

2. **Domain Layer** (Bottom-up approach):
   - Define entities (`post_entity.dart`)
   - Define repository interface (`post_repository.dart`)
   - Create use cases (`get_posts_usecase.dart`, `create_post_usecase.dart`)

3. **Data Layer**:
   - Create models extending entities (`post_model.dart`)
   - Implement data sources (`post_remote_datasource.dart`, `post_local_datasource.dart`)
   - Implement repository (`post_repository_impl.dart`)

4. **Presentation Layer**:
   - Create BLoC (`post_bloc.dart`, `post_event.dart`, `post_state.dart`)
   - Create page widget (`posts_page.dart`)
   - Create feature-specific widgets (`post_item.dart`, `post_form.dart`)

5. **Register in DI**:
   - Add repository binding
   - Add use case binding
   - Add BLoC provider

---

### Không được làm
- KHÔNG print debug output — dùng logger package nếu cần
- KHÔNG để TODO, FIXME chưa xử lý
- KHÔNG mix BLoC + Riverpod
- KHÔNG gọi repository/usecase trực tiếp từ UI — luôn qua BLoC
- KHÔNG tạo global state — dùng GetIt service locator thay vì Provider

---

## Checklist trước khi kết thúc

- [ ] `flutter analyze` không có lỗi
- [ ] Tất cả routes đã được khai báo trong `config/router/router.dart`
- [ ] Tất cả BLoCs đã được register trong `config/provider/bloc_providers.dart`
- [ ] Tất cả services đã được setup trong `config/di/service_locator.dart`
- [ ] Không có `print()` statement hay debug code
- [ ] Không có `TODO`, `FIXME` chưa xử lý
- [ ] pubspec.yaml đã đủ toàn bộ dependencies (dio, flutter_bloc, get_it, go_router, formz)
