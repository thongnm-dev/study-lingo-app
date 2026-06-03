import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/learning_language.dart';
import '../cubit/language_cubit.dart';
import 'language_selection_view.dart';
import 'skill_selection_view.dart';

/// Lessons tab root. Reads the app-root [LanguageCubit] (the learning-session
/// language, shared with e.g. the vocabulary deck filter): until a study
/// language is picked it shows the language picker, then the skill picker
/// (grammar / vocabulary / listening-speaking / reading / writing). Tapping a
/// skill pushes its topics.
class LessonsTabPage extends StatelessWidget {
  const LessonsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LearningLanguage?>(
      builder: (context, language) {
        if (language == null) return const LanguageSelectionView();
        return SkillSelectionView(language: language);
      },
    );
  }
}
