import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/app_theme_mode.dart';
import '../repositories/theme_repository.dart';

/// Reads the user's saved theme mode. Returns `null` when no choice has been
/// persisted yet.
class LoadThemeUseCase extends UseCase<AppThemeMode?, NoParams> {
  const LoadThemeUseCase(this._repository);

  final ThemeRepository _repository;

  @override
  Future<Either<Failure, AppThemeMode?>> call(NoParams params) async {
    try {
      return Right(await _repository.load());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
