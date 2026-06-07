import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/icons/app_icons.dart';
import '../../data/repositories/fake_password_reset_repository.dart';
import '../../domain/entities/otp_channel.dart';
import '../bloc/forgot_password_bloc.dart';

/// Password recovery: choose a delivery channel + destination → receive and
/// enter a one-time code → set a new password. Owns its [BlocProvider] so the
/// flow's state is scoped here; swap [FakePasswordResetRepository] for a live
/// implementation when going to production (see that class's docs).
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(const FakePasswordResetRepository()),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Khôi phục mật khẩu'),
        leading: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          buildWhen: (a, b) => a.step != b.step,
          builder: (context, state) {
            return IconButton(
              icon: const Icon(AppIcons.arrowBack),
              tooltip: 'Quay lại',
              // On the first/last step, leave the flow; otherwise step back.
              onPressed: state.isSubmitting
                  ? null
                  : () {
                      final canStepBack =
                          state.step == ForgotPasswordStep.verify ||
                          state.step == ForgotPasswordStep.reset;
                      if (canStepBack) {
                        context
                            .read<ForgotPasswordBloc>()
                            .add(const ForgotBackRequested());
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
            );
          },
        ),
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listenWhen: (a, b) => a.status != b.status,
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: scheme.errorContainer,
                  content: Row(
                    children: [
                      Icon(AppIcons.errorOutline, color: scheme.onErrorContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.errorMessage ?? 'Đã có lỗi xảy ra.',
                          style: TextStyle(color: scheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StepIndicator(step: state.step),
                      const SizedBox(height: 28),
                      // Smoothly cross-fade between steps.
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: KeyedSubtree(
                          key: ValueKey(state.step),
                          child: switch (state.step) {
                            ForgotPasswordStep.request => const _RequestStep(),
                            ForgotPasswordStep.verify => const _VerifyStep(),
                            ForgotPasswordStep.reset => const _ResetStep(),
                            ForgotPasswordStep.done => const _DoneStep(),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A 3-dot progress indicator above the active step's form.
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});
  final ForgotPasswordStep step;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // `done` counts as past the 3rd step.
    final activeIndex = switch (step) {
      ForgotPasswordStep.request => 0,
      ForgotPasswordStep.verify => 1,
      ForgotPasswordStep.reset => 2,
      ForgotPasswordStep.done => 3,
    };
    return Row(
      children: List.generate(3, (i) {
        final reached = i <= activeIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 6,
              decoration: BoxDecoration(
                color: reached
                    ? scheme.primary
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Step headers ────────────────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

// ── Step 1: request a code ───────────────────────────────────────────────────

class _RequestStep extends StatelessWidget {
  const _RequestStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepHeader(
          title: 'Quên mật khẩu?',
          subtitle:
              'Nhập email hoặc số điện thoại của bạn. Chúng tôi sẽ gửi một mã '
              'gồm 6 chữ số để xác minh đó là bạn.',
        ),
        const _DestinationField(),
        const SizedBox(height: 28),
        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return _PrimaryButton(
              label: 'Gửi mã xác nhận',
              enabled: state.canRequest,
              loading: state.isSubmitting,
              onTap: () => context
                  .read<ForgotPasswordBloc>()
                  .add(const ForgotOtpRequested()),
            );
          },
        ),
      ],
    );
  }
}

class _DestinationField extends StatelessWidget {
  const _DestinationField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (a, b) =>
          a.destination != b.destination ||
          a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final showError =
            state.destination.isNotEmpty && !state.isDestinationValid;
        // The icon hints which channel was detected once the input is valid.
        final icon = switch (state.detectedChannel) {
          OtpChannel.email => AppIcons.email,
          OtpChannel.phone => AppIcons.phone,
          null => AppIcons.at,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel('Email hoặc số điện thoại'),
            TextField(
              enabled: !state.isSubmitting,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.telephoneNumber,
              ],
              onChanged: (v) => context
                  .read<ForgotPasswordBloc>()
                  .add(ForgotDestinationChanged(v)),
              onSubmitted: (_) {
                if (state.canRequest) {
                  context
                      .read<ForgotPasswordBloc>()
                      .add(const ForgotOtpRequested());
                }
              },
              decoration: _fieldDecoration(
                context,
                hint: 'Nhập email hoặc số điện thoại',
                icon: icon,
                errorText: showError
                    ? 'Vui lòng nhập email hoặc số điện thoại hợp lệ'
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Step 2: verify the code ──────────────────────────────────────────────────

class _VerifyStep extends StatelessWidget {
  const _VerifyStep();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        final via = state.isEmailDestination ? 'email' : 'số điện thoại';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StepHeader(
              title: 'Nhập mã xác nhận',
              subtitle:
                  'Chúng tôi đã gửi mã gồm 6 chữ số tới $via '
                  '${state.destination.trim()}. (Bản demo: mã là 123456.)',
            ),
            const _CodeField(),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: state.isSubmitting
                    ? null
                    : () => context
                          .read<ForgotPasswordBloc>()
                          .add(const ForgotOtpRequested()),
                icon: const Icon(AppIcons.refresh, size: 20),
                label: const Text('Gửi lại mã'),
              ),
            ),
            const SizedBox(height: 20),
            _PrimaryButton(
              label: 'Xác nhận',
              enabled: state.canVerify,
              loading: state.isSubmitting,
              onTap: () => context
                  .read<ForgotPasswordBloc>()
                  .add(const ForgotOtpSubmitted()),
            ),
          ],
        );
      },
    );
  }
}

