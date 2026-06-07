import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/quran_native_service.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Sticky App Bar with Search
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.background,
              title: const Text(
                'استكشف',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: _buildSearchBar(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTagsRow().animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 24.0),
                    _buildDailyContentCard().animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: 32.0),
                    _buildSectionTitle('المكتبة الإسلامية').animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 16.0),
                    _buildCategoriesGrid(),
                    const SizedBox(height: 100.0), // Padding below everything to prevent cut-off
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث عن آية، حديث، أو دعاء...',
          hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: const Icon(Icons.mic, color: AppColors.primary),
            onPressed: () {
              // Voice search action
            },
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTagsRow() {
    final tags = ['#الصبر', '#الجنة', '#بر_الوالدين', '#الفجر', '#الرزق'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tags.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              tags[index],
              style: const TextStyle(color: AppColors.primaryDark, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            onPressed: () {},
          );
        },
      ),
    );
  }

  Widget _buildDailyContentCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Watermark Pattern
          Positioned(
            left: -20,
            top: -20,
            child: Icon(Icons.mosque, size: 140, color: Colors.white.withValues(alpha: 0.08)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'آية اليوم',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'سورة الأحزاب • ٥٦',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              const Text(
                '﴿ إِنَّ اللَّهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ ۚ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا ﴾',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  height: 1.6,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28.0),
              // Interaction Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAyahActionButton(Icons.volume_up_rounded, 'استماع'),
                  const SizedBox(width: 32),
                  _buildAyahActionButton(Icons.favorite_border_rounded, 'حفظ'),
                  const SizedBox(width: 32),
                  _buildAyahActionButton(Icons.share_rounded, 'مشاركة'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAyahActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
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

  Widget _buildCategoriesGrid() {
    final categories = [
      {'title': 'القرآن الكريم', 'desc': 'تلاوة وحفظ', 'icon': Icons.menu_book, 'color': const Color(0xFFD4AF37), 'route': null}, // Gold
      {'title': 'الحديث الشريف', 'desc': 'الكتب الستة', 'icon': Icons.auto_stories, 'color': Colors.teal, 'route': null}, // Greenish
      {'title': 'حصن المسلم', 'desc': 'أكثر من 100 دعاء', 'icon': Icons.shield, 'color': Colors.purple.shade300, 'route': '/hisn'}, // Soft Purple
      {'title': 'السيرة النبوية', 'desc': 'حياة الرسول', 'icon': Icons.history_edu, 'color': Colors.brown.shade400, 'route': null}, // Brown
      {'title': 'الفتاوى', 'desc': 'سؤال وجواب', 'icon': Icons.question_answer, 'color': Colors.blue.shade400, 'route': null}, // Blue
      {'title': 'المقالات', 'desc': 'قراءات متنوعة', 'icon': Icons.article, 'color': Colors.deepOrange.shade300, 'route': null}, // Orange
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final Color catColor = category['color'] as Color;
        final String? route = category['route'] as String?;
        return _buildCategoryCard(
          context: context,
          title: category['title'] as String,
          desc: category['desc'] as String,
          icon: category['icon'] as IconData,
          color: catColor,
          delay: 400 + (index * 100),
          route: route,
        );
      },
    );
  }

  Widget _buildCategoryCard({required BuildContext context, required String title, required String desc, required IconData icon, required Color color, required int delay, String? route}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (route != null) {
            context.push(route);
          } else if (title == 'القرآن الكريم') {
            QuranNativeService.openQuran();
          }
        },
        borderRadius: BorderRadius.circular(20.0),
        highlightColor: color.withValues(alpha: 0.1),
        splashColor: color.withValues(alpha: 0.2),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 10.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36.0, color: color),
              ),
              const SizedBox(height: 12.0),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                desc,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
