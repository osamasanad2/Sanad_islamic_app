import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class MonthlyPrayerTimesScreen extends StatefulWidget {
  const MonthlyPrayerTimesScreen({super.key});
  @override
  State<MonthlyPrayerTimesScreen> createState() =>
      _MonthlyPrayerTimesScreenState();
}

class _MonthlyPrayerTimesScreenState extends State<MonthlyPrayerTimesScreen> {
  int _currentMonth = 5; // May
  int _currentYear = 2026;
  final int _todayDay = 1;

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

  // Mock data generator
  List<Map<String, String>> get _monthData {
    final daysInMonth = DateUtils.getDaysInMonth(_currentYear, _currentMonth);
    return List.generate(daysInMonth, (i) {
      final d = i + 1;
      return {
        'day': '$d',
        'fajr': '4:${(28 + (d % 5)).toString().padLeft(2, '0')}',
        'sunrise': '5:${(50 + (d % 4)).toString().padLeft(2, '0')}',
        'dhuhr': '12:0${3 + (d % 3)}',
        'asr': '3:${(28 + (d % 4)).toString().padLeft(2, '0')}',
        'maghrib': '6:${(12 + (d % 5)).toString().padLeft(2, '0')}',
        'isha': '7:${(40 + (d % 6)).toString().padLeft(2, '0')}',
      };
    });
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
                child: _buildPrayerTable().animate().fadeIn(delay: 200.ms),
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

  Widget _buildPrayerTable() {
    final data = _monthData;
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
                  final isToday =
                      _currentMonth == 5 &&
                      _currentYear == 2026 &&
                      (i + 1) == _todayDay;
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
