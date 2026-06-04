import '../entities/otp_channel.dart';
import 'auth_repository.dart' show AuthException;

/// Contract for the "forgot password" flow, kept separate from [AuthRepository]
/// so the sign-in/out contract stays focused. The Bloc depends on this
/// interface only — swap a fake for Firebase/REST without touching presentation.
///
/// Every method may throw [AuthException]; its [AuthException.message] is safe
/// to surface to the user.
abstract class PasswordResetRepository {
  /// Send a one-time code to [destination] (an email address or phone number,
  /// per [channel]). Returns when the backend has accepted the send request.
  Future<void> requestOtp({
    required OtpChannel channel,
    required String destination,
  });

  /// Validate the [code] the user received for [destination]. Returns a
  /// short-lived reset token to be passed to [resetPassword] — proving the
  /// code was verified without re-sending it. Throws [AuthException] when the
  /// code is wrong or expired.
  Future<String> verifyOtp({
    required String destination,
    required String code,
  });

  /// Set a new password using the [resetToken] obtained from [verifyOtp].
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  });
}
