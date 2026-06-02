import 'package:flutter/material.dart';

/// A square drawing surface that shows [glyph] faintly as a guide and lets the
/// user trace over it with a finger. Stroke points are owned by the parent (so
/// it can clear them on "Next"); this widget just reports gestures and paints.
class TracingCanvas extends StatelessWidget {
  const TracingCanvas({
    super.key,
    required this.glyph,
    required this.strokes,
    required this.onStrokeStart,
    required this.onStrokePoint,
  });

  final String glyph;

  /// Completed + in-progress strokes, each a list of local-coordinate points.
  final List<List<Offset>> strokes;
  final ValueChanged<Offset> onStrokeStart;
  final ValueChanged<Offset> onStrokePoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.surfaceContainerHighest,
        child: GestureDetector(
          onPanStart: (d) => onStrokeStart(d.localPosition),
          onPanUpdate: (d) => onStrokePoint(d.localPosition),
          child: CustomPaint(
            painter: _TracingPainter(
              glyph: glyph,
              strokes: strokes,
              guideColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
              gridColor: theme.colorScheme.outlineVariant,
              inkColor: theme.colorScheme.primary,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  _TracingPainter({
    required this.glyph,
    required this.strokes,
    required this.guideColor,
    required this.gridColor,
    required this.inkColor,
  });

  final String glyph;
  final List<List<Offset>> strokes;
  final Color guideColor;
  final Color gridColor;
  final Color inkColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Dashed-ish center guides (helps with proportions).
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      gridPaint,
    );

    // The faint character guide, centered.
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

    // The user's ink.
    final inkPaint = Paint()
      ..color = inkColor
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final dotPaint = Paint()..color = inkColor;
    for (final stroke in strokes) {
      if (stroke.length == 1) {
        // A tap with no drag — draw a dot.
        canvas.drawCircle(stroke.first, inkPaint.strokeWidth / 2, dotPaint);
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final point in stroke.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, inkPaint);
    }
  }

  @override
  bool shouldRepaint(_TracingPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.strokes != strokes;
}
