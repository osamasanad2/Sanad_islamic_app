import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/shared_prefs_provider.dart';

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, Map<String, bool>>(
  NotificationSettingsNotifier.new,
);

class NotificationSettingsNotifier extends Notifier<Map<String, bool>> {
  static const _keys = [
    'prayer_times',
    'morning_azkar',
    'evening_azkar',
    'daily_reminder',
    'quran_reminder',
  ];

  @override
  Map<String, bool> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return {
      for (final key in _keys) key: prefs.getBool('notif_$key') ?? true,
    };
  }

  Future<void> toggle(String key, bool value) async {
    state = {...state, key: value};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_$key', value);
  }
}

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final settings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: Text(t.get('notification_settings')),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
              children: [
                _buildNotificationTile(
                  context,
                  icon: Icons.mosque,
                  title: t.get('prayer_times_notif'),
                  subtitle: t.get('prayer_times_desc'),
                  value: settings['prayer_times'] ?? true,
                  onChanged: (v) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggle('prayer_times', v),
                ),
                const Divider(height: 1, indent: 56),
                _buildNotificationTile(
                  context,
                  icon: Icons.wb_sunny,
                  title: t.get('morning_azkar'),
                  subtitle: t.get('morning_azkar_desc'),
                  value: settings['morning_azkar'] ?? true,
                  onChanged: (v) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggle('morning_azkar', v),
                ),
                const Divider(height: 1, indent: 56),
                _buildNotificationTile(
                  context,
                  icon: Icons.nights_stay,
                  title: t.get('evening_azkar'),
                  subtitle: t.get('evening_azkar_desc'),
                  value: settings['evening_azkar'] ?? true,
                  onChanged: (v) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggle('evening_azkar', v),
                ),
                const Divider(height: 1, indent: 56),
                _buildNotificationTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: t.get('daily_reminder'),
                  subtitle: t.get('daily_reminder_desc'),
                  value: settings['daily_reminder'] ?? true,
                  onChanged: (v) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggle('daily_reminder', v),
                ),
                const Divider(height: 1, indent: 56),
                _buildNotificationTile(
                  context,
                  icon: Icons.menu_book,
                  title: t.get('quran_reminder'),
                  subtitle: t.get('quran_reminder_desc'),
                  value: settings['quran_reminder'] ?? true,
                  onChanged: (v) => ref
                      .read(notificationSettingsProvider.notifier)
                      .toggle('quran_reminder', v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: context.appColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: context.appColors.textSecondary,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeTrackColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}
