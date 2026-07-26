import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/audio_providers.dart';

class TaskSpeakerButton extends ConsumerWidget {
  final String textToSpeak;
  final double iconSize;

  const TaskSpeakerButton({
    super.key,
    required this.textToSpeak,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        border: Border.all(
          color: colorScheme.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(Icons.campaign, size: iconSize),
        onPressed: () => ref.read(audioServiceProvider).speak(textToSpeak),
        tooltip: 'Hear pronunciation',
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }
}
