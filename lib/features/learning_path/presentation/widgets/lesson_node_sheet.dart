import 'package:flutter/material.dart';

import '../../../../shared/widgets/pressable_3d.dart';
import '../../domain/entities/course_unit.dart';
import '../../domain/entities/lesson_node.dart';

/// Bottom sheet shown when tapping a path node: title, subtitle, and a CTA.
class LessonNodeSheet extends StatelessWidget {
  final CourseUnit unit;
  final LessonNode node;
  final Color color;
  final Color darkColor;
  final VoidCallback onStart;

  const LessonNodeSheet({
    super.key,
    required this.unit,
    required this.node,
    required this.color,
    required this.darkColor,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, sub, btn) = _content();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(color: darkColor, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 26, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        sub,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Pressable3D(
              width: double.infinity,
              height: 54,
              color: color,
              darkColor: darkColor,
              lift: 5,
              borderRadius: BorderRadius.circular(16),
              onTap: onStart,
              child: Text(
                btn,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: .5,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String icon, String sub, String btn) _content() {
    if (node.kind == NodeKind.chest) {
      return ('🎁', 'Phần thưởng đang chờ bạn', 'MỞ NGAY  🎁');
    }
    if (node.kind == NodeKind.trophy) {
      return ('🏆', '${unit.title} · Thử thách', 'BẮT ĐẦU  🏆');
    }
    if (node.isCurrent) {
      return ('⭐', 'Bài học mới · +10 XP', 'BẮT ĐẦU  ·  +10 XP');
    }
    return ('✓', 'Đã hoàn thành ✓ · Luyện tập lại', 'LUYỆN TẬP  ·  +5 XP');
  }
}
