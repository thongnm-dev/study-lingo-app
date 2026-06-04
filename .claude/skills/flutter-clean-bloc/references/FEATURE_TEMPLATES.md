# Feature Scaffolding Templates

## Quick Copy-Paste Templates for New Features

### 1. Entity Template

```dart
// features/{feature}/domain/entities/{feature}_entity.dart
import 'package:equatable/equatable.dart';

class {FeatureEntity} extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;

  const {FeatureEntity}({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, createdAt];
}
```

### 2. Repository Interface Template

```dart
// features/{feature}/domain/repositories/{feature}_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/{feature}_entity.dart';

abstract class {FeatureRepository} {
  Future<Either<Failure, List<{FeatureEntity}>>> getAll();
  
  Future<Either<Failure, {FeatureEntity}>> getById(int id);
  
  Future<Either<Failure, {FeatureEntity}>> create({FeatureEntity} entity);
  
  Future<Either<Failure, {FeatureEntity}>> update({FeatureEntity} entity);
  
  Future<Either<Failure, void>> delete(int id);
}
```

### 3. UseCase Template

```dart
// features/{feature}/domain/usecases/get_{feature}_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:your_app/core/usecases/usecase.dart';
import '../entities/{feature}_entity.dart';
import '../repositories/{feature}_repository.dart';

class Get{FeatureUseCase} implements UseCase<List<{FeatureEntity}>, NoParams> {
  final {FeatureRepository} repository;

  Get{FeatureUseCase}({required this.repository});

  @override
  Future<Either<Failure, List<{FeatureEntity}>>> call(NoParams params) {
    return repository.getAll();
  }
}
```

### 4. Model Template (Freezed)

```dart
// features/{feature}/data/models/{feature}_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/{feature}_entity.dart';

part '{feature}_model.freezed.dart';
part '{feature}_model.g.dart';

@freezed
class {FeatureModel} with _${FeatureModel} {
  const factory {FeatureModel}({
    required int id,
    required String title,
    required String description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _{FeatureModel};

  factory {FeatureModel}.fromJson(Map<String, dynamic> json) =>
      _${FeatureModel}FromJson(json);
}

extension {FeatureModelX} on {FeatureModel} {
  {FeatureEntity} toEntity() => {FeatureEntity}(
    id: id,
    title: title,
    description: description,
    createdAt: createdAt,
  );
}
```

### 5. Remote DataSource Template

```dart
// features/{feature}/data/datasources/{feature}_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../domain/entities/{feature}_entity.dart';
import '../models/{feature}_model.dart';
import 'package:your_app/core/network/dio_client.dart';

abstract class {FeatureRemoteDataSource} {
  Future<List<{FeatureModel}>> getAll();
  
  Future<{FeatureModel}> getById(int id);
  
  Future<{FeatureModel}> create({FeatureModel} model);
  
  Future<{FeatureModel}> update({FeatureModel} model);
  
  Future<void> delete(int id);
}

class {FeatureRemoteDataSourceImpl} implements {FeatureRemoteDataSource} {
  final ApiClient apiClient;
  static const String _endpoint = '/api/{features}';

  {FeatureRemoteDataSourceImpl}({required this.apiClient});

  @override
  Future<List<{FeatureModel}>> getAll() async {
    try {
      final response = await apiClient.get(_endpoint);
      final data = response.data as List;
      return data.map((e) => {FeatureModel}.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<{FeatureModel}> getById(int id) async {
    try {
      final response = await apiClient.get('$_endpoint/$id');
      return {FeatureModel}.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<{FeatureModel}> create({FeatureModel} model) async {
    try {
      final response = await apiClient.post(
        _endpoint,
        data: model.toJson(),
      );
      return {FeatureModel}.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<{FeatureModel}> update({FeatureModel} model) async {
    try {
      final response = await apiClient.put(
        '$_endpoint/${model.id}',
        data: model.toJson(),
      );
      return {FeatureModel}.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await apiClient.delete('$_endpoint/$id');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.response?.statusCode == 404) {
      return Exception('Not found');
    }
    return Exception('Network error: ${e.message}');
  }
}
```

### 6. Repository Implementation Template

```dart
// features/{feature}/data/repositories/{feature}_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/failures.dart';
import '../../domain/entities/{feature}_entity.dart';
import '../../domain/repositories/{feature}_repository.dart';
import '../datasources/{feature}_remote_datasource.dart';
import '../models/{feature}_model.dart';

class {FeatureRepositoryImpl} implements {FeatureRepository} {
  final {FeatureRemoteDataSource} remoteDataSource;

  {FeatureRepositoryImpl}({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<{FeatureEntity}>>> getAll() async {
    try {
      final models = await remoteDataSource.getAll();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch {features}: $e'));
    }
  }

  @override
  Future<Either<Failure, {FeatureEntity}>> getById(int id) async {
    try {
      final model = await remoteDataSource.getById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to fetch {feature}: $e'));
    }
  }

  @override
  Future<Either<Failure, {FeatureEntity}>> create({FeatureEntity} entity) async {
    try {
      final model = {FeatureModel}(
        id: 0,
        title: entity.title,
        description: entity.description,
        createdAt: entity.createdAt,
      );
      final result = await remoteDataSource.create(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to create {feature}: $e'));
    }
  }

  @override
  Future<Either<Failure, {FeatureEntity}>> update({FeatureEntity} entity) async {
    try {
      final model = {FeatureModel}(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        createdAt: entity.createdAt,
      );
      final result = await remoteDataSource.update(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to update {feature}: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) async {
    try {
      await remoteDataSource.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete {feature}: $e'));
    }
  }
}
```

