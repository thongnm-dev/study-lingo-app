import 'package:flutter/material.dart';

import '../../domain/entities/japanese_script.dart';
import 'character_tracing_page.dart';

/// Entry screen for Japanese handwriting practice: choose a script (Hiragana or
/// Kanji), then trace its characters. Reached from the Japanese "Viết" skill.
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Text(script.sample, style: const TextStyle(fontSize: 40)),
        title: Text(script.label, style: theme.textTheme.titleLarge),
        subtitle: const Text('Tô theo nét chữ mẫu'),
        trailing: const Icon(Icons.edit),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CharacterTracingPage(script: script),
          ),
        ),
      ),
    );
  }
}
