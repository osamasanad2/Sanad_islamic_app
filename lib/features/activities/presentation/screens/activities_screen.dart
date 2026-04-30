import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String _selectedFilter = 'الكل';
  final List<String> _filters = ['الكل', 'صلاة', 'قرآن', 'أذكار', 'تحديات'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.background,
              title: const Text(
                'الأنشطة',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_active_outlined, color: AppColors.textPrimary),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFilters().animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 24.0),
                    _buildLiveAnalytics().animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: 32.0),
                    _buildSectionTitle('تحديات اليوم').animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 16.0),
                    _buildDailyChallenges(),
                    const SizedBox(height: 32.0),
                    _buildSectionTitle('المسارات الروحية').animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 16.0),
                    _buildSpiritualPaths().animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                    const SizedBox(height: 100.0), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 38.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return ActionChip(
            label: Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            onPressed: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildLiveAnalytics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
        children: [
          Positioned(
            right: -20,
            top: -10,
            child: Icon(Icons.show_chart, size: 100, color: Colors.white.withValues(alpha: 0.1)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.trending_up, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'إحصائياتك الحية',
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'أنت اليوم أنجزت 10% أكثر من الأمس! 💪',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              // Mini chart visualization
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final heights = [10.0, 20.0, 15.0, 30.0, 25.0, 18.0, 35.0];
                  final isToday = index == 6;
                  return Expanded(
                    child: Container(
                      height: heights[index],
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                        color: isToday ? Colors.white : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
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

  Widget _buildDailyChallenges() {
    return SizedBox(
      height: 160.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildChallengeCard(
            title: 'تحدي الـ 5 دقائق',
            subtitle: 'أذكار الصباح السريعة',
            icon: Icons.timer_outlined,
            color: Colors.teal,
            actionText: 'ابدأ الآن',
            isSpecial: false,
          ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
          const SizedBox(width: 16.0),
          _buildChallengeCard(
            title: 'العداد التفاعلي',
            subtitle: 'المس الشاشة للتسبيح',
            icon: Icons.touch_app_outlined,
            color: Colors.purple.shade400,
            actionText: 'جرب الآن',
            isSpecial: false,
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
          const SizedBox(width: 16.0),
          _buildMysteryBoxCard().animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String actionText,
    required bool isSpecial,
  }) {
    return Container(
      width: 140.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              actionText,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMysteryBoxCard() {
    return Container(
      width: 140.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade300, Colors.deepOrange.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 40),
          const SizedBox(height: 12.0),
          const Text(
            'صندوق المفاجآت',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0),
          ),
          const SizedBox(height: 6.0),
          const Text(
            'أكمل 3 أنشطة لفتحه',
            style: TextStyle(color: Colors.white70, fontSize: 10.0),
          ),
          const SizedBox(height: 12.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: LinearProgressIndicator(
              value: 2 / 3, // 2 out of 3 activities
              minHeight: 6.0,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpiritualPaths() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildPathNode(
            title: 'مسار الطمأنينة',
            subtitle: 'نشاط ٣ أيام - أذكار القلق والراحة',
            icon: Icons.self_improvement,
            color: Colors.blue.shade300,
            isCompleted: true,
            isLast: false,
          ),
          _buildPathNode(
            title: 'بناء عادة',
            subtitle: 'نشاط ٢١ يوم - صلاة الضحى',
            icon: Icons.wb_sunny_rounded,
            color: Colors.orange.shade300,
            isCompleted: false,
            isActive: true,
            isLast: false,
            progress: 0.4,
          ),
          _buildPathNode(
            title: 'نور على نور',
            subtitle: 'قراءة سورة الكهف أسبوعياً',
            icon: Icons.menu_book,
            color: Colors.green.shade400,
            isCompleted: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPathNode({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isCompleted,
    bool isActive = false,
    required bool isLast,
    double? progress,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline graphics
          SizedBox(
            width: 40.0,
            child: Column(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: isCompleted || isActive ? color : color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: isActive ? Border.all(color: color.withValues(alpha: 0.3), width: 4.0) : null,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : icon,
                    color: isCompleted || isActive ? Colors.white : color,
                    size: 20.0,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.0,
                      color: isCompleted ? color : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: isActive ? color : Colors.grey.shade100, width: isActive ? 1.5 : 1.0),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.15),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (isActive)
                          const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 24),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (progress != null) ...[
                      const SizedBox(height: 12.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6.0,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
