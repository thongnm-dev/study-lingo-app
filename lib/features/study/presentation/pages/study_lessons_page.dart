import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/service_locator.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/study_lesson.dart';
import '../../domain/entities/study_lesson_focus.dart';
import '../../domain/entities/study_topic.dart';
import '../bloc/study_lessons_cubit.dart';

/// Lessons within one [StudyTopic]. Tap a lesson → opens the existing
/// `QuizPage` with the lesson's questions.
class StudyLessonsPage extends StatelessWidget {
  const StudyLessonsPage({super.key, required this.topic});

  final StudyTopic topic;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudyLessonsCubit>()..load(topic.id),
      child: _LessonsView(topic: topic),
    );
  }
}

class _LessonsView extends StatelessWidget {
  const _LessonsView({required this.topic});

  final StudyTopic topic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(topic.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Flexible(child: Text(topic.title)),
          ],
        ),
      ),
      body: BlocBuilder<StudyLessonsCubit, StudyLessonsState>(
        builder: (context, state) {
          switch (state.status) {
            case StudyLessonsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case StudyLessonsStatus.failure:
              return Center(child: Text(l10n.studyLessonsError));
            case StudyLessonsStatus.success:
              if (state.lessons.isEmpty) {
                return Center(child: Text(l10n.studyLessonsEmpty));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
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

extension on StudyLessonFocus {
  IconData get icon => switch (this) {
    StudyLessonFocus.grammar => AppIcons.grammar,
    StudyLessonFocus.pronunciation => AppIcons.listening,
    StudyLessonFocus.vocabulary => AppIcons.vocabulary,
  };

  Color get accent => switch (this) {
    StudyLessonFocus.grammar => AppColors.skillGrammar,
    StudyLessonFocus.pronunciation => AppColors.skillListeningSpeaking,
    StudyLessonFocus.vocabulary => AppColors.skillVocabulary,
  };
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson});

  final StudyLesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final accent = lesson.focus.accent;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: accent.withValues(alpha: 0.18),
          child: Icon(lesson.focus.icon, color: accent),
        ),
        title: Text(lesson.title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  lesson.focus.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.studyLessonQuestionCount(lesson.questionCount),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
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
