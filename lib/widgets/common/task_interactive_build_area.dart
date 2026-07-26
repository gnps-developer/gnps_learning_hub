import 'package:flutter/material.dart';
import 'task_build_area.dart';

/// A specialized [TaskBuildArea] that integrates a [DragTarget].
/// This is the primary construction area for all interactive tasks.
class TaskInteractiveBuildArea<T extends Object> extends StatelessWidget {
  final List<Widget> children;
  final bool? isCorrect;
  final AnimationController? shakeController;
  final String hintText;
  final void Function(T data) onAccept;
  final double spacing;

  const TaskInteractiveBuildArea({
    super.key,
    required this.children,
    required this.onAccept,
    this.isCorrect,
    this.shakeController,
    this.hintText = 'Drag items here',
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        return TaskBuildArea(
          isCorrect: isCorrect,
          shakeController: shakeController,
          hintText: hintText,
          spacing: spacing,
          children: children,
        );
      },
    );
  }
}
