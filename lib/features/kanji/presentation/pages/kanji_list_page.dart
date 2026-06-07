import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/service_locator.dart';
import '../../../../config/router/route_names.dart';
import '../../domain/entities/kanji.dart';
import '../bloc/kanji_list_cubit.dart';

/// "Học Hán tự" — a grid of kanji to browse. Tapping one opens its detail.
class KanjiListPage extends StatelessWidget {
  const KanjiListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<KanjiListCubit>()..load(),
      child: const _KanjiListView(),
    );
  }
}

class _KanjiListView extends StatelessWidget {
  const _KanjiListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Học Hán tự')),
      body: BlocBuilder<KanjiListCubit, KanjiListState>(
        builder: (context, state) {
          switch (state.status) {
            case KanjiListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case KanjiListStatus.failure:
              return const Center(child: Text('Không tải được Hán tự.'));
            case KanjiListStatus.success:
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: state.kanji.length,
                itemBuilder: (context, i) => _KanjiCard(kanji: state.kanji[i]),
              );
          }
        },
      ),
    );
  }
}

class _KanjiCard extends StatelessWidget {
  const _KanjiCard({required this.kanji});

  final Kanji kanji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(RouteNames.kanjiDetail, extra: kanji),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(kanji.glyph, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 4),
              Text(
                kanji.meaning,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
