import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/features/auth/domain/entities/otp_channel.dart';
import 'package:study_lingo/features/auth/domain/repositories/auth_repository.dart';
import 'package:study_lingo/features/auth/domain/repositories/password_reset_repository.dart';
import 'package:study_lingo/features/auth/presentation/bloc/forgot_password_bloc.dart';

class MockPasswordResetRepository extends Mock
    implements PasswordResetRepository {}

void main() {
  late PasswordResetRepository repository;

  setUpAll(() {
    // Needed for `any(named: 'channel')` on the OtpChannel enum.
    registerFallbackValue(OtpChannel.email);
  });

  setUp(() {
    repository = MockPasswordResetRepository();
  });

  group('ForgotPasswordBloc', () {
    test('starts on the request step', () {
      final bloc = ForgotPasswordBloc(repository);
      expect(bloc.state.step, ForgotPasswordStep.request);
      expect(bloc.state.detectedChannel, isNull);
    });

    test('auto-detects an email destination', () {
      const state = ForgotPasswordState(destination: 'a@b.com');
      expect(state.detectedChannel, OtpChannel.email);
      expect(state.isDestinationValid, isTrue);
    });

    test('auto-detects a phone destination, ignoring spaces/dashes', () {
      const state = ForgotPasswordState(destination: '+84 90-123 4567');
      expect(state.detectedChannel, OtpChannel.phone);
      expect(state.isDestinationValid, isTrue);
    });

    test('invalid input is detected as neither channel', () {
      const state = ForgotPasswordState(destination: 'nope');
      expect(state.detectedChannel, isNull);
      expect(state.isDestinationValid, isFalse);
    });

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'requestOtp emits [submitting, verify] on success',
      setUp: () {
        when(
          () => repository.requestOtp(
            channel: any(named: 'channel'),
            destination: any(named: 'destination'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => ForgotPasswordBloc(repository),
      seed: () => const ForgotPasswordState(destination: 'a@b.com'),
      act: (bloc) => bloc.add(const ForgotOtpRequested()),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.submitting,
        ),
        isA<ForgotPasswordState>().having(
          (s) => s.step,
          'step',
          ForgotPasswordStep.verify,
        ),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'does not request when the destination is invalid',
      build: () => ForgotPasswordBloc(repository),
      seed: () => const ForgotPasswordState(destination: 'nope'),
      act: (bloc) => bloc.add(const ForgotOtpRequested()),
      expect: () => const <ForgotPasswordState>[],
      verify: (_) {
        verifyNever(
          () => repository.requestOtp(
            channel: any(named: 'channel'),
            destination: any(named: 'destination'),
          ),
        );
      },
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'verifyOtp stores the token and advances to the reset step',
      setUp: () {
        when(
          () => repository.verifyOtp(
            destination: any(named: 'destination'),
            code: any(named: 'code'),
          ),
        ).thenAnswer((_) async => 'token-123');
      },
      build: () => ForgotPasswordBloc(repository),
      seed: () => const ForgotPasswordState(
        step: ForgotPasswordStep.verify,
        destination: 'a@b.com',
        code: '123456',
      ),
      act: (bloc) => bloc.add(const ForgotOtpSubmitted()),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.submitting,
        ),
        isA<ForgotPasswordState>()
            .having((s) => s.step, 'step', ForgotPasswordStep.reset)
            .having((s) => s.resetToken, 'resetToken', 'token-123'),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'maps AuthException from verifyOtp to a failure state',
      setUp: () {
        when(
          () => repository.verifyOtp(
            destination: any(named: 'destination'),
            code: any(named: 'code'),
          ),
        ).thenThrow(const AuthException('Mã sai'));
      },
      build: () => ForgotPasswordBloc(repository),
      seed: () => const ForgotPasswordState(
        step: ForgotPasswordStep.verify,
        destination: 'a@b.com',
        code: '000000',
      ),
      act: (bloc) => bloc.add(const ForgotOtpSubmitted()),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.submitting,
        ),
        isA<ForgotPasswordState>()
            .having((s) => s.status, 'status', ForgotPasswordStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'Mã sai')
            // Stays on the verify step so the user can retry.
            .having((s) => s.step, 'step', ForgotPasswordStep.verify),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'resetPassword emits [submitting, done] on success',
      setUp: () {
        when(
          () => repository.resetPassword(
            resetToken: any(named: 'resetToken'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => ForgotPasswordBloc(repository),
      seed: () => const ForgotPasswordState(
        step: ForgotPasswordStep.reset,
        resetToken: 'token-123',
        newPassword: 'secret123',
        confirmPassword: 'secret123',
      ),
      act: (bloc) => bloc.add(const ForgotPasswordSubmitted()),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.status,
          'status',
          ForgotPasswordStatus.submitting,
        ),
        isA<ForgotPasswordState>()
            .having((s) => s.step, 'step', ForgotPasswordStep.done)
            .having((s) => s.status, 'status', ForgotPasswordStatus.success),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'does not reset when passwords do not match',
      build: () => ForgotPasswordBloc(repository),
      seed: () => const ForgotPasswordState(
        step: ForgotPasswordStep.reset,
        resetToken: 'token-123',
        newPassword: 'secret123',
        confirmPassword: 'different',
      ),
      act: (bloc) => bloc.add(const ForgotPasswordSubmitted()),
      expect: () => const <ForgotPasswordState>[],
      verify: (_) {
        verifyNever(
          () => repository.resetPassword(
            resetToken: any(named: 'resetToken'),
            newPassword: any(named: 'newPassword'),
          ),
        );
      },
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'back from verify returns to the request step',
      build: () => ForgotPasswordBloc(repository),
      seed: () =>
          const ForgotPasswordState(step: ForgotPasswordStep.verify),
      act: (bloc) => bloc.add(const ForgotBackRequested()),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.step,
          'step',
          ForgotPasswordStep.request,
        ),
      ],
    );
  });
}
