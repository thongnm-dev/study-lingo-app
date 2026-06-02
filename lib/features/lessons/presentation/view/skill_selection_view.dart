import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/learning_language.dart';
import '../../domain/entities/learning_skill.dart';
import '../cubit/language_cubit.dart';
import 'topics_page.dart';

/// Shows the five skill tracks for the chosen [language]. Picking one drills
/// into that skill's topics. The app-bar "Change" action returns to the
/// language picker (via [LanguageCubit], provided by the lessons tab).
class SkillSelectionView extends StatelessWidget {
  const SkillSelectionView({super.key, required this.language});

  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn ${language.labelEn}'),
        actions: [
          TextButton.icon(
            onPressed: () => context.read<LanguageCubit>().reset(),
            icon: Text(language.flag),
            label: const Text('Change'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: LearningSkill.values.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) =>
            _SkillTile(skill: LearningSkill.values[i], language: language),
      ),
    );
  }
}

class _SkillTile extends StatelessWidget {
  const _SkillTile({required this.skill, required this.language});

  final LearningSkill skill;
  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Text(skill.emoji, style: const TextStyle(fontSize: 32)),
        title: Text(skill.label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TopicsPage(language: language, skill: skill),
          ),
        ),
      ),
    );
  }
}
