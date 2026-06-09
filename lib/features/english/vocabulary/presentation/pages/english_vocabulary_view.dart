import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/di/service_locator.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../bloc/english_vocabulary_bloc.dart';
import '../widgets/english_vocabulary_card.dart';

/// English vocabulary view. Owns the [EnglishVocabularyBloc] BlocProvider so
/// the bloc is scoped to this view. Embedded inside the vocabulary hub when
/// the learning session is English.
class EnglishVocabularyView extends StatelessWidget {
  const EnglishVocabularyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<EnglishVocabularyBloc>()..add(const EnglishVocabularyRequested()),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<EnglishVocabularyBloc, EnglishVocabularyState>(
      builder: (context, state) {
        switch (state.status) {
          case EnglishVocabularyStatus.initial:
          case EnglishVocabularyStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case EnglishVocabularyStatus.failure:
            return Center(
              child: Text(state.errorMessage ?? l10n.vocabularyError),
            );
          case EnglishVocabularyStatus.success:
            if (state.words.isEmpty) {
              return Center(child: Text(l10n.vocabularyEmpty));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              itemCount: state.words.length,
              itemBuilder: (context, i) =>
                  EnglishVocabularyCard(word: state.words[i]),
            );
        }
      },
    );
  }
}