class _CodeField extends StatelessWidget {
  const _CodeField();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (a, b) =>
          a.code != b.code || a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel('Mã xác nhận'),
            TextField(
              enabled: !state.isSubmitting,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 6,
              autofillHints: const [AutofillHints.oneTimeCode],
              style: theme.textTheme.headlineSmall?.copyWith(
                letterSpacing: 8,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              onChanged: (v) =>
                  context.read<ForgotPasswordBloc>().add(ForgotCodeChanged(v)),
              onSubmitted: (_) {
                if (state.canVerify) {
                  context
                      .read<ForgotPasswordBloc>()
                      .add(const ForgotOtpSubmitted());
                }
              },
              decoration: _fieldDecoration(
                context,
                hint: '••••••',
                icon: AppIcons.password,
              ).copyWith(counterText: ''),
            ),
          ],
        );
      },
    );
  }
}

// ── Step 3: set a new password ───────────────────────────────────────────────

class _ResetStep extends StatelessWidget {
  const _ResetStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepHeader(
          title: 'Đặt lại mật khẩu',
          subtitle: 'Tạo mật khẩu mới cho tài khoản của bạn.',
        ),
        const _NewPasswordField(),
        const SizedBox(height: 18),
        const _ConfirmNewPasswordField(),
        const SizedBox(height: 28),
        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return _PrimaryButton(
              label: 'Đặt lại mật khẩu',
              enabled: state.canReset,
              loading: state.isSubmitting,
              onTap: () => context
                  .read<ForgotPasswordBloc>()
                  .add(const ForgotPasswordSubmitted()),
            );
          },
        ),
      ],
    );
  }
}

class _NewPasswordField extends StatefulWidget {
  const _NewPasswordField();

  @override
  State<_NewPasswordField> createState() => _NewPasswordFieldState();
}

class _NewPasswordFieldState extends State<_NewPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (a, b) =>
          a.newPassword != b.newPassword || a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final showError =
            state.newPassword.isNotEmpty && !state.isPasswordValid;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel('Mật khẩu mới'),
            TextField(
              enabled: !state.isSubmitting,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: (v) => context
                  .read<ForgotPasswordBloc>()
                  .add(ForgotNewPasswordChanged(v)),
              decoration: _fieldDecoration(
                context,
                hint: 'Nhập mật khẩu mới',
                icon: AppIcons.lock,
                errorText: showError ? 'Tối thiểu 6 ký tự' : null,
                suffixIcon: _ObscureToggle(
                  obscure: _obscure,
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

class _ConfirmNewPasswordField extends StatefulWidget {
  const _ConfirmNewPasswordField();

  @override
  State<_ConfirmNewPasswordField> createState() =>
      _ConfirmNewPasswordFieldState();
}

class _ConfirmNewPasswordFieldState extends State<_ConfirmNewPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (a, b) =>
          a.confirmPassword != b.confirmPassword ||
          a.newPassword != b.newPassword ||
          a.isSubmitting != b.isSubmitting,
      builder: (context, state) {
        final showError =
            state.confirmPassword.isNotEmpty && !state.doPasswordsMatch;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel('Xác nhận mật khẩu mới'),
            TextField(
              enabled: !state.isSubmitting,
              obscureText: _obscure,
              onChanged: (v) => context
                  .read<ForgotPasswordBloc>()
                  .add(ForgotConfirmPasswordChanged(v)),
              decoration: _fieldDecoration(
                context,
                hint: 'Nhập lại mật khẩu mới',
                icon: AppIcons.lock,
                errorText: showError ? 'Mật khẩu không khớp' : null,
                suffixIcon: _ObscureToggle(
                  obscure: _obscure,
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

// ── Step 4: done ─────────────────────────────────────────────────────────────

class _DoneStep extends StatelessWidget {
  const _DoneStep();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          height: 88,
          width: 88,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            AppIcons.check,
            size: 52,
            color: scheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Đổi mật khẩu thành công!',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mật khẩu của bạn đã được cập nhật. Hãy đăng nhập bằng mật khẩu mới.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        _PrimaryButton(
          label: 'Quay lại đăng nhập',
          enabled: true,
          loading: false,
          // The AuthPage that pushed this is still beneath us — just pop back.
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

// ── Shared widgets / helpers (mirroring auth_page.dart) ──────────────────────

/// Large rounded gradient action button — matches the auth screen's submit CTA.
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Opacity(
      opacity: enabled || loading ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [scheme.primary, scheme.tertiary]),
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
            onTap: enabled && !loading ? onTap : null,
            child: SizedBox(
              height: 56,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: loading
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
  }
}

class _ObscureToggle extends StatelessWidget {
  const _ObscureToggle({required this.obscure, required this.onPressed});
  final bool obscure;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
      icon: Icon(
        obscure ? AppIcons.visibility : AppIcons.visibilityOff,
      ),
      onPressed: onPressed,
    );
  }
}

/// Small caption label rendered above a field (same style as auth_page).
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

/// Shared field decoration: a rounded, filled field with a placeholder hint —
/// mirrors `_fieldDecoration` on the auth screen for a consistent look.
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
