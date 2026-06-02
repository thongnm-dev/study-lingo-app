import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/in_memory_writing_repository.dart';
import '../../domain/entities/japanese_script.dart';
import '../../domain/entities/writing_character.dart';
import '../cubit/writing_practice_cubit.dart';
import '../widgets/stroke_order_data.dart';
import '../widgets/stroke_order_view.dart';
import '../widgets/tracing_canvas.dart';

/// Tracing practice. Either walks a whole [script] (via the repository) or a
/// fixed [characters] list (e.g. a single kanji from its detail page). Shows the
/// character as a faint guide; the user traces it, can view stroke order, clears
/// and moves on. The character list/index lives in [WritingPracticeCubit]; the
/// drawn strokes are local UI state.
class CharacterTracingPage extends StatelessWidget {
  const CharacterTracingPage({
    super.key,
    this.script,
    this.characters,
    this.title,
  }) : assert(
         script != null || characters != null,
         'Provide a script or a characters list',
       );

  final JapaneseScript? script;
  final List<WritingCharacter>? characters;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final appTitle =
        title ??
        (script != null ? 'Luyện viết · ${script!.label}' : 'Luyện viết');
    return BlocProvider(
      create: (_) {
        final cubit = WritingPracticeCubit(const InMemoryWritingRepository());
        if (characters != null) {
          cubit.setCharacters(characters!);
        } else {
          cubit.load(script!);
        }
        return cubit;
      },
      child: _TracingView(title: appTitle),
    );
  }
}

class _TracingView extends StatefulWidget {
  const _TracingView({required this.title});

  final String title;

  @override
  State<_TracingView> createState() => _TracingViewState();
}

class _TracingViewState extends State<_TracingView> {
  // Transient drawing state: completed strokes + the one in progress.
  final List<List<Offset>> _strokes = [];

  void _startStroke(Offset p) => setState(() => _strokes.add([p]));
  void _appendPoint(Offset p) => setState(() => _strokes.last.add(p));
  void _clear() => setState(_strokes.clear);

  void _showStrokeOrder(String glyph, List<List<Offset>> strokes) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: StrokeOrderView(glyph: glyph, strokes: strokes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocConsumer<WritingPracticeCubit, WritingPracticeState>(
        // Clear the canvas whenever the current character changes.
        listenWhen: (a, b) => a.index != b.index,
        listener: (_, _) => _clear(),
        builder: (context, state) {
          final character = state.current;
          if (!state.loaded || character == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final cubit = context.read<WritingPracticeCubit>();
          final strokeOrder = strokeOrderFor(character.glyph);
          return Column(
            children: [
              LinearProgressIndicator(value: state.progress),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Chữ ${state.index + 1}/${state.total}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      character.reading,
                      style: theme.textTheme.headlineSmall,
                    ),
                    if (character.meaning != null)
                      Text(
                        character.meaning!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (strokeOrder != null)
                      TextButton.icon(
                        onPressed: () =>
                            _showStrokeOrder(character.glyph, strokeOrder),
                        icon: const Icon(Icons.gesture),
                        label: const Text('Thứ tự nét'),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: TracingCanvas(
                      glyph: character.glyph,
                      strokes: _strokes,
                      onStrokeStart: _startStroke,
                      onStrokePoint: _appendPoint,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _clear,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Xóa'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: state.isLast
                              ? () => Navigator.of(context).pop()
                              : cubit.next,
                          icon: Icon(
                            state.isLast ? Icons.check : Icons.arrow_forward,
                          ),
                          label: Text(state.isLast ? 'Hoàn thành' : 'Tiếp'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
