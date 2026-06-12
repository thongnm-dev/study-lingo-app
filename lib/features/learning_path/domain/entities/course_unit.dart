import 'package:equatable/equatable.dart';

import 'lesson_node.dart';

class CourseUnit extends Equatable {
  final String id;
  final int index;
  final String title;
  final String emoji;
  final List<LessonNode> nodes;

  const CourseUnit({
    required this.id,
    required this.index,
    required this.title,
    required this.emoji,
    required this.nodes,
  });

  int get completedCount =>
      nodes.where((n) => n.state == NodeState.done).length;

  int get totalCount => nodes.length;

  String get progress => '$completedCount/$totalCount';

  @override
  List<Object?> get props => [id, index, title, emoji, nodes];
}
