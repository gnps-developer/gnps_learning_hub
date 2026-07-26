import 'package:flutter/material.dart';

class TaskBuiltTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final double fontSize;

  const TaskBuiltTile({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.fontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.blue.shade700,
        ),
      ),
    );
  }
}
