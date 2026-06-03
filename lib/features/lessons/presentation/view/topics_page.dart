import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../kanji/presentation/view/kanji_list_page.dart';
import '../../../writing/presentation/view/writing_home_page.dart';
import '../../domain/entities/learning_language.dart';
import '../../domain/entities/learning_skill.dart';
import '../../domain/entities/topic.dart';
import '../../domain/repositories/lessons_repository.dart';
import '../cubit/topics_cubit.dart';
import 'lessons_page.dart';

extension on LearningSkill {
  IconData get icon => switch (this) {
    LearningSkill.grammar => Icons.rule,
    LearningSkill.vocabulary => Icons.translate,
    LearningSkill.listeningSpeaking => Icons.headset,
    LearningSkill.reading => Icons.menu_book,
    LearningSkill.writing => Icons.draw,
  };
}

IconData _topicIcon(String emoji) =>
    const {
      '👋': Icons.front_hand,
      '🍜': Icons.restaurant,
      '✈️': Icons.flight,
      '🧩': Icons.extension,
      '💬': Icons.forum,
      '🪧': Icons.article,
      '✏️': Icons.edit,
    }[emoji] ??
    Icons.bookmark;

/// Topics within one [skill] track, for the chosen [language], as a vertical
/// list. Pushed from the skill picker. Reads the shared [LessonsRepository].
class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key, required this.language, required this.skill});

  final LearningLanguage language;
  final LearningSkill skill;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TopicsCubit(context.read<LessonsRepository>())..load(skill),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(skill.icon, size: 20),
              const SizedBox(width: 8),
              Text(skill.label),
            ],
          ),
        ),
        body: BlocBuilder<TopicsCubit, TopicsState>(
          builder: (context, state) {
            switch (state.status) {
              case TopicsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case TopicsStatus.failure:
                return const Center(child: Text('Không tải được chủ đề.'));
              case TopicsStatus.success:
                // Japanese writing skill gets a handwriting-practice card on
                // top of its quiz topics.
                final showWriting =
                    language == LearningLanguage.japanese &&
                    skill == LearningSkill.writing;
                if (state.topics.isEmpty && !showWriting) {
                  return const Center(
                    child: Text('Chưa có chủ đề cho kỹ năng này.'),
                  );
                }
                // Japanese writing skill gets two practice entries on top.
                final extra = showWriting ? 2 : 0;
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.topics.length + extra,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    if (showWriting && i == 0) {
                      return const _WritingPracticeCard();
                    }
                    if (showWriting && i == 1) {
                      return const _KanjiLearnCard();
                    }
                    return _TopicTile(
                      topic: state.topics[i - extra],
                      language: language,
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

/// Handwriting practice entry, shown only in the Japanese "Viết" skill.
class _WritingPracticeCard extends StatelessWidget {
  const _WritingPracticeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.primaryContainer,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.draw, size: 32),
        title: const Text('Luyện viết chữ'),
        subtitle: const Text('Tô nét Hiragana & Kanji'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const WritingHomePage()),
        ),
      ),
    );
  }
}

/// Kanji-learning entry, shown only in the Japanese "Viết" skill.
class _KanjiLearnCard extends StatelessWidget {
  const _KanjiLearnCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondaryContainer,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.auto_stories, size: 32),
        title: const Text('Học Hán tự'),
        subtitle: const Text('Nghĩa, âm On/Kun, ví dụ'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const KanjiListPage())),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic, required this.language});

  final Topic topic;
  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(_topicIcon(topic.emoji), size: 32),
        title: Text(topic.titleIn(language)),
        subtitle: Text(
          '${topic.subtitleIn(language)} · ${topic.lessonCount} lessons',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => LessonsPage(topic: topic, language: language),
          ),
        ),
      ),
    );
  }
}
