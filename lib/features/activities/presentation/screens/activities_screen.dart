import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/activity_models.dart';
import '../../data/activity_provider.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> {
  String _selectedFilter = 'الكل';
  final List<String> _filters = ['الكل', 'صلاة', 'قرآن', 'أذكار', 'تحديات'];

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(activityProvider);

    if (activityState.isLoading) {
      return Scaffold(
        backgroundColor: context.appColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: context.appColors.background,
              title: Text(
                'الأنشطة',
                style: TextStyle(
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_active_outlined,
                    color: context.appColors.textPrimary,
                  ),
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
                    if (activityState.currentSeason != null)
                      _buildSeasonalBanner(activityState.currentSeason!)
                          .animate()
                          .fadeIn(delay: 150.ms),
                    const SizedBox(height: 16.0),
                    _buildLiveAnalytics(activityState.userStats)
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.1),
                    const SizedBox(height: 32.0),
                    _buildSectionTitle(
                      'تحديات اليوم',
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 16.0),
                    _buildDailyChallenges(activityState.dailyActivities),
                    if (activityState.weeklyChallenges.isNotEmpty) ...[
                      const SizedBox(height: 32.0),
                      _buildSectionTitle(
                        'التحديات الأسبوعية',
                      ).animate().fadeIn(delay: 350.ms),
                      const SizedBox(height: 16.0),
                      _buildWeeklyChallenges(activityState.weeklyChallenges),
                    ],
                    if (activityState.monthlyGoals.isNotEmpty) ...[
                      const SizedBox(height: 32.0),
                      _buildSectionTitle(
                        'أهداف الشهر',
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 16.0),
                      _buildMonthlyGoals(activityState.monthlyGoals),
                    ],
                    if (activityState.seasonalActivities.isNotEmpty) ...[
                      const SizedBox(height: 32.0),
                      _buildSeasonalSection(activityState),
                    ],
                    const SizedBox(height: 32.0),
                    _buildSectionTitle(
                      'المسارات الروحية',
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 16.0),
                    _buildSpiritualPaths(activityState.spiritualPaths)
                        .animate()
                        .fadeIn(delay: 500.ms)
                        .slideY(begin: 0.1),
                    const SizedBox(height: 100.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonalBanner(String season) {
    String title;
    IconData icon;
    Color color;
    switch (season) {
      case 'ramadan':
        title = 'رمضان مبارك';
        icon = Icons.nightlight;
        color = const Color(0xFF1B5E20);
      case 'eid_fitr':
        title = 'عيد الفطر';
        icon = Icons.celebration;
        color = AppColors.primary;
      case 'eid_adha':
        title = 'عيد الأضحى';
        icon = Icons.celebration;
        color = AppColors.primary;
      case 'arafah':
        title = 'يوم عرفة';
        icon = Icons.wb_sunny;
        color = Colors.orange;
      case 'dhul_hijjah':
        title = 'عشر ذي الحجة';
        icon = Icons.calendar_month;
        color = const Color(0xFF795548);
      case 'ashura':
        title = 'عاشوراء';
        icon = Icons.restaurant;
        color = const Color(0xFF5D4037);
      default:
        return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'أنشطة موسمية',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalSection(ActivityState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('أنشطة موسمية').animate().fadeIn(delay: 450.ms),
        const SizedBox(height: 16.0),
        ...state.seasonalActivities.map((a) => _buildSeasonalTile(a)),
      ],
    );
  }

  Widget _buildSeasonalTile(Activity activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: activity.isCompleted
                ? Colors.green.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.1),
          ),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activity.isCompleted
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.isCompleted ? Icons.check_circle : activity.icon,
              color: activity.isCompleted ? Colors.green : Colors.amber,
              size: 24,
            ),
          ),
          title: Text(
            activity.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: activity.isCompleted
                  ? context.appColors.textSecondary
                  : context.appColors.textPrimary,
            ),
          ),
          subtitle: Text(
            activity.description,
            style: TextStyle(
              fontSize: 12,
              color: context.appColors.textSecondary,
            ),
          ),
          trailing: activity.isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green, size: 22)
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ابدأ',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
          onTap: activity.isCompleted
              ? null
              : () => ref.read(activityProvider.notifier).completeActivity(activity.id),
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
                color: isSelected ? Colors.white : context.appColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            backgroundColor: isSelected ? AppColors.primary : context.appColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.2),
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

  Widget _buildLiveAnalytics(UserStats stats) {
    final pct = stats.dailyGoal > 0
        ? (stats.totalCompletedToday / stats.dailyGoal * 100).round()
        : 0;

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
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.show_chart,
                size: 100,
                color: Colors.white,
              ),
            ),
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
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'إحصائياتك الحية',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                stats.totalCompletedToday > 0
                    ? 'أكملت ${stats.totalCompletedToday} من ${stats.dailyGoal} أنشطة اليوم ($pct%)'
                    : 'ابدأ أول نشاط لك اليوم! 💪',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatChip(Icons.emoji_events, 'المستوى ${stats.level}'),
                  const SizedBox(width: 12),
                  _buildStatChip(Icons.star, '${stats.xp} XP'),
                  const SizedBox(width: 12),
                  _buildStatChip(Icons.local_fire_department, '${stats.streakDays} يوم'),
                ],
              ),
              const SizedBox(height: 16.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: LinearProgressIndicator(
                  value: stats.progressToNextLevel,
                  minHeight: 6.0,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
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
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: context.appColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildDailyChallenges(List<Activity> activities) {
    if (activities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'لا توجد تحديات اليوم',
          style: TextStyle(color: context.appColors.textSecondary),
        ),
      );
    }
    return SizedBox(
      height: 160.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          ...activities.asMap().entries.map((entry) {
            final i = entry.key;
            final a = entry.value;
            return Padding(
              padding: EdgeInsets.only(left: i < activities.length - 1 ? 16 : 0),
              child: _buildChallengeCard(a).animate().fadeIn(
                delay: (300 + i * 100).ms,
              ).slideX(begin: 0.1),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(Activity activity) {
    Color getCategoryColor() {
      switch (activity.category) {
        case ActivityCategory.quran:
          return Colors.teal;
        case ActivityCategory.azkar:
          return Colors.amber.shade700;
        case ActivityCategory.prayer:
          return Colors.green;
        case ActivityCategory.hadith:
          return Colors.indigo;
        case ActivityCategory.dua:
          return Colors.purple.shade400;
        case ActivityCategory.seerah:
          return Colors.brown;
        case ActivityCategory.challenge:
          return Colors.deepOrange;
      }
    }

    final color = getCategoryColor();

    return Container(
      width: 140.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: activity.isCompleted
            ? Colors.green.withValues(alpha: 0.08)
            : context.appColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: activity.isCompleted
              ? Colors.green.withValues(alpha: 0.3)
              : color.withValues(alpha: 0.2),
          width: 1.5,
        ),
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
              color: activity.isCompleted
                  ? Colors.green.withValues(alpha: 0.15)
                  : color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.isCompleted ? Icons.check_circle : activity.icon,
              color: activity.isCompleted ? Colors.green : color,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            activity.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: activity.isCompleted
                  ? context.appColors.textSecondary
                  : context.appColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            activity.description,
            style: TextStyle(
              fontSize: 10.0,
              color: context.appColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12.0),
          GestureDetector(
            onTap: activity.isCompleted
                ? null
                : () => ref.read(activityProvider.notifier).completeActivity(activity.id),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                color: activity.isCompleted ? Colors.green : color,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                activity.isCompleted ? 'تم ✓' : 'ابدأ',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChallenges(List<Activity> challenges) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: challenges.map((c) => _buildWeeklyTile(c)).toList(),
      ),
    );
  }

  Widget _buildWeeklyTile(Activity challenge) {
    Color getColor() {
      switch (challenge.category) {
        case ActivityCategory.quran:
          return Colors.teal;
        case ActivityCategory.azkar:
          return Colors.amber.shade700;
        case ActivityCategory.prayer:
          return Colors.green;
        case ActivityCategory.hadith:
          return Colors.indigo;
        case ActivityCategory.dua:
          return Colors.purple.shade400;
        case ActivityCategory.seerah:
          return Colors.brown;
        case ActivityCategory.challenge:
          return Colors.deepOrange;
      }
    }

    final color = getColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: challenge.isCompleted
                ? Colors.green.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: challenge.isCompleted
                  ? Colors.green.withValues(alpha: 0.1)
                  : color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              challenge.isCompleted ? Icons.check_circle : challenge.icon,
              color: challenge.isCompleted ? Colors.green : color,
              size: 22,
            ),
          ),
          title: Text(
            challenge.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: challenge.isCompleted
                  ? context.appColors.textSecondary
                  : context.appColors.textPrimary,
            ),
          ),
          subtitle: Text(
            challenge.description,
            style: TextStyle(
              fontSize: 12,
              color: context.appColors.textSecondary,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: challenge.isCompleted ? Colors.green : color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${challenge.xpReward} XP',
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
          onTap: challenge.isCompleted
              ? null
              : () => ref.read(activityProvider.notifier).completeActivity(challenge.id),
        ),
      ),
    );
  }

  Widget _buildMonthlyGoals(List<Activity> goals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: goals.map((g) => _buildMonthlyTile(g)).toList(),
      ),
    );
  }

  Widget _buildMonthlyTile(Activity goal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          gradient: goal.isCompleted
              ? null
              : const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: goal.isCompleted ? Colors.green.withValues(alpha: 0.08) : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: goal.isCompleted
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              goal.isCompleted ? Icons.check_circle : goal.icon,
              color: goal.isCompleted ? Colors.green : Colors.white,
              size: 28,
            ),
          ),
          title: Text(
            goal.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: goal.isCompleted
                  ? context.appColors.textPrimary
                  : Colors.white,
            ),
          ),
          subtitle: Text(
            goal.description,
            style: TextStyle(
              fontSize: 12,
              color: goal.isCompleted
                  ? context.appColors.textSecondary
                  : Colors.white70,
            ),
          ),
          trailing: goal.isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${goal.xpReward} XP',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
          onTap: goal.isCompleted
              ? null
              : () => ref.read(activityProvider.notifier).completeActivity(goal.id),
        ),
      ),
    );
  }

  Widget _buildSpiritualPaths(List<SpiritualPath> paths) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: paths.map((path) => _buildPathNode(path)).toList(),
      ),
    );
  }

  Widget _buildPathNode(SpiritualPath path) {
    final isFirst = path.id == 'tranquility';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40.0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: path.isActive || path.isCompleted
                      ? null
                      : () => ref.read(activityProvider.notifier).startPath(
                            _pathIndex(path.id),
                          ),
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: path.isCompleted || path.isActive
                          ? path.color
                          : path.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: path.isActive && !path.isCompleted
                          ? Border.all(
                              color: path.color.withValues(alpha: 0.3),
                              width: 4.0,
                            )
                          : null,
                    ),
                    child: Icon(
                      path.isCompleted ? Icons.check : path.icon,
                      color: path.isCompleted || path.isActive
                          ? Colors.white
                          : path.color,
                      size: 20.0,
                    ),
                  ),
                ),
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 2.0,
                      color: path.isCompleted
                          ? path.color
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: context.appColors.surface,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: path.isActive && !path.isCompleted
                        ? path.color
                        : Colors.grey.shade100,
                    width: path.isActive && !path.isCompleted ? 1.5 : 1.0,
                  ),
                  boxShadow: path.isActive && !path.isCompleted
                      ? [
                          BoxShadow(
                            color: path.color.withValues(alpha: 0.15),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            path.title,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: context.appColors.textPrimary,
                            ),
                          ),
                        ),
                        if (path.isActive && !path.isCompleted)
                          const Icon(
                            Icons.play_circle_fill,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        if (path.isCompleted)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 24,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      path.description,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!path.isCompleted)
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: LinearProgressIndicator(
                                value: path.overallProgress,
                                minHeight: 6.0,
                                backgroundColor: Colors.grey.shade200,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(path.color),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(path.overallProgress * 100).round()}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    if (path.isActive && !path.isCompleted && path.currentStageIndex < path.stages.length)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: path.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.flag, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'التالي: ${path.stages[path.currentStageIndex].title}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context.appColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => ref.read(activityProvider.notifier)
                                    .advancePathStage(_pathIndex(path.id)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'أكمل',
                                    style: TextStyle(color: Colors.white, fontSize: 11),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _pathIndex(String id) {
    return ['tranquility', 'habit_builder', 'quran_path', 'azkar_path', 'istighfar_path', 'prayer_path']
        .indexOf(id);
  }
}
