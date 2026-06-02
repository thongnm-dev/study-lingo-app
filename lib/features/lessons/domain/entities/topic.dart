import 'package:equatable/equatable.dart';

import 'learning_language.dart';
import 'learning_skill.dart';

/// A theme that groups lessons (e.g. Greetings, Food, Travel) within a
/// [LearningSkill] track. The lessons tab lists a skill's topics; tapping one
/// drills into its lessons.
class Topic extends Equatable {
  const Topic({
    required this.id,
    required this.skill,
    required this.titleEn,
    required this.titleJa,
    required this.emoji,
    required this.lessonCount,
  });

  final String id;

  /// Which skill track this topic belongs to.
  final LearningSkill skill;
  final String titleEn;
  final String titleJa;

  /// A leading glyph for the topic card. Swap for an asset/icon later.
  final String emoji;
  final int lessonCount;

  /// Title in the chosen study language (the primary line on a topic card).
  String titleIn(LearningLanguage language) =>
      language == LearningLanguage.japanese ? titleJa : titleEn;

  /// Title in the other language (shown as a secondary line).
  String subtitleIn(LearningLanguage language) =>
      language == LearningLanguage.japanese ? titleEn : titleJa;

  @override
  List<Object?> get props => [id, skill, titleEn, titleJa, emoji, lessonCount];
}
