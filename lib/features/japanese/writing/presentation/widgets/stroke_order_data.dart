import 'dart:ui';

/// Approximate stroke-order paths, normalized to a 0..1 box (origin top-left).
/// Each entry is an ordered list of strokes; each stroke is an ordered list of
/// points. These illustrate stroke ORDER and DIRECTION (the teaching value) —
/// they are hand-approximated, not font-accurate outlines, and only cover a
/// representative subset. Characters absent here simply show no animation.
const Map<String, List<List<Offset>>> kStrokeOrder = {
  // --- Kanji: numbers & simple radicals ---
  '一': [
    [Offset(0.15, 0.5), Offset(0.85, 0.5)],
  ],
  '二': [
    [Offset(0.2, 0.35), Offset(0.8, 0.35)],
    [Offset(0.15, 0.66), Offset(0.85, 0.66)],
  ],
  '三': [
    [Offset(0.22, 0.28), Offset(0.78, 0.28)],
    [Offset(0.28, 0.5), Offset(0.72, 0.5)],
    [Offset(0.15, 0.72), Offset(0.85, 0.72)],
  ],
  '十': [
    [Offset(0.15, 0.45), Offset(0.85, 0.45)],
    [Offset(0.5, 0.15), Offset(0.5, 0.85)],
  ],
  '人': [
    [Offset(0.5, 0.2), Offset(0.28, 0.82)],
    [Offset(0.5, 0.45), Offset(0.8, 0.82)],
  ],
  '川': [
    [Offset(0.26, 0.2), Offset(0.2, 0.85)],
    [Offset(0.5, 0.25), Offset(0.5, 0.78)],
    [Offset(0.78, 0.2), Offset(0.82, 0.85)],
  ],
  '山': [
    [Offset(0.5, 0.28), Offset(0.5, 0.72)],
    [Offset(0.25, 0.42), Offset(0.25, 0.8), Offset(0.8, 0.8)],
    [Offset(0.78, 0.32), Offset(0.78, 0.8)],
  ],
  '口': [
    [Offset(0.28, 0.25), Offset(0.28, 0.78)],
    [Offset(0.28, 0.25), Offset(0.74, 0.25), Offset(0.74, 0.78)],
    [Offset(0.28, 0.78), Offset(0.74, 0.78)],
  ],
  '日': [
    [Offset(0.3, 0.2), Offset(0.3, 0.82)],
    [Offset(0.3, 0.2), Offset(0.72, 0.2), Offset(0.72, 0.82)],
    [Offset(0.3, 0.51), Offset(0.72, 0.51)],
    [Offset(0.3, 0.82), Offset(0.72, 0.82)],
  ],
  '木': [
    [Offset(0.2, 0.4), Offset(0.8, 0.4)],
    [Offset(0.5, 0.18), Offset(0.5, 0.85)],
    [Offset(0.5, 0.52), Offset(0.25, 0.82)],
    [Offset(0.5, 0.52), Offset(0.78, 0.82)],
  ],
  // --- Hiragana: simple shapes ---
  'し': [
    [
      Offset(0.45, 0.2),
      Offset(0.45, 0.66),
      Offset(0.56, 0.82),
      Offset(0.72, 0.72),
    ],
  ],
  'つ': [
    [
      Offset(0.3, 0.35),
      Offset(0.7, 0.33),
      Offset(0.72, 0.55),
      Offset(0.4, 0.76),
    ],
  ],
  'く': [
    [Offset(0.6, 0.24), Offset(0.34, 0.5), Offset(0.62, 0.78)],
  ],
  'へ': [
    [Offset(0.24, 0.62), Offset(0.5, 0.4), Offset(0.82, 0.66)],
  ],
  'こ': [
    [Offset(0.3, 0.36), Offset(0.7, 0.34)],
    [Offset(0.28, 0.62), Offset(0.56, 0.7), Offset(0.72, 0.62)],
  ],
  'い': [
    [Offset(0.35, 0.3), Offset(0.3, 0.66), Offset(0.4, 0.76)],
    [Offset(0.66, 0.32), Offset(0.62, 0.62)],
  ],
};

/// The stroke paths for [glyph], or null if none are authored.
List<List<Offset>>? strokeOrderFor(String glyph) => kStrokeOrder[glyph];
