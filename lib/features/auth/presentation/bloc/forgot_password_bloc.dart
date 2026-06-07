import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/entities/otp_channel.dart';
import '../../domain/usecases/request_otp.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/verify_otp.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

/// Drives the three-step password recovery flow: pick a channel + enter a
/// destination → request an OTP → verify the code → set a new password. It is
/// a [Bloc] (not a Cubit) because it has many distinct triggers across the
/// steps and an event audit trail is useful for an account-security flow.
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required RequestOtpUseCase requestOtp,
    required VerifyOtpUseCase verifyOtp,
    required ResetPasswordUseCase resetPassword,
  }) : _requestOtp = requestOtp,
       _verifyOtp = verifyOtp,
       _resetPassword = resetPassword,
       super(const ForgotPasswordState()) {
    on<ForgotDestinationChanged>(_onDestinationChanged);
    on<ForgotOtpRequested>(_onOtpRequested);
    on<ForgotCodeChanged>(_onCodeChanged);
    on<ForgotOtpSubmitted>(_onOtpSubmitted);
    on<ForgotNewPasswordChanged>(_onNewPasswordChanged);
    on<ForgotConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ForgotPasswordSubmitted>(_onPasswordSubmitted);
    on<ForgotBackRequested>(_onBackRequested);
  }

  final RequestOtpUseCase _requestOtp;
  final VerifyOtpUseCase _verifyOtp;
  final ResetPasswordUseCase _resetPassword;

  void _onDestinationChanged(
    ForgotDestinationChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        destination: event.destination,
        status: ForgotPasswordStatus.editing,
      ),
    );
  }

  Future<void> _onOtpRequested(
    ForgotOtpRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final channel = state.detectedChannel;
    if (channel == null || !state.canRequest) return;
    await _run<void>(
      emit,
      () => _requestOtp(
        RequestOtpParams(
          channel: channel,
          destination: state.destination.trim(),
        ),
      ),
      onSuccess: (_) => state.copyWith(
        step: ForgotPasswordStep.verify,
        status: ForgotPasswordStatus.editing,
        code: '',
      ),
    );
  }

  void _onCodeChanged(
    ForgotCodeChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        code: event.code,
        status: ForgotPasswordStatus.editing,
      ),
    );
  }

  Future<void> _onOtpSubmitted(
    ForgotOtpSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (!state.canVerify) return;
    await _run<String>(
      emit,
      () => _verifyOtp(
        VerifyOtpParams(
          destination: state.destination.trim(),
          code: state.code.trim(),
        ),
      ),
      onSuccess: (token) => state.copyWith(
        step: ForgotPasswordStep.reset,
        status: ForgotPasswordStatus.editing,
        resetToken: token,
      ),
    );
  }

  void _onNewPasswordChanged(
    ForgotNewPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        newPassword: event.password,
        status: ForgotPasswordStatus.editing,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    ForgotConfirmPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        status: ForgotPasswordStatus.editing,
      ),
    );
  }

  Future<void> _onPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (!state.canReset) return;
    await _run<void>(
      emit,
      () => _resetPassword(
        ResetPasswordParams(
          resetToken: state.resetToken,
          newPassword: state.newPassword,
        ),
      ),
      onSuccess: (_) => state.copyWith(
        step: ForgotPasswordStep.done,
        status: ForgotPasswordStatus.success,
      ),
    );
  }

  void _onBackRequested(
    ForgotBackRequested event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final previous = switch (state.step) {
      ForgotPasswordStep.reset => ForgotPasswordStep.verify,
      ForgotPasswordStep.verify => ForgotPasswordStep.request,
      _ => state.step,
    };
    emit(
      state.copyWith(step: previous, status: ForgotPasswordStatus.editing),
    );
  }

  /// Shared submit plumbing: flip to submitting, run [action], then either
  /// apply [onSuccess] (which returns the next state) or emit a failure with
  /// a user-safe message.
  Future<void> _run<T>(
    Emitter<ForgotPasswordState> emit,
    Future<Either<Failure, T>> Function() action, {
    required ForgotPasswordState Function(T result) onSuccess,
  }) async {
    emit(state.copyWith(status: ForgotPasswordStatus.submitting));
    final result = await action();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (value) => emit(onSuccess(value)),
    );
  }
}
