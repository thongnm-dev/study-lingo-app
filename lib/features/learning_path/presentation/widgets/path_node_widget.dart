import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/pressable_3d.dart';
import '../../domain/entities/lesson_node.dart';

/// A single node on the learning path: 72px circle with 3D effect,
/// pulse ring + bounce animation for the current node, and a "BẮT ĐẦU" label.
class PathNodeWidget extends StatefulWidget {
  final LessonNode node;
  final Color color;
  final Color darkColor;
  final VoidCallback onTap;

  const PathNodeWidget({
    super.key,
    required this.node,
    required this.color,
    required this.darkColor,
    required this.onTap,
  });

  @override
  State<PathNodeWidget> createState() => _PathNodeWidgetState();
}

class _PathNodeWidgetState extends State<PathNodeWidget>
    with TickerProviderStateMixin {
  AnimationController? _bob;
  AnimationController? _pulse;

  @override
  void initState() {
    super.initState();
    if (widget.node.isCurrent) {
      _bob = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1100),
      )..repeat(reverse: true);
      _pulse = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _bob?.dispose();
    _pulse?.dispose();
    super.dispose();
  }

  Widget _icon(ThemeData theme) {
    final n = widget.node;
    switch (n.kind) {
      case NodeKind.chest:
        return Opacity(
          opacity: n.isLocked ? .4 : 1,
          child: const Text('🎁', style: TextStyle(fontSize: 28)),
        );
      case NodeKind.trophy:
        return Opacity(
          opacity: n.isLocked ? .4 : 1,
          child: const Text('🏆', style: TextStyle(fontSize: 26)),
        );
      case NodeKind.lesson:
        if (n.isDone) {
          return const Icon(Icons.check_rounded, color: Colors.white, size: 36);
        }
        if (n.isCurrent) {
          return const Icon(Icons.star_rounded, color: Colors.white, size: 40);
        }
        return Icon(
          Icons.lock_rounded,
          color: theme.colorScheme.onSurfaceVariant,
          size: 28,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final button = SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.node.isCurrent && _pulse != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulse!,
                builder: (_, _) {
                  final t = Curves.easeOut.transform(_pulse!.value);
                  return Transform.scale(
                    scale: 1 + .75 * t,
                    child: Opacity(
                      opacity: .45 * (1 - t),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.color,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          Pressable3D(
            width: 72,
            height: 72,
            shape: BoxShape.circle,
            color: widget.color,
            darkColor: widget.darkColor,
            softShadow: true,
            onTap: widget.onTap,
            child: _icon(theme),
          ),
          if (widget.node.isCurrent)
            Positioned(
              top: -48,
              left: -60,
              right: -60,
              child: Center(child: _StartLabel(color: widget.color)),
            ),
        ],
      ),
    );

    if (_bob == null) return button;
    return AnimatedBuilder(
      animation: _bob!,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -7 * Curves.easeInOut.transform(_bob!.value)),
        child: child,
      ),
      child: button,
    );
  }
}

class _StartLabel extends StatelessWidget {
  final Color color;
  const _StartLabel({required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            'BẮT ĐẦU',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: .6,
              color: color,
            ),
          ),
        ),
        Positioned(
          bottom: -4,
          child: Transform.rotate(
            angle: 3.14159 / 4,
            child: Container(
              width: 9,
              height: 9,
              color: theme.colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}

/// Resolves node colors based on unit accent and node state/kind.
(Color, Color) nodeColors(
  (Color, Color) unitAccent,
  LessonNode node,
  ThemeData theme,
) {
  if (node.isLocked) {
    return (
      theme.colorScheme.surfaceContainerHighest,
      theme.colorScheme.outlineVariant,
    );
  }
  if (node.kind != NodeKind.lesson) {
    return (AppColors.unitAmber, AppColors.unitAmberDark);
  }
  return unitAccent;
}
