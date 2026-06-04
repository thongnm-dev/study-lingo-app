import '../../domain/entities/otp_channel.dart';
import '../../domain/repositories/auth_repository.dart' show AuthException;
import '../../domain/repositories/password_reset_repository.dart';

/// A simulated [PasswordResetRepository] so the forgot-password flow runs with
/// no backend or SMS/email provider. It accepts a fixed demo code and fabricates
/// a reset token, validating inputs the way a real backend would.
///
/// Demo conventions (for exercising the UI without a server):
///   * The OTP is always `123456` — any other code fails verification.
///   * Requesting a code for `unknown@example.com` (or phone `000`) fails, to
///     exercise the "no such account" path.
///
/// To go live, implement [PasswordResetRepository] against your backend:
///   * Email -> firebase_auth `sendPasswordResetEmail`, or a REST endpoint that
///     emails a code.
///   * Phone -> firebase_auth phone verification, or an SMS provider (Twilio…).
/// Then swap this for the real class at [ForgotPasswordPage]'s BlocProvider —
/// no presentation/Bloc changes needed.
class FakePasswordResetRepository implements PasswordResetRepository {
  const FakePasswordResetRepository();

  static const _latency = Duration(milliseconds: 700);
  static const _demoCode = '123456';

  @override
  Future<void> requestOtp({
    required OtpChannel channel,
    required String destination,
  }) async {
    await Future<void>.delayed(_latency);
    final normalized = destination.trim().toLowerCase();
    if (normalized == 'unknown@example.com' || normalized == '000') {
      throw const AuthException('Không tìm thấy tài khoản với thông tin này.');
    }
  }

  @override
  Future<String> verifyOtp({
    required String destination,
    required String code,
  }) async {
    await Future<void>.delayed(_latency);
    if (code != _demoCode) {
      throw const AuthException('Mã xác nhận không đúng hoặc đã hết hạn.');
    }
    // A real backend returns an opaque, single-use token here.
    return 'reset_${destination.hashCode}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    await Future<void>.delayed(_latency);
    if (resetToken.isEmpty) {
      throw const AuthException('Phiên đặt lại mật khẩu đã hết hạn.');
    }
  }
}
