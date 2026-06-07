import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';


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
final prayerProvider = NotifierProvider<PrayerNotifier, PrayerState>(PrayerNotifier.new);

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
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('خدمات الموقع غير مفعلة.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('تم رفض صلاحية الموقع.');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('صلاحية الموقع مرفوضة دائماً، يرجى تفعيلها من الإعدادات.');
      } 

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      final coordinates = Coordinates(position.latitude, position.longitude);
      
      // Calculate Prayer Times using Umm al-Qura standard
      final params = CalculationMethod.umm_al_qura.getParameters();
      params.madhab = Madhab.shafi;
      
      final date = DateComponents.from(DateTime.now());
      final prayerTimes = PrayerTimes(coordinates, date, params);
      
      state = state.copyWith(
        isLoading: false,
        prayerTimes: prayerTimes,
        locationName: 'موقعي الحالي',
      );
      
      _updateCountdown();
      
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  void _updateCountdown() {
    if (state.prayerTimes == null) return;
    
    Prayer next = state.prayerTimes!.nextPrayer();
    DateTime nextTime = state.prayerTimes!.timeForPrayer(next) ?? DateTime.now();
    
    // If next prayer is none, it means it's after Isha, so we get Fajr of tomorrow
    if (next == Prayer.none) {
      next = Prayer.fajr;
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowParams = CalculationMethod.umm_al_qura.getParameters();
      final tomorrowTimes = PrayerTimes(
        state.prayerTimes!.coordinates, 
        DateComponents.from(tomorrow), 
        tomorrowParams
      );
      nextTime = tomorrowTimes.fajr;
    }
    
    final difference = nextTime.difference(DateTime.now());
    
    state = state.copyWith(
      nextPrayer: next,
      timeUntilNextPrayer: difference,
    );
  }
  
  // Helpers to get formatted strings for the UI
  String getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'الفجر';
      case Prayer.sunrise: return 'الشروق';
      case Prayer.dhuhr: return 'الظهر';
      case Prayer.asr: return 'العصر';
      case Prayer.maghrib: return 'المغرب';
      case Prayer.isha: return 'العشاء';
      case Prayer.none: return 'غير محدد';
    }
  }
  
  String getFormattedTime(DateTime? time) {
    if (time == null) return '--:--';
    String hour = time.hour > 12 ? (time.hour - 12).toString() : time.hour.toString();
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
