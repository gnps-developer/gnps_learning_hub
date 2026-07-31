import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/debug_config.dart';
import '../config/ui_config.dart';
import '../config/ui_strings.dart';
import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';
import '../tools/content_debug_screen.dart';
import '../tools/tracing_checkpoint_recorder_screen.dart';
import '../widgets/celebration/achievement_celebration_overlay.dart';
import 'attributions_screen.dart';
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
        title: const Text(UIStrings.factoryResetTitle),
        content: const Text(UIStrings.factoryResetWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(UIStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text(UIStrings.resetEverything),
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
        const SnackBar(content: Text(UIStrings.markAllCompleteLabel)),
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
          const SnackBar(content: Text(UIStrings.incorrectCode)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(UIStrings.settingsTitle)),
      body: progressAsync.when(
        data: (progress) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.volume_up_outlined),
              title: const Text(UIStrings.soundLabel),
              value: progress.soundEnabled,
              onChanged: (value) {
                ref.read(progressProvider.notifier).updateSoundEnabled(value);
                if (value) SystemSound.play(SystemSoundType.click);
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.vibration),
              title: const Text(UIStrings.hapticsLabel),
              value: progress.hapticsEnabled,
              onChanged: (value) {
                ref.read(progressProvider.notifier).updateHapticsEnabled(value);
                if (value) HapticFeedback.heavyImpact();
              },
            ),
            const Divider(height: AppSpacing.xl),
            const _SectionHeader(UIStrings.themeColorLabel),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
            const Divider(height: AppSpacing.xl),
            const _SectionHeader(UIStrings.aboutLabel),
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
                          horizontal: AppSpacing.md,
                        ),
                        leading: const Icon(Icons.info_outline),
                        title: const Text(UIStrings.appVersionLabel),
                        trailing: Text(appVersion),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      leading: const Icon(Icons.menu_book_outlined),
                      title: const Text(UIStrings.contentVersionLabel),
                      trailing: Text(journeyVersion),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      leading: const Icon(Icons.school_outlined),
                      title: const Text(UIStrings.totalLessonsLabel),
                      trailing: Text(totalLessons),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      leading: const Icon(Icons.checklist_outlined),
                      title: const Text(UIStrings.totalTasksLabel),
                      trailing: Text(totalTasks),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      leading: const Icon(Icons.videogame_asset_outlined),
                      title: const Text(UIStrings.totalGamesLabel),
                      trailing: Text(totalGames),
                    ),
                    ListTile(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AttributionsScreen(),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      leading: const Icon(Icons.palette_outlined),
                      title: const Text(UIStrings.artworkAttributionsLabel),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: AppSpacing.xl),
            const _SectionHeader(UIStrings.contactSupport),
            ListTile(
              onTap: _contactSupport,
              leading: const Icon(Icons.email_outlined),
              title: const Text(UIStrings.contactSupport),
              subtitle: const Text(UIStrings.supportEmail),
              trailing: const Icon(Icons.open_in_new, size: 16),
            ),
            const Divider(height: AppSpacing.xl),
            const _SectionHeader(UIStrings.accountManagementLabel),
            _SettingsActionButton(
              onPressed: () => _confirmAndReset(context),
              icon: Icons.restart_alt,
              label: UIStrings.factoryResetLabel,
              isDestructive: true,
            ),
            if (kDebugMode || progress.isDeveloperModeEnabled) ...[
              const Divider(height: AppSpacing.xl),
              const _SectionHeader(UIStrings.debugToolsLabel),
              _SettingsActionButton(
                onPressed: () => _debugCompleteAllLessons(context),
                icon: Icons.done_all,
                label: UIStrings.markAllCompleteLabel,
              ),
              const SizedBox(height: AppSpacing.ms),
              _SettingsActionButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ContentDebugScreen()),
                ),
                icon: Icons.bug_report_outlined,
                label: UIStrings.contentDebugLabel,
              ),
              const SizedBox(height: AppSpacing.ms),
              _SettingsActionButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CheckpointRecorderScreen(),
                  ),
                ),
                icon: Icons.edit_road,
                label: UIStrings.tracingRecorderLabel,
              ),
              const SizedBox(height: AppSpacing.ms),
              _SettingsActionButton(
                onPressed: () => _testAchievementCelebration(context),
                icon: Icons.celebration_outlined,
                label: UIStrings.testCelebrationLabel,
              ),
              if (progress.isDeveloperModeEnabled) ...[
                const SizedBox(height: AppSpacing.ms),
                _SettingsActionButton(
                  onPressed: () => ref
                      .read(progressProvider.notifier)
                      .updateDeveloperMode(false),
                  icon: Icons.no_accounts,
                  label: UIStrings.disableDevModeLabel,
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
          content: Text(UIStrings.devModeSteps(remaining)),
        ),
      );
    } else if (remaining <= 0) {
      _tapCount = 0;
      _showUnlockDialog();
    }
  }

  Future<void> _showUnlockDialog() async {
    final controller = TextEditingController();
    bool isObscured = true;
    String? errorMessage;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          void submit() {
            final input = controller.text.trim();
            final bytes = utf8.encode(input);
            final digest = sha256.convert(bytes);
            final hex = digest.toString().toLowerCase();
            final expected = DebugConfig.developerModeUnlockHash.toLowerCase();

            if (hex == expected) {
              Navigator.of(context).pop(true);
            } else {
              setDialogState(() {
                errorMessage = UIStrings.incorrectCode;
              });
            }
          }

          return AlertDialog(
            title: const Text(UIStrings.unlockDevModeTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  obscureText: isObscured,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => submit(),
                  decoration: InputDecoration(
                    labelText: UIStrings.enterSecretCode,
                    border: const OutlineInputBorder(),
                    errorText: errorMessage,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          isObscured = !isObscured;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(UIStrings.cancel),
              ),
              TextButton(
                onPressed: submit,
                child: const Text(UIStrings.unlock),
              ),
            ],
          );
        },
      ),
    );

    if (result == true) {
      await ref.read(progressProvider.notifier).updateDeveloperMode(true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(UIStrings.devModeUnlocked)),
        );
      }
    }
  }

  void _testAchievementCelebration(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Test Trophy Type'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showCelebration(1);
            },
            child: const Text('Bronze (Easy)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showCelebration(2);
            },
            child: const Text('Silver (Medium)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showCelebration(3);
            },
            child: const Text('Gold (Hard)'),
          ),
        ],
      ),
    );
  }

  void _showCelebration(int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Test Celebration',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, _, _) => AchievementCelebrationOverlay(
        gameTitle: 'Test Game',
        difficultyIndex: index,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
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
