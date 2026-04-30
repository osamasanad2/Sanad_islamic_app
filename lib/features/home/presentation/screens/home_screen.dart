import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/common_widgets/prayer_time_item.dart';
import '../../../../core/common_widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCarousel(),
              const SizedBox(height: 24.0),
              _buildPrayerTimesRow(),
              const SizedBox(height: 32.0),
              _buildSectionTitle('وصول سريع'),
              const SizedBox(height: 16.0),
              _buildQuickAccess(),
              const SizedBox(height: 32.0),
              _buildSectionTitle('رحلتي اليومية'),
              const SizedBox(height: 16.0),
              _buildDailyJourneyCard(),
              const SizedBox(height: 40.0), // Padding below everything
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCarousel() {
    return SizedBox(
      height: 250.0,
      child: PageView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15.0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 24.0,
                  right: 24.0,
                  bottom: 32.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'صلاة العصر',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'باقي 1 ساعة و 20 دقيقة',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesRow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: PrayerTimeItem(title: 'الفجر', time: '4:30', icon: Icons.nights_stay_outlined, isActive: false)),
          SizedBox(width: 8.0),
          Expanded(child: PrayerTimeItem(title: 'الظهر', time: '12:05', icon: Icons.wb_sunny_outlined, isActive: false)),
          SizedBox(width: 8.0),
          Expanded(child: PrayerTimeItem(title: 'العصر', time: '3:30', icon: Icons.wb_twilight_outlined, isActive: true)),
          SizedBox(width: 8.0),
          Expanded(child: PrayerTimeItem(title: 'المغرب', time: '6:15', icon: Icons.nights_stay, isActive: false)),
          SizedBox(width: 8.0),
          Expanded(child: PrayerTimeItem(title: 'العشاء', time: '7:45', icon: Icons.mode_night_outlined, isActive: false)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: QuickActionCard(title: 'القرآن الكريم', icon: Icons.menu_book, onTap: () {})),
          const SizedBox(width: 12.0),
          Expanded(child: QuickActionCard(title: 'القبلة', icon: Icons.explore_outlined, onTap: () {})),
          const SizedBox(width: 12.0),
          Expanded(child: QuickActionCard(title: 'أذكار اليوم', icon: Icons.wb_sunny_outlined, onTap: () {})),
        ],
      ),
    );
  }

  Widget _buildDailyJourneyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(Icons.local_fire_department, color: Colors.orange),
                  ),
                  const SizedBox(width: 12.0),
                  const Text(
                    'تتابع 5',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '150',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(Icons.diamond_outlined, color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          const Text(
            'تقدم اليوم: 8 من 24 مهمة مكتملة',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 12.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: 8 / 24,
              minHeight: 10.0,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
