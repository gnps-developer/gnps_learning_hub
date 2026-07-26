import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/debug_config.dart';
import '../config/ui_strings.dart';
import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';
import '../tools/content_debug_screen.dart';
import '../tools/tracing_checkpoint_recorder_screen.dart';
import 'intro_screen.dart';

const List<Color> _themeColorOptions = [
  Colors.blue,
  Colors.purple,
  Colors.pink,
  Colors.red,
  Colors.orange,
  Colors.amber,
  Colors.green,
  Colors.teal,
  Colors.indigo,
];

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _tapCount = 0;

  Future<void> _confirmAndReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Factory Reset?'),
        content: const Text(
          'This clears all points, streaks, and lesson progress, and reloads '
          'lesson content fresh. This can\'t be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(progressProvider.notifier).reset();
    await ref.read(contentRepositoryProvider).clearCache();

    // Fetch fresh content directly from the repository.
    final journey = await ref
        .read(contentRepositoryProvider)
        .checkForUpdatesAndSync();

    ref.invalidate(journeySyncProvider);

    await ref
        .read(progressProvider.notifier)
        .ensureFirstLessonUnlocked(journey);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const IntroScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _debugCompleteAllLessons(BuildContext context) async {
    final journey =
        ref.read(journeyProvider).value ??
        await ref.read(contentRepositoryProvider).getLocalJourney();

    await ref.read(progressProvider.notifier).debugCompleteAllLessons(journey);

    if (context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(content: Text('All lessons marked complete (debug).')),
      );
    }
  }

  Future<void> _contactSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: UIStrings.supportEmail,
      query: 'subject=Support Request: GNPS Learning Hub',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: progressAsync.when(
        data: (progress) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.volume_up_outlined),
              title: const Text('Sound'),
              value: progress.soundEnabled,
              onChanged: (value) {
                ref.read(progressProvider.notifier).updateSoundEnabled(value);
                if (value) SystemSound.play(SystemSoundType.click);
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.vibration),
              title: const Text('Haptic feedback'),
              value: progress.hapticsEnabled,
              onChanged: (value) {
                ref.read(progressProvider.notifier).updateHapticsEnabled(value);
                if (value) HapticFeedback.heavyImpact();
              },
            ),
            const Divider(height: 32),
            const _SectionHeader('Theme color'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _themeColorOptions.map((color) {
                  final isSelected =
                      progress.themeSeedColor == color.toARGB32();
                  return GestureDetector(
                    onTap: () => ref
                        .read(progressProvider.notifier)
                        .updateThemeSeedColor(color.toARGB32()),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 3,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 32),
            const _SectionHeader('About'),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final appVersion = snapshot.hasData
                    ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                    : '—';

                final journeyAsync = ref.watch(journeyProvider);
                final journeyVersion = journeyAsync.maybeWhen(
                  data: (j) => '${j.version}',
                  orElse: () => '—',
                );
                final totalLessons = journeyAsync.maybeWhen(
                  data: (j) => '${j.activeLessons.length}',
                  orElse: () => '—',
                );
                final totalTasks = journeyAsync.maybeWhen(
                  data: (j) =>
                      '${j.activeLessons.fold<int>(0, (sum, lesson) => sum + lesson.allTasks.length)}',
                  orElse: () => '—',
                );
                final totalGames = journeyAsync.maybeWhen(
                  data: (j) => '${j.games.length}',
                  orElse: () => '—',
                );

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _handleVersionTap(progress.isDeveloperModeEnabled),
                      behavior: HitTestBehavior.opaque,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        leading: const Icon(Icons.info_outline),
                        title: const Text('App version'),
                        trailing: Text(appVersion),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: const Icon(Icons.menu_book_outlined),
                      title: const Text('Lesson content version'),
                      trailing: Text(journeyVersion),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: const Icon(Icons.school_outlined),
                      title: const Text('Total lessons'),
                      trailing: Text(totalLessons),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: const Icon(Icons.checklist_outlined),
                      title: const Text('Total interactive tasks'),
                      trailing: Text(totalTasks),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: const Icon(Icons.videogame_asset_outlined),
                      title: const Text('Total games'),
                      trailing: Text(totalGames),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 32),
            const _SectionHeader('Support'),
            ListTile(
              onTap: _contactSupport,
              leading: const Icon(Icons.email_outlined),
              title: const Text('Contact Support'),
              subtitle: const Text(UIStrings.supportEmail),
              trailing: const Icon(Icons.open_in_new, size: 16),
            ),
            const Divider(height: 32),
            const _SectionHeader('Account management'),
            _SettingsActionButton(
              onPressed: () => _confirmAndReset(context),
              icon: Icons.restart_alt,
              label: 'Factory Reset',
              isDestructive: true,
            ),
            if (kDebugMode || progress.isDeveloperModeEnabled) ...[
              const Divider(height: 32),
              const _SectionHeader('Debug Tools'),
              _SettingsActionButton(
                onPressed: () => _debugCompleteAllLessons(context),
                icon: Icons.done_all,
                label: 'Mark All Lessons Complete',
              ),
              const SizedBox(height: 12),
              _SettingsActionButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ContentDebugScreen()),
                ),
                icon: Icons.bug_report_outlined,
                label: 'Content Progress Debug',
              ),
              const SizedBox(height: 12),
              _SettingsActionButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CheckpointRecorderScreen(),
                  ),
                ),
                icon: Icons.edit_road,
                label: 'Tracing Checkpoint Recorder',
              ),
              if (progress.isDeveloperModeEnabled) ...[
                const SizedBox(height: 12),
                _SettingsActionButton(
                  onPressed: () => ref
                      .read(progressProvider.notifier)
                      .updateDeveloperMode(false),
                  icon: Icons.no_accounts,
                  label: 'Disable Developer Mode',
                  isDestructive: true,
                ),
              ],
            ],
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading settings: $e')),
      ),
    );
  }

  void _handleVersionTap(bool isAlreadyEnabled) {
    if (isAlreadyEnabled) return;

    setState(() => _tapCount++);

    final remaining = DebugConfig.developerModeTapCount - _tapCount;
    if (remaining > 0 && remaining <= 3) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text('You are $remaining steps away from developer mode.'),
        ),
      );
    } else if (remaining <= 0) {
      _tapCount = 0;
      _showUnlockDialog();
    }
  }

  Future<void> _showUnlockDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlock Developer Mode'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Enter secret code',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final bytes = utf8.encode(controller.text);
              final digest = sha256.convert(bytes);
              if (digest.toString() == DebugConfig.developerModeUnlockHash) {
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect code.')),
                );
              }
            },
            child: const Text('Unlock'),
          ),
        ],
      ),
    );

    if (result == true) {
      await ref.read(progressProvider.notifier).updateDeveloperMode(true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Developer mode unlocked!')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SettingsActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isDestructive;

  const _SettingsActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: color != null ? BorderSide(color: color) : null,
          minimumSize: const Size(double.infinity, 52),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
