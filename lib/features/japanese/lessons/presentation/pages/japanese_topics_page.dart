import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/di/service_locator.dart';
import '../../../../../config/router/app_router.dart';
import '../../../../../config/router/route_names.dart';
import '../../../../../core/constants/learning_skill.dart';
import '../../../../../core/icons/app_icons.dart';
import '../../domain/entities/japanese_topic.dart';
import '../bloc/japanese_topics_cubit.dart';

extension on LearningSkill {
  IconData get icon => switch (this) {
    LearningSkill.grammar => AppIcons.grammar,
    LearningSkill.vocabulary => AppIcons.vocabulary,
    LearningSkill.listeningSpeaking => AppIcons.listening,
    LearningSkill.reading => AppIcons.reading,
    LearningSkill.writing => AppIcons.writing,
  };
}

IconData _topicIcon(String emoji) =>
    const {
      '👋': AppIcons.greet,
      '🍜': AppIcons.food,
      '✈️': AppIcons.travel,
      '🧩': AppIcons.puzzle,
      '💬': AppIcons.chat,
      '🪧': AppIcons.article,
      '✏️': AppIcons.edit,
    }[emoji] ??
    AppIcons.bookmark;

/// Japanese topics within one [skill] track, as a vertical list. When [skill]
/// is `writing`, two extra cards (handwriting + kanji) are prepended.
class JapaneseTopicsPage extends StatelessWidget {
  const JapaneseTopicsPage({super.key, required this.skill});

  final LearningSkill skill;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<JapaneseTopicsCubit>()..load(skill),
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
        body: BlocBuilder<JapaneseTopicsCubit, JapaneseTopicsState>(
          builder: (context, state) {
            switch (state.status) {
              case JapaneseTopicsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case JapaneseTopicsStatus.failure:
                return const Center(child: Text('Không tải được chủ đề.'));
              case JapaneseTopicsStatus.success:
                // Writing skill prepends a single "Luyện viết chữ" entry that
                // opens the writing home (hiragana / katakana / kanji).
                final showWriting = skill == LearningSkill.writing;
                if (state.topics.isEmpty && !showWriting) {
                  return const Center(
                    child: Text('Chưa có chủ đề cho kỹ năng này.'),
                  );
                }
                final extra = showWriting ? 1 : 0;
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.topics.length + extra,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    if (showWriting && i == 0) {
                      return const _WritingPracticeCard();
                    }
                    return _TopicTile(topic: state.topics[i - extra]);
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

/// Single entry for the Japanese "Viết" skill: opens the writing home, which
/// is where hiragana / katakana / kanji sub-flows live.
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
        leading: const Icon(AppIcons.writing, size: 32),
        title: const Text('Luyện viết chữ'),
        subtitle: const Text('Hiragana · Katakana · Kanji'),
        trailing: const Icon(AppIcons.chevronRight),
        onTap: () => context.push(RouteNames.japaneseWritingHome),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic});

  final JapaneseTopic topic;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(_topicIcon(topic.emoji), size: 32),
        title: Text(topic.title),
        subtitle: Text('${topic.lessonCount} lessons'),
        trailing: const Icon(AppIcons.chevronRight),
        onTap: () => context.push(
          RouteNames.japaneseLessons,
          extra: JapaneseLessonsPageArgs(topic: topic),
        ),
      ),
    );
  }
}
