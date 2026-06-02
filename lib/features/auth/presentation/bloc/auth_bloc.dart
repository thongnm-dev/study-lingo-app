import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState()) {
    on<AuthModeToggled>(_onModeToggled);
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AuthEmailSubmitted>(_onEmailSubmitted);
    on<AuthGooglePressed>(_onGooglePressed);
    on<AuthFacebookPressed>(_onFacebookPressed);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final AuthRepository _repository;

  void _onModeToggled(AuthModeToggled event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        mode: state.isLogin ? AuthMode.register : AuthMode.login,
        status: AuthStatus.editing,
      ),
    );
  }

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
    await _run(
      emit,
      () => state.isLogin
          ? _repository.signInWithEmail(
              email: state.email,
              password: state.password,
            )
          : _repository.signUpWithEmail(
              email: state.email,
              password: state.password,
            ),
    );
  }

  Future<void> _onGooglePressed(
    AuthGooglePressed event,
    Emitter<AuthState> emit,
  ) => _run(emit, _repository.signInWithGoogle);

  Future<void> _onFacebookPressed(
    AuthFacebookPressed event,
    Emitter<AuthState> emit,
  ) => _run(emit, _repository.signInWithFacebook);

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.signOut();
    emit(const AuthState());
  }

  /// Shared submit/social plumbing: flip to submitting, run the action, then
  /// emit success (with the user) or failure (with a message).
  Future<void> _run(
    Emitter<AuthState> emit,
    Future<AuthUser> Function() action,
  ) async {
    emit(state.copyWith(status: AuthStatus.submitting));
    try {
      final user = await action();
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } on AuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}
