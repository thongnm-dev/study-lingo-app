import 'package:flutter/material.dart';

import '../../domain/entities/english_vocabulary_word.dart';

/// Displays one [EnglishVocabularyWord]: the English headline with the
/// Vietnamese gloss below it. The English example leads, the Vietnamese
/// translation trails.
class EnglishVocabularyCard extends StatelessWidget {
  const EnglishVocabularyCard({super.key, required this.word});

  final EnglishVocabularyWord word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(word.english, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(word.vietnamese, style: theme.textTheme.titleMedium),
            if (word.exampleEnglish != null) ...[
              const SizedBox(height: 12),
              Text(word.exampleEnglish!, style: theme.textTheme.bodyMedium),
            ],
            if (word.exampleVietnamese != null)
              Text(
                word.exampleVietnamese!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
