import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/quiz_bloc.dart';

/// Runs the quiz for one lesson. Expects a [QuizBloc] provided above it (see
/// LessonsPage). Shows one question at a time with answer feedback, then a
/// result screen on completion.
class QuizPage extends StatelessWidget {
  const QuizPage({super.key, required this.lessonTitle});

  final String lessonTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lessonTitle)),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state.status == QuizStatus.finished) {
            return _QuizResult(state: state);
          }
          return _QuizQuestionView(state: state);
        },
      ),
    );
  }
}

class _QuizQuestionView extends StatelessWidget {
  const _QuizQuestionView({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = state.currentQuestion;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: state.progress),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            'Question ${state.currentIndex + 1} of ${state.totalQuestions}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(question.prompt, style: theme.textTheme.headlineSmall),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: question.options.length,
            itemBuilder: (context, i) => _OptionTile(state: state, index: i),
          ),
        ),
        if (state.isAnswered && question.explanation != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              question.explanation!,
              style: theme.textTheme.bodySmall,
            ),
          ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: state.isAnswered
                  ? () => context.read<QuizBloc>().add(const QuizAdvanced())
                  : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: Text(state.isLastQuestion ? 'Finish' : 'Next'),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.state, required this.index});

  final QuizState state;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = state.currentQuestion;
    final isSelected = state.selectedOptionIndex == index;
    final isCorrect = question.correctIndex == index;

    // Color feedback only after the user has answered.
    Color? bg;
    Widget? trailing;
    if (state.isAnswered) {
      if (isCorrect) {
        bg = theme.colorScheme.primaryContainer;
        trailing = Icon(Icons.check_circle, color: theme.colorScheme.primary);
      } else if (isSelected) {
        bg = theme.colorScheme.errorContainer;
        trailing = Icon(Icons.cancel, color: theme.colorScheme.error);
      }
    }

    return Card(
      color: bg,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(question.options[index]),
        trailing: trailing,
        onTap: state.isAnswered
            ? null
            : () => context.read<QuizBloc>().add(QuizAnswerSelected(index)),
      ),
    );
  }
}

class _QuizResult extends StatelessWidget {
  const _QuizResult({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final correct = state.correctCount;
    final total = state.totalQuestions;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Lesson complete!', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '$correct / $total correct  ·  +${state.earnedXp} XP',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(minimumSize: const Size(180, 48)),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
