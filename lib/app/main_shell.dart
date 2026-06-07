import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/icons/app_icons.dart';
import '../features/auth/domain/entities/auth_user.dart';
import '../features/more/presentation/pages/more_menu.dart';
import '../l10n/generated/app_localizations.dart';

/// Bottom-nav shell. Wraps a [StatefulNavigationShell] (GoRouter's
/// `StatefulShellRoute.indexedStack`) so each tab keeps its own navigation
/// stack and scroll position across tab switches.
///
/// The "More" destination (index == branch count) is an action, not a route:
/// it opens [showMoreMenu] without changing the selected tab.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell, required this.user});

  final StatefulNavigationShell navigationShell;

  /// The signed-in user, surfaced by the "Hồ sơ" (profile) entry in More.
  final AuthUser user;

  static const _branchCount = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) {
          if (i >= _branchCount) {
            showMoreMenu(context, user);
          } else {
            navigationShell.goBranch(
              i,
              initialLocation: i == navigationShell.currentIndex,
            );
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.homeOutlined),
            selectedIcon: const Icon(AppIcons.homeFilled),
            label: l10n.navLessons,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.progressOutlined),
            selectedIcon: const Icon(AppIcons.progressFilled),
            label: l10n.navProgress,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.wordsOutlined),
            selectedIcon: const Icon(AppIcons.wordsFilled),
            label: l10n.navVocabulary,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.more),
            label: l10n.navMore,
          ),
        ],
      ),
    );
  }
}
