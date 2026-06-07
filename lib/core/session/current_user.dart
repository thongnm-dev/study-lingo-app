import '../../features/auth/domain/entities/auth_user.dart';

/// Mutable holder for the signed-in [AuthUser], shared via GetIt as a
/// singleton. The auth flow writes here on success, and the router's redirect
/// reads it to gate the post-login routes.
///
/// This is a deliberately tiny seam. A larger app would put session state
/// inside an `AuthSessionCubit` (events for login/logout, listeners that can
/// react to expiry) — wire that the same way and the rest of the app stays
/// unchanged.
class CurrentUser {
  AuthUser? value;
}
