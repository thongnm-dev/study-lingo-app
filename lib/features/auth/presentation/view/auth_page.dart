import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/home_shell.dart';
import '../../data/repositories/fake_auth_repository.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/social_sign_in_button.dart';

/// Single-screen auth: login and register share one form, toggled by the
/// "Sign up / Sign in" link at the bottom. Owns the BlocProvider so auth state
/// is scoped here. In a real app you'd lift an auth Bloc to the app root to
/// gate routing, and inject a live AuthRepository instead of the fake.
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(const FakeAuthRepository()),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (a, b) => a.status != b.status,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state.status == AuthStatus.failure) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: scheme.errorContainer,
                  content: Row(
                    children: [
                      Icon(Icons.error_outline, color: scheme.onErrorContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.errorMessage ?? 'Đăng nhập thất bại',
                          style: TextStyle(color: scheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          } else if (state.status == AuthStatus.success &&
              state.user != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => HomeShell(user: state.user!),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _GreetingHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: const _AuthForm(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Multilingual greeting illustration — fits a bilingual EN/JA learning app and
/// echoes the reference design's "Hello / こんにちは / Hola …" hero.
class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    Widget greeting(String text, double size, double opacity, FontWeight w) =>
        Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: size,
            fontWeight: w,
            color: scheme.onPrimaryContainer.withValues(alpha: opacity),
          ),
        );

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
          // Scattered multilingual greetings.
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              greeting('Hello', 22, 0.9, FontWeight.bold),
              greeting('안녕하세요', 14, 0.6, FontWeight.w500),
              greeting('Hola', 16, 0.7, FontWeight.w600),
              greeting('こんにちは', 20, 0.95, FontWeight.bold),
              greeting('Привет', 15, 0.55, FontWeight.w500),
              greeting('Bonjour', 17, 0.7, FontWeight.w600),
              greeting('Ciao', 14, 0.6, FontWeight.w500),
            ],
          ),
          const SizedBox(height: 20),
          // Central study badge.
          Container(
            height: 84,
            width: 84,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [scheme.primary, scheme.tertiary],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
          const SizedBox(height: 14),
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

class _AuthForm extends StatelessWidget {
  const _AuthForm();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (a, b) => a.mode != b.mode,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isLogin ? 'Chào mừng trở lại 👋' : 'Tạo tài khoản mới',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  state.isLogin
                      ? 'Rất vui được gặp lại bạn!'
                      : 'Bắt đầu hành trình học ngôn ngữ của bạn.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        const _EmailField(),
        const SizedBox(height: 18),
        const _PasswordField(),
        const _ConfirmPasswordField(),
        const _OptionsRow(),
        const SizedBox(height: 24),
        const _SubmitButton(),
        const SizedBox(height: 24),
        const _OrDivider(),
        const SizedBox(height: 20),
        const _SocialButtons(),
        const SizedBox(height: 20),
        const _ModeToggleLink(),
      ],
    );
  }
}

/// Shared decoration: a label sits *above* a rounded, filled field that uses a
/// placeholder hint (matching the reference design).
InputDecoration _fieldDecoration(
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

/// Small caption label rendered above a field.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
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

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) =>
          a.email != b.email || a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final showError = state.email.isNotEmpty && !state.isEmailValid;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel('Email'),
            TextField(
              enabled: !state.isSubmitting,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: (v) =>
                  context.read<AuthBloc>().add(AuthEmailChanged(v)),
              decoration: _fieldDecoration(
                context,
                hint: 'Nhập email của bạn',
                icon: Icons.mail_outline_rounded,
                errorText: showError ? 'Email không hợp lệ' : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField();

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

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
            const _FieldLabel('Mật khẩu'),
            TextField(
              enabled: !state.isSubmitting,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.password],
              onChanged: (v) =>
                  context.read<AuthBloc>().add(AuthPasswordChanged(v)),
              decoration: _fieldDecoration(
                context,
                hint: 'Nhập mật khẩu',
                icon: Icons.lock_outline_rounded,
                errorText: showError ? 'Tối thiểu 6 ký tự' : null,
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
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

/// Only shown in register mode. Animates in/out for a smooth mode switch.
class _ConfirmPasswordField extends StatefulWidget {
  const _ConfirmPasswordField();

  @override
  State<_ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<_ConfirmPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) =>
          a.mode != b.mode ||
          a.confirmPassword != b.confirmPassword ||
          a.password != b.password ||
          a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final showError =
            state.confirmPassword.isNotEmpty && !state.doPasswordsMatch;
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: state.isLogin
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('Xác nhận mật khẩu'),
                      TextField(
                        enabled: !state.isSubmitting,
                        obscureText: _obscure,
                        onChanged: (v) => context.read<AuthBloc>().add(
                          AuthConfirmPasswordChanged(v),
                        ),
                        decoration: _fieldDecoration(
                          context,
                          hint: 'Nhập lại mật khẩu',
                          icon: Icons.lock_outline_rounded,
                          errorText: showError ? 'Mật khẩu không khớp' : null,
                          suffixIcon: IconButton(
                            tooltip:
                                _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

/// "Remember me" + "Forgot password?" row, shown only in login mode.
/// Remember-me is UI-only for now (no backend persistence yet).
class _OptionsRow extends StatefulWidget {
  const _OptionsRow();

  @override
  State<_OptionsRow> createState() => _OptionsRowState();
}

class _OptionsRowState extends State<_OptionsRow> {
  bool _remember = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) => a.mode != b.mode,
      builder: (context, state) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: !state.isLogin
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _remember,
                                onChanged: (v) =>
                                    setState(() => _remember = v ?? false),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Ghi nhớ đăng nhập',
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Tính năng đặt lại mật khẩu sắp ra mắt.',
                                ),
                              ),
                            );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Quên mật khẩu?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

/// Large rounded gradient action button (login / create account).
class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

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
                              state.isLogin ? 'Đăng nhập' : 'Tạo tài khoản',
                              key: ValueKey(state.mode),
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

class _OrDivider extends StatelessWidget {
  const _OrDivider();

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

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

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
              icon: Icons.g_mobiledata,
              iconColor: const Color(0xFFDB4437),
              onPressed: state.isSubmitting
                  ? null
                  : () => bloc.add(const AuthGooglePressed()),
            ),
            const SizedBox(height: 12),
            SocialSignInButton(
              label: 'Tiếp tục với Facebook',
              icon: Icons.facebook,
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

/// Bottom "Don't have an account? Sign up" toggle that switches login/register.
class _ModeToggleLink extends StatelessWidget {
  const _ModeToggleLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) => a.mode != b.mode,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.isLogin ? 'Chưa có tài khoản? ' : 'Đã có tài khoản? ',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  context.read<AuthBloc>().add(const AuthModeToggled()),
              child: Text(
                state.isLogin ? 'Đăng ký' : 'Đăng nhập',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
