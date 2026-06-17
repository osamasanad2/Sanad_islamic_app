import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/shared_prefs_provider.dart';
import 'notification_service.dart';

class AzkarNotificationService {
  final NotificationService _notificationService;
  final SharedPreferences _prefs;
  Timer? _morningTimer;
  Timer? _eveningTimer;

  AzkarNotificationService(this._notificationService, this._prefs);

  Future<void> start() async {
    _scheduleMorningAzkar();
    _scheduleEveningAzkar();
  }

  void _scheduleMorningAzkar() {
    _morningTimer?.cancel();

    if (!(_prefs.getBool('notif_morning_azkar') ?? true)) return;

    final now = DateTime.now();
    final morningTime = DateTime(now.year, now.month, now.day, 6, 0);
    final delay = morningTime.isAfter(now)
        ? morningTime.difference(now)
        : const Duration(minutes: 1);

    _morningTimer = Timer(delay, () {
      _notificationService.showAzkarReminder(
        id: 2001,
        title: 'أذكار الصباح',
        body: '🌅 حان وقت أذكار الصباح - ابدأ يومك بذكر الله',
      );

      _morningTimer = Timer.periodic(const Duration(hours: 24), (_) {
        _notificationService.showAzkarReminder(
          id: 2001,
          title: 'أذكار الصباح',
          body: '🌅 حان وقت أذكار الصباح - ابدأ يومك بذكر الله',
        );
      });
    });
  }

  void _scheduleEveningAzkar() {
    _eveningTimer?.cancel();

    if (!(_prefs.getBool('notif_evening_azkar') ?? true)) return;

    final now = DateTime.now();
    final eveningTime = DateTime(now.year, now.month, now.day, 17, 30);
    final delay = eveningTime.isAfter(now)
        ? eveningTime.difference(now)
        : const Duration(minutes: 1);

    _eveningTimer = Timer(delay, () {
      _notificationService.showAzkarReminder(
        id: 2002,
        title: 'أذكار المساء',
        body: '🌆 حان وقت أذكار المساء - احتمِ بذكر الله',
      );

      _eveningTimer = Timer.periodic(const Duration(hours: 24), (_) {
        _notificationService.showAzkarReminder(
          id: 2002,
          title: 'أذكار المساء',
          body: '🌆 حان وقت أذكار المساء - احتمِ بذكر الله',
        );
      });
    });
  }

  Future<void> cancelAll() async {
    _morningTimer?.cancel();
    _eveningTimer?.cancel();
  }

  void dispose() {
    _morningTimer?.cancel();
    _eveningTimer?.cancel();
  }
}

final azkarNotificationServiceProvider = Provider<AzkarNotificationService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final prefs = ref.watch(sharedPrefsProvider);
  return AzkarNotificationService(notificationService, prefs);
});
