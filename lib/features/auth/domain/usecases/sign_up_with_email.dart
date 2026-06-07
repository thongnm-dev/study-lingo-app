import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';
import 'sign_in_with_email.dart';

class SignUpWithEmailUseCase extends UseCase<AuthUser, EmailPasswordParams> {
  const SignUpWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser>> call(EmailPasswordParams params) async {
    try {
      final user = await _repository.signUpWithEmail(
        email: params.email,
        password: params.password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
