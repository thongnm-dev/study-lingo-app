import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/app_language.dart';
import '../repositories/locale_repository.dart';

/// Persists the chosen display language.
class SaveLocaleUseCase extends UseCase<void, AppLanguage> {
  const SaveLocaleUseCase(this._repository);

  final LocaleRepository _repository;

  @override
  Future<Either<Failure, void>> call(AppLanguage language) async {
    try {
      await _repository.save(language);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
