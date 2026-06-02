import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/learning_language.dart';
import '../../domain/entities/learning_skill.dart';
import '../../domain/entities/topic.dart';
import '../../domain/repositories/lessons_repository.dart';
import '../cubit/topics_cubit.dart';
import 'lessons_page.dart';

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
        appBar: AppBar(title: Text('${skill.emoji} ${skill.label}')),
        body: BlocBuilder<TopicsCubit, TopicsState>(
          builder: (context, state) {
            switch (state.status) {
              case TopicsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case TopicsStatus.failure:
                return const Center(child: Text('Could not load topics.'));
              case TopicsStatus.success:
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
                      _TopicTile(topic: state.topics[i], language: language),
                );
            }
          },
        ),
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
        leading: Text(topic.emoji, style: const TextStyle(fontSize: 32)),
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
