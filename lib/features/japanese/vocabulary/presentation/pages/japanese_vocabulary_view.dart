import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/di/service_locator.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../bloc/japanese_vocabulary_bloc.dart';
import '../widgets/japanese_vocabulary_card.dart';

/// Japanese vocabulary view. Owns the [JapaneseVocabularyBloc] BlocProvider so
/// the bloc is scoped to this view. Embedded inside the vocabulary hub when
/// the learning session is Japanese.
class JapaneseVocabularyView extends StatelessWidget {
  const JapaneseVocabularyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<JapaneseVocabularyBloc>()
        ..add(const JapaneseVocabularyRequested()),
      child: const Column(
        children: [
          _FilterBar(),
          Expanded(child: _Body()),
        ],
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
    return BlocBuilder<JapaneseVocabularyBloc, JapaneseVocabularyState>(
      buildWhen: (a, b) => a.jlptFilter != b.jlptFilter,
      builder: (context, state) {
        final bloc = context.read<JapaneseVocabularyBloc>();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ChoiceChip(
                label: Text(l10n.vocabularyAllLevels),
                selected: state.jlptFilter == null,
                onSelected: (_) =>
                    bloc.add(const JapaneseVocabularyRequested()),
              ),
              const SizedBox(width: 8),
              for (final level in _jlptLevels) ...[
                ChoiceChip(
                  label: Text('N$level'),
                  selected: state.jlptFilter == level,
                  onSelected: (_) => bloc.add(
                    JapaneseVocabularyRequested(jlptLevel: level),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<JapaneseVocabularyBloc, JapaneseVocabularyState>(
      builder: (context, state) {
        switch (state.status) {
          case JapaneseVocabularyStatus.initial:
          case JapaneseVocabularyStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case JapaneseVocabularyStatus.failure:
            return Center(
              child: Text(state.errorMessage ?? l10n.vocabularyError),
            );
          case JapaneseVocabularyStatus.success:
            if (state.words.isEmpty) {
              return Center(child: Text(l10n.vocabularyEmpty));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: state.words.length,
              itemBuilder: (context, i) =>
                  JapaneseVocabularyCard(word: state.words[i]),
            );
        }
      },
    );
  }
}
