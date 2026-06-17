import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:adhan/adhan.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/prayer_provider.dart';

class MonthlyPrayerTimesScreen extends ConsumerStatefulWidget {
  const MonthlyPrayerTimesScreen({super.key});
  @override
  ConsumerState<MonthlyPrayerTimesScreen> createState() =>
      _MonthlyPrayerTimesScreenState();
}

class _MonthlyPrayerTimesScreenState
    extends ConsumerState<MonthlyPrayerTimesScreen> {
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  double? _lat;
  double? _lng;

  final _months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  final _headers = [
    'اليوم',
    'الفجر',
    'الشروق',
    'الظهر',
    'العصر',
    'المغرب',
    'العشاء',
  ];

  List<Map<String, String>>? _cachedMonthData;
  int _cachedMonth = -1;
  int _cachedYear = -1;
  double? _cachedLat;
  double? _cachedLng;

  String _formatTime(DateTime time) {
    final h = time.hour > 12 ? time.hour - 12 : time.hour;
    final hour = h == 0 ? 12 : h;
    return '${hour.toString()}:${time.minute.toString().padLeft(2, '0')}';
  }

  List<Map<String, String>> _computeMonthData(
      int year, int month, double lat, double lng) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final coords = Coordinates(lat, lng);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    return List.generate(daysInMonth, (i) {
      final d = i + 1;
      final pt = PrayerTimes(
        coords,
        DateComponents.from(DateTime(year, month, d)),
        params,
      );
      return {
        'day': '$d',
        'fajr': _formatTime(pt.fajr),
        'sunrise': _formatTime(pt.sunrise),
        'dhuhr': _formatTime(pt.dhuhr),
        'asr': _formatTime(pt.asr),
        'maghrib': _formatTime(pt.maghrib),
        'isha': _formatTime(pt.isha),
      };
    });
  }

  List<Map<String, String>>? get _monthData {
    if (_lat == null || _lng == null) return null;
    if (_cachedMonth == _currentMonth &&
        _cachedYear == _currentYear &&
        _cachedLat == _lat &&
        _cachedLng == _lng &&
        _cachedMonthData != null) {
      return _cachedMonthData;
    }
    _cachedMonthData =
        _computeMonthData(_currentYear, _currentMonth, _lat!, _lng!);
    _cachedMonth = _currentMonth;
    _cachedYear = _currentYear;
    _cachedLat = _lat;
    _cachedLng = _lng;
    return _cachedMonthData;
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth += delta;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      }
      if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final prayerState = ref.watch(prayerProvider);

    if (prayerState.prayerTimes != null) {
      final coords = prayerState.prayerTimes!.coordinates;
      if (_lat != coords.latitude || _lng != coords.longitude) {
        _lat = coords.latitude;
        _lng = coords.longitude;
      }
    }

    final data = _monthData;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildMonthSelector().animate().fadeIn(delay: 100.ms),
              Expanded(
                child: _buildBody(prayerState, data)
                    .animate()
                    .fadeIn(delay: 200.ms),
              ),
              _buildActionButtons()
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slideY(begin: 0.1),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
      PrayerState prayerState, List<Map<String, String>>? data) {
    if (prayerState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (prayerState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            prayerState.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    if (data == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'لم يتم تحديد الموقع بعد. يرجى العودة إلى الشاشة الرئيسية.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF757575), fontSize: 16),
          ),
        ),
      );
    }
    return _buildPrayerTable(data);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
            onPressed: () => context.pop(),
          ),
          const Spacer(),
          const Text(
            'مواقيت الصلاة الشهرية',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _changeMonth(-1),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
          Text(
            '${_months[_currentMonth - 1]} $_currentYear',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF333333),
            ),
          ),
          GestureDetector(
            onTap: () => _changeMonth(1),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTable(List<Map<String, String>> data) {
    final today = DateTime.now();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            // Table Header
            Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                children: _headers
                    .map(
                      (h) => Expanded(
                        child: Text(
                          h,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            // Table Body
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (ctx, i) {
                  final row = data[i];
                  final isToday = _currentMonth == today.month &&
                      _currentYear == today.year &&
                      (i + 1) == today.day;
                  return Container(
                    color: isToday
                        ? const Color(0xFFE8F5E9)
                        : (i.isEven ? Colors.white : const Color(0xFFFAFAFA)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        _cell(row['day']!, isToday, isBold: true),
                        _cell(row['fajr']!, isToday),
                        _cell(row['sunrise']!, isToday),
                        _cell(row['dhuhr']!, isToday),
                        _cell(row['asr']!, isToday),
                        _cell(row['maghrib']!, isToday),
                        _cell(row['isha']!, isToday),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cell(String text, bool isToday, {bool isBold = false}) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: isToday ? const Color(0xFF2D7D46) : const Color(0xFF333333),
          fontWeight: isToday || isBold ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded, size: 20),
              label: const Text(
                'تحميل الجدول',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.calendar_month,
              size: 18,
              color: AppColors.primary,
            ),
            label: const Text(
              'إضافة إلى التقويم',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
