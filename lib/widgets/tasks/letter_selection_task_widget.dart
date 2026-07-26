import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../../providers/audio_providers.dart';
import '../../config/task_config.dart';
import '../common/task_speaker_button.dart';
import '../common/task_header.dart';

class LetterSelectionTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onIncorrect;

  const LetterSelectionTaskWidget({
    super.key,
    required this.task,
    required this.onComplete,
    this.onIncorrect,
  });

  @override
  ConsumerState<LetterSelectionTaskWidget> createState() =>
      _LetterSelectionTaskWidgetState();
}

class _LetterSelectionTaskWidgetState
    extends ConsumerState<LetterSelectionTaskWidget>
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
    final correct = widget.task.content['correctLetter'] as String;
    final distractors = List<String>.from(
      widget.task.content['distractorLetters'] as List,
    );

    // Ensure we only have 4 options total (1 correct + 3 distractors)
    _options = [correct, ...distractors.take(3)]..shuffle(Random());

    // Auto-play the letter sound after a short delay
    Future.delayed(TaskConfig.autoPlayDelay, () {
      if (mounted) {
        ref.read(audioServiceProvider).speak(correct);
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

    final correct = widget.task.content['correctLetter'] as String;
    setState(() {
      _selected = option;
      _isCorrect = option == correct;
    });

    if (option == correct) {
      Future.delayed(const Duration(milliseconds: 600), widget.onComplete);
    } else {
      HapticFeedback.heavyImpact();
      _shakeController.forward(from: 0.0);
      widget.onIncorrect?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final correctLetter = widget.task.content['correctLetter'] as String;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      child: Column(
        children: [
          const TaskHeader(title: 'Listen and select the correct letter'),
          const SizedBox(height: 32),
          TaskSpeakerButton(textToSpeak: correctLetter, iconSize: 64),
          const SizedBox(height: 48),
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
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: _options.map((letter) {
                  final isSelected = _selected == letter;
                  Color? borderColor;
                  if (isSelected) {
                    borderColor = (_isCorrect ?? false)
                        ? Colors.green
                        : Colors.red;
                  }
                  return GestureDetector(
                    onTap: () => _select(letter),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        border: Border.all(
                          color: borderColor ?? Colors.grey.shade300,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
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
