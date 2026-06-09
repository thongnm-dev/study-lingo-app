import 'package:equatable/equatable.dart';

/// A kanji entry for the learning feature: the character plus its meaning,
/// on'yomi / kun'yomi readings, and one example word.
class Kanji extends Equatable {
  const Kanji({
    required this.glyph,
    required this.meaning,
    required this.onyomi,
    required this.kunyomi,
    required this.exampleWord,
    required this.exampleReading,
    required this.exampleMeaning,
  });

  final String glyph;
  final String meaning;

  /// On'yomi (Chinese-derived reading), in katakana by convention.
  final String onyomi;

  /// Kun'yomi (native Japanese reading), in hiragana by convention.
  final String kunyomi;

  final String exampleWord;
  final String exampleReading;
  final String exampleMeaning;

  @override
  List<Object?> get props => [
    glyph,
    meaning,
    onyomi,
    kunyomi,
    exampleWord,
    exampleReading,
    exampleMeaning,
  ];
}
