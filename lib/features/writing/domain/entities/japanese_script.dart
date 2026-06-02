/// The Japanese script being practiced in the handwriting feature. Pure Dart;
/// the UI maps these to display. [sample] is a representative glyph for cards.
enum JapaneseScript {
  hiragana(label: 'Hiragana', sample: 'あ'),
  katakana(label: 'Katakana', sample: 'ア'),
  kanji(label: 'Kanji', sample: '漢');

  const JapaneseScript({required this.label, required this.sample});

  final String label;
  final String sample;
}
