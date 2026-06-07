import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/auth_repository.dart' show AuthException;
import '../repositories/password_reset_repository.dart';

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.resetToken, required this.newPassword});
  final String resetToken;
  final String newPassword;

  @override
  List<Object?> get props => [resetToken, newPassword];
}

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  const ResetPasswordUseCase(this._repository);

  final PasswordResetRepository _repository;

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    try {
      await _repository.resetPassword(
        resetToken: params.resetToken,
        newPassword: params.newPassword,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
