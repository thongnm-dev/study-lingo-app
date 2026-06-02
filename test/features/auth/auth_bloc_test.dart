import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/features/auth/domain/entities/auth_user.dart';
import 'package:study_lingo/features/auth/domain/repositories/auth_repository.dart';
import 'package:study_lingo/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const googleUser = AuthUser(id: 'g', provider: AuthProvider.google);
  const emailUser = AuthUser(
    id: 'e',
    provider: AuthProvider.email,
    email: 'a@b.com',
  );

  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'toggles between login and register',
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const AuthModeToggled()),
      expect: () => [
        isA<AuthState>().having((s) => s.mode, 'mode', AuthMode.register),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'canSubmit is false until email and password are valid',
      build: () => AuthBloc(repository),
      act: (bloc) => bloc
        ..add(const AuthEmailChanged('not-an-email'))
        ..add(const AuthPasswordChanged('123')),
      verify: (bloc) => expect(bloc.state.canSubmit, isFalse),
    );

    blocTest<AuthBloc, AuthState>(
      'submits email login and emits [submitting, success]',
      setUp: () {
        when(
          () => repository.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => emailUser);
      },
      build: () => AuthBloc(repository),
      seed: () => const AuthState(email: 'a@b.com', password: 'secret123'),
      act: (bloc) => bloc.add(const AuthEmailSubmitted()),
      expect: () => [
        isA<AuthState>().having(
          (s) => s.status,
          'status',
          AuthStatus.submitting,
        ),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.success)
            .having((s) => s.user, 'user', emailUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'does not submit when the form is invalid',
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const AuthEmailSubmitted()),
      expect: () => const <AuthState>[],
      verify: (_) {
        verifyNever(
          () => repository.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Google sign-in emits [submitting, success] with the user',
      setUp: () {
        when(
          () => repository.signInWithGoogle(),
        ).thenAnswer((_) async => googleUser);
      },
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const AuthGooglePressed()),
      expect: () => [
        isA<AuthState>().having(
          (s) => s.status,
          'status',
          AuthStatus.submitting,
        ),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.success)
            .having((s) => s.user, 'user', googleUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'maps AuthException to a failure state with its message',
      setUp: () {
        when(
          () => repository.signInWithFacebook(),
        ).thenThrow(const AuthException('nope'));
      },
      build: () => AuthBloc(repository),
      act: (bloc) => bloc.add(const AuthFacebookPressed()),
      expect: () => [
        isA<AuthState>().having(
          (s) => s.status,
          'status',
          AuthStatus.submitting,
        ),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'nope'),
      ],
    );
  });
}
