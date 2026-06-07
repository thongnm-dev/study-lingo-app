import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/app_language.dart';
import '../repositories/locale_repository.dart';

/// Reads the user's saved display language. Returns `null` when no choice has
/// been persisted yet.
class LoadLocaleUseCase extends UseCase<AppLanguage?, NoParams> {
  const LoadLocaleUseCase(this._repository);

  final LocaleRepository _repository;

  @override
  Future<Either<Failure, AppLanguage?>> call(NoParams params) async {
    try {
      return Right(await _repository.load());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
