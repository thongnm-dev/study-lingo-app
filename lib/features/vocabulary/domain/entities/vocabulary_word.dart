import 'package:equatable/equatable.dart';

import '../../../lessons/domain/entities/learning_language.dart';

/// A single vocabulary item. Bilingual by design: every word carries both an
/// English and a Japanese form so the same feature serves learners of either
/// language. [target] marks which study language the word belongs to (its
/// deck); Japanese-specific fields (furigana, JLPT level) are optional and
/// only populated for entries where the Japanese side is the study target.
class VocabularyWord extends Equatable {
  const VocabularyWord({
    required this.id,
    required this.target,
    required this.english,
    required this.japanese,
    this.furigana,
    this.romaji,
    this.jlptLevel,
    this.exampleEnglish,
    this.exampleJapanese,
  });

  final String id;

  /// The study language this word is taught for. The vocabulary list filters
  /// on this when a learning session is active, and the card renders this
  /// language as its primary line. ([LearningLanguage] is the shared, pure-Dart
  /// language enum from the lessons feature.)
  final LearningLanguage target;

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
    target,
    english,
    japanese,
    furigana,
    romaji,
    jlptLevel,
    exampleEnglish,
    exampleJapanese,
  ];
}
