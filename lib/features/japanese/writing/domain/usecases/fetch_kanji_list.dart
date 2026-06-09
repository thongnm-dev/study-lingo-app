import 'package:dartz/dartz.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure.dart';
import '../entities/kanji.dart';
import '../repositories/kanji_repository.dart';

/// Fetches every kanji available in the learning catalog.
class FetchKanjiListUseCase extends UseCase<List<Kanji>, NoParams> {
  const FetchKanjiListUseCase(this._repository);

  final KanjiRepository _repository;

  @override
  Future<Either<Failure, List<Kanji>>> call(NoParams params) async {
    try {
      final kanji = await _repository.fetchAll();
      return Right(kanji);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
