import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// A simulated [AuthRepository] so the auth flow is fully runnable with no
/// backend, OAuth credentials, or platform config. It validates inputs the way
/// a real backend would and fabricates an [AuthUser] after a short delay.
///
/// To go live, write a real implementation of [AuthRepository] and swap it in
/// at [AuthPage]'s BlocProvider. Typical wiring:
///   * Email      -> firebase_auth `createUserWithEmailAndPassword` / `signInWithEmailAndPassword`
///   * Google     -> google_sign_in -> credential -> firebase_auth `signInWithCredential`
///   * Facebook   -> flutter_facebook_auth -> credential -> firebase_auth `signInWithCredential`
/// Each of those also needs platform setup (google-services.json / Info.plist,
/// Facebook App ID, OAuth client IDs) — none of which this fake requires.
class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository();

  static const _latency = Duration(milliseconds: 700);

  @override
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);
    // Pretend this address is already taken, to exercise the failure path.
    if (email.toLowerCase() == 'taken@example.com') {
      throw const AuthException('That email is already registered.');
    }
    return AuthUser(
      id: 'email_${email.hashCode}',
      provider: AuthProvider.email,
      email: email,
      displayName: email.split('@').first,
    );
  }

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);
    // Demo failure: any password "wrong" is rejected.
    if (password == 'wrong') {
      throw const AuthException('Incorrect email or password.');
    }
    return AuthUser(
      id: 'email_${email.hashCode}',
      provider: AuthProvider.email,
      email: email,
      displayName: email.split('@').first,
    );
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    await Future<void>.delayed(_latency);
    return const AuthUser(
      id: 'google_demo',
      provider: AuthProvider.google,
      email: 'demo@gmail.com',
      displayName: 'Google User',
    );
  }

  @override
  Future<AuthUser> signInWithFacebook() async {
    await Future<void>.delayed(_latency);
    return const AuthUser(
      id: 'facebook_demo',
      provider: AuthProvider.facebook,
      email: 'demo@facebook.com',
      displayName: 'Facebook User',
    );
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
