import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/shared_prefs_provider.dart';

// SharedPreferences keys for location caching
const String _kLatitude = 'prayer_latitude';
const String _kLongitude = 'prayer_longitude';
const String _kCity = 'prayer_city';
const String _kLastLocationUpdate = 'prayer_last_location_update';
const String _kLastPrayerCalcDate = 'prayer_last_calc_date';
const Duration _kLocationExpiry = Duration(days: 30);

// 1. Data model for Prayer State
class PrayerState {
  final bool isLoading;
  final String? error;
  final PrayerTimes? prayerTimes;
  final Prayer? nextPrayer;
  final Duration? timeUntilNextPrayer;
  final String hijriDate;
  final String locationName;

  PrayerState({
    this.isLoading = true,
    this.error,
    this.prayerTimes,
    this.nextPrayer,
    this.timeUntilNextPrayer,
    this.hijriDate = '',
    this.locationName = 'تحديد الموقع...',
  });

  PrayerState copyWith({
    bool? isLoading,
    String? error,
    PrayerTimes? prayerTimes,
    Prayer? nextPrayer,
    Duration? timeUntilNextPrayer,
    String? hijriDate,
    String? locationName,
  }) {
    return PrayerState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      timeUntilNextPrayer: timeUntilNextPrayer ?? this.timeUntilNextPrayer,
      hijriDate: hijriDate ?? this.hijriDate,
      locationName: locationName ?? this.locationName,
    );
  }
}

// 2. Provider Definition
final prayerProvider = NotifierProvider<PrayerNotifier, PrayerState>(
  PrayerNotifier.new,
);

// 3. Notifier Logic
class PrayerNotifier extends Notifier<PrayerState> {
  Timer? _timer;

  @override
  PrayerState build() {
    final hijriDate = _initHijri();
    final initialState = PrayerState(hijriDate: hijriDate);
    state = initialState;

    _loadLocationAndPrayers();

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (state.prayerTimes != null) {
        _updateCountdown();
      }
    });

    ref.onDispose(() => _timer?.cancel());

    return state;
  }

  String _initHijri() {
    HijriCalendar.setLocal('ar');
    final today = HijriCalendar.now();
    return '${today.hDay} ${today.longMonthName} ${today.hYear} هـ';
  }

  Future<void> _loadLocationAndPrayers() async {
    final prefs = ref.read(sharedPrefsProvider);

    final cachedLat = prefs.getDouble(_kLatitude);
    final cachedLng = prefs.getDouble(_kLongitude);
    final cachedCity = prefs.getString(_kCity);
    final lastUpdate = prefs.getInt(_kLastLocationUpdate);

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final isExpired = lastUpdate == null ||
        (nowMs - lastUpdate) > _kLocationExpiry.inMilliseconds;
    final hasValidCache = cachedLat != null && cachedLng != null && !isExpired;

    // If we have a valid cached location, use it without GPS
    if (hasValidCache) {
      final success = _calculateFromCoords(cachedLat, cachedLng, cachedCity);
      if (success) return;
      // If calculation failed (corrupted data), fall through to GPS
    }

    // No valid cache — fetch from GPS
    await _fetchFromGps(prefs, cachedLat, cachedLng, cachedCity);
  }

  /// Calculate prayer times from coordinates (pure Dart, no I/O).
  /// Returns true on success, false on failure.
  bool _calculateFromCoords(double lat, double lng, String? city) {
    try {
      final coordinates = Coordinates(lat, lng);
      final params = CalculationMethod.umm_al_qura.getParameters();
      params.madhab = Madhab.shafi;
      final date = DateComponents.from(DateTime.now());
      final prayerTimes = PrayerTimes(coordinates, date, params);

      state = state.copyWith(
        isLoading: false,
        prayerTimes: prayerTimes,
        locationName: city ?? 'موقعي الحالي',
      );

      _updateCountdown();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Fetch location from GPS, save to cache, and calculate prayer times.
  /// [fallbackLat]/[fallbackLng]/[fallbackCity] are used if GPS fails.
  Future<void> _fetchFromGps(
    SharedPreferences prefs, [
    double? fallbackLat,
    double? fallbackLng,
    String? fallbackCity,
  ]) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('خدمات الموقع غير مفعلة.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('تم رفض صلاحية الموقع.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'صلاحية الموقع مرفوضة دائماً، يرجى تفعيلها من الإعدادات.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      // Save location to SharedPreferences cache
      const city = 'موقعي الحالي';
      await _saveLocationToPrefs(
        prefs,
        position.latitude,
        position.longitude,
        city,
      );

      // Calculate prayer times
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.umm_al_qura.getParameters();
      params.madhab = Madhab.shafi;
      final date = DateComponents.from(DateTime.now());
      final prayerTimes = PrayerTimes(coordinates, date, params);

      state = state.copyWith(
        isLoading: false,
        prayerTimes: prayerTimes,
        locationName: city,
      );

      await _savePrayerCalcDate(prefs);
      _updateCountdown();
    } catch (e) {
      // If GPS fails but we have fallback coordinates, use them
      if (fallbackLat != null && fallbackLng != null) {
        final used = _calculateFromCoords(fallbackLat, fallbackLng, fallbackCity);
        if (used) return;
      }
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Save location data to SharedPreferences cache
  Future<void> _saveLocationToPrefs(
    SharedPreferences prefs,
    double lat,
    double lng,
    String city,
  ) async {
    await prefs.setDouble(_kLatitude, lat);
    await prefs.setDouble(_kLongitude, lng);
    await prefs.setString(_kCity, city);
    await prefs.setInt(
      _kLastLocationUpdate,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Save today's date as the last prayer calculation date
  Future<void> _savePrayerCalcDate(SharedPreferences prefs) async {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await prefs.setString(_kLastPrayerCalcDate, dateStr);
  }

  /// Force a fresh GPS location fetch and recalculate prayer times.
  /// Call this from a "تحديث الموقع" (Refresh Location) button.
  Future<void> refreshLocation() async {
    final prefs = ref.read(sharedPrefsProvider);
    await _fetchFromGps(prefs);
  }

  void _updateCountdown() {
    if (state.prayerTimes == null) return;

    Prayer next = state.prayerTimes!.nextPrayer();
    DateTime nextTime =
        state.prayerTimes!.timeForPrayer(next) ?? DateTime.now();

    // If next prayer is none, it means it's after Isha, so we get Fajr of tomorrow
    if (next == Prayer.none) {
      next = Prayer.fajr;
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowParams = CalculationMethod.umm_al_qura.getParameters();
      final tomorrowTimes = PrayerTimes(
        state.prayerTimes!.coordinates,
        DateComponents.from(tomorrow),
        tomorrowParams,
      );
      nextTime = tomorrowTimes.fajr;
    }

    final difference = nextTime.difference(DateTime.now());

    state = state.copyWith(nextPrayer: next, timeUntilNextPrayer: difference);
  }

  // Helpers to get formatted strings for the UI
  String getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      case Prayer.none:
        return 'غير محدد';
    }
  }

  String getFormattedTime(DateTime? time) {
    if (time == null) return '--:--';
    String hour = time.hour > 12
        ? (time.hour - 12).toString()
        : time.hour.toString();
    if (hour == '0') hour = '12';
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String getCountdownString() {
    if (state.timeUntilNextPrayer == null) return 'حساب الوقت...';
    final duration = state.timeUntilNextPrayer!;

    if (duration.isNegative) return 'حان وقت الصلاة';

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return 'باقي $hours ساعة و $minutes دقيقة';
    } else {
      return 'باقي $minutes دقيقة';
    }
  }
}
