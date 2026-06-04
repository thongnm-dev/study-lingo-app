part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

/// Step 1 — the email address or phone number the code is sent to. The channel
/// (email vs phone) is auto-detected from this value, not chosen by the user.
class ForgotDestinationChanged extends ForgotPasswordEvent {
  const ForgotDestinationChanged(this.destination);
  final String destination;

  @override
  List<Object?> get props => [destination];
}

/// Step 1 — send the OTP (also used to resend from step 2).
class ForgotOtpRequested extends ForgotPasswordEvent {
  const ForgotOtpRequested();
}

/// Step 2 — the code the user typed in.
class ForgotCodeChanged extends ForgotPasswordEvent {
  const ForgotCodeChanged(this.code);
  final String code;

  @override
  List<Object?> get props => [code];
}

/// Step 2 — verify the entered code.
class ForgotOtpSubmitted extends ForgotPasswordEvent {
  const ForgotOtpSubmitted();
}

/// Step 3 — the new password.
class ForgotNewPasswordChanged extends ForgotPasswordEvent {
  const ForgotNewPasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

/// Step 3 — the new-password confirmation.
class ForgotConfirmPasswordChanged extends ForgotPasswordEvent {
  const ForgotConfirmPasswordChanged(this.confirmPassword);
  final String confirmPassword;

  @override
  List<Object?> get props => [confirmPassword];
}

/// Step 3 — commit the new password.
class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordSubmitted();
}

/// Go back one step (verify → request, reset → verify).
class ForgotBackRequested extends ForgotPasswordEvent {
  const ForgotBackRequested();
}
