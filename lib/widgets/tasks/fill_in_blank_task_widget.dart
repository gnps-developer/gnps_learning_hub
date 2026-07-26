import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../../providers/audio_providers.dart';
import '../../config/task_config.dart';
import '../common/task_speaker_button.dart';
import '../common/task_header.dart';
import '../common/task_letter_bank.dart';
import '../common/task_built_tile.dart';
import '../common/task_interactive_build_area.dart';

class FillInBlankTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onIncorrect;

  const FillInBlankTaskWidget({
    super.key,
    required this.task,
    required this.onComplete,
    this.onIncorrect,
  });

  @override
  ConsumerState<FillInBlankTaskWidget> createState() =>
      _FillInBlankTaskWidgetState();
}

class _FillInBlankTaskWidgetState extends ConsumerState<FillInBlankTaskWidget>
    with SingleTickerProviderStateMixin {
  String? _selected;
  bool? _isCorrect;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    super.initState();
    // Auto-play the sentence sound after a short delay
    final parts = List<String>.from(widget.task.content['sentenceParts'] as List);
    final correctWord = widget.task.content['correctWord'] as String;
    final fullSentence = parts.map((p) => p == '___' ? correctWord : p).join(' ');

    Future.delayed(TaskConfig.autoPlayDelay, () {
      if (mounted) {
        ref.read(audioServiceProvider).speak(fullSentence);
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

    final correctWord = widget.task.content['correctWord'] as String;
    setState(() {
      _selected = option;
      _isCorrect = option == correctWord;
    });
    if (option == correctWord) {
      Future.delayed(const Duration(milliseconds: 600), widget.onComplete);
    } else {
      _shakeController.forward(from: 0.0);
      widget.onIncorrect?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final parts = List<String>.from(
      widget.task.content['sentenceParts'] as List,
    );
    final options = List<String>.from(widget.task.content['options'] as List);
    final correctWord = widget.task.content['correctWord'] as String;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      child: Column(
        children: [
          const TaskHeader(title: 'Fill in the blank'),
          const SizedBox(height: 12),
          TaskSpeakerButton(
            textToSpeak: parts
                .map((p) => p == '___' ? correctWord : p)
                .join(' '),
          ),
          const SizedBox(height: 12),

          TaskInteractiveBuildArea<String>(
            onAccept: _select,
            isCorrect: _isCorrect,
            shakeController: _shakeController,
            hintText: '',
            children: parts.map((p) {
              final isBlank = p == '___';
              Color? tileColor;
              if (isBlank) {
                tileColor = _isCorrect == null
                    ? Colors.blue.shade700
                    : (_isCorrect! ? Colors.green : Colors.red);
              } else {
                tileColor = Colors.black87;
              }

              return TaskBuiltTile(
                text: isBlank ? (_selected ?? '___') : p,
                onTap: () {
                  if (isBlank && _isCorrect != true) {
                    setState(() => _selected = null);
                  }
                },
                color: tileColor,
                fontSize: 36,
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: options.map((option) {
              return TaskLetterBank(text: option, onTap: () => _select(option));
            }).toList(),
          ),
        ],
      ),
    );
  }
}
