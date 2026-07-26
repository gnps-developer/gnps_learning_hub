import 'package:flutter/material.dart';

class TaskHeader extends StatelessWidget {
  final String title;

  const TaskHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800,
          ),
      textAlign: TextAlign.center,
    );
  }
}
