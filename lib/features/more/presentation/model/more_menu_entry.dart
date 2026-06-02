import 'package:flutter/material.dart';

/// Which destination a [MoreMenuEntry] routes to. `practice` is wired to the
/// real quiz flow; the rest are placeholders for now.
enum MoreMenuAction { profile, pronunciation, videoCall, practice }

/// One row in the "More" (•••) bottom-sheet menu. Kept in its own file so both
/// the sheet and the destination page can depend on it without an import cycle.
class MoreMenuEntry {
  const MoreMenuEntry({
    required this.action,
    required this.icon,
    required this.color,
    required this.label,
  });

  final MoreMenuAction action;
  final IconData icon;
  final Color color;
  final String label;
}

/// The menu shown by [showMoreMenu]. "Luyện tập" routes to the practice quiz;
/// the others open a "coming soon" placeholder until their feature lands.
const moreMenuEntries = <MoreMenuEntry>[
  MoreMenuEntry(
    action: MoreMenuAction.profile,
    icon: Icons.person,
    color: Color(0xFF1CB0F6),
    label: 'Hồ sơ',
  ),
  MoreMenuEntry(
    action: MoreMenuAction.pronunciation,
    icon: Icons.record_voice_over,
    color: Color(0xFFFF6F61),
    label: 'Phát âm',
  ),
  MoreMenuEntry(
    action: MoreMenuAction.videoCall,
    icon: Icons.videocam,
    color: Color(0xFFA560F0),
    label: 'Cuộc gọi video',
  ),
  MoreMenuEntry(
    action: MoreMenuAction.practice,
    icon: Icons.fitness_center,
    color: Color(0xFF1CB0F6),
    label: 'Luyện tập',
  ),
];
