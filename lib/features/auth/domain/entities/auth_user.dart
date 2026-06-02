import 'package:equatable/equatable.dart';

/// How the user authenticated. Drives provider-specific UI later (e.g. showing
/// "signed in with Google").
enum AuthProvider { email, google, facebook }

/// An authenticated user. Provider-agnostic on purpose — the same shape is
/// returned whether the user signed in with email, Google, or Facebook, so the
/// rest of the app never branches on the auth backend.
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.provider,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  final String id;
  final AuthProvider provider;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  @override
  List<Object?> get props => [id, provider, email, displayName, photoUrl];
}
