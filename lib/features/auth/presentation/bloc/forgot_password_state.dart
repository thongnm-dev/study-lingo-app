part of 'forgot_password_bloc.dart';

/// Which step of the recovery flow is on screen.
enum ForgotPasswordStep { request, verify, reset, done }

/// Transient status within a step. Widgets switch on this to show a spinner /
/// error; the [ForgotPasswordStep] drives which form is shown.
enum ForgotPasswordStatus { editing, submitting, success, failure }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.step = ForgotPasswordStep.request,
    this.status = ForgotPasswordStatus.editing,
    this.destination = '',
    this.code = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.resetToken = '',
    this.errorMessage,
  });

  final ForgotPasswordStep step;
  final ForgotPasswordStatus status;
  final String destination;
  final String code;
  final String newPassword;
  final String confirmPassword;

  /// Token returned by `verifyOtp`, consumed by `resetPassword`.
  final String resetToken;
  final String? errorMessage;

  bool get isSubmitting => status == ForgotPasswordStatus.submitting;

  // Lightweight client-side validation. The repository/backend is still the
  // source of truth — this only gates the action buttons and inline hints.

  bool get _looksLikeEmail =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(destination.trim());

  /// Phone: optional leading +, then 8–15 digits (E.164-ish); spaces/dashes
  /// are allowed and ignored.
  bool get _looksLikePhone {
    final digits = destination.trim().replaceAll(RegExp(r'[\s-]'), '');
    return RegExp(r'^\+?\d{8,15}$').hasMatch(digits);
  }

  /// The channel is inferred from what the user typed — they don't pick it.
  /// `null` means the input is neither a valid email nor a valid phone number.
  OtpChannel? get detectedChannel {
    if (_looksLikeEmail) return OtpChannel.email;
    if (_looksLikePhone) return OtpChannel.phone;
    return null;
  }

  bool get isEmailDestination => detectedChannel == OtpChannel.email;

  bool get isDestinationValid => detectedChannel != null;

  /// OTP codes here are 6 digits.
  bool get isCodeValid => RegExp(r'^\d{6}$').hasMatch(code.trim());

  bool get isPasswordValid => newPassword.length >= 6;
  bool get doPasswordsMatch => newPassword == confirmPassword;

  bool get canRequest => isDestinationValid && !isSubmitting;
  bool get canVerify => isCodeValid && !isSubmitting;
  bool get canReset =>
      isPasswordValid && doPasswordsMatch && !isSubmitting;

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    ForgotPasswordStatus? status,
    String? destination,
    String? code,
    String? newPassword,
    String? confirmPassword,
    String? resetToken,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      destination: destination ?? this.destination,
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      resetToken: resetToken ?? this.resetToken,
      // errorMessage is intentionally not `?? this.errorMessage`: it clears on
      // any non-failure emit so a stale error never lingers.
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    step,
    status,
    destination,
    code,
    newPassword,
    confirmPassword,
    resetToken,
    errorMessage,
  ];
}
