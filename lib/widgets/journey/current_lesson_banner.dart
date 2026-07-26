import 'package:flutter/material.dart';

import '../../config/reward_config.dart';
import '../../config/ui_strings.dart';

class CurrentLessonBanner extends StatelessWidget {
  final String lessonTitle;
  final String? sectionTitle;
  final int taskIndex;
  final int totalTasks;
  final int streak;
  final int points;
  final VoidCallback onBack;
  final GlobalKey? iconKey;

  const CurrentLessonBanner({
    super.key,
    required this.lessonTitle,
    this.sectionTitle,
    required this.taskIndex,
    required this.totalTasks,
    required this.streak,
    required this.points,
    required this.onBack,
    this.iconKey,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progressFraction = totalTasks == 0 ? 0.0 : (taskIndex) / totalTasks;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: scheme.onPrimary),
                onPressed: onBack,
              ),
              const Spacer(),
              _StatChip(
                icon: Icons.local_fire_department,
                color: Colors.orangeAccent,
                value: '$streak',
              ),
              const SizedBox(width: 8),
              _PointsChip(chipKey: iconKey, value: points),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lessonTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (sectionTitle != null)
                  Text(
                    sectionTitle!,
                    style: TextStyle(
                      color: scheme.onPrimary.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressFraction,
                    minHeight: 8,
                    backgroundColor: scheme.onPrimary.withValues(alpha: 0.25),
                    valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${UIStrings.taskLabel} ${taskIndex + 1} ${UIStrings.ofLabel} $totalTasks',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;

  const _StatChip({
    required this.icon,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// The points/reward chip. Split out from _StatChip because it needs an
/// attachable [chipKey] (the burst animation's landing target) and a
/// smooth count-up when [value] changes rather than jumping straight to
/// the new number — TweenAnimationBuilder animates from whatever's
/// currently on screen to the new end value automatically.
class _PointsChip extends StatelessWidget {
  final GlobalKey? chipKey;
  final int value;

  const _PointsChip({this.chipKey, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: chipKey,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(RewardConfig.icon, color: RewardConfig.color, size: 20),
          const SizedBox(width: 6),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: value.toDouble()),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, child) => Text(
              '${animatedValue.round()}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
