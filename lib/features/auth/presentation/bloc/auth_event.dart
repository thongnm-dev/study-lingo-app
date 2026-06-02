part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Toggle between login and register on the same screen.
class AuthModeToggled extends AuthEvent {
  const AuthModeToggled();
}

class AuthEmailChanged extends AuthEvent {
  const AuthEmailChanged(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

class AuthPasswordChanged extends AuthEvent {
  const AuthPasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

class AuthConfirmPasswordChanged extends AuthEvent {
  const AuthConfirmPasswordChanged(this.confirmPassword);
  final String confirmPassword;

  @override
  List<Object?> get props => [confirmPassword];
}

/// Submit the email/password form (sign in or sign up depending on mode).
class AuthEmailSubmitted extends AuthEvent {
  const AuthEmailSubmitted();
}

class AuthGooglePressed extends AuthEvent {
  const AuthGooglePressed();
}

class AuthFacebookPressed extends AuthEvent {
  const AuthFacebookPressed();
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
