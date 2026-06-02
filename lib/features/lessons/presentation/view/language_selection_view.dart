import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/learning_language.dart';
import '../cubit/language_cubit.dart';

extension on LearningLanguage {
  IconData get icon => switch (this) {
        LearningLanguage.english => Icons.language,
        LearningLanguage.japanese => Icons.east,
      };
}

/// Shown in the Lessons tab until the user picks a study language. Selecting one
/// drives [LanguageCubit] and reveals the topics list.
class LanguageSelectionView extends StatelessWidget {
  const LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Bài học')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Bạn muốn học gì?',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Chọn ngôn ngữ để bắt đầu bài học.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          for (final language in LearningLanguage.values) ...[
            _LanguageCard(language: language),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.language});

  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Icon(language.icon, size: 36),
        title: Text(language.labelVi, style: theme.textTheme.titleLarge),
        subtitle: Text(language.nativeName),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.read<LanguageCubit>().select(language),
      ),
    );
  }
}
