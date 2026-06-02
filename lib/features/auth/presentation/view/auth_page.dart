import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/home_shell.dart';
import '../../data/repositories/fake_auth_repository.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/social_sign_in_button.dart';

/// Single-screen auth: login and register share one form, toggled by a
/// SegmentedButton. Owns the BlocProvider so auth state is scoped here. In a
/// real app you'd lift an auth Bloc to the app root to gate routing, and inject
/// a live AuthRepository instead of the fake.
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
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (a, b) => a.status != b.status,
          listener: (context, state) {
            final messenger = ScaffoldMessenger.of(context);
            if (state.status == AuthStatus.failure) {
              messenger.showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Failed')),
              );
            } else if (state.status == AuthStatus.success &&
                state.user != null) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text('Welcome, ${state.user?.displayName ?? ''}!'),
                ),
              );
              // Demo routing: replace the auth screen with the app's home,
              // carrying the signed-in user through for the profile screen.
              // A real app would let an app-root auth Bloc drive this.
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => HomeShell(user: state.user!),
                ),
              );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: const _AuthForm(),
              ),
            ),
          ),
        ),
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
        Text(
          'StudyLingo',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Learn English & Japanese',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        const _ModeSelector(),
        const SizedBox(height: 24),
        const _EmailField(),
        const SizedBox(height: 16),
        const _PasswordField(),
        const _ConfirmPasswordField(),
        const SizedBox(height: 24),
        const _SubmitButton(),
        const SizedBox(height: 24),
        const _OrDivider(),
        const SizedBox(height: 24),
        const _SocialButtons(),
      ],
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) => a.mode != b.mode,
      builder: (context, state) {
        return SegmentedButton<AuthMode>(
          segments: const [
            ButtonSegment(value: AuthMode.login, label: Text('Sign in')),
            ButtonSegment(value: AuthMode.register, label: Text('Sign up')),
          ],
          selected: {state.mode},
          onSelectionChanged: (_) =>
              context.read<AuthBloc>().add(const AuthModeToggled()),
        );
      },
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
        return TextField(
          enabled: !state.isSubmitting,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          onChanged: (v) => context.read<AuthBloc>().add(AuthEmailChanged(v)),
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.mail_outline),
            border: const OutlineInputBorder(),
            errorText: showError ? 'Enter a valid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (a, b) =>
          a.password != b.password || a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final showError = state.password.isNotEmpty && !state.isPasswordValid;
        return TextField(
          enabled: !state.isSubmitting,
          obscureText: true,
          autofillHints: const [AutofillHints.password],
          onChanged: (v) =>
              context.read<AuthBloc>().add(AuthPasswordChanged(v)),
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            border: const OutlineInputBorder(),
            errorText: showError ? 'At least 6 characters' : null,
          ),
        );
      },
    );
  }
}

/// Only shown in register mode. Animates in/out for a smooth mode switch.
class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField();

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
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    enabled: !state.isSubmitting,
                    obscureText: true,
                    onChanged: (v) => context.read<AuthBloc>().add(
                      AuthConfirmPasswordChanged(v),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      errorText: showError ? 'Passwords do not match' : null,
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return FilledButton(
          onPressed: state.canSubmit
              ? () => context.read<AuthBloc>().add(const AuthEmailSubmitted())
              : null,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          child: state.isSubmitting
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(state.isLogin ? 'Sign in' : 'Create account'),
        );
      },
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: Theme.of(context).textTheme.bodySmall,
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
              label: 'Continue with Google',
              icon: Icons.g_mobiledata,
              iconColor: const Color(0xFFDB4437),
              onPressed: state.isSubmitting
                  ? null
                  : () => bloc.add(const AuthGooglePressed()),
            ),
            const SizedBox(height: 12),
            SocialSignInButton(
              label: 'Continue with Facebook',
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
