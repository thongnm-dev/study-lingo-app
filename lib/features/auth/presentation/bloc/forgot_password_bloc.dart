import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/otp_channel.dart';
import '../../domain/repositories/auth_repository.dart' show AuthException;
import '../../domain/repositories/password_reset_repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

/// Drives the three-step password recovery flow: pick a channel + enter a
/// destination → request an OTP → verify the code → set a new password. It is a
/// [Bloc] (not a Cubit) because it has many distinct triggers across the steps
/// and an event audit trail is useful for an account-security flow.
///
/// All steps funnel through [_run], which flips to [ForgotPasswordStatus.submitting],
/// runs the action, and on success applies [onSuccess] (advancing the step) or
/// on failure emits [ForgotPasswordStatus.failure] with a user-safe message.
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc(this._repository) : super(const ForgotPasswordState()) {
    on<ForgotDestinationChanged>(_onDestinationChanged);
    on<ForgotOtpRequested>(_onOtpRequested);
    on<ForgotCodeChanged>(_onCodeChanged);
    on<ForgotOtpSubmitted>(_onOtpSubmitted);
    on<ForgotNewPasswordChanged>(_onNewPasswordChanged);
    on<ForgotConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ForgotPasswordSubmitted>(_onPasswordSubmitted);
    on<ForgotBackRequested>(_onBackRequested);
  }

  final PasswordResetRepository _repository;

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
    await _run(
      emit,
      () => _repository.requestOtp(
        channel: channel,
        destination: state.destination.trim(),
      ),
      onSuccess: (_) => state.copyWith(
        step: ForgotPasswordStep.verify,
        status: ForgotPasswordStatus.editing,
        // Clear any stale code from a previous attempt.
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
    await _run(
      emit,
      () => _repository.verifyOtp(
        destination: state.destination.trim(),
        code: state.code.trim(),
      ),
      onSuccess: (token) => state.copyWith(
        step: ForgotPasswordStep.reset,
        status: ForgotPasswordStatus.editing,
        resetToken: token as String,
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
    await _run(
      emit,
      () => _repository.resetPassword(
        resetToken: state.resetToken,
        newPassword: state.newPassword,
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

  /// Shared submit plumbing: flip to submitting, run [action], then either apply
  /// [onSuccess] (which returns the next state) or emit a failure with a
  /// user-safe message.
  Future<void> _run(
    Emitter<ForgotPasswordState> emit,
    Future<Object?> Function() action, {
    required ForgotPasswordState Function(Object? result) onSuccess,
  }) async {
    emit(state.copyWith(status: ForgotPasswordStatus.submitting));
    try {
      final result = await action();
      emit(onSuccess(result));
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
        ),
      );
    }
  }
}
