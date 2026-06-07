import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../model/more_menu_entry.dart';

/// Placeholder screen opened when a "More" menu item is tapped. Replace with the
/// real feature page (profile, pronunciation, video call, practice) as each is
/// built — the menu wiring stays the same.
class MoreDestinationPage extends StatelessWidget {
  const MoreDestinationPage({super.key, required this.entry});

  final MoreMenuEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final label = entry.labelOf(l10n);
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(entry.icon, size: 72, color: entry.color),
            const SizedBox(height: 16),
            Text(label, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              l10n.comingSoon,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
