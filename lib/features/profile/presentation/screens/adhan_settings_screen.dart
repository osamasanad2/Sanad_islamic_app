import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/adhan_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/shared_prefs_provider.dart';

class AdhanSettingsScreen extends ConsumerWidget {
  const AdhanSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adhanService = ref.watch(adhanServiceProvider);
    final availableSounds = adhanService.availableAdhanSounds;
    final prefs = ref.watch(sharedPrefsProvider);
    final currentSound = prefs.getString('adhan_sound') ?? 'default';

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('إعدادات الأذان'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Text(
                    'اختيار صوت الأذان',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ),
                ...availableSounds.entries.map((entry) {
                  return ListTile(
                    leading: Radio<String>(
                      value: entry.key,
                      groupValue: currentSound,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        if (value != null) {
                          adhanService.setAdhanSound(value);
                          prefs.setString('adhan_sound', value);
                        }
                      },
                    ),
                    title: Text(entry.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_circle_outline),
                      color: AppColors.primary,
                      onPressed: () => adhanService.playAdhanPreview(entry.key),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
