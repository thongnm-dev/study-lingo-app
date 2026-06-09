import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/learning_language.dart';
import '../../../../core/constants/learning_skill.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/icons/learning_language_icon.dart';
import '../../../../core/session/language_cubit.dart';

/// Home tab root, styled as an "Overview" dashboard: a promo banner, the
/// study-language picker, and the skill tracks for the selected language.
///
/// Owns the language picker that drives the app-wide [LanguageCubit] (shared
/// with the vocabulary deck filter). Picking a language highlights it here and
/// reveals its skill tracks; tapping a skill drills into either the english or
/// japanese topics page depending on the selected language.
class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tổng quan'),
        actions: [
          IconButton(
            tooltip: 'Thông báo',
            icon: const Icon(AppIcons.notifications),
            onPressed: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Chưa có thông báo mới.'),
                ),
              ),
          ),
        ],
      ),
      body: BlocBuilder<LanguageCubit, LearningLanguage?>(
        builder: (context, language) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const _PromoBanner(),
              const SizedBox(height: 28),
              const _SectionHeader('Chọn ngôn ngữ'),
              const SizedBox(height: 12),
              _LanguageRow(selected: language),
              const SizedBox(height: 28),
              _SkillsSection(language: language),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Gradient hero banner with a quick-practice call to action.
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.tertiary],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HỌC MỖI NGÀY',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Cách tốt nhất để\nhọc ngôn ngữ',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.push(RouteNames.practice),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: scheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Luyện tập ngay'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            AppIcons.stories,
            size: 72,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }
}

/// The study-language picker chips. Tapping one drives [LanguageCubit] (shared
/// with the vocabulary deck filter) and reveals its skill tracks below.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({required this.selected});

  final LearningLanguage? selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final language in LearningLanguage.values) ...[
          Expanded(
            child: _LanguageChip(
              language: language,
              selected: language == selected,
              onTap: () => context.read<LanguageCubit>().select(language),
            ),
          ),
          if (language != LearningLanguage.values.last)
            const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final LearningLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                language.icon,
                size: 34,
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                language.labelVi,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected ? scheme.onPrimaryContainer : null,
                ),
              ),
              Text(
                language.nativeName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on LearningSkill {
  IconData get icon => switch (this) {
    LearningSkill.grammar => AppIcons.grammar,
    LearningSkill.vocabulary => AppIcons.vocabulary,
    LearningSkill.listeningSpeaking => AppIcons.listening,
    LearningSkill.reading => AppIcons.reading,
    LearningSkill.writing => AppIcons.writing,
  };

  /// Accent color for the skill's card (works on light and dark themes).
  Color get accent => switch (this) {
    LearningSkill.grammar => AppColors.skillGrammar,
    LearningSkill.vocabulary => AppColors.skillVocabulary,
    LearningSkill.listeningSpeaking => AppColors.skillListeningSpeaking,
    LearningSkill.reading => AppColors.skillReading,
    LearningSkill.writing => AppColors.skillWriting,
  };

  String get blurb => switch (this) {
    LearningSkill.grammar => 'Cấu trúc & quy tắc',
    LearningSkill.vocabulary => 'Mở rộng từ vựng',
    LearningSkill.listeningSpeaking => 'Luyện nghe & nói',
    LearningSkill.reading => 'Đọc hiểu văn bản',
    LearningSkill.writing => 'Luyện viết & chữ',
  };
}

/// The skill-track grid. Reacts to the selected [language]: shows a prompt when
/// none is chosen yet, otherwise a 2-column grid of skill cards.
class _SkillsSection extends StatelessWidget {
  const _SkillsSection({required this.language});

  final LearningLanguage? language;

  @override
  Widget build(BuildContext context) {
    final lang = language;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          lang == null ? 'Kỹ năng' : 'Kỹ năng · ${lang.labelVi}',
        ),
        const SizedBox(height: 12),
        if (lang == null)
          const _ChooseLanguageHint()
        else
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 12.0;
              final itemWidth = (constraints.maxWidth - spacing) / 2;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final skill in LearningSkill.values)
                    SizedBox(
                      width: itemWidth,
                      child: _SkillCard(skill: skill, language: lang),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _ChooseLanguageHint extends StatelessWidget {
  const _ChooseLanguageHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            AppIcons.tap,
            size: 40,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'Chọn một ngôn ngữ phía trên để bắt đầu học.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill, required this.language});

  final LearningSkill skill;
  final LearningLanguage language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = skill.accent;
    return Material(
      color: accent.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openTopics(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(skill.icon, color: accent, size: 24),
              ),
              const SizedBox(height: 14),
              Text(
                skill.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                skill.blurb,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Bắt đầu',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(AppIcons.arrowForward, size: 16, color: accent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTopics(BuildContext context) {
    switch (language) {
      case LearningLanguage.english:
        context.push(
          RouteNames.englishTopics,
          extra: EnglishTopicsPageArgs(skill: skill),
        );
      case LearningLanguage.japanese:
        context.push(
          RouteNames.japaneseTopics,
          extra: JapaneseTopicsPageArgs(skill: skill),
        );
    }
  }
}
