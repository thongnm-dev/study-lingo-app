import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/core/theme/app_colors.dart';
import 'package:flutter_bloc/l10n/app_localizations.dart';

/// Wraps a form screen with a discard-confirmation flow when the user has
/// unsaved changes. Use for create/edit screens where the user could lose
/// in-progress input by accidentally leaving.
///
/// Two integration points are needed on the host screen:
///
/// 1. Wrap the `Scaffold` (or its body) with [UnsavedChangesGuard] so system
///    back / iOS swipe-back goes through [PopScope].
/// 2. Route the `AppBar` leading back button through
///    [UnsavedChangesGuard.maybePop] so tapping it triggers the same dialog.
///
/// Both paths are blocked while [isBlocked] is true (e.g. while submitting).
class UnsavedChangesGuard extends StatelessWidget {
  /// Whether the form currently has unsaved changes.
  final bool isDirty;

  /// Hard-block any pop attempt (e.g. while the form is submitting) so the
  /// dialog isn't shown and the user can't leave until the operation ends.
  final bool isBlocked;

  /// Optional override for how to perform the pop after confirmation. Defaults
  /// to `context.pop()` when the route can pop. Pass this when the host uses
  /// a custom navigation helper (e.g. fallback to `context.go(...)` on deep
  /// links).
  final VoidCallback? onPop;

  final Widget child;

  const UnsavedChangesGuard({
    super.key,
    required this.isDirty,
    required this.child,
    this.isBlocked = false,
    this.onPop,
  });

  /// Show the discard dialog when [isDirty] is true and return whether the
  /// user chose to leave. When [isDirty] is false the dialog is skipped and
  /// this returns true immediately.
  static Future<bool> confirmDiscard(
    BuildContext context, {
    required bool isDirty,
  }) async {
    if (!isDirty) return true;
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.unsavedChangesTitle),
        content: Text(l10n.unsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.unsavedChangesKeepEditing),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.unsavedChangesLeave),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Pop helper for AppBar back buttons. Confirms with the user when
  /// [isDirty]; does nothing when [isBlocked].
  static Future<void> maybePop(
    BuildContext context, {
    required bool isDirty,
    bool isBlocked = false,
    VoidCallback? onPop,
  }) async {
    if (isBlocked) return;
    final ok = await confirmDiscard(context, isDirty: isDirty);
    if (!ok || !context.mounted) return;
    _performPop(context, onPop);
  }

  static void _performPop(BuildContext context, VoidCallback? onPop) {
    if (onPop != null) {
      onPop();
    } else if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isDirty && !isBlocked,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (isBlocked) return;
        final ok = await confirmDiscard(context, isDirty: isDirty);
        if (ok && context.mounted) _performPop(context, onPop);
      },
      child: child,
    );
  }
}
