import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/service_locator.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/constants/learning_language.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/icons/learning_language_icon.dart';
import '../../../../core/session/language_cubit.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/study_topic.dart';
import '../bloc/study_topics_cubit.dart';

/// "Học" tab — themed study topics (Daily Conversation, Office, Health…) per
/// language. Reads the app-wide [LanguageCubit] for the session language and
/// reloads the topic list whenever that switches.
class StudyPage extends StatelessWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudyTopicsCubit>(
      create: (_) {
        final cubit = getIt<StudyTopicsCubit>();
        final lang = context.read<LanguageCubit>().state;
        if (lang != null) cubit.load(lang);
        return cubit;
      },
      child: const _StudyView(),
    );
  }
}

class _StudyView extends StatelessWidget {
  const _StudyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.studyTitle)),
      body: BlocListener<LanguageCubit, LearningLanguage?>(
        listener: (context, language) {
          if (language != null) {
            context.read<StudyTopicsCubit>().load(language);
          }
        },
        child: BlocBuilder<LanguageCubit, LearningLanguage?>(
          builder: (context, language) => language == null
              ? const _LanguagePicker()
              : _TopicsList(language: language),
        ),
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.studyPickLanguagePrompt,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          for (final language in LearningLanguage.values) ...[
            Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: Icon(language.icon, size: 32),
                title: Text(language.labelVi),
                subtitle: Text(language.nativeName),
                trailing: const Icon(AppIcons.chevronRight),
                onTap: () =>
                    context.read<LanguageCubit>().select(language),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _TopicsList extends StatelessWidget {
  const _TopicsList({required this.language});

  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CurrentLanguageHeader(language: language),
        const Expanded(child: _TopicsListBody()),
      ],
    );
  }
}

class _CurrentLanguageHeader extends StatelessWidget {
  const _CurrentLanguageHeader({required this.language});

  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(language.icon, color: scheme.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language.labelVi,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  language.nativeName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.read<LanguageCubit>().reset(),
            child: Text(l10n.studyChangeLanguage),
          ),
        ],
      ),
    );
  }
}

class _TopicsListBody extends StatelessWidget {
  const _TopicsListBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<StudyTopicsCubit, StudyTopicsState>(
      builder: (context, state) {
        switch (state.status) {
          case StudyTopicsStatus.initial:
          case StudyTopicsStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case StudyTopicsStatus.failure:
            return Center(child: Text(l10n.studyTopicsError));
          case StudyTopicsStatus.success:
            if (state.topics.isEmpty) {
              return Center(child: Text(l10n.studyTopicsEmpty));
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: state.topics.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) =>
                  _TopicCard(topic: state.topics[i]),
            );
        }
      },
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.topic});

  final StudyTopic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push(
          RouteNames.studyLessons,
          extra: StudyLessonsPageArgs(topic: topic),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  topic.emoji,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      topic.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.studyLessonCount(topic.lessonCount),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(AppIcons.chevronRight),
            ],
          ),
        ),
      ),
    );
  }
}
