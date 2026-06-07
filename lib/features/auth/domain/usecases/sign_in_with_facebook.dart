import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithFacebookUseCase extends UseCase<AuthUser, NoParams> {
  const SignInWithFacebookUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser>> call(NoParams params) async {
    try {
      return Right(await _repository.signInWithFacebook());
    } on AuthException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
