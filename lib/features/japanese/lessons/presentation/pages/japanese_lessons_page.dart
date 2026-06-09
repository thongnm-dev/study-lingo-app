import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/di/service_locator.dart';
import '../../../../../config/router/app_router.dart';
import '../../../../../config/router/route_names.dart';
import '../../../../../core/icons/app_icons.dart';
import '../../domain/entities/japanese_lesson.dart';
import '../../domain/entities/japanese_topic.dart';
import '../bloc/japanese_lessons_cubit.dart';

/// Lessons within one [JapaneseTopic]. Tapping a lesson opens its quiz.
class JapaneseLessonsPage extends StatelessWidget {
  const JapaneseLessonsPage({super.key, required this.topic});

  final JapaneseTopic topic;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<JapaneseLessonsCubit>()..load(topic.id),
      child: _LessonsView(topic: topic),
    );
  }
}

class _LessonsView extends StatelessWidget {
  const _LessonsView({required this.topic});

  final JapaneseTopic topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: BlocBuilder<JapaneseLessonsCubit, JapaneseLessonsState>(
        builder: (context, state) {
          switch (state.status) {
            case JapaneseLessonsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case JapaneseLessonsStatus.failure:
              return const Center(child: Text('Không tải được bài học.'));
            case JapaneseLessonsStatus.success:
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.lessons.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) =>
                    _LessonTile(lesson: state.lessons[i]),
              );
          }
        },
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson});

  final JapaneseLesson lesson;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const CircleAvatar(child: Icon(AppIcons.bookOpen)),
        title: Text(lesson.title),
        subtitle: Text('${lesson.questionCount} questions'),
        trailing: const Icon(AppIcons.chevronRight),
        onTap: () => context.push(
          RouteNames.quiz,
          extra: QuizPageArgs(
            questions: lesson.questions,
            lessonTitle: lesson.title,
          ),
        ),
      ),
    );
  }
}
