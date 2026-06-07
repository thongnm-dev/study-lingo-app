import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/icons/app_icons.dart';
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
            'Câu ${state.currentIndex + 1} / ${state.totalQuestions}',
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
              child: Text(state.isLastQuestion ? 'Hoàn thành' : 'Tiếp theo'),
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
        trailing = Icon(AppIcons.checkCircle, color: theme.colorScheme.primary);
      } else if (isSelected) {
        bg = theme.colorScheme.errorContainer;
        trailing = Icon(AppIcons.cancel, color: theme.colorScheme.error);
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
              AppIcons.trophy,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Hoàn thành bài học!', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '$correct / $total đúng  ·  +${state.earnedXp} XP',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(minimumSize: const Size(180, 48)),
              child: const Text('Xong'),
            ),
          ],
        ),
      ),
    );
  }
}
