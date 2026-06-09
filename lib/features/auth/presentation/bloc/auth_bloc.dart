import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_facebook.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInWithEmailUseCase signInWithEmail,
    required SignUpWithEmailUseCase signUpWithEmail,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignInWithFacebookUseCase signInWithFacebook,
    required SignOutUseCase signOut,
    AuthMode initialMode = AuthMode.login,
    String initialEmail = '',
    String initialPassword = '',
  }) : _signInWithEmail = signInWithEmail,
       _signUpWithEmail = signUpWithEmail,
       _signInWithGoogle = signInWithGoogle,
       _signInWithFacebook = signInWithFacebook,
       _signOut = signOut,
       super(
         AuthState(
           mode: initialMode,
           email: initialEmail,
           password: initialPassword,
         ),
       ) {
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AuthEmailSubmitted>(_onEmailSubmitted);
    on<AuthGooglePressed>(_onGooglePressed);
    on<AuthFacebookPressed>(_onFacebookPressed);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final SignInWithEmailUseCase _signInWithEmail;
  final SignUpWithEmailUseCase _signUpWithEmail;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignInWithFacebookUseCase _signInWithFacebook;
  final SignOutUseCase _signOut;

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(email: event.email, status: AuthStatus.editing));
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(password: event.password, status: AuthStatus.editing));
  }

  void _onConfirmPasswordChanged(
    AuthConfirmPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        status: AuthStatus.editing,
      ),
    );
  }

  Future<void> _onEmailSubmitted(
    AuthEmailSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.canSubmit) return;
    final params = EmailPasswordParams(
      email: state.email,
      password: state.password,
    );
    await _run(
      emit,
      () => state.isLogin
          ? _signInWithEmail(params)
          : _signUpWithEmail(params),
    );
  }

  Future<void> _onGooglePressed(
    AuthGooglePressed event,
    Emitter<AuthState> emit,
  ) => _run(emit, () => _signInWithGoogle(const NoParams()));

  Future<void> _onFacebookPressed(
    AuthFacebookPressed event,
    Emitter<AuthState> emit,
  ) => _run(emit, () => _signInWithFacebook(const NoParams()));

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut(const NoParams());
    emit(const AuthState());
  }

  /// Shared submit/social plumbing: flip to submitting, run the action, then
  /// emit success (with the user) or failure (with a message).
  Future<void> _run(
    Emitter<AuthState> emit,
    Future<Either<Failure, AuthUser>> Function() action,
  ) async {
    emit(state.copyWith(status: AuthStatus.submitting));
    final result = await action();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: AuthStatus.failure, errorMessage: failure.message)),
      (user) =>
          emit(state.copyWith(status: AuthStatus.success, user: user)),
    );
  }
}
