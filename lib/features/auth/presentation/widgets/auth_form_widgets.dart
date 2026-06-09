import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/icons/app_icons.dart';
import '../bloc/auth_bloc.dart';
import 'social_sign_in_button.dart';

/// Gradient hero at the top of the auth screens. Currently shows a styled
/// placeholder (gradient school-icon tile + "StudyLingo" wordmark); when a
/// real banner asset is ready, drop it in at the marked spot below — declare
/// the asset in `pubspec.yaml` and swap the placeholder block for
/// `Image.asset(...)` (or `Image.network`/`SvgPicture` as appropriate).
class AuthBannerHeader extends StatelessWidget {
  const AuthBannerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, topPadding + 28, 24, 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scheme.primaryContainer,
            scheme.primaryContainer.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // ── Banner image slot ──────────────────────────────────────────────
          // TODO: replace this placeholder with the real banner, e.g.
          //   Image.asset(
          //     'assets/banners/auth_banner.png',
          //     height: 120,
          //     fit: BoxFit.contain,
          //   ),
          // Keep the surrounding ConstrainedBox so the gradient hero stays a
          // consistent height across screens until the asset is wired up.
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.primary, scheme.tertiary],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  AppIcons.school,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'StudyLingo',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onPrimaryContainer,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared decoration for the auth form's rounded, filled fields.
InputDecoration authFieldDecoration(
  BuildContext context, {
  required String hint,
  required IconData icon,
  String? errorText,
  Widget? suffixIcon,
}) {
  final scheme = Theme.of(context).colorScheme;
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon),
    suffixIcon: suffixIcon,
    errorText: errorText,
    filled: true,
    fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
    border: border(Colors.transparent),
    enabledBorder: border(Colors.transparent),
    focusedBorder: border(scheme.primary, 1.6),
    errorBorder: border(scheme.error),
    focusedErrorBorder: border(scheme.error, 1.6),
  );
}

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    // Seed the TextFormField's internal controller from the bloc's *initial*
    // state once — that's what surfaces the prefilled demo creds. Later
    // rebuilds preserve the user's typing.
    final initialEmail = context.read<AuthBloc>().state.email;
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) =>
          a.email != b.email || a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final showError = state.email.isNotEmpty && !state.isEmailValid;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthFieldLabel('Email'),
            TextFormField(
              initialValue: initialEmail,
              enabled: !state.isSubmitting,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: (v) =>
                  context.read<AuthBloc>().add(AuthEmailChanged(v)),
              decoration: authFieldDecoration(
                context,
                hint: 'vidu@email.com',
                icon: AppIcons.email,
                errorText: showError ? 'Email không hợp lệ' : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    this.textInputAction = TextInputAction.done,
  });

  final TextInputAction textInputAction;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;
  late final String _initialPassword =
      context.read<AuthBloc>().state.password;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) =>
          a.password != b.password || a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final showError = state.password.isNotEmpty && !state.isPasswordValid;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthFieldLabel('Mật khẩu'),
            TextFormField(
              initialValue: _initialPassword,
              enabled: !state.isSubmitting,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.password],
              textInputAction: widget.textInputAction,
              onChanged: (v) =>
                  context.read<AuthBloc>().add(AuthPasswordChanged(v)),
              onFieldSubmitted: (_) =>
                  context.read<AuthBloc>().add(const AuthEmailSubmitted()),
              decoration: authFieldDecoration(
                context,
                hint: 'Ít nhất 6 ký tự',
                icon: AppIcons.lock,
                errorText: showError ? 'Tối thiểu 6 ký tự' : null,
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                  icon: Icon(
                    _obscure ? AppIcons.visibility : AppIcons.visibilityOff,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AuthConfirmPasswordField extends StatefulWidget {
  const AuthConfirmPasswordField({super.key});

  @override
  State<AuthConfirmPasswordField> createState() =>
      _AuthConfirmPasswordFieldState();
}

class _AuthConfirmPasswordFieldState extends State<AuthConfirmPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) =>
          a.confirmPassword != b.confirmPassword ||
          a.password != b.password ||
          a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final showError =
            state.confirmPassword.isNotEmpty && !state.doPasswordsMatch;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthFieldLabel('Xác nhận mật khẩu'),
            TextFormField(
              enabled: !state.isSubmitting,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              onChanged: (v) => context.read<AuthBloc>().add(
                AuthConfirmPasswordChanged(v),
              ),
              onFieldSubmitted: (_) =>
                  context.read<AuthBloc>().add(const AuthEmailSubmitted()),
              decoration: authFieldDecoration(
                context,
                hint: 'Nhập lại mật khẩu',
                icon: AppIcons.lock,
                errorText: showError ? 'Mật khẩu không khớp' : null,
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                  icon: Icon(
                    _obscure ? AppIcons.visibility : AppIcons.visibilityOff,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Large rounded gradient submit button. The label varies between
/// "Đăng nhập" / "Tạo tài khoản" depending on which page hosts it.
class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final enabled = state.canSubmit;
        return Opacity(
          opacity: enabled || state.isSubmitting ? 1 : 0.5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.tertiary],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: enabled
                    ? () => context
                          .read<AuthBloc>()
                          .add(const AuthEmailSubmitted())
                    : null,
                child: SizedBox(
                  height: 56,
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: state.isSubmitting
                          ? const SizedBox(
                              key: ValueKey('loading'),
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              label,
                              key: ValueKey(label),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = scheme.outlineVariant;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'hoặc tiếp tục với',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}

class AuthSocialButtons extends StatelessWidget {
  const AuthSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) => a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final bloc = context.read<AuthBloc>();
        return Column(
          children: [
            SocialSignInButton(
              label: 'Tiếp tục với Google',
              icon: AppIcons.google,
              iconColor: const Color(0xFFDB4437),
              onPressed: state.isSubmitting
                  ? null
                  : () => bloc.add(const AuthGooglePressed()),
            ),
            const SizedBox(height: 12),
            SocialSignInButton(
              label: 'Tiếp tục với Facebook',
              icon: AppIcons.facebook,
              iconColor: const Color(0xFF1877F2),
              onPressed: state.isSubmitting
                  ? null
                  : () => bloc.add(const AuthFacebookPressed()),
            ),
          ],
        );
      },
    );
  }
}
