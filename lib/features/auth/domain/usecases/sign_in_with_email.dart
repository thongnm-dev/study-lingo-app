import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class EmailPasswordParams extends Equatable {
  const EmailPasswordParams({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignInWithEmailUseCase extends UseCase<AuthUser, EmailPasswordParams> {
  const SignInWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser>> call(EmailPasswordParams params) async {
    try {
      final user = await _repository.signInWithEmail(
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
