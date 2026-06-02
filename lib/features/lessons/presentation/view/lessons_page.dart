import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../progress/domain/repositories/progress_repository.dart';
import '../../domain/entities/learning_language.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/topic.dart';
import '../../domain/repositories/lessons_repository.dart';
import '../bloc/quiz_bloc.dart';
import '../cubit/lessons_cubit.dart';
import 'quiz_page.dart';

/// Lessons within one [Topic], titled in the chosen study [language]. Tapping a
/// lesson opens its quiz.
class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key, required this.topic, required this.language});

  final Topic topic;
  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LessonsCubit(context.read<LessonsRepository>())
            ..load(topic.id, language),
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
        leading: const CircleAvatar(child: Icon(Icons.menu_book_outlined)),
        title: Text(lesson.titleIn(language)),
        subtitle: Text(
          '${lesson.subtitleIn(language)} · ${lesson.questionCount} questions',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _startQuiz(context, lesson),
      ),
    );
  }

  void _startQuiz(BuildContext context, Lesson lesson) {
    // Pull the shared ProgressRepository from the app root so completing this
    // quiz updates the Progress tab.
    final progress = context.read<ProgressRepository>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => QuizBloc(lesson: lesson, progress: progress),
          child: QuizPage(lessonTitle: lesson.titleIn(language)),
        ),
      ),
    );
  }
}
