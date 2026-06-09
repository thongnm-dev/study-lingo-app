import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/service_locator.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/constants/learning_language.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/icons/learning_language_icon.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../english/lessons/domain/usecases/fetch_english_practice_lesson.dart';
import '../../../japanese/lessons/domain/usecases/fetch_japanese_practice_lesson.dart';

/// "Luyện tập" entry point (from the More menu or the home promo banner). Pick
/// a language, then run a mixed practice quiz built from across all topics —
/// reusing the same [QuizPage] as lessons, so a finished session also records
/// daily progress. Routes through each language's own practice use case.
class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  /// The language whose practice set is currently loading, if any.
  LearningLanguage? _loading;

  Future<void> _start(LearningLanguage language) async {
    setState(() => _loading = language);

    final args = switch (language) {
      LearningLanguage.english => await _loadEnglish(),
      LearningLanguage.japanese => await _loadJapanese(),
    };
    if (!mounted) return;

    await context.push(RouteNames.quiz, extra: args);
    if (mounted) setState(() => _loading = null);
  }

  Future<QuizPageArgs> _loadEnglish() async {
    final result = await getIt<FetchEnglishPracticeLessonUseCase>()(NoParams());
    return result.fold(
      (_) => const QuizPageArgs(questions: [], lessonTitle: 'Luyện tập'),
      (lesson) => QuizPageArgs(
        questions: lesson.questions,
        lessonTitle: 'Luyện tập',
      ),
    );
  }

  Future<QuizPageArgs> _loadJapanese() async {
    final result = await getIt<FetchJapanesePracticeLessonUseCase>()(
      NoParams(),
    );
    return result.fold(
      (_) => const QuizPageArgs(questions: [], lessonTitle: 'Luyện tập'),
      (lesson) => QuizPageArgs(
        questions: lesson.questions,
        lessonTitle: 'Luyện tập',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _loading != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Luyện tập')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Ôn tập nhanh', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Chọn ngôn ngữ để bắt đầu một phiên luyện tập tổng hợp.',
            style: theme.textTheme.bodyMedium?.copyWith(
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
                title: Text('Luyện tập ${language.labelVi}'),
                subtitle: Text(language.nativeName),
                trailing: _loading == language
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Icon(AppIcons.play),
                onTap: busy ? null : () => _start(language),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
