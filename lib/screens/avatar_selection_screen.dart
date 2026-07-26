import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/shop_item.dart';
import '../providers/progress_providers.dart';
import '../providers/shop_providers.dart';
import 'journey_screen.dart';

class AvatarSelectionScreen extends ConsumerStatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  ConsumerState<AvatarSelectionScreen> createState() =>
      _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends ConsumerState<AvatarSelectionScreen> {
  String? _selectedId;
  bool _saving = false;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _selectedId != null && _nameController.text.trim().isNotEmpty && !_saving;

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(shopCatalogProvider);
    final baseAvatars = catalog
        .where((i) => i.avatarSlot == AvatarSlot.base)
        .toList();
    final typedName = _nameController.text.trim();

    return Scaffold(
      appBar: AppBar(title: const Text('Choose your avatar')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What should we call you?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              maxLength: 20,
              decoration: const InputDecoration(
                hintText: 'Your name',
                border: OutlineInputBorder(),
                counterText: "",
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text(
              'Pick who\'ll join you on this journey',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: baseAvatars.map((avatar) {
                  final selected = _selectedId == avatar.id;
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => setState(() => _selectedId = avatar.id),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                          width: selected ? 3 : 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: avatar.imageAssetPath != null
                          ? SvgPicture.asset(
                              avatar.imageAssetPath!,
                              fit: BoxFit.contain,
                            )
                          : Icon(avatar.icon, size: 64, color: avatar.color),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: !_canContinue
                  ? null
                  : () async {
                      setState(() => _saving = true);
                      final avatar = baseAvatars.firstWhere(
                        (a) => a.id == _selectedId,
                      );
                      final notifier = ref.read(progressProvider.notifier);
                      await notifier.updateUserName(typedName);
                      await notifier.equipItem(avatar);
                      await notifier.completeOnboarding();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const JourneyScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Continue'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
