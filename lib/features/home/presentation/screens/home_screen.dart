import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/common_widgets/quick_action_card.dart';
import '../../../../core/common_widgets/islamic_icons.dart';
import '../../../../core/services/quran_native_service.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import '../../../prayer_times/data/prayer_provider.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final List<String> _hadiths = [
    '« مَنْ صَلَّى الْبَرْدَيْنِ دَخَلَ الْجَنَّةَ »',
    '« خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ »',
    '« إنَّ اللَّهَ جَمِيلٌ يُحِبُّ الْجَمَالَ »',
    '« الدُّنْيَا سِجْنُ الْمُؤْمِنِ وَجَنَّةُ الْكَافِرِ »',
    '« تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ صَدَقَةٌ »',
  ];

  int _currentHadithIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimations = List.generate(6, (i) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(i * 0.12, 0.5 + i * 0.08,
              curve: Curves.easeOutQuart),
        ),
      );
    });

    _slideAnimations = List.generate(6, (i) {
      return Tween<Offset>(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(i * 0.12, 0.5 + i * 0.08,
              curve: Curves.easeOutQuart),
        ),
      );
    });

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _openQuran(BuildContext context) {
    QuranNativeService.openQuran();
  }

  String _timeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'صباح الخير ☀️';
    if (hour >= 12 && hour < 18) return 'مساء الخير 🌤';
    return 'مساء الخير 🌙';
  }

  void _copyHadith(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ الحديث'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _shareHadith(String text) {
    Share.share(text);
  }

  void _saveHadith(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حفظ الحديث في المفضلة'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _IslamicTexturePainter()),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  _buildGreeting(),
                  const SizedBox(height: 16),
                  _buildHadithCard(),
                  const SizedBox(height: 16),
                  _buildNextPrayerCard(),
                  const SizedBox(height: 20),
                  _buildHeaderCarousel(),
                  const SizedBox(height: 20),
                  _buildDailyActivityCards(),
                  const SizedBox(height: 24),
                  _buildQuickAccess(),
                  const SizedBox(height: 24),
                  _buildDailyJourneySection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return FadeTransition(
      opacity: _fadeAnimations[0],
      child: SlideTransition(
        position: _slideAnimations[0],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _timeBasedGreeting(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => context.push('/monthly-prayers'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ref.watch(prayerProvider).hijriDate.isNotEmpty
                          ? ref.watch(prayerProvider).hijriDate
                          : 'جاري الحساب...',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.calendar_month,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHadithCard() {
    final hadith = _hadiths[_currentHadithIndex];
    return FadeTransition(
      opacity: _fadeAnimations[1],
      child: SlideTransition(
        position: _slideAnimations[1],
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.format_quote_rounded,
                      color: AppColors.gold,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'حديث اليوم',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                hadith,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _HadithActionButton(
                    icon: Icons.copy_rounded,
                    tooltip: 'نسخ',
                    onTap: () => _copyHadith(hadith),
                  ),
                  const SizedBox(width: 8),
                  _HadithActionButton(
                    icon: Icons.share_rounded,
                    tooltip: 'مشاركة',
                    onTap: () => _shareHadith(hadith),
                  ),
                  const SizedBox(width: 8),
                  _HadithActionButton(
                    icon: Icons.bookmark_border_rounded,
                    tooltip: 'حفظ',
                    onTap: () => _saveHadith(hadith),
                  ),
                  const SizedBox(width: 8),
                  _HadithActionButton(
                    icon: Icons.refresh_rounded,
                    tooltip: 'تحديث',
                    onTap: () {
                      setState(() {
                        _currentHadithIndex =
                            (_currentHadithIndex + 1) % _hadiths.length;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextPrayerCard() {
    return FadeTransition(
      opacity: _fadeAnimations[2],
      child: SlideTransition(
        position: _slideAnimations[2],
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.nightlight_round_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الصلاة القادمة',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(prayerProvider);
                        if (state.nextPrayer == null) {
                          return const Text(
                            'جاري التحميل...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return Text(
                          ref
                              .read(prayerProvider.notifier)
                              .getPrayerName(state.nextPrayer!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(prayerProvider);
                        return Text(
                          state.timeUntilNextPrayer != null
                              ? ref
                                  .read(prayerProvider.notifier)
                                  .getCountdownString()
                              : 'حساب الوقت...',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(prayerProvider);
                  if (state.prayerTimes == null) return const SizedBox();
                  final notifier = ref.read(prayerProvider.notifier);
                  final next = state.nextPrayer;
                  DateTime? nextTime;
                  if (next != null && next != Prayer.none) {
                    nextTime = state.prayerTimes!.timeForPrayer(next);
                  }
                  return Column(
                    children: [
                      Text(
                        nextTime != null
                            ? notifier.getFormattedTime(nextTime)
                            : '--:--',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.4),
                            width: 0.5,
                          ),
                        ),
                        child: const Text(
                          'متبقي',
                          style: TextStyle(
                            color: AppColors.goldLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCarousel() {
    return FadeTransition(
      opacity: _fadeAnimations[3],
      child: SlideTransition(
        position: _slideAnimations[3],
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CarouselSlider.builder(
                itemCount: 5,
                itemBuilder: (context, index, realIndex) {
                  return _buildCarouselItem(index);
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 24.0 : 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/${index + 1}.png', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.15),
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.75),
                  ],
                  stops: const [0.3, 0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Consumer(
                          builder: (context, ref, _) {
                            final state = ref.watch(prayerProvider);
                            final notifier =
                                ref.read(prayerProvider.notifier);
                            return Text(
                              state.nextPrayer != null
                                  ? 'صلاة ${notifier.getPrayerName(state.nextPrayer!)}'
                                  : 'جاري الحساب...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Consumer(
                          builder: (context, ref, _) {
                            final notifier =
                                ref.read(prayerProvider.notifier);
                            return Text(
                              notifier.getCountdownString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openQuran(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyActivityCards() {
    return FadeTransition(
      opacity: _fadeAnimations[4],
      child: SlideTransition(
        position: _slideAnimations[4],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _ActivityInfoCard(
                  icon: Icons.local_fire_department_rounded,
                  label: 'الأيام المتتالية',
                  value: '5',
                  color: Colors.orange,
                  onTap: () => context.push('/activities'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActivityInfoCard(
                  icon: Icons.menu_book_rounded,
                  label: 'تقدم الحفظ',
                  value: '3 أجزاء',
                  color: AppColors.primary,
                  onTap: () => _openQuran(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActivityInfoCard(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'إنجاز الورد',
                  value: '80%',
                  color: AppColors.gold,
                  onTap: () => context.push('/azkar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccess() {
    return FadeTransition(
      opacity: _fadeAnimations[5],
      child: SlideTransition(
        position: _slideAnimations[5],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'وصول سريع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (ctx) => QuickActionCard(
                            title: 'القرآن',
                            icon: Icons.menu_book,
                            customIcon:
                                IslamicIcons.quran(color: AppColors.primary),
                            onTap: () => _openQuran(ctx),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Builder(
                          builder: (ctx) => QuickActionCard(
                            title: 'المسبحة',
                            icon: Icons.ads_click,
                            customIcon:
                                IslamicIcons.tasbeeh(color: AppColors.primary),
                            onTap: () => ctx.push('/tasbeeh'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Builder(
                          builder: (ctx) => QuickActionCard(
                            title: 'الأذكار',
                            icon: Icons.wb_sunny_outlined,
                            customIcon:
                                IslamicIcons.azkar(color: AppColors.primary),
                            onTap: () => ctx.push('/azkar'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (ctx) => QuickActionCard(
                            title: 'القبلة',
                            icon: Icons.explore_rounded,
                            onTap: () => ctx.push('/qibla'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Builder(
                          builder: (ctx) => QuickActionCard(
                            title: 'الدعاء',
                            icon: Icons.favorite_rounded,
                            onTap: () => ctx.push('/dua'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Builder(
                          builder: (ctx) => QuickActionCard(
                            title: 'الحديث',
                            icon: Icons.format_quote_rounded,
                            onTap: () => ctx.push('/hisn'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyJourneySection() {
    return FadeTransition(
      opacity: _fadeAnimations[5],
      child: SlideTransition(
        position: _slideAnimations[5],
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push('/activities'),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
            children: [
              SizedBox(
                height: 88,
                width: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 88,
                      width: 88,
                      child: CircularProgressIndicator(
                        value: 8 / 24,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '33%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          'مكتمل',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أداء متميز!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'لقد أنهيت 8 من أصل 24 مهمة اليوم.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _JourneyBadge(
                          icon: Icons.local_fire_department,
                          value: '5 أيام',
                          label: 'تتابع',
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 16),
                        _JourneyBadge(
                          icon: Icons.diamond,
                          value: '150',
                          label: 'نقطة',
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    ),
  );
}

}

class _HadithActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HadithActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _ActivityInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _JourneyBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IslamicTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    const spacing = 60.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
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
