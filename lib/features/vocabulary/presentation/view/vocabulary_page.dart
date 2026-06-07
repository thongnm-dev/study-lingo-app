import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../lessons/domain/entities/learning_language.dart';
import '../../../lessons/presentation/cubit/language_cubit.dart';
import '../../data/datasources/vocabulary_local_data_source.dart';
import '../../data/repositories/vocabulary_repository_impl.dart';
import '../bloc/vocabulary_bloc.dart';
import '../widgets/vocabulary_card.dart';

extension on LearningLanguage {
  String nameOf(AppLocalizations l10n) => switch (this) {
    LearningLanguage.english => l10n.learningLanguageEnglish,
    LearningLanguage.japanese => l10n.learningLanguageJapanese,
  };
}

/// Entry point for the vocabulary feature. Owns the BlocProvider so the Bloc is
/// scoped to this feature rather than the whole app. The word list follows the
/// learning session: the initial load and a [BlocListener] both read the
/// app-root [LanguageCubit], so picking a study language in the Lessons tab
/// filters this deck too. In a larger app the repository would come from a DI
/// container instead of being constructed here.
class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VocabularyBloc(
            const VocabularyRepositoryImpl(InMemoryVocabularyDataSource()),
          )..add(
            VocabularyRequested(language: context.read<LanguageCubit>().state),
          ),
      child: const VocabularyView(),
    );
  }
}

class VocabularyView extends StatelessWidget {
  const VocabularyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.vocabularyTitle)),
      // Re-filter when the learning session changes (the tab stays alive in
      // the IndexedStack, so this fires even while another tab is shown).
      body: BlocListener<LanguageCubit, LearningLanguage?>(
        listener: (context, language) {
          final bloc = context.read<VocabularyBloc>();
          bloc.add(
            VocabularyRequested(
              language: language,
              // JLPT classification is Japanese-only; drop the level filter
              // when the session switches to English.
              jlptLevel: language == LearningLanguage.english
                  ? null
                  : bloc.state.jlptFilter,
            ),
          );
        },
        child: const Column(
          children: [
            _FilterBar(),
            Expanded(child: _VocabularyList()),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  static const _jlptLevels = [5, 4, 3, 2, 1];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      buildWhen: (a, b) =>
          a.languageFilter != b.languageFilter || a.jlptFilter != b.jlptFilter,
      builder: (context, state) {
        final bloc = context.read<VocabularyBloc>();
        final language = state.languageFilter;
        // JLPT levels only make sense while the Japanese deck is in view.
        final showJlpt = language != LearningLanguage.english;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (language != null) ...[
                Chip(
                  avatar: const Icon(AppIcons.school, size: 18),
                  label: Text(
                    l10n.vocabularyStudyingChip(language.nameOf(l10n)),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (showJlpt) ...[
                ChoiceChip(
                  label: Text(l10n.vocabularyAllLevels),
                  selected: state.jlptFilter == null,
                  onSelected: (_) =>
                      bloc.add(VocabularyRequested(language: language)),
                ),
                const SizedBox(width: 8),
                for (final level in _jlptLevels) ...[
                  ChoiceChip(
                    label: Text('N$level'),
                    selected: state.jlptFilter == level,
                    onSelected: (_) => bloc.add(
                      VocabularyRequested(language: language, jlptLevel: level),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

class _VocabularyList extends StatelessWidget {
  const _VocabularyList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        switch (state.status) {
          case VocabularyStatus.initial:
          case VocabularyStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case VocabularyStatus.failure:
            return Center(
              child: Text(state.errorMessage ?? l10n.vocabularyError),
            );
          case VocabularyStatus.success:
            if (state.words.isEmpty) {
              return Center(child: Text(l10n.vocabularyEmpty));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: state.words.length,
              itemBuilder: (context, i) => VocabularyCard(word: state.words[i]),
            );
        }
      },
    );
  }
}
