import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/common_widgets/islamic_icons.dart';
import '../../../../core/services/quran_native_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import '../../../prayer_times/data/prayer_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  int _sliderIndex = 0;
  final int _currentHadithIndex = 0;

  final List<String> _hadiths = [
    '« مَنْ صَلَّى الْبَرْدَيْنِ دَخَلَ الْجَنَّةَ »',
    '« خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ »',
    '« إنَّ اللَّهَ جَمِيلٌ يُحِبُّ الْجَمَالَ »',
    '« الدُّنْيَا سِجْنُ الْمُؤْمِنِ وَجَنَّةُ الْكَافِرِ »',
    '« تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ صَدَقَةٌ »',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    const count = 8;
    _fadeAnims = List.generate(count, (i) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(i * 0.08, 0.35 + i * 0.06, curve: Curves.easeOutCubic),
        ),
      );
    });
    _slideAnims = List.generate(count, (i) {
      return Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(i * 0.08, 0.35 + i * 0.06, curve: Curves.easeOutCubic),
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

  String _timeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'صباح الخير';
    if (hour >= 12 && hour < 18) return 'مساء الخير';
    return 'مساء الخير';
  }

  String _greetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return '☀️';
    if (hour >= 12 && hour < 18) return '🌤';
    return '🌙';
  }

  void _openQuran(BuildContext context) {
    QuranNativeService.openQuran();
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ الحديث للمشاركة'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Clipboard.setData(ClipboardData(text: text));
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
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildSection(0, _buildGreetingHeader()),
              const SizedBox(height: 20),
              _buildSection(1, _buildPrayerHeroCard()),
              const SizedBox(height: 20),
              _buildSection(2, _buildReadingAndHadithGrid()),
              const SizedBox(height: 20),
              _buildSection(3, _buildDailyGoalCard()),
              const SizedBox(height: 20),
              _buildSection(4, _buildFeaturedSlider()),
              const SizedBox(height: 20),
              _buildSection(5, _buildAchievementCards()),
              const SizedBox(height: 20),
              _buildSection(6, _buildQuickAccessTitle()),
              const SizedBox(height: 12),
              _buildSection(7, _buildQuickAccessGrid()),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  // ─── Section 1: Greeting Header ───
  Widget _buildGreetingHeader() {
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_greetingEmoji()} ${_timeBasedGreeting()}، أحمد',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.textPrimary,
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
                        style: TextStyle(
                          fontSize: 13,
                          color: context.appColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.calendar_month,
                        color: context.appColors.textSecondary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section 2: Main Prayer Hero Card ───
  Widget _buildPrayerHeroCard() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: Opacity(
                opacity: 0.12,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.softLight,
                  ),
                  child: Image.asset(
                    'assets/images/7.jpg',
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPrayerBadge(),
                    const Spacer(),
                    _buildCrescentGlass(),
                  ],
                ),
                const SizedBox(height: 1),
                _buildLocationRow(),
                const SizedBox(height: 2),
                _buildNextPrayerCenter(),
                const SizedBox(height: 2),
                _buildPrayerTimeline(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 0.5),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, color: Colors.white, size: 14),
          SizedBox(width: 6),
          Text(
            'أوقات الصلاة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrescentGlass() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 0.5),
      ),
      child: const Icon(
        Icons.nightlight_round,
        color: AppColors.goldLight,
        size: 30,
      ),
    );
  }

  Widget _buildLocationRow() {
    return Consumer(
      builder: (context, ref, _) {
        final location = ref.watch(prayerProvider).locationName;
        return Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.6), size: 14),
            const SizedBox(width: 4),
            Text(
              location,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }

  Widget _buildNextPrayerCenter() {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(prayerProvider);
        final notifier = ref.read(prayerProvider.notifier);
        final prayerName = state.nextPrayer != null
            ? notifier.getPrayerName(state.nextPrayer!)
            : 'جاري الحساب...';
        final countdown = state.timeUntilNextPrayer != null
            ? notifier.getCountdownString()
            : 'حساب الوقت...';
        final prayerTime = state.nextPrayer != null && state.nextPrayer != Prayer.none
            ? notifier.getFormattedTime(state.prayerTimes!.timeForPrayer(state.nextPrayer!))
            : null;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'الصلاة القادمة',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  prayerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (prayerTime != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      prayerTime,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              countdown,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                height: 1.1,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrayerTimeline() {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(prayerProvider);
        final times = state.prayerTimes;
        if (times == null) return const SizedBox.shrink();
        final notifier = ref.read(prayerProvider.notifier);
        final nextPrayer = state.nextPrayer;
        final prayers = [
          ('الفجر', times.fajr, Prayer.fajr),
          ('الشروق', times.sunrise, Prayer.sunrise),
          ('الظهر', times.dhuhr, Prayer.dhuhr),
          ('العصر', times.asr, Prayer.asr),
          ('المغرب', times.maghrib, Prayer.maghrib),
          ('العشاء', times.isha, Prayer.isha),
        ];
        return SizedBox(
          height: 24,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: prayers.map((p) {
                    final isNext = nextPrayer == p.$3;
                    return Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          p.$1,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                            color: isNext ? Colors.white : Colors.white60,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Row(
                  children: prayers.map((p) {
                    final time = notifier.getFormattedTime(p.$2);
                    return Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white.withValues(alpha: 0.45),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        height: 1.5,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                    Row(
                      children: prayers.map((p) {
                        final isNext = nextPrayer == p.$3;
                        final passed = nextPrayer != null && _prayerPassed(p.$3, nextPrayer);
                        final dotSize = isNext ? 8.0 : 5.0;
                        final dotColor = isNext
                            ? AppColors.goldLight
                            : passed
                                ? Colors.white.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.25);
                        return Expanded(
                          child: Center(
                            child: Container(
                              width: dotSize,
                              height: dotSize,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                                border: isNext
                                    ? Border.all(color: Colors.white, width: 1.5)
                                    : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _prayerPassed(Prayer prayer, Prayer next) {
    const order = [
      Prayer.fajr, Prayer.sunrise, Prayer.dhuhr,
      Prayer.asr, Prayer.maghrib, Prayer.isha,
    ];
    final pIdx = order.indexOf(prayer);
    final nIdx = order.indexOf(next);
    if (pIdx == -1 || nIdx == -1) return false;
    return pIdx < nIdx;
  }

  // ─── Section 3: Reading Continuation + Hadith ───
  Widget _buildReadingAndHadithGrid() {
    return SizedBox(
      height: 170,
      child: Row(
        children: [
          Expanded(child: _buildReadingCard()),
          const SizedBox(width: 12),
          Expanded(child: _buildHadithCard()),
        ],
      ),
    );
  }

  Widget _buildReadingCard() {
    return _ScaleTap(
      onTap: () => _openQuran(context),
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: IslamicIcons.quran(size: 90, color: AppColors.primaryLight.withValues(alpha: 0.25)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أكمل قراءتك',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'سورة الكهف\nالآية 42',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.appColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'متابعة القراءة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_back_rounded, color: Colors.white, size: 14),
                      ],
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

  Widget _buildHadithCard() {
    final hadith = _hadiths[_currentHadithIndex];
    return _ScaleTap(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'حديث اليوم',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                hadith,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CircleActionButton(
                    icon: Icons.copy_rounded,
                    size: 40,
                    onTap: () => _copyHadith(hadith),
                  ),
                  const SizedBox(width: 6),
                  _CircleActionButton(
                    icon: Icons.share_rounded,
                    size: 40,
                    onTap: () => _shareHadith(hadith),
                  ),
                  const SizedBox(width: 6),
                  _CircleActionButton(
                    icon: Icons.bookmark_border_rounded,
                    size: 40,
                    onTap: () => _saveHadith(hadith),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section 4: Daily Goal Card ───
  Widget _buildDailyGoalCard() {
    return _ScaleTap(
      onTap: () => context.push('/azkar'),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'وردك اليوم',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.appColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '3 / 10 صفحات',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: 0.3,
                      minHeight: 8,
                      backgroundColor: context.appColors.background,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            IslamicIcons.quran(size: 48, color: AppColors.primaryLight.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  // ─── Section 5: Featured Slider ───
  Widget _buildFeaturedSlider() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 170,
          child: CarouselSlider.builder(
            itemCount: 5,
            itemBuilder: (context, index, realIndex) {
              return _buildSliderItem(index);
            },
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 8),
              enlargeCenterPage: true,
              viewportFraction: 0.92,
              height: 170,
              onPageChanged: (index, reason) {
                setState(() => _sliderIndex = index);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final isActive = _sliderIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 24.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : const Color(0xFFD0D0D0),
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSliderItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
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
                  Colors.black.withValues(alpha: 0.6),
                ],
                stops: const [0.4, 1.0],
              ),
            ),
          ),
          Positioned(
            right: 20,
            left: 20,
            bottom: 16,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          final state = ref.watch(prayerProvider);
                          final notifier = ref.read(prayerProvider.notifier);
                          final name = state.nextPrayer != null
                              ? notifier.getPrayerName(state.nextPrayer!)
                              : 'الفجر';
                          return Text(
                            'صلاة $name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              shadows: [
                                Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 2)),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Consumer(
                        builder: (context, ref, _) {
                          final notifier = ref.read(prayerProvider.notifier);
                          final countdown = notifier.getCountdownString();
                          return Text(
                            'باقي $countdown',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
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
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section 6: Achievement Cards ───
  Widget _buildAchievementCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            'إنجازاتك اليوم',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: Row(
            children: [
              Expanded(child: _buildAchievementCard('🔥', '5 أيام\nمتتالية', Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildAchievementCard('📖', '3 أجزاء\nمحفوظة', AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(child: _buildAchievementCard('✅', '80%\nإنجاز الورد', AppColors.gold)),
              const SizedBox(width: 12),
              Expanded(child: _buildAchievementCard('🎯', '8/24\nمهمة', Colors.blue)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(String emoji, String text, Color accent) {
    return _ScaleTap(
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: context.appColors.textPrimary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section 7: Quick Access ───
  Widget _buildQuickAccessTitle() {
    return Row(
      children: [
        const Text(
          '⚡ ',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'الوصول السريع',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: context.appColors.textPrimary,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildQuickAccessGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildQuickAccessCard(
              title: 'القرآن',
              icon: IslamicIcons.quran(size: 32, color: AppColors.primary),
              isLarge: true,
              onTap: () => _openQuran(context),
            )),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  _buildQuickAccessCard(
                    title: 'المسبحة',
                    icon: IslamicIcons.tasbeeh(size: 32, color: AppColors.primary),
                    onTap: () => context.push('/tasbeeh'),
                  ),
                  const SizedBox(height: 12),
                  _buildQuickAccessCard(
                    title: 'الأذكار',
                    icon: IslamicIcons.azkar(size: 32, color: AppColors.primary),
                    onTap: () => context.push('/azkar'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildQuickAccessCard(
              title: 'الحديث',
              icon: Icons.format_quote_rounded,
              onTap: () => context.push('/hisn'),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildQuickAccessCard(
              title: 'السيرة النبوية',
              icon: Icons.auto_stories_rounded,
              onTap: () => context.push('/seerah'),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildQuickAccessCard(
              title: 'الدعاء',
              icon: Icons.favorite_rounded,
              onTap: () => context.push('/dua'),
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildQuickAccessCard(
              title: 'القبلة',
              icon: Icons.explore_rounded,
              onTap: () => context.push('/qibla'),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildQuickAccessCard(
              title: 'المزيد',
              icon: Icons.grid_view_rounded,
              onTap: () {},
            )),
            const SizedBox(width: 12),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard({
    required String title,
    required dynamic icon,
    bool isLarge = false,
    required VoidCallback onTap,
  }) {
    final height = isLarge ? 180.0 : 90.0;
    return _ScaleTap(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(isLarge ? 24 : 22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isLarge
            ? _buildLargeCardContent(title, icon)
            : _buildSmallCardContent(title, icon),
      ),
    );
  }

  Widget _buildLargeCardContent(String title, dynamic icon) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon is Widget) icon else Icon(icon as IconData, size: 32, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.appColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCardContent(String title, dynamic icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon is Widget) icon else Icon(icon as IconData, size: 32, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.appColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Helpers ───

class _ScaleTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _ScaleTap({required this.child, this.onTap});

  @override
  State<_ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<_ScaleTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onTap != null
          ? (_) {
              _controller.reverse();
              widget.onTap!();
            }
          : null,
      onTapCancel: widget.onTap != null ? () => _controller.reverse() : null,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;

  const _CircleActionButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: size * 0.45, color: context.appColors.textSecondary),
        ),
      ),
    );
  }
}


