import '../entities/auth_user.dart';

/// Thrown by [AuthRepository] when authentication fails. [message] is safe to
/// surface to the user.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Contract the auth Bloc depends on. The Bloc never knows whether this is
/// backed by a fake, Firebase, or a custom REST API — swap the implementation
/// in the data layer without touching presentation.
abstract class AuthRepository {
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUser> signInWithGoogle();

  Future<AuthUser> signInWithFacebook();

  Future<void> signOut();
}
