import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import '../providers/shared_prefs_provider.dart';
import 'notification_service.dart';

class PrayerNotificationScheduler {
  final NotificationService _notificationService;
  final SharedPreferences _prefs;
  Timer? _checkTimer;
  bool _scheduled = false;

  PrayerNotificationScheduler(this._notificationService, this._prefs);

  Future<void> start(PrayerTimes prayerTimes) async {
    if (_scheduled) return;

    if (_prefs.getBool('notif_prayer_times') ?? true) {
      _notifyCurrentPrayer(prayerTimes);
    }

    _checkTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      if (_prefs.getBool('notif_prayer_times') ?? true) {
        _notifyCurrentPrayer(prayerTimes);
      }
    });

    _scheduled = true;
  }

  void _notifyCurrentPrayer(PrayerTimes times) {
    final prayers = {
      'الفجر': times.fajr,
      'الظهر': times.dhuhr,
      'العصر': times.asr,
      'المغرب': times.maghrib,
      'العشاء': times.isha,
    };

    final now = DateTime.now();

    for (final entry in prayers.entries) {
      final prayerTime = entry.value;

      if (prayerTime.isBefore(now) || prayerTime.difference(now).inMinutes > 1) {
        continue;
      }

      final timeStr =
          '${prayerTime.hour.toString().padLeft(2, '0')}:${prayerTime.minute.toString().padLeft(2, '0')}';

      _notificationService.showPrayerNotification(
        id: _prayerId(entry.key),
        prayerName: entry.key,
        time: timeStr,
      );
    }
  }

  int _prayerId(String name) {
    final ids = {
      'الفجر': 1001,
      'الظهر': 1002,
      'العصر': 1003,
      'المغرب': 1004,
      'العشاء': 1005,
    };
    return ids[name] ?? 1000;
  }

  Future<void> reschedule(PrayerTimes prayerTimes) async {
    _scheduled = false;
    if (_prefs.getBool('notif_prayer_times') ?? true) {
      await start(prayerTimes);
    }
  }

  Future<void> cancelAll() async {
    _scheduled = false;
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  void dispose() {
    _checkTimer?.cancel();
  }
}

final prayerNotificationSchedulerProvider = Provider<PrayerNotificationScheduler>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final prefs = ref.watch(sharedPrefsProvider);
  return PrayerNotificationScheduler(notificationService, prefs);
});
