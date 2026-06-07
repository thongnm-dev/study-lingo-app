import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Which destination a [MoreMenuEntry] routes to. `practice` is wired to the
/// real quiz flow; the rest are placeholders for now.
enum MoreMenuAction { profile, pronunciation, videoCall, practice }

/// One row in the "More" (•••) bottom-sheet menu. Kept in its own file so both
/// the sheet and the destination page can depend on it without an import cycle.
/// The label is resolved per-locale via [labelOf] rather than stored, so the
/// menu follows the app's display language.
class MoreMenuEntry {
  const MoreMenuEntry({
    required this.action,
    required this.icon,
    required this.color,
  });

  final MoreMenuAction action;
  final IconData icon;
  final Color color;

  String labelOf(AppLocalizations l10n) => switch (action) {
    MoreMenuAction.profile => l10n.moreProfile,
    MoreMenuAction.pronunciation => l10n.morePronunciation,
    MoreMenuAction.videoCall => l10n.moreVideoCall,
    MoreMenuAction.practice => l10n.morePractice,
  };
}

/// The menu shown by [showMoreMenu]. "Luyện tập" routes to the practice quiz;
/// the others open a "coming soon" placeholder until their feature lands.
const moreMenuEntries = <MoreMenuEntry>[
  MoreMenuEntry(
    action: MoreMenuAction.profile,
    icon: AppIcons.personFilled,
    color: Color(0xFF1CB0F6),
  ),
  MoreMenuEntry(
    action: MoreMenuAction.pronunciation,
    icon: AppIcons.speaking,
    color: Color(0xFFFF6F61),
  ),
  MoreMenuEntry(
    action: MoreMenuAction.videoCall,
    icon: AppIcons.video,
    color: Color(0xFFA560F0),
  ),
  MoreMenuEntry(
    action: MoreMenuAction.practice,
    icon: AppIcons.exercise,
    color: Color(0xFF1CB0F6),
  ),
];
