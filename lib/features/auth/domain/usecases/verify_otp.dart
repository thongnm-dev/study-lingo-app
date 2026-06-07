import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/auth_repository.dart' show AuthException;
import '../repositories/password_reset_repository.dart';

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({required this.destination, required this.code});
  final String destination;
  final String code;

  @override
  List<Object?> get props => [destination, code];
}

class VerifyOtpUseCase extends UseCase<String, VerifyOtpParams> {
  const VerifyOtpUseCase(this._repository);

  final PasswordResetRepository _repository;

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) async {
    try {
      final token = await _repository.verifyOtp(
        destination: params.destination,
        code: params.code,
      );
      return Right(token);
    } on AuthException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
