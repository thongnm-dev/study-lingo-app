import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/core/usecases/usecase.dart';
import 'package:study_lingo/core/utils/failure.dart';
import 'package:study_lingo/features/auth/domain/entities/auth_user.dart';
import 'package:study_lingo/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:study_lingo/features/auth/domain/usecases/sign_in_with_facebook.dart';
import 'package:study_lingo/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:study_lingo/features/auth/domain/usecases/sign_out.dart';
import 'package:study_lingo/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:study_lingo/features/auth/presentation/bloc/auth_bloc.dart';

class MockSignInEmail extends Mock implements SignInWithEmailUseCase {}

class MockSignUpEmail extends Mock implements SignUpWithEmailUseCase {}

class MockSignInGoogle extends Mock implements SignInWithGoogleUseCase {}

class MockSignInFacebook extends Mock implements SignInWithFacebookUseCase {}

class MockSignOut extends Mock implements SignOutUseCase {}

void main() {
  const googleUser = AuthUser(id: 'g', provider: AuthProvider.google);
  const emailUser = AuthUser(
    id: 'e',
    provider: AuthProvider.email,
    email: 'a@b.com',
  );

  late MockSignInEmail signInEmail;
  late MockSignUpEmail signUpEmail;
  late MockSignInGoogle signInGoogle;
  late MockSignInFacebook signInFacebook;
  late MockSignOut signOut;

  setUpAll(() {
    registerFallbackValue(
      const EmailPasswordParams(email: 'x', password: 'y'),
    );
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    signInEmail = MockSignInEmail();
    signUpEmail = MockSignUpEmail();
    signInGoogle = MockSignInGoogle();
    signInFacebook = MockSignInFacebook();
    signOut = MockSignOut();
  });

  AuthBloc build({AuthMode mode = AuthMode.login}) => AuthBloc(
    signInWithEmail: signInEmail,
    signUpWithEmail: signUpEmail,
    signInWithGoogle: signInGoogle,
    signInWithFacebook: signInFacebook,
    signOut: signOut,
    initialMode: mode,
  );

  group('AuthBloc', () {
    test('starts in the initialMode passed at construction', () {
      expect(build().state.mode, AuthMode.login);
      expect(build(mode: AuthMode.register).state.mode, AuthMode.register);
    });

    blocTest<AuthBloc, AuthState>(
      'canSubmit is false until email and password are valid',
      build: build,
      act: (bloc) => bloc
        ..add(const AuthEmailChanged('not-an-email'))
        ..add(const AuthPasswordChanged('123')),
      verify: (bloc) => expect(bloc.state.canSubmit, isFalse),
    );

    blocTest<AuthBloc, AuthState>(
      'submits email login and emits [submitting, success]',
      setUp: () {
        when(
          () => signInEmail(any()),
        ).thenAnswer((_) async => const Right<Failure, AuthUser>(emailUser));
      },
      build: build,
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
      build: build,
      act: (bloc) => bloc.add(const AuthEmailSubmitted()),
      expect: () => const <AuthState>[],
      verify: (_) => verifyNever(() => signInEmail(any())),
    );

    blocTest<AuthBloc, AuthState>(
      'Google sign-in emits [submitting, success] with the user',
      setUp: () {
        when(
          () => signInGoogle(any()),
        ).thenAnswer((_) async => const Right<Failure, AuthUser>(googleUser));
      },
      build: build,
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
      'maps a Left failure to a failure state with its message',
      setUp: () {
        when(() => signInFacebook(any())).thenAnswer(
          (_) async =>
              const Left<Failure, AuthUser>(ValidationFailure('nope')),
        );
      },
      build: build,
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
