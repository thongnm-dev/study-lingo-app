import 'package:equatable/equatable.dart';

import '../../../../../core/constants/learning_skill.dart';

/// A theme that groups Japanese lessons (e.g. 挨拶, 食べ物, 旅行) within a
/// [LearningSkill] track. The topics page lists a skill's topics; tapping one
/// drills into its lessons.
class JapaneseTopic extends Equatable {
  const JapaneseTopic({
    required this.id,
    required this.skill,
    required this.title,
    required this.emoji,
    required this.lessonCount,
  });

  final String id;

  /// Which skill track this topic belongs to.
  final LearningSkill skill;
  final String title;

  /// A leading glyph for the topic card. Swap for an asset/icon later.
  final String emoji;
  final int lessonCount;

  @override
  List<Object?> get props => [id, skill, title, emoji, lessonCount];
}
