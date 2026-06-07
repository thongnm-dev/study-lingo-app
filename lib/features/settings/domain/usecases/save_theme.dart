import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/app_theme_mode.dart';
import '../repositories/theme_repository.dart';

/// Persists the chosen theme mode.
class SaveThemeUseCase extends UseCase<void, AppThemeMode> {
  const SaveThemeUseCase(this._repository);

  final ThemeRepository _repository;

  @override
  Future<Either<Failure, void>> call(AppThemeMode mode) async {
    try {
      await _repository.save(mode);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
