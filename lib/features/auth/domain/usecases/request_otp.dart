import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../entities/otp_channel.dart';
import '../repositories/auth_repository.dart' show AuthException;
import '../repositories/password_reset_repository.dart';

class RequestOtpParams extends Equatable {
  const RequestOtpParams({required this.channel, required this.destination});
  final OtpChannel channel;
  final String destination;

  @override
  List<Object?> get props => [channel, destination];
}

class RequestOtpUseCase extends UseCase<void, RequestOtpParams> {
  const RequestOtpUseCase(this._repository);

  final PasswordResetRepository _repository;

  @override
  Future<Either<Failure, void>> call(RequestOtpParams params) async {
    try {
      await _repository.requestOtp(
        channel: params.channel,
        destination: params.destination,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
