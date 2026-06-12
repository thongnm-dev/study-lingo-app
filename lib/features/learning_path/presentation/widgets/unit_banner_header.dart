import 'package:flutter/material.dart';

import '../../domain/entities/course_unit.dart';

/// Sticky banner for each course unit. Used as a pinned
/// [SliverPersistentHeader] inside [SliverMainAxisGroup].
class UnitBannerHeader extends SliverPersistentHeaderDelegate {
  final CourseUnit unit;
  final Color color;
  final Color darkColor;

  UnitBannerHeader({
    required this.unit,
    required this.color,
    required this.darkColor,
  });

  static const double extent = 84;

  @override
  double get minExtent => extent;
  @override
  double get maxExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: darkColor, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unit.emoji,
                style: const TextStyle(fontSize: 23),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ĐƠN VỊ ${unit.index} · ${unit.progress}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    unit.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('📖', style: TextStyle(fontSize: 19)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant UnitBannerHeader oldDelegate) =>
      oldDelegate.unit != unit ||
      oldDelegate.color != color ||
      oldDelegate.darkColor != darkColor;
}
