import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Shared empty-state for load failures: icon + message + retry button.
///
/// Use this anywhere a screen needs to surface a "failed to load" state with a
/// retry action. Callers supply the resolved [message] (already falling back to
/// a feature-specific default) and the [onRetry] callback.
class ErrorRetryView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  /// Wrap content in a [Center]. Set to false when the host already centers
  /// (e.g. inside an [Expanded] column with `mainAxisAlignment: center`).
  final bool centered;

  const ErrorRetryView({
    super.key,
    required this.message,
    required this.onRetry,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 56,
            color: colors.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
    return centered ? Center(child: content) : content;
  }
}
