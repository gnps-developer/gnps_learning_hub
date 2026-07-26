import 'package:flutter/material.dart';

class TaskClearButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const TaskClearButton({
    super.key,
    required this.onPressed,
    this.label = 'Clear',
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh, size: 24),
      label: Text(label),
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
    );
  }
}
