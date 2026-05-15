import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/common_widgets/prayer_time_item.dart';
import '../../../../core/common_widgets/quick_action_card.dart';
import '../../../../core/common_widgets/islamic_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _openQuran(BuildContext context) {
    context.push('/quran');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Faint Islamic geometric texture
          Positioned.fill(
            child: CustomPaint(painter: _IslamicTexturePainter()),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  _buildGreeting().animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
                  _buildQuoteOfTheDay().animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 12.0),
                  _buildHeaderCarousel().animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
                  const SizedBox(height: 24.0),
                  _buildPrayerTimesList().animate().fadeIn(duration: 600.ms, delay: 200.ms).slideX(begin: 0.1),
                  const SizedBox(height: 32.0),
                  _buildSectionTitleWithAction('وصول سريع', Icons.edit_outlined).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 16.0),
                  _buildQuickAccess().animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                  const SizedBox(height: 32.0),
                  _buildSectionTitle('رحلتي اليومية').animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 16.0),
                  _buildGamifiedDailyJourney().animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'السلام عليكم، أحمد 👋',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.0),
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => ctx.push('/monthly-prayers'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '١٥ رمضان ١٤٤٧ هـ',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.calendar_month, color: AppColors.textSecondary, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteOfTheDay() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '« مَنْ صَلَّى الْبَرْدَيْنِ دَخَلَ الْجَنَّةَ »',
              style: TextStyle(
                color: AppColors.textPrimary.withValues(alpha: 0.8),
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeaderCarousel() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        SizedBox(
          height: 230.0,
          child: CarouselSlider.builder(
            itemCount: 5,
            itemBuilder: (context, index, realIndex) {
              return _buildCarouselItem(index, isDarkMode);
            },
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 8),
              enlargeCenterPage: true,
              viewportFraction: 0.92,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: _currentIndex == index ? 24.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: _currentIndex == index 
                    ? AppColors.primary 
                    : AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4.0),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(int index, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0), // Softer corners
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 20.0,
            spreadRadius: -2.0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Layer 1: Background Image
            Image.asset(
              'assets/images/${index + 1}.png',
              fit: BoxFit.cover,
            ),
            
            // Layer 2: Glassmorphism Blur (very subtle)
            if (isDarkMode)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              )
            else
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Container(color: Colors.black.withValues(alpha: 0.1)),
              ),
            
            // Layer 3: Theme-Aware Gradient Scrim (Smoother transition)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                  ],
                  stops: const [0.4, 0.7, 1.0],
                ),
              ),
            ),

            // Layer 4: Content
            Positioned(
              left: 24.0,
              right: 24.0,
              bottom: 24.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'صلاة العصر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 3))
                            ],
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        const Text(
                          'باقي 1 ساعة و 20 دقيقة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Glowing Smooth Progress Bar
                        Container(
                          height: 6.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(color: AppColors.gold.withValues(alpha: 0.5), blurRadius: 10.0, spreadRadius: 0.5),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: LinearProgressIndicator(
                              value: 0.4,
                              backgroundColor: Colors.white.withValues(alpha: 0.25),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24.0),
                  // Play Button with Glass effect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList() {
    return SizedBox(
      height: 125.0, // Increased height to prevent cut-off and fit drop shadows
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        children: const [
          PrayerTimeItem(date: 'اليوم', title: 'الفجر', time: '4:30', icon: Icons.nights_stay_outlined, isActive: false),
          SizedBox(width: 8.0),
          PrayerTimeItem(date: 'اليوم', title: 'الظهر', time: '12:05', icon: Icons.wb_sunny_outlined, isActive: false),
          SizedBox(width: 8.0),
          PrayerTimeItem(date: 'اليوم', title: 'العصر', time: '3:30', icon: Icons.wb_twilight_outlined, isActive: true),
          SizedBox(width: 8.0),
          PrayerTimeItem(date: 'اليوم', title: 'المغرب', time: '6:15', icon: Icons.nights_stay, isActive: false),
          SizedBox(width: 8.0),
          PrayerTimeItem(date: 'اليوم', title: 'العشاء', time: '7:45', icon: Icons.mode_night_outlined, isActive: false),
          SizedBox(width: 16.0),
          // Tomorrow's times
          PrayerTimeItem(date: 'غداً', title: 'الفجر', time: '4:29', icon: Icons.nights_stay_outlined, isActive: false),
          SizedBox(width: 8.0),
          PrayerTimeItem(date: 'غداً', title: 'الظهر', time: '12:05', icon: Icons.wb_sunny_outlined, isActive: false),
          SizedBox(width: 8.0),
          PrayerTimeItem(date: 'غداً', title: 'العصر', time: '3:30', icon: Icons.wb_twilight_outlined, isActive: false),
          SizedBox(width: 8.0),
          PrayerTimeItem(date: 'غداً', title: 'المغرب', time: '6:16', icon: Icons.nights_stay, isActive: false),
          SizedBox(width: 8.0),
          PrayerTimeItem(date: 'غداً', title: 'العشاء', time: '7:46', icon: Icons.mode_night_outlined, isActive: false),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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

  Widget _buildSectionTitleWithAction(String title, IconData actionIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(actionIcon, color: AppColors.textSecondary, size: 22.0),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildQuickAccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Builder(
              builder: (ctx) => QuickActionCard(
                title: 'القرآن',
                icon: Icons.menu_book,
                customIcon: IslamicIcons.quran(color: AppColors.primary),
                onTap: () => _openQuran(ctx),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Builder(
              builder: (ctx) => QuickActionCard(
                title: 'المسبحة',
                icon: Icons.ads_click,
                customIcon: IslamicIcons.tasbeeh(color: AppColors.primary),
                onTap: () => ctx.push('/tasbeeh'),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Builder(
              builder: (ctx) => QuickActionCard(
                title: 'الأذكار',
                icon: Icons.wb_sunny_outlined,
                customIcon: IslamicIcons.azkar(color: AppColors.primary),
                onTap: () => ctx.push('/azkar'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamifiedDailyJourney() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress indicator
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: CircularProgressIndicator(
                    value: 8 / 24,
                    strokeWidth: 8.0,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '33%',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      'مكتمل',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ).animate().scale(delay: 500.ms, duration: 600.ms, curve: Curves.easeOutBack),
          ),
          const SizedBox(width: 24.0),
          // Gamification Badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'أداء متميز!',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'لقد أنهيت 8 من أصل 24 مهمة اليوم.',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGamificationBadge(icon: Icons.local_fire_department, value: '5 أيام', label: 'تتابع', color: Colors.orange),
                    _buildGamificationBadge(icon: Icons.diamond, value: '150', label: 'نقطة', color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamificationBadge({required IconData icon, required String value, required String label, required Color color}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10.0,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Faint Islamic geometric texture for background
class _IslamicTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const spacing = 60.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        // Draw octagonal Islamic pattern
        final path = Path();
        const r = 18.0;
        for (int i = 0; i < 8; i++) {
          final angle = (i * 3.14159 * 2 / 8) - 3.14159 / 8;
          final px = x + r * _cos(angle);
          final py = y + r * _sin(angle);
          if (i == 0) {
            path.moveTo(px, py);
          } else {
            path.lineTo(px, py);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  double _cos(double a) => math.cos(a);
  double _sin(double a) => math.sin(a);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
