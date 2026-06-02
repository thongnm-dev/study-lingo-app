import 'package:flutter/material.dart';

import '../../../auth/domain/entities/auth_user.dart';
import '../../../lessons/presentation/view/practice_page.dart';
import '../../../profile/presentation/view/profile_page.dart';
import '../model/more_menu_entry.dart';
import 'more_destination_page.dart';

/// Opens the "•••" menu as a modal bottom sheet (the Duolingo-style sheet that
/// slides up from the bottom nav). Returns after the user dismisses it; if they
/// picked an entry, routes to its destination ("Hồ sơ" → profile, "Luyện tập" →
/// practice quiz; everything else → a placeholder page for now). [user] is the
/// signed-in account shown on the profile screen.
Future<void> showMoreMenu(BuildContext context, AuthUser user) async {
  final selected = await showModalBottomSheet<MoreMenuEntry>(
    context: context,
    showDragHandle: true,
    builder: (_) => const _MoreMenuSheet(entries: moreMenuEntries),
  );
  if (selected == null || !context.mounted) return;
  final route = switch (selected.action) {
    MoreMenuAction.profile => MaterialPageRoute<void>(
      builder: (_) => ProfilePage(user: user),
    ),
    MoreMenuAction.practice => MaterialPageRoute<void>(
      builder: (_) => const PracticePage(),
    ),
    _ => MaterialPageRoute<void>(
      builder: (_) => MoreDestinationPage(entry: selected),
    ),
  };
  await Navigator.of(context).push(route);
}

class _MoreMenuSheet extends StatelessWidget {
  const _MoreMenuSheet({required this.entries});

  final List<MoreMenuEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < entries.length; i++) ...[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                leading: Icon(
                  entries[i].icon,
                  color: entries[i].color,
                  size: 30,
                ),
                title: Text(
                  entries[i].label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(entries[i]),
              ),
              if (i < entries.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}
