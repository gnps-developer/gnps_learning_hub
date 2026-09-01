import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';
import 'crossword_debug_screen.dart';

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
          data: (progress) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionHeader('Progress Shortcuts'),
              const SizedBox(height: 8),
              _DebugActionGrid(
                children: [
                  _DebugButton(
                    label: 'Unlock All Lessons',
                    icon: Icons.lock_open,
                    color: Colors.blue.shade700,
                    onPressed: () async {
                      await ref.read(progressProvider.notifier).debugUnlockAllLessons(journey);
                      if (context.mounted) _showSnack(context, 'All lessons unlocked!');
                    },
                  ),
                  _DebugButton(
                    label: 'Complete All Lessons',
                    icon: Icons.done_all,
                    color: Colors.green.shade700,
                    onPressed: () async {
                      await ref.read(progressProvider.notifier).debugCompleteAllLessons(journey);
                      if (context.mounted) _showSnack(context, 'All lessons marked complete!');
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const _SectionHeader('Game Management'),
              const SizedBox(height: 8),
              _DebugActionGrid(
                children: [
                  _DebugButton(
                    label: 'Unlock All Trophies',
                    icon: Icons.emoji_events,
                    color: Colors.orange.shade800,
                    onPressed: () async {
                      await ref.read(progressProvider.notifier).debugCompleteAllAchievements();
                      if (context.mounted) _showSnack(context, 'All game trophies unlocked!');
                    },
                  ),
                  _DebugButton(
                    label: 'Reset Crossword',
                    icon: Icons.refresh,
                    color: Colors.red.shade700,
                    onPressed: () async {
                      await ref.read(progressProvider.notifier).debugResetCrosswordProgress();
                      if (context.mounted) _showSnack(context, 'Crossword progress reset!');
                    },
                  ),
                  _DebugButton(
                    label: 'Inspect Layouts',
                    icon: Icons.grid_on,
                    color: Colors.purple.shade700,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CrosswordDebugScreen()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const _SectionHeader('Individual Lessons'),
              const SizedBox(height: 12),
              ...journey.lessons.map((lesson) {


                final isCompleted =
                    progress.completedLessonIds.contains(lesson.id);
                final isUnlocked =
                    progress.unlockedLessonIds.contains(lesson.id);
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
              }),
              const SizedBox(height: 40),
            ],
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

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
        letterSpacing: 1.2,
      ),
    );
  }
}

class _DebugActionGrid extends StatelessWidget {
  final List<Widget> children;
  const _DebugActionGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.8,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: children,
    );
  }
}

class _DebugButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback onPressed;

  const _DebugButton({
    required this.label,
    this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        backgroundColor: color.withValues(alpha: 0.05),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

