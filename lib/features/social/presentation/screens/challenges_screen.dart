import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/social_provider.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  Color _categoryColor(ChallengeCategory category) {
    switch (category) {
      case ChallengeCategory.quran:
        return Colors.teal;
      case ChallengeCategory.tasbeeh:
        return Colors.amber.shade700;
      case ChallengeCategory.azkar:
        return Colors.green;
      case ChallengeCategory.prayer:
        return AppColors.primary;
      case ChallengeCategory.general:
        return Colors.deepOrange;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final social = ref.watch(socialProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildUserProgressCard(social),
          const SizedBox(height: 24),
          _buildSectionTitle('تحديات اليوم'),
          const SizedBox(height: 12),
          if (social.dailyChallenges.isEmpty)
            _buildNoChallenges()
          else
            ...social.dailyChallenges.map((c) => _buildChallengeCard(c, ref)),
          const SizedBox(height: 24),
          _buildSectionTitle('تحديات الأسبوع'),
          const SizedBox(height: 12),
          if (social.weeklyChallenges.isEmpty)
            _buildNoChallenges()
          else
            ...social.weeklyChallenges.map((c) => _buildChallengeCard(c, ref)),
          const SizedBox(height: 24),
          _buildRewardsSection(social),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildUserProgressCard(SocialState social) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -10,
            top: -10,
            child: Opacity(
              opacity: 0.08,
              child: const Icon(Icons.emoji_events, size: 100, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.trending_up, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'تحدياتي',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildXpChip(Icons.star, '${social.userPoints} XP'),
                  const SizedBox(width: 8),
                  _buildXpChip(Icons.emoji_events, 'المستوى ${social.userLevel}'),
                  const SizedBox(width: 8),
                  _buildXpChip(Icons.local_fire_department, '${social.userStreak} يوم'),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (social.userPoints % 100) / 100,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${social.userPoints % 100}/100 XP للمستوى التالي',
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildXpChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildNoChallenges() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'لا توجد تحديات متاحة',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(DailyChallenge challenge, WidgetRef ref) {
    final color = _categoryColor(challenge.category);
    final isCompleted = challenge.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.withValues(alpha: 0.06) : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withValues(alpha: 0.3)
              : color.withValues(alpha: 0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withValues(alpha: 0.15)
                      : color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : challenge.icon,
                  color: isCompleted ? Colors.green : color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      challenge.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${challenge.xpReward} XP',
                  style: TextStyle(
                    color: isCompleted ? Colors.white : AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: challenge.progress,
                    minHeight: 6,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? Colors.green : color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${challenge.currentCount}/${challenge.targetCount}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              if (!isCompleted && challenge.targetCount > 1)
                GestureDetector(
                  onTap: () {
                    ref.read(socialProvider.notifier).updateChallengeProgress(challenge.id, 1);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+1',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              if (!isCompleted && challenge.targetCount == 1)
                GestureDetector(
                  onTap: () => ref.read(socialProvider.notifier).completeChallenge(challenge.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'أكمل',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 14, color: Colors.green),
                      SizedBox(width: 2),
                      Text(
                        'تم',
                        style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildRewardsSection(SocialState social) {
    final totalCompleted = [
      ...social.dailyChallenges,
      ...social.weeklyChallenges,
    ].where((c) => c.isCompleted).length;
    final total = social.dailyChallenges.length + social.weeklyChallenges.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.card_giftcard, color: AppColors.gold, size: 22),
              const SizedBox(width: 8),
              const Text(
                'المكافآت',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRewardItem(Icons.check_circle, 'تم $totalCompleted/$total'),
              const SizedBox(width: 12),
              _buildRewardItem(Icons.star, '${social.userPoints} XP'),
              const SizedBox(width: 12),
              _buildRewardItem(Icons.local_fire_department, '${social.userStreak} يوم'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
