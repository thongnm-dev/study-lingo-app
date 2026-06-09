import 'package:equatable/equatable.dart';

/// One word in the English study deck. Primary form is [english]; [vietnamese]
/// is the learner-facing gloss (the user's mother tongue). Example sentences
/// are paired so the card can show both.
class EnglishVocabularyWord extends Equatable {
  const EnglishVocabularyWord({
    required this.id,
    required this.english,
    required this.vietnamese,
    this.exampleEnglish,
    this.exampleVietnamese,
  });

  final String id;
  final String english;
  final String vietnamese;
  final String? exampleEnglish;
  final String? exampleVietnamese;

  @override
  List<Object?> get props => [
    id,
    english,
    vietnamese,
    exampleEnglish,
    exampleVietnamese,
  ];
}
