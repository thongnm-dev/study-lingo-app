import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/di/service_locator.dart';
import '../../../../../config/router/app_router.dart';
import '../../../../../config/router/route_names.dart';
import '../../../../../core/constants/learning_skill.dart';
import '../../../../../core/icons/app_icons.dart';
import '../../domain/entities/english_topic.dart';
import '../bloc/english_topics_cubit.dart';

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

/// English topics within one [skill] track, as a vertical list. Pushed from the
/// home overview's skill picker.
class EnglishTopicsPage extends StatelessWidget {
  const EnglishTopicsPage({super.key, required this.skill});

  final LearningSkill skill;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EnglishTopicsCubit>()..load(skill),
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
        body: BlocBuilder<EnglishTopicsCubit, EnglishTopicsState>(
          builder: (context, state) {
            switch (state.status) {
              case EnglishTopicsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case EnglishTopicsStatus.failure:
                return const Center(child: Text('Không tải được chủ đề.'));
              case EnglishTopicsStatus.success:
                if (state.topics.isEmpty) {
                  return const Center(
                    child: Text('Chưa có chủ đề cho kỹ năng này.'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.topics.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) =>
                      _TopicTile(topic: state.topics[i]),
                );
            }
          },
        ),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic});

  final EnglishTopic topic;

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
          RouteNames.englishLessons,
          extra: EnglishLessonsPageArgs(topic: topic),
        ),
      ),
    );
  }
}
