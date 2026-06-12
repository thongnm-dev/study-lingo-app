import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../config/router/route_names.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/learning_language.dart';
import '../../domain/entities/course_unit.dart';
import '../../domain/entities/lesson_node.dart';
import '../bloc/learning_path_cubit.dart';
import '../widgets/lesson_node_sheet.dart';
import '../widgets/path_node_widget.dart';
import '../widgets/unit_banner_header.dart';

class LearningPathPage extends StatefulWidget {
  final LearningLanguage language;

  const LearningPathPage({super.key, required this.language});

  @override
  State<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> {
  /// Sinusoidal wave offsets — repeats every 8 nodes for a smooth S-curve.
  static const _pattern = <double>[0, 46, 70, 46, 0, -46, -70, -46];

  @override
  void initState() {
    super.initState();
    context.read<LearningPathCubit>().load(widget.language);
  }

  (Color, Color) _unitAccent(int index) {
    final pair = AppColors.unitAccents[(index - 1) % AppColors.unitAccents.length];
    return pair;
  }

  void _showLockedToast() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '🔒  Hoàn thành các bài trước để mở khoá!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.fromLTRB(48, 0, 48, 16),
          duration: const Duration(milliseconds: 2200),
        ),
      );
  }

  void _openNode(CourseUnit unit, LessonNode node, Color color, Color dark) {
    if (node.isLocked) {
      _showLockedToast();
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => LessonNodeSheet(
        unit: unit,
        node: node,
        color: color,
        darkColor: dark,
        onStart: () {
          Navigator.of(context).pop();
          if (node.questions.isNotEmpty) {
            context.push(
              RouteNames.quiz,
              extra: QuizPageArgs(
                questions: node.questions,
                lessonTitle: node.title,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Lộ trình · ${widget.language.labelVi}')),
      body: BlocBuilder<LearningPathCubit, LearningPathState>(
        builder: (context, state) {
          if (state.status == LearningPathStatus.loading ||
              state.status == LearningPathStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == LearningPathStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Đã xảy ra lỗi',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }
          return _buildPath(state.units, theme);
        },
      ),
    );
  }

  Widget _buildPath(List<CourseUnit> units, ThemeData theme) {
    var globalIndex = 0;
    final slivers = <Widget>[];

    for (final unit in units) {
      final (color, dark) = _unitAccent(unit.index);
      final nodes = <Widget>[];

      for (final node in unit.nodes) {
        final ox = _pattern[globalIndex % _pattern.length];
        globalIndex++;
        final (bg, dk) = nodeColors((color, dark), node, theme);
        nodes.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Transform.translate(
              offset: Offset(ox, 0),
              child: PathNodeWidget(
                node: node,
                color: bg,
                darkColor: dk,
                onTap: () => _openNode(unit, node, color, dark),
              ),
            ),
          ),
        );
      }

      slivers.add(
        SliverMainAxisGroup(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: UnitBannerHeader(
                unit: unit,
                color: color,
                darkColor: dark,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 14),
                child: Column(children: nodes),
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        ...slivers,
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
