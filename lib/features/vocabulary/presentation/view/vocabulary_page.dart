import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/vocabulary_local_data_source.dart';
import '../../data/repositories/vocabulary_repository_impl.dart';
import '../bloc/vocabulary_bloc.dart';
import '../widgets/vocabulary_card.dart';

/// Entry point for the vocabulary feature. Owns the BlocProvider so the Bloc is
/// scoped to this feature rather than the whole app. In a larger app the
/// repository would come from a DI container instead of being constructed here.
class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VocabularyBloc(
        const VocabularyRepositoryImpl(InMemoryVocabularyDataSource()),
      )..add(const VocabularyRequested()),
      child: const VocabularyView(),
    );
  }
}

class VocabularyView extends StatelessWidget {
  const VocabularyView({super.key});

  static const _jlptLevels = [5, 4, 3, 2, 1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary')),
      body: Column(
        children: [
          _JlptFilterBar(levels: _jlptLevels),
          const Expanded(child: _VocabularyList()),
        ],
      ),
    );
  }
}

class _JlptFilterBar extends StatelessWidget {
  const _JlptFilterBar({required this.levels});

  final List<int> levels;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      buildWhen: (a, b) => a.jlptFilter != b.jlptFilter,
      builder: (context, state) {
        final bloc = context.read<VocabularyBloc>();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: state.jlptFilter == null,
                onSelected: (_) => bloc.add(const VocabularyRequested()),
              ),
              const SizedBox(width: 8),
              for (final level in levels) ...[
                ChoiceChip(
                  label: Text('N$level'),
                  selected: state.jlptFilter == level,
                  onSelected: (_) =>
                      bloc.add(VocabularyRequested(jlptLevel: level)),
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

class _VocabularyList extends StatelessWidget {
  const _VocabularyList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        switch (state.status) {
          case VocabularyStatus.initial:
          case VocabularyStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case VocabularyStatus.failure:
            return Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            );
          case VocabularyStatus.success:
            if (state.words.isEmpty) {
              return const Center(child: Text('No words for this level yet.'));
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
