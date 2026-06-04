/// Where a one-time password (OTP) is delivered during password reset. The user
/// can recover their account either by email or by phone number — both are
/// first-class, so the rest of the flow branches on this instead of assuming
/// email.
enum OtpChannel { email, phone }
