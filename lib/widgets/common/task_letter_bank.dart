import 'package:flutter/material.dart';

class TaskLetterBank extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? feedback;
  final Object? data;

  const TaskLetterBank({
    super.key,
    required this.text,
    required this.onTap,
    this.feedback,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    final chip = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );

    if (data != null) {
      return Draggable(
        data: data,
        feedback: feedback ?? Material(color: Colors.transparent, child: chip),
        childWhenDragging: Opacity(opacity: 0.2, child: chip),
        child: GestureDetector(
          onTap: onTap,
          child: chip,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: chip,
    );
  }
}
