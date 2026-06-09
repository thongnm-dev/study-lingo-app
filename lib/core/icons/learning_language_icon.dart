import 'package:flutter/widgets.dart';

import '../constants/learning_language.dart';
import 'app_icons.dart';

/// Visual representation of a [LearningLanguage]. Lives in core/ so any feature
/// that shows a language picker (overview, practice, vocabulary chip) can pull
/// the same glyph without depending on a language-specific feature.
extension LearningLanguageIcon on LearningLanguage {
  IconData get icon => switch (this) {
    LearningLanguage.english => AppIcons.language,
    LearningLanguage.japanese => AppIcons.vocabulary,
  };
}
