import 'package:equatable/equatable.dart';

/// How the user authenticated. Drives provider-specific UI later (e.g. showing
/// "signed in with Google").
enum AuthProvider { email, google, facebook }

/// Self-declared gender on the profile. `null` means "not specified".
enum Gender { male, female, other }

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
    this.gender,
  });

  final String id;
  final AuthProvider provider;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final Gender? gender;

  AuthUser copyWith({
    String? displayName,
    String? photoUrl,
    Gender? gender,
    bool clearPhotoUrl = false,
    bool clearGender = false,
  }) {
    return AuthUser(
      id: id,
      provider: provider,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: clearPhotoUrl ? null : (photoUrl ?? this.photoUrl),
      gender: clearGender ? null : (gender ?? this.gender),
    );
  }

  @override
  List<Object?> get props => [
    id,
    provider,
    email,
    displayName,
    photoUrl,
    gender,
  ];
}
