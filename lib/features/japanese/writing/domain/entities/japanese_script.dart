/// The Japanese script being practiced in the handwriting feature. Pure Dart;
/// the UI maps these to display. [sample] is a representative glyph for cards.
///
/// Note: [kanji] is included so the writing repository can return a beginner
/// kanji tracing set, but the user-facing writing home routes the kanji card
/// to the richer kanji list/detail flow instead of bulk tracing.
enum JapaneseScript {
  hiragana(label: 'Hiragana', sample: 'あ'),
  katakana(label: 'Katakana', sample: 'ア'),
  kanji(label: 'Kanji', sample: '漢');

  const JapaneseScript({required this.label, required this.sample});

  final String label;
  final String sample;
}
