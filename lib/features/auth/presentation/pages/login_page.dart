import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/service_locator.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/session/current_user.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_form_widgets.dart';

/// Login screen. Pairs with [RegisterPage] — the "Đăng ký" link at the bottom
/// pushes the register route. Owns its own AuthBloc (scoped to login mode) so
/// the form's submit dispatches `signInWithEmail`.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(param1: AuthMode.login),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

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
                      Icon(
                        AppIcons.errorOutline,
                        color: scheme.onErrorContainer,
                      ),
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
                        AuthPasswordField(),
                        _OptionsRow(),
                        SizedBox(height: 24),
                        AuthSubmitButton(label: 'Đăng nhập'),
                        SizedBox(height: 24),
                        AuthOrDivider(),
                        SizedBox(height: 20),
                        AuthSocialButtons(),
                        SizedBox(height: 20),
                        _GoToRegisterLink(),
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

/// "Remember me" + "Forgot password?" row. Remember-me is UI-only for now
/// (no backend persistence yet).
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
    return Padding(
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
            onPressed: () => context.push(RouteNames.forgotPassword),
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
    );
  }
}

class _GoToRegisterLink extends StatelessWidget {
  const _GoToRegisterLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Chưa có tài khoản? ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: () => context.push(RouteNames.register),
          child: Text(
            'Đăng ký',
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
