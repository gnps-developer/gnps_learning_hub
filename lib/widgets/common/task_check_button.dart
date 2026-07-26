import 'package:flutter/material.dart';

class TaskCheckButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const TaskCheckButton({
    super.key,
    required this.onPressed,
    this.label = 'Check',
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(140, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
      child: Text(label),
    );
  }
}
