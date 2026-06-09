import 'package:equatable/equatable.dart';

/// One word in the Japanese study deck. Primary form is [japanese] (kanji/kana
/// surface); [furigana] is the kana reading, [romaji] the Latin
/// transliteration, [jlptLevel] the JLPT classification (1–5; null = unranked).
/// [vietnamese] is the learner-facing gloss (the user's mother tongue).
class JapaneseVocabularyWord extends Equatable {
  const JapaneseVocabularyWord({
    required this.id,
    required this.japanese,
    required this.vietnamese,
    this.furigana,
    this.romaji,
    this.jlptLevel,
    this.exampleJapanese,
    this.exampleVietnamese,
  });

  final String id;
  final String japanese;
  final String vietnamese;
  final String? furigana;
  final String? romaji;
  final int? jlptLevel;
  final String? exampleJapanese;
  final String? exampleVietnamese;

  @override
  List<Object?> get props => [
    id,
    japanese,
    vietnamese,
    furigana,
    romaji,
    jlptLevel,
    exampleJapanese,
    exampleVietnamese,
  ];
}
