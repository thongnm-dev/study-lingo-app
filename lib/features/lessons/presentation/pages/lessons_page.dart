import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/service_locator.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/icons/app_icons.dart';
import '../../domain/entities/learning_language.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/topic.dart';
import '../bloc/lessons_cubit.dart';

/// Lessons within one [Topic], titled in the chosen study [language]. Tapping a
/// lesson opens its quiz.
class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key, required this.topic, required this.language});

  final Topic topic;
  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LessonsCubit>()..load(topic.id, language),
      child: _LessonsView(topic: topic, language: language),
    );
  }
}

class _LessonsView extends StatelessWidget {
  const _LessonsView({required this.topic, required this.language});

  final Topic topic;
  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.titleIn(language))),
      body: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          switch (state.status) {
            case LessonsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LessonsStatus.failure:
              return const Center(child: Text('Không tải được bài học.'));
            case LessonsStatus.success:
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.lessons.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) =>
                    _LessonTile(lesson: state.lessons[i], language: language),
              );
          }
        },
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson, required this.language});

  final Lesson lesson;
  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const CircleAvatar(child: Icon(AppIcons.bookOpen)),
        title: Text(lesson.titleIn(language)),
        subtitle: Text(
          '${lesson.subtitleIn(language)} · ${lesson.questionCount} questions',
        ),
        trailing: const Icon(AppIcons.chevronRight),
        onTap: () => _startQuiz(context, lesson),
      ),
    );
  }

  void _startQuiz(BuildContext context, Lesson lesson) {
    context.push(
      RouteNames.quiz,
      extra: QuizPageArgs(
        lesson: lesson,
        lessonTitle: lesson.titleIn(language),
      ),
    );
  }
}
