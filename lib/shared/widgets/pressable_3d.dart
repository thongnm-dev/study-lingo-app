import 'package:flutter/material.dart';

/// Gamified 3D-press button: a darker bottom edge that compresses on tap.
class Pressable3D extends StatefulWidget {
  final double? width;
  final double? height;
  final Color color;
  final Color darkColor;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final double lift;
  final bool softShadow;
  final VoidCallback? onTap;
  final Widget child;

  const Pressable3D({
    super.key,
    this.width,
    this.height,
    required this.color,
    required this.darkColor,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.lift = 7,
    this.softShadow = false,
    this.onTap,
    required this.child,
  });

  @override
  State<Pressable3D> createState() => _Pressable3DState();
}

class _Pressable3DState extends State<Pressable3D> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeOut,
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        transform:
            Matrix4.translationValues(0, _down ? widget.lift - 2 : 0, 0),
        decoration: BoxDecoration(
          color: widget.color,
          shape: widget.shape,
          borderRadius: widget.shape == BoxShape.rectangle
              ? (widget.borderRadius ?? BorderRadius.circular(16))
              : null,
          boxShadow: [
            BoxShadow(
              color: widget.darkColor,
              offset: Offset(0, _down ? 2 : widget.lift),
            ),
            if (widget.softShadow && !_down)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                offset: const Offset(0, 10),
                blurRadius: 16,
              ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
