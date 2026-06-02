import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(entry.label)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(entry.icon, size: 72, color: entry.color),
            const SizedBox(height: 16),
            Text(entry.label, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Sắp ra mắt',
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
