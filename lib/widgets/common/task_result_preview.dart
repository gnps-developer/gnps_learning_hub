import 'package:flutter/material.dart';

class TaskResultPreview extends StatelessWidget {
  final String text;
  final bool? isCorrect;
  final double fontSize;

  const TaskResultPreview({
    super.key,
    required this.text,
    this.isCorrect,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: isCorrect == null
              ? Colors.black
              : (isCorrect! ? Colors.green : Colors.red),
        ),
      ),
    );
  }
}
