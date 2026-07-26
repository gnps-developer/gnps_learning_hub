import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../../providers/audio_providers.dart';
import '../../config/task_config.dart';
import '../common/task_speaker_button.dart';
import '../common/task_header.dart';

class MatchingPicturesTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onIncorrect;

  const MatchingPicturesTaskWidget({
    super.key,
    required this.task,
    required this.onComplete,
    this.onIncorrect,
  });

  @override
  ConsumerState<MatchingPicturesTaskWidget> createState() =>
      _MatchingPicturesTaskWidgetState();
}

class _MatchingPicturesTaskWidgetState
    extends ConsumerState<MatchingPicturesTaskWidget>
    with SingleTickerProviderStateMixin {
  late final List<String> _options;
  String? _selected;
  bool? _isCorrect;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    super.initState();
    final correct = widget.task.content['correctEmoji'] as String;
    final distractors = List<String>.from(
      widget.task.content['distractorEmojis'] as List,
    );
    _options = [correct, ...distractors]..shuffle(Random());

    // Auto-play the target word sound after a short delay
    final word = widget.task.content['word'] as String;
    Future.delayed(TaskConfig.autoPlayDelay, () {
      if (mounted) {
        ref.read(audioServiceProvider).speak(word);
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _select(String option) {
    if (_isCorrect == true) return; // already completed, ignore further taps

    final correct = widget.task.content['correctEmoji'] as String;
    setState(() {
      _selected = option;
      _isCorrect = option == correct;
    });

    if (option == correct) {
      Future.delayed(const Duration(milliseconds: 600), widget.onComplete);
    } else {
      _shakeController.forward(from: 0.0);
      widget.onIncorrect?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.task.content['word'] as String;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      child: Column(
        children: [
          const TaskHeader(title: 'Select the correct picture'),
          const SizedBox(height: 4),
          Column(
            children: [
              TaskSpeakerButton(textToSpeak: word),
              const SizedBox(height: 12),
              Text(word, style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                final sineValue = sin(_shakeController.value * 4 * pi);
                return Transform.translate(
                  offset: Offset(sineValue * 8, 0),
                  child: child,
                );
              },
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: _options.map((emoji) {
                  final isSelected = _selected == emoji;
                  Color? borderColor;
                  if (isSelected) {
                    borderColor = (_isCorrect ?? false)
                        ? Colors.green
                        : Colors.red;
                  }
                  return GestureDetector(
                    onTap: () => _select(emoji),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        border: Border.all(
                          color: borderColor ?? Colors.grey.shade300,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 64),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
