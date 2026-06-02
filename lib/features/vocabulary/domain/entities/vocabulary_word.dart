import 'package:equatable/equatable.dart';

/// A single vocabulary item. Bilingual by design: every word carries both an
/// English and a Japanese form so the same feature serves learners of either
/// language. Japanese-specific fields (furigana, JLPT level) are optional and
/// only populated for entries where the Japanese side is the study target.
class VocabularyWord extends Equatable {
  const VocabularyWord({
    required this.id,
    required this.english,
    required this.japanese,
    this.furigana,
    this.romaji,
    this.jlptLevel,
    this.exampleEnglish,
    this.exampleJapanese,
  });

  final String id;

  /// English form, e.g. "water".
  final String english;

  /// Japanese form in kanji/kana, e.g. "水".
  final String japanese;

  /// Reading of [japanese] in kana, shown as furigana, e.g. "みず".
  final String? furigana;

  /// Latin transliteration of [japanese], e.g. "mizu".
  final String? romaji;

  /// JLPT level (1–5, where 5 is easiest / N5). Null if not classified.
  final int? jlptLevel;

  final String? exampleEnglish;
  final String? exampleJapanese;

  @override
  List<Object?> get props => [
    id,
    english,
    japanese,
    furigana,
    romaji,
    jlptLevel,
    exampleEnglish,
    exampleJapanese,
  ];
}
