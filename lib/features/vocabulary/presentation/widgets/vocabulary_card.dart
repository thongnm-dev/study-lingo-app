import 'package:flutter/material.dart';

import '../../../lessons/domain/entities/learning_language.dart';
import '../../domain/entities/vocabulary_word.dart';

/// Displays one [VocabularyWord] with its study target as the primary line:
/// Japanese-target words show the Japanese form with furigana stacked above it
/// (the common textbook layout) and the English gloss below; English-target
/// words show the English form first with the Japanese gloss below. The
/// target-language example sentence leads, the other trails.
class VocabularyCard extends StatelessWidget {
  const VocabularyCard({super.key, required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isJapaneseTarget = word.target == LearningLanguage.japanese;
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
                Expanded(
                  child: isJapaneseTarget
                      ? _JapaneseWithFurigana(word: word)
                      : Text(
                          word.english,
                          style: theme.textTheme.headlineSmall,
                        ),
                ),
                if (word.jlptLevel != null) _JlptBadge(level: word.jlptLevel!),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isJapaneseTarget ? word.english : word.japanese,
              style: theme.textTheme.titleMedium,
            ),
            if (word.romaji != null)
              Text(
                word.romaji!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ..._examples(theme, isJapaneseTarget: isJapaneseTarget),
          ],
        ),
      ),
    );
  }

  /// Example sentences, target language first.
  List<Widget> _examples(ThemeData theme, {required bool isJapaneseTarget}) {
    final primary = isJapaneseTarget
        ? word.exampleJapanese
        : word.exampleEnglish;
    final secondary = isJapaneseTarget
        ? word.exampleEnglish
        : word.exampleJapanese;
    return [
      if (primary != null) ...[
        const SizedBox(height: 12),
        Text(primary, style: theme.textTheme.bodyMedium),
      ],
      if (secondary != null)
        Text(
          secondary,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
    ];
  }
}

class _JapaneseWithFurigana extends StatelessWidget {
  const _JapaneseWithFurigana({required this.word});

  final VocabularyWord word;

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
