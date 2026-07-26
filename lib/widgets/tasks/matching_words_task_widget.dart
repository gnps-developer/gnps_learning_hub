import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../../providers/audio_providers.dart';
import '../common/task_header.dart';

class MatchingWordsTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onIncorrect;

  const MatchingWordsTaskWidget({
    super.key,
    required this.task,
    required this.onComplete,
    this.onIncorrect,
  });

  @override
  ConsumerState<MatchingWordsTaskWidget> createState() =>
      _MatchingWordsTaskWidgetState();
}

class _MatchingWordsTaskWidgetState extends ConsumerState<MatchingWordsTaskWidget> {
  late final List<String> _gurmukhiWords;
  late final List<String> _englishWords;
  final Set<String> _completedGurmukhi = {};
  final Set<String> _completedEnglish = {};

  @override
  void initState() {
    super.initState();
    final pairs = widget.task.content['pairs'] as Map<String, dynamic>;
    _gurmukhiWords = pairs.keys.toList()..shuffle(Random());
    _englishWords = pairs.values.map((e) => e.toString()).toList()..shuffle(Random());
  }

  void _onMatch(String gurmukhi, String english) {
    final pairs = widget.task.content['pairs'] as Map<String, dynamic>;
    if (pairs[gurmukhi] == english) {
      setState(() {
        _completedGurmukhi.add(gurmukhi);
        _completedEnglish.add(english);
      });
      ref.read(audioServiceProvider).playSuccess();
      
      if (_completedGurmukhi.length == _gurmukhiWords.length) {
        Future.delayed(const Duration(milliseconds: 600), widget.onComplete);
      }
    } else {
      HapticFeedback.heavyImpact();
      ref.read(audioServiceProvider).playFailure();
      widget.onIncorrect?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const TaskHeader(title: 'Match Gurmukhi words to English'),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                // Gurmukhi words (Left)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _gurmukhiWords.map((word) {
                      final isCompleted = _completedGurmukhi.contains(word);
                      return Opacity(
                        opacity: isCompleted ? 0.5 : 1.0,
                        child: Draggable<String>(
                          data: word,
                          feedback: _WordTile(word: word, isFeedback: true),
                          childWhenDragging: _WordTile(word: word, isDragging: true),
                          maxSimultaneousDrags: isCompleted ? 0 : 1,
                          child: GestureDetector(
                            onTap: () => ref.read(audioServiceProvider).speak(word),
                            child: _WordTile(word: word),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 32),
                // English words (Right)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _englishWords.map((word) {
                      final isCompleted = _completedEnglish.contains(word);
                      return DragTarget<String>(
                        onWillAcceptWithDetails: (details) => !isCompleted,
                        onAcceptWithDetails: (details) => _onMatch(details.data, word),
                        builder: (context, candidateData, rejectedData) {
                          final isOver = candidateData.isNotEmpty;
                          return _WordTile(
                            word: word,
                            isEnglish: true,
                            isCompleted: isCompleted,
                            isTargeted: isOver,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WordTile extends StatelessWidget {
  final String word;
  final bool isEnglish;
  final bool isCompleted;
  final bool isTargeted;
  final bool isDragging;
  final bool isFeedback;

  const _WordTile({
    required this.word,
    this.isEnglish = false,
    this.isCompleted = false,
    this.isTargeted = false,
    this.isDragging = false,
    this.isFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    Color backgroundColor = isEnglish 
        ? scheme.secondaryContainer 
        : scheme.primaryContainer;
    
    if (isCompleted) backgroundColor = Colors.green.shade100;
    if (isTargeted) backgroundColor = scheme.tertiaryContainer;
    if (isDragging) backgroundColor = backgroundColor.withValues(alpha: 0.3);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: isFeedback ? 140 : double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted ? Colors.green : (isTargeted ? scheme.tertiary : scheme.outlineVariant),
            width: isTargeted ? 3 : 1,
          ),
          boxShadow: isFeedback ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            word,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isEnglish ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: isCompleted ? Colors.green.shade900 : (isEnglish ? scheme.onSecondaryContainer : scheme.onPrimaryContainer),
            ),
          ),
        ),
      ),
    );
  }
}
