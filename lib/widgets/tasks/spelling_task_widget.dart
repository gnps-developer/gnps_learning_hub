import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../../providers/audio_providers.dart';
import '../../config/task_config.dart';
import '../common/task_speaker_button.dart';
import '../common/task_check_button.dart';
import '../common/task_header.dart';
import '../common/task_letter_bank.dart';
import '../common/task_built_tile.dart';
import '../common/task_interactive_build_area.dart';

/// Presents an emoji + word bank; the child drags letter/syllable tiles
/// from the bank into a build area to spell the target word.
class SpellingTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onIncorrect;

  const SpellingTaskWidget({
    super.key,
    required this.task,
    required this.onComplete,
    this.onIncorrect,
  });

  @override
  ConsumerState<SpellingTaskWidget> createState() => _SpellingTaskWidgetState();
}

class _SpellingTaskWidgetState extends ConsumerState<SpellingTaskWidget>
    with SingleTickerProviderStateMixin {
  late List<_Tile> _bankTiles;
  final List<_Tile> _builtTiles = [];
  bool? _lastCheckCorrect;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    super.initState();
    final letterBank = List<String>.from(
      widget.task.content['letterBank'] as List,
    );
    _bankTiles = [
      for (int i = 0; i < letterBank.length; i++)
        _Tile(id: i, text: letterBank[i]),
    ]..shuffle(Random());

    // Auto-play the target word sound after a short delay
    final targetWord = widget.task.content['targetWord'] as String;
    Future.delayed(TaskConfig.autoPlayDelay, () {
      if (mounted) {
        ref.read(audioServiceProvider).speak(targetWord);
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _moveToBuilt(_Tile tile) {
    setState(() {
      _bankTiles.remove(tile);
      _builtTiles.add(tile);
      _lastCheckCorrect = null;
    });
  }

  void _moveToBank(_Tile tile) {
    setState(() {
      _builtTiles.remove(tile);
      _bankTiles.add(tile);
      _lastCheckCorrect = null;
    });
  }

  void _check() {
    final targetWord = widget.task.content['targetWord'] as String;
    final built = _builtTiles.map((t) => t.text).join();
    final isCorrect = built == targetWord;
    setState(() => _lastCheckCorrect = isCorrect);

    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 600), widget.onComplete);
    } else {
      HapticFeedback.heavyImpact();
      _shakeController.forward(from: 0.0);
      widget.onIncorrect?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final emoji = widget.task.content['emoji'] as String;
    final targetWord = widget.task.content['targetWord'] as String;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const TaskHeader(title: 'Spell the word'),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 140,
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 96)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TaskSpeakerButton(textToSpeak: targetWord),
                  const SizedBox(height: 16),

                  // Integrated Build Area + Preview
                  TaskInteractiveBuildArea<_Tile>(
                    onAccept: _moveToBuilt,
                    isCorrect: _lastCheckCorrect,
                    shakeController: _shakeController,
                    hintText: 'Drag letters here',
                    children: [
                      if (_builtTiles.isNotEmpty)
                        TaskBuiltTile(
                          text: _builtTiles.map((t) => t.text).join(),
                          fontSize: 36,
                          onTap: () => _moveToBank(_builtTiles.last),
                          color: _lastCheckCorrect == null
                              ? null
                              : (_lastCheckCorrect! ? Colors.green : Colors.red),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Letter bank
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: _bankTiles
                        .map(
                          (t) => TaskLetterBank(
                            text: t.text,
                            data: t,
                            onTap: () => _moveToBuilt(t),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          TaskCheckButton(onPressed: _builtTiles.isEmpty ? null : _check),
        ],
      ),
    );
  }
}

class _Tile {
  final int id;
  final String text;

  _Tile({required this.id, required this.text});
}
