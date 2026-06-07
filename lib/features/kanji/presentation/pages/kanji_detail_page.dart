import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../writing/domain/entities/writing_character.dart';
import '../../domain/entities/kanji.dart';

/// Detail for one [Kanji]: meaning, readings, an example word, and a button to
/// practice writing it (reuses the writing-tracing screen for this one glyph).
class KanjiDetailPage extends StatelessWidget {
  const KanjiDetailPage({super.key, required this.kanji});

  final Kanji kanji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Hán tự · ${kanji.glyph}')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Text(kanji.glyph, style: const TextStyle(fontSize: 120)),
          ),
          Center(
            child: Text(kanji.meaning, style: theme.textTheme.headlineSmall),
          ),
          const SizedBox(height: 24),
          _ReadingRow(label: 'Âm On (音読み)', value: kanji.onyomi),
          _ReadingRow(label: 'Âm Kun (訓読み)', value: kanji.kunyomi),
          const Divider(height: 32),
          Text('Ví dụ', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(
                '${kanji.exampleWord} (${kanji.exampleReading})',
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(kanji.exampleMeaning),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push(
              RouteNames.characterTracing,
              extra: CharacterTracingArgs(
                title: 'Luyện viết · ${kanji.glyph}',
                characters: [
                  WritingCharacter(
                    glyph: kanji.glyph,
                    reading: kanji.kunyomi,
                    meaning: kanji.meaning,
                  ),
                ],
              ),
            ),
            icon: const Icon(AppIcons.edit),
            label: const Text('Luyện viết chữ này'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  const _ReadingRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.titleMedium)),
        ],
      ),
    );
  }
}
