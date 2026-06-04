import 'package:flutter/material.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/lessons/presentation/view/overview_page.dart';
import '../../features/more/presentation/view/more_menu.dart';
import '../../features/progress/presentation/view/progress_page.dart';
import '../../features/vocabulary/presentation/view/vocabulary_page.dart';
import '../../l10n/generated/app_localizations.dart';

/// Top-level navigation after sign-in. Each destination is a self-contained
/// feature page that provides its own Bloc/Cubit (reading shared repositories
/// from the app-root RepositoryProvider).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.user});

  /// The signed-in user, surfaced by the "Hồ sơ" (profile) entry in More.
  final AuthUser user;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // Kept alive across tab switches via IndexedStack so in-progress state (e.g.
  // a scroll position or a loaded list) survives navigation.
  static const _pages = [OverviewPage(), ProgressPage(), VocabularyPage()];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        // The "More" destination (index == _pages.length) is an action, not a
        // page: it opens the bottom-sheet menu and leaves the selected tab as-is.
        onDestinationSelected: (i) {
          if (i >= _pages.length) {
            showMoreMenu(context, widget.user);
          } else {
            setState(() => _index = i);
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navLessons,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: l10n.navProgress,
          ),
          NavigationDestination(
            icon: const Icon(Icons.style_outlined),
            selectedIcon: const Icon(Icons.style),
            label: l10n.navVocabulary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz),
            label: l10n.navMore,
          ),
        ],
      ),
    );
  }
}
