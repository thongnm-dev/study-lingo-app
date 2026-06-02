part of 'auth_bloc.dart';

enum AuthMode { login, register }

enum AuthStatus { editing, submitting, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.mode = AuthMode.login,
    this.status = AuthStatus.editing,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.user,
    this.errorMessage,
  });

  final AuthMode mode;
  final AuthStatus status;
  final String email;
  final String password;
  final String confirmPassword;
  final AuthUser? user;
  final String? errorMessage;

  bool get isLogin => mode == AuthMode.login;
  bool get isSubmitting => status == AuthStatus.submitting;

  // Lightweight client-side validation. The repository/backend is still the
  // source of truth — this only gates the submit button and inline hints.
  bool get isEmailValid =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  bool get isPasswordValid => password.length >= 6;
  bool get doPasswordsMatch => password == confirmPassword;

  bool get canSubmit {
    if (!isEmailValid || !isPasswordValid) return false;
    if (!isLogin && !doPasswordsMatch) return false;
    return !isSubmitting;
  }

  AuthState copyWith({
    AuthMode? mode,
    AuthStatus? status,
    String? email,
    String? password,
    String? confirmPassword,
    AuthUser? user,
    String? errorMessage,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    status,
    email,
    password,
    confirmPassword,
    user,
    errorMessage,
  ];
}
