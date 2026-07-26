import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';

class ContentDebugScreen extends ConsumerWidget {
  const ContentDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyAsync = ref.watch(journeyProvider);
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Content Debug Tool')),
      body: journeyAsync.when(
        data: (journey) => progressAsync.when(
          data: (progress) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: journey.lessons.length,
            itemBuilder: (context, index) {
              final lesson = journey.lessons[index];
              final isCompleted = progress.completedLessonIds.contains(lesson.id);
              final isUnlocked = progress.unlockedLessonIds.contains(lesson.id);
              final completedSections = lesson.sections
                  .where((s) => progress.completedSectionIds.contains(s.id))
                  .length;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lesson.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _StatusBadge(
                            isCompleted: isCompleted,
                            isUnlocked: isUnlocked,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sections: $completedSections / ${lesson.sections.length}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Row(
                            children: [
                              _ShuffleIndicator(
                                icon: Icons.low_priority,
                                enabled: lesson.shuffleSections,
                                tooltip: 'Shuffles Chapters',
                              ),
                              const SizedBox(width: 8),
                              _ShuffleIndicator(
                                icon: Icons.shuffle,
                                enabled: lesson.shuffleTasks,
                                tooltip: 'Shuffles Tasks',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _DebugButton(
                            label: 'Reset',
                            color: Colors.grey,
                            onPressed: () => ref
                                .read(progressProvider.notifier)
                                .debugUpdateLessonProgress(
                                  journey: journey,
                                  lessonId: lesson.id,
                                  percent: 0.0,
                                ),
                          ),
                          _DebugButton(
                            label: '50%',
                            color: Colors.blue,
                            onPressed: () => ref
                                .read(progressProvider.notifier)
                                .debugUpdateLessonProgress(
                                  journey: journey,
                                  lessonId: lesson.id,
                                  percent: 0.5,
                                ),
                          ),
                          _DebugButton(
                            label: 'Complete',
                            color: Colors.green,
                            onPressed: () => ref
                                .read(progressProvider.notifier)
                                .debugUpdateLessonProgress(
                                  journey: journey,
                                  lessonId: lesson.id,
                                  percent: 1.0,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading progress: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading journey: $e')),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isCompleted;
  final bool isUnlocked;

  const _StatusBadge({required this.isCompleted, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    if (isCompleted) {
      color = Colors.amber.shade700;
      label = 'COMPLETED';
    } else if (isUnlocked) {
      color = Colors.green;
      label = 'UNLOCKED';
    } else {
      color = Colors.grey;
      label = 'LOCKED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ShuffleIndicator extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final String tooltip;

  const _ShuffleIndicator({
    required this.icon,
    required this.enabled,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '$tooltip: ${enabled ? 'ON' : 'OFF'}',
      child: Icon(
        icon,
        size: 18,
        color: enabled ? Colors.deepPurple : Colors.grey.shade300,
      ),
    );
  }
}

class _DebugButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _DebugButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(80, 36),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
