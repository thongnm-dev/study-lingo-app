import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/router/app_router.dart';
import '../../../../../config/router/route_names.dart';
import '../../../../../core/icons/app_icons.dart';
import '../../domain/entities/japanese_script.dart';

/// Entry screen for Japanese handwriting practice: pick a script. Hiragana and
/// Katakana drop straight into the tracing flow; Kanji opens the richer kanji
/// list so the user can study individual kanji before tracing.
class WritingHomePage extends StatelessWidget {
  const WritingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Luyện viết chữ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Chọn bộ chữ để luyện viết', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final script in JapaneseScript.values) ...[
            _ScriptCard(script: script),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ScriptCard extends StatelessWidget {
  const _ScriptCard({required this.script});

  final JapaneseScript script;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKanji = script == JapaneseScript.kanji;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Text(script.sample, style: const TextStyle(fontSize: 40)),
        title: Text(script.label, style: theme.textTheme.titleLarge),
        subtitle: Text(
          isKanji ? 'Nghĩa, âm On/Kun & luyện viết' : 'Tô theo nét chữ mẫu',
        ),
        trailing: Icon(isKanji ? AppIcons.chevronRight : AppIcons.edit),
        onTap: () {
          if (isKanji) {
            context.push(RouteNames.japaneseKanjiList);
          } else {
            context.push(
              RouteNames.japaneseTracing,
              extra: CharacterTracingArgs(script: script),
            );
          }
        },
      ),
    );
  }
}
