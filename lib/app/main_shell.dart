import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/icons/app_icons.dart';
import '../l10n/generated/app_localizations.dart';

/// Bottom-nav shell. Wraps a [StatefulNavigationShell] (GoRouter's
/// `StatefulShellRoute.indexedStack`) so each tab keeps its own navigation
/// stack and scroll position across tab switches.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.homeOutlined),
            selectedIcon: const Icon(AppIcons.homeFilled),
            label: l10n.navLessons,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.studyOutlined),
            selectedIcon: const Icon(AppIcons.studyFilled),
            label: l10n.navStudy,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.chatOutlined),
            selectedIcon: const Icon(AppIcons.chatFilled),
            label: l10n.navChat,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.person),
            selectedIcon: const Icon(AppIcons.personFilled),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
