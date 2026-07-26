import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/progress.dart';
import '../providers/progress_providers.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// Derives which calendar days belong to the user's *current* streak.
///
/// [LocalProgress] only stores a running count (`currentStreak`) and the
/// most recent active day (`lastActiveDate`) — not a full history of every
/// day ever played. That's enough to reconstruct the current streak (it's
/// just `currentStreak` consecutive days ending on `lastActiveDate`, since
/// the counter resets to 0 rather than preserving history on a break), but
/// it means days from a *previous, already-broken* streak can't be shown —
/// that data simply doesn't exist in the model.
Set<DateTime> _currentStreakDays(LocalProgress progress) {
  final last = progress.lastActiveDate;
  if (last == null || progress.currentStreak <= 0) return {};
  final lastDay = DateTime(last.year, last.month, last.day);
  return {
    for (var i = 0; i < progress.currentStreak; i++)
      lastDay.subtract(Duration(days: i)),
  };
}

class StreakScreen extends ConsumerStatefulWidget {
  const StreakScreen({super.key});

  @override
  ConsumerState<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends ConsumerState<StreakScreen> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month);
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _displayedMonth.year == now.year &&
        _displayedMonth.month == now.month;
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    if (_isCurrentMonth) return; // can't navigate into the future
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Streak')),
      body: SafeArea(
        child: progressAsync.when(
          data: (progress) => _StreakContent(
            progress: progress,
            displayedMonth: _displayedMonth,
            isCurrentMonth: _isCurrentMonth,
            onPreviousMonth: _goToPreviousMonth,
            onNextMonth: _goToNextMonth,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              const Center(child: Text('Could not load streak data.')),
        ),
      ),
    );
  }
}

class _StreakContent extends StatelessWidget {
  final LocalProgress progress;
  final DateTime displayedMonth;
  final bool isCurrentMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _StreakContent({
    required this.progress,
    required this.displayedMonth,
    required this.isCurrentMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final streakDays = _currentStreakDays(progress);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          _StreakCounter(streak: progress.currentStreak),
          const SizedBox(height: 28),
          _MonthHeader(
            displayedMonth: displayedMonth,
            isCurrentMonth: isCurrentMonth,
            onPreviousMonth: onPreviousMonth,
            onNextMonth: onNextMonth,
          ),
          const SizedBox(height: 12),
          _WeekdayHeaderRow(),
          const SizedBox(height: 4),
          _CalendarGrid(displayedMonth: displayedMonth, streakDays: streakDays),
        ],
      ),
    );
  }
}

class _StreakCounter extends StatelessWidget {
  final int streak;

  const _StreakCounter({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.local_fire_department, color: Colors.orange, size: 72),
        const SizedBox(height: 8),
        Text(
          '$streak',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade800,
          ),
        ),
        Text(
          streak == 1 ? 'day streak' : 'day streak',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final DateTime displayedMonth;
  final bool isCurrentMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _MonthHeader({
    required this.displayedMonth,
    required this.isCurrentMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          '${_monthNames[displayedMonth.month - 1]} ${displayedMonth.year}',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          // Disabled rather than hidden, so the header doesn't jump.
          onPressed: isCurrentMonth ? null : onNextMonth,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _WeekdayHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: Colors.grey.shade500,
      fontWeight: FontWeight.w600,
    );
    return Row(
      children: [
        for (final label in _weekdayLabels)
          Expanded(
            child: Center(child: Text(label, style: style)),
          ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime displayedMonth;
  final Set<DateTime> streakDays;

  const _CalendarGrid({required this.displayedMonth, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      displayedMonth.year,
      displayedMonth.month,
    );
    final firstOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    // weekday: Mon=1..Sun=7; grid starts on Monday, so leading blanks = weekday-1.
    final leadingBlanks = firstOfMonth.weekday - 1;
    final today = DateTime.now();

    final cells = <Widget>[
      for (var i = 0; i < leadingBlanks; i++) const SizedBox.shrink(),
      for (var day = 1; day <= daysInMonth; day++)
        _DayCell(
          date: DateTime(displayedMonth.year, displayedMonth.month, day),
          isStreakDay: streakDays.contains(
            DateTime(displayedMonth.year, displayedMonth.month, day),
          ),
          isToday: DateUtils.isSameDay(
            DateTime(displayedMonth.year, displayedMonth.month, day),
            today,
          ),
        ),
    ];

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cells,
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isStreakDay;
  final bool isToday;

  const _DayCell({
    required this.date,
    required this.isStreakDay,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isStreakDay ? Colors.orange.withValues(alpha: 0.12) : null,
            border: isToday
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: isStreakDay
                ? const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 22,
                  )
                : Text(
                    '${date.day}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
