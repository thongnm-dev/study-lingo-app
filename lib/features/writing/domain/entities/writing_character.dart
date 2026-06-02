import 'package:equatable/equatable.dart';

/// A single character to trace in the handwriting practice. [glyph] is the
/// character drawn as the faint guide; [reading] is its romaji; [meaning] is
/// only set for kanji.
class WritingCharacter extends Equatable {
  const WritingCharacter({
    required this.glyph,
    required this.reading,
    this.meaning,
  });

  final String glyph;
  final String reading;
  final String? meaning;

  @override
  List<Object?> get props => [glyph, reading, meaning];
}
