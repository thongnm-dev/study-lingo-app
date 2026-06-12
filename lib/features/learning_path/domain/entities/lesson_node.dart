import 'package:equatable/equatable.dart';

import '../../../quiz/domain/entities/quiz_question.dart';

enum NodeKind { lesson, chest, trophy }

enum NodeState { done, current, locked }

class LessonNode extends Equatable {
  final String id;
  final NodeKind kind;
  final NodeState state;
  final String title;
  final List<QuizQuestion> questions;

  const LessonNode({
    required this.id,
    required this.kind,
    required this.state,
    required this.title,
    this.questions = const [],
  });

  bool get isLocked => state == NodeState.locked;
  bool get isCurrent => state == NodeState.current;
  bool get isDone => state == NodeState.done;

  @override
  List<Object?> get props => [id, kind, state, title, questions];
}
