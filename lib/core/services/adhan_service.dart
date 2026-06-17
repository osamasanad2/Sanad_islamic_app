import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import '../providers/shared_prefs_provider.dart';
import 'audio_service.dart';

class AdhanService {
  final AudioService _audioService;
  final SharedPreferences _prefs;
  Timer? _checkTimer;
  DateTime? _lastPlayedDate;
  String? _lastPrayerPlayed;
  bool _isPlayingAdhan = false;

  AdhanService(this._audioService, this._prefs);

  static const _adhanUrls = {
    'default': 'https://www.islamcan.com/audio/adhan/azan1.mp3',
    'makkah': 'https://www.islamcan.com/audio/adhan/azan2.mp3',
    'madinah': 'https://www.islamcan.com/audio/adhan/azan3.mp3',
    'mishary': 'https://server8.mp3quran.net/afasy/Adhan.mp3',
  };

  Map<String, String> get availableAdhanSounds => Map.unmodifiable(_adhanUrls);

  Future<void> startChecking(PrayerTimes prayerTimes) async {
    _checkTimer?.cancel();

    _checkTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkAndPlayAdhan(prayerTimes);
    });

    _checkAndPlayAdhan(prayerTimes);
  }

  Future<void> _checkAndPlayAdhan(PrayerTimes times) async {
    if (!(_prefs.getBool('notif_prayer_times') ?? true)) return;
    if (_isPlayingAdhan) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final prayers = {
      'الفجر': times.fajr,
      'الظهر': times.dhuhr,
      'العصر': times.asr,
      'المغرب': times.maghrib,
      'العشاء': times.isha,
    };

    for (final entry in prayers.entries) {
      final prayerTime = entry.value;
      if (_lastPlayedDate == today && _lastPrayerPlayed == entry.key) continue;

      final diff = now.difference(prayerTime).inSeconds.abs();
      if (diff <= 30) {
        _isPlayingAdhan = true;
        _lastPlayedDate = today;
        _lastPrayerPlayed = entry.key;

        final adhanUrl = _prefs.getString('adhan_sound') ?? 'default';
        final url = _adhanUrls[adhanUrl] ?? _adhanUrls['default']!;

        await _audioService.play(url, title: 'أذان $entry.key');

        Future.delayed(const Duration(seconds: 30), () {
          _isPlayingAdhan = false;
        });

        break;
      }
    }
  }

  Future<void> playAdhanPreview(String key) async {
    final url = _adhanUrls[key] ?? _adhanUrls['default']!;
    await _audioService.play(url, title: 'أذان');
    Future.delayed(const Duration(seconds: 10), () {
      _audioService.stop();
    });
  }

  Future<void> setAdhanSound(String key) async {
    await _prefs.setString('adhan_sound', key);
  }

  Future<void> stop() async {
    _isPlayingAdhan = false;
    await _audioService.stop();
  }

  void dispose() {
    _checkTimer?.cancel();
  }
}

final adhanServiceProvider = Provider<AdhanService>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  final prefs = ref.watch(sharedPrefsProvider);
  return AdhanService(audioService, prefs);
});