### 7. BLoC Template (Freezed)

```dart
// features/{feature}/presentation/bloc/{feature}_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/{feature}_entity.dart';
import '../../domain/usecases/{feature}_usecase.dart';
import 'package:your_app/core/usecases/usecase.dart';

part '{feature}_event.dart';
part '{feature}_state.dart';
part '{feature}_bloc.freezed.dart';

class {FeatureBloc} extends Bloc<{FeatureEvent}, {FeatureState}> {
  final Get{FeatureUseCase} get{FeatureUseCase};

  {FeatureBloc}({
    required this.get{FeatureUseCase},
  }) : super(const {FeatureState}.initial()) {
    on<_Fetch{FeatureUseCase}>(_onFetch{FeatureUseCase});
  }

  Future<void> _onFetch{FeatureUseCase}(
    _Fetch{FeatureUseCase} event,
    Emitter<{FeatureState}> emit,
  ) async {
    emit(const {FeatureState}.loading());
    
    final result = await get{FeatureUseCase}(NoParams());
    
    result.fold(
      (failure) => emit({FeatureState}.error(message: failure.message)),
      (data) => emit({FeatureState}.success(items: data)),
    );
  }
}

// {feature}_event.dart
part of '{feature}_bloc.dart';

@freezed
class {FeatureEvent} with _${FeatureEvent} {
  const factory {FeatureEvent}.fetch() = _Fetch{FeatureUseCase};
}

// {feature}_state.dart
part of '{feature}_bloc.dart';

@freezed
class {FeatureState} with _${FeatureState} {
  const factory {FeatureState}.initial() = _Initial;
  
  const factory {FeatureState}.loading() = _Loading;
  
  const factory {FeatureState}.success({
    required List<{FeatureEntity}> items,
  }) = _Success;
  
  const factory {FeatureState}.error({
    required String message,
  }) = _Error;
}
```

### 8. Page Template

```dart
// features/{feature}/presentation/pages/{feature}_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/{feature}_bloc.dart';
import '../widgets/{feature}_item.dart';

class {FeaturePage} extends StatelessWidget {
  const {FeaturePage}({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{Feature} List'),
      ),
      body: BlocListener<{FeatureBloc}, {FeatureState}>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            orElse: () {},
          );
        },
        child: BlocBuilder<{FeatureBloc}, {FeatureState}>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              success: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text('No {features} found'),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return {FeatureItem}(item: items[index]);
                  },
                );
              },
              error: (message) => Center(
                child: Text('Error: $message'),
              ),
              orElse: () => const Center(
                child: Text('Start by fetching {features}'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<{FeatureBloc}>().add(const {FeatureEvent}.fetch());
        },
        tooltip: 'Fetch {features}',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

### 9. DI Registration Template

```dart
// Add to config/di/injection.dart

void _register{FeatureModule}() {
  // Remote Data Source
  getIt.registerFactory<{FeatureRemoteDataSource}>(
    {FeatureRemoteDataSourceImpl}(
      apiClient: getIt<ApiClient>(),
    ),
  );

  // Repository
  getIt.registerFactory<{FeatureRepository}>(
    {FeatureRepositoryImpl}(
      remoteDataSource: getIt<{FeatureRemoteDataSource}>(),
    ),
  );

  // Use Cases
  getIt.registerFactory<Get{FeatureUseCase}>(
    Get{FeatureUseCase}(
      repository: getIt<{FeatureRepository}>(),
    ),
  );

  // BLoC
  getIt.registerFactory<{FeatureBloc}>(
    {FeatureBloc}(
      get{FeatureUseCase}: getIt<Get{FeatureUseCase}>(),
    ),
  );
}

// Call in setupServiceLocator():
void setupServiceLocator() {
  // ... other setup
  _register{FeatureModule}();
}
```

---

## Placeholders

Replace these in templates:
- `{feature}` → lowercase feature name (e.g., `posts`)
- `{Feature}` → PascalCase feature name (e.g., `Posts`)
- `{FeatureEntity}` → Entity class name (e.g., `PostEntity`)
- `{FeatureRepository}` → Repository class name (e.g., `PostRepository`)
- `{FeatureUseCase}` → Use case class name
