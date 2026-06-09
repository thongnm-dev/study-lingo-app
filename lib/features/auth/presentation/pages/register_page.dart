import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/service_locator.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/session/current_user.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_form_widgets.dart';

/// Registration screen. Pairs with [LoginPage] — the "Đăng nhập" link at the
/// bottom pops back (or jumps to login if there's nothing to pop). Owns its
/// own AuthBloc (scoped to register mode) so the form's submit dispatches
/// `signUpWithEmail`.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(param1: AuthMode.register),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Transparent AppBar floats over the banner so the back button is
      // reachable without breaking the gradient hero's full-bleed look.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onPrimaryContainer,
      ),
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
                      Icon(
                        AppIcons.errorOutline,
                        color: scheme.onErrorContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.errorMessage ?? 'Đăng ký thất bại',
                          style: TextStyle(color: scheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          } else if (state.status == AuthStatus.success &&
              state.user != null) {
            getIt<CurrentUser>().value = state.user;
            context.go(RouteNames.overview);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AuthBannerHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthEmailField(),
                        SizedBox(height: 18),
                        AuthPasswordField(
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 18),
                        AuthConfirmPasswordField(),
                        SizedBox(height: 24),
                        AuthSubmitButton(label: 'Tạo tài khoản'),
                        SizedBox(height: 24),
                        AuthOrDivider(),
                        SizedBox(height: 20),
                        AuthSocialButtons(),
                        SizedBox(height: 20),
                        _GoToLoginLink(),
                      ],
                    ),
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

class _GoToLoginLink extends StatelessWidget {
  const _GoToLoginLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản? ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.auth);
            }
          },
          child: Text(
            'Đăng nhập',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
