import 'package:flutter/widgets.dart';

import '../../../../core/icons/app_icons.dart';
import '../../domain/entities/learning_language.dart';

/// Visual representation of a [LearningLanguage]. Lives in the presentation
/// layer so the domain enum stays pure-Dart. Replaces the old flag-emoji
/// approach, which inherited Apple/Google's emoji font and broke the app's
/// "looks identical on every platform" goal.
extension LearningLanguageIcon on LearningLanguage {
  IconData get icon => switch (this) {
    LearningLanguage.english => AppIcons.language,
    LearningLanguage.japanese => AppIcons.vocabulary,
  };
}
