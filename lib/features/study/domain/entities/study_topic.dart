import 'package:equatable/equatable.dart';

import '../../../../core/constants/learning_language.dart';

/// A themed study topic (Daily Conversation, Office, Health & Wellness …). One
/// topic belongs to one [language] and groups several lessons that review the
/// topic from multiple angles (grammar / pronunciation / vocabulary).
class StudyTopic extends Equatable {
  const StudyTopic({
    required this.id,
    required this.language,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.lessonCount,
  });

  final String id;
  final LearningLanguage language;
  final String title;

  /// Vietnamese-leaning blurb shown beneath the topic title.
  final String subtitle;

  /// Leading glyph (also useful as a fallback when icons aren't bundled).
  final String emoji;
  final int lessonCount;

  @override
  List<Object?> get props => [id, language, title, subtitle, emoji, lessonCount];
}
