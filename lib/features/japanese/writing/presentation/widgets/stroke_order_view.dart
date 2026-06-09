import 'package:flutter/material.dart';

import '../../../../../core/icons/app_icons.dart';

/// Animates [strokes] (normalized 0..1 polylines) one after another, numbering
/// each stroke at its start point, to demonstrate stroke order/direction.
/// Auto-plays on build and on the replay button.
class StrokeOrderView extends StatefulWidget {
  const StrokeOrderView({
    super.key,
    required this.glyph,
    required this.strokes,
  });

  final String glyph;
  final List<List<Offset>> strokes;

  @override
  State<StrokeOrderView> createState() => _StrokeOrderViewState();
}

class _StrokeOrderViewState extends State<StrokeOrderView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700 * widget.strokes.length),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _replay() => _controller.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Card(
            clipBehavior: Clip.antiAlias,
            color: theme.colorScheme.surfaceContainerHighest,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: _StrokeOrderPainter(
                  glyph: widget.glyph,
                  strokes: widget.strokes,
                  progress: _controller.value,
                  guideColor: theme.colorScheme.onSurface.withValues(
                    alpha: 0.10,
                  ),
                  inkColor: theme.colorScheme.primary,
                  numberColor: theme.colorScheme.error,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${widget.strokes.length} nét',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton.icon(
          onPressed: _replay,
          icon: const Icon(AppIcons.replay),
          label: const Text('Xem lại'),
        ),
      ],
    );
  }
}

class _StrokeOrderPainter extends CustomPainter {
  _StrokeOrderPainter({
    required this.glyph,
    required this.strokes,
    required this.progress,
    required this.guideColor,
    required this.inkColor,
    required this.numberColor,
  });

  final String glyph;
  final List<List<Offset>> strokes;
  final double progress; // 0..1 across all strokes
  final Color guideColor;
  final Color inkColor;
  final Color numberColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Faint full glyph as a backdrop.
    final tp = TextPainter(
      text: TextSpan(
        text: glyph,
        style: TextStyle(fontSize: size.height * 0.7, color: guideColor),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
    );

    final inkPaint = Paint()
      ..color = inkColor
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final scaled = progress * strokes.length;
    Offset toPx(Offset n) => Offset(n.dx * size.width, n.dy * size.height);

    for (var i = 0; i < strokes.length; i++) {
      final points = strokes[i].map(toPx).toList();
      final reveal = (scaled - i).clamp(0.0, 1.0);
      if (reveal <= 0) break;
      _drawPartialPolyline(canvas, points, reveal, inkPaint);
      // Number badge at the stroke's start, once the stroke has begun.
      _drawNumber(canvas, points.first, i + 1);
    }
  }

  void _drawPartialPolyline(
    Canvas canvas,
    List<Offset> points,
    double fraction,
    Paint paint,
  ) {
    if (points.length < 2) {
      canvas.drawCircle(points.first, paint.strokeWidth / 2, paint);
      return;
    }
    // Total length, then draw up to fraction * total.
    var total = 0.0;
    for (var i = 1; i < points.length; i++) {
      total += (points[i] - points[i - 1]).distance;
    }
    final target = total * fraction;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    var covered = 0.0;
    for (var i = 1; i < points.length; i++) {
      final seg = (points[i] - points[i - 1]).distance;
      if (covered + seg <= target) {
        path.lineTo(points[i].dx, points[i].dy);
        covered += seg;
      } else {
        final remain = (target - covered) / seg;
        final p = Offset.lerp(points[i - 1], points[i], remain)!;
        path.lineTo(p.dx, p.dy);
        break;
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawNumber(Canvas canvas, Offset at, int number) {
    final tp = TextPainter(
      text: TextSpan(
        text: '$number',
        style: TextStyle(
          color: numberColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, at - Offset(tp.width / 2 + 8, tp.height / 2 + 8));
  }

  @override
  bool shouldRepaint(_StrokeOrderPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.glyph != glyph;
}
