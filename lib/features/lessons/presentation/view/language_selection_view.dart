import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/learning_language.dart';
import '../cubit/language_cubit.dart';

/// Shown in the Lessons tab until the user picks a study language. Selecting one
/// drives [LanguageCubit] and reveals the topics list.
class LanguageSelectionView extends StatelessWidget {
  const LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'What do you want to learn?',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Pick a language to start your lessons.',
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
        leading: Text(language.flag, style: const TextStyle(fontSize: 36)),
        title: Text(language.nativeName, style: theme.textTheme.titleLarge),
        subtitle: Text('Learn ${language.labelEn}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.read<LanguageCubit>().select(language),
      ),
    );
  }
}
