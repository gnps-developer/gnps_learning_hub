import 'dart:math';
import 'package:flutter/material.dart';

class TaskBuildArea extends StatelessWidget {
  final List<Widget> children;
  final bool? isCorrect;
  final AnimationController? shakeController;
  final String hintText;
  final double spacing;

  const TaskBuildArea({
    super.key,
    required this.children,
    this.isCorrect,
    this.shakeController,
    this.hintText = 'Drag items here',
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 110),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(
          color: isCorrect == null
              ? Colors.grey.shade300
              : (isCorrect! ? Colors.green : Colors.red),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: spacing,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children.isEmpty
            ? [
                Text(
                  hintText,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]
            : children,
      ),
    );

    if (shakeController != null) {
      return AnimatedBuilder(
        animation: shakeController!,
        builder: (context, child) {
          final sineValue = sin(shakeController!.value * 4 * pi);
          return Transform.translate(
            offset: Offset(sineValue * 10, 0),
            child: child,
          );
        },
        child: content,
      );
    }

    return content;
  }
}
