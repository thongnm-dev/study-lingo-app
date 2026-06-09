import 'package:flutter/material.dart';

import '../../domain/entities/japanese_vocabulary_word.dart';

/// Displays one [JapaneseVocabularyWord]: the Japanese surface form with
/// furigana stacked above it (the common textbook layout) and the Vietnamese
/// gloss below. Romaji is shown if available; the Japanese example sentence
/// leads, the Vietnamese translation trails. A JLPT badge floats to the right.
class JapaneseVocabularyCard extends StatelessWidget {
  const JapaneseVocabularyCard({super.key, required this.word});

  final JapaneseVocabularyWord word;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _JapaneseWithFurigana(word: word)),
                if (word.jlptLevel != null) _JlptBadge(level: word.jlptLevel!),
              ],
            ),
            const SizedBox(height: 8),
            Text(word.vietnamese, style: theme.textTheme.titleMedium),
            if (word.romaji != null)
              Text(
                word.romaji!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (word.exampleJapanese != null) ...[
              const SizedBox(height: 12),
              Text(word.exampleJapanese!, style: theme.textTheme.bodyMedium),
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

class _JapaneseWithFurigana extends StatelessWidget {
  const _JapaneseWithFurigana({required this.word});

  final JapaneseVocabularyWord word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (word.furigana != null)
          Text(
            word.furigana!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        Text(word.japanese, style: theme.textTheme.headlineSmall),
      ],
    );
  }
}

class _JlptBadge extends StatelessWidget {
  const _JlptBadge({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'N$level',
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
