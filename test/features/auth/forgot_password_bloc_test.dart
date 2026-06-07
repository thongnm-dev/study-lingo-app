import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_lingo/core/utils/failure.dart';
import 'package:study_lingo/features/auth/domain/entities/otp_channel.dart';
import 'package:study_lingo/features/auth/domain/usecases/request_otp.dart';
import 'package:study_lingo/features/auth/domain/usecases/reset_password.dart';
import 'package:study_lingo/features/auth/domain/usecases/verify_otp.dart';
import 'package:study_lingo/features/auth/presentation/bloc/forgot_password_bloc.dart';

class MockRequestOtp extends Mock implements RequestOtpUseCase {}

class MockVerifyOtp extends Mock implements VerifyOtpUseCase {}

class MockResetPassword extends Mock implements ResetPasswordUseCase {}

void main() {
  late MockRequestOtp requestOtp;
  late MockVerifyOtp verifyOtp;
  late MockResetPassword resetPassword;

  setUpAll(() {
    registerFallbackValue(OtpChannel.email);
    registerFallbackValue(
      const RequestOtpParams(channel: OtpChannel.email, destination: ''),
    );
    registerFallbackValue(const VerifyOtpParams(destination: '', code: ''));
    registerFallbackValue(
      const ResetPasswordParams(resetToken: '', newPassword: ''),
    );
  });

  setUp(() {
    requestOtp = MockRequestOtp();
    verifyOtp = MockVerifyOtp();
    resetPassword = MockResetPassword();
  });

  ForgotPasswordBloc build() => ForgotPasswordBloc(
    requestOtp: requestOtp,
    verifyOtp: verifyOtp,
    resetPassword: resetPassword,
  );

  group('ForgotPasswordBloc', () {
    test('starts on the request step', () {
      final bloc = build();
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
      setUp: () => when(
        () => requestOtp(any()),
      ).thenAnswer((_) async => const Right<Failure, void>(null)),
      build: build,
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
      build: build,
      seed: () => const ForgotPasswordState(destination: 'nope'),
      act: (bloc) => bloc.add(const ForgotOtpRequested()),
      expect: () => const <ForgotPasswordState>[],
      verify: (_) => verifyNever(() => requestOtp(any())),
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'verifyOtp stores the token and advances to the reset step',
      setUp: () => when(
        () => verifyOtp(any()),
      ).thenAnswer((_) async => const Right<Failure, String>('token-123')),
      build: build,
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
      'maps a Left failure from verifyOtp to a failure state',
      setUp: () => when(() => verifyOtp(any())).thenAnswer(
        (_) async =>
            const Left<Failure, String>(ValidationFailure('Mã sai')),
      ),
      build: build,
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
      setUp: () => when(
        () => resetPassword(any()),
      ).thenAnswer((_) async => const Right<Failure, void>(null)),
      build: build,
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
      build: build,
      seed: () => const ForgotPasswordState(
        step: ForgotPasswordStep.reset,
        resetToken: 'token-123',
        newPassword: 'secret123',
        confirmPassword: 'different',
      ),
      act: (bloc) => bloc.add(const ForgotPasswordSubmitted()),
      expect: () => const <ForgotPasswordState>[],
      verify: (_) => verifyNever(() => resetPassword(any())),
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'back from verify returns to the request step',
      build: build,
      seed: () => const ForgotPasswordState(step: ForgotPasswordStep.verify),
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
