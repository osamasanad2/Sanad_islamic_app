import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/social_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final social = ref.watch(socialProvider);
    final entries = social.leaderboard;
    final userEntry = entries.where((e) => e.isCurrentUser).firstOrNull;

    return Column(
      children: [
        _buildPeriodSelector(ref, social.selectedPeriod),
        const SizedBox(height: 16),
        _buildPodium(entries),
        const SizedBox(height: 20),
        if (userEntry != null && userEntry.rank > 3)
          _buildCurrentUserCard(userEntry),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              if (entry.isCurrentUser || entry.rank <= 3) {
                return const SizedBox.shrink();
              }
              return _buildLeaderboardRow(entry);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(WidgetRef ref, LeaderboardPeriod selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildPeriodTab(ref, 'أسبوعي', LeaderboardPeriod.weekly, selected),
            _buildPeriodTab(ref, 'شهري', LeaderboardPeriod.monthly, selected),
            _buildPeriodTab(ref, 'كل الوقت', LeaderboardPeriod.allTime, selected),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodTab(WidgetRef ref, String label, LeaderboardPeriod period, LeaderboardPeriod selected) {
    final isSelected = period == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(socialProvider.notifier).setPeriod(period),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodium(List<LeaderboardEntry> entries) {
    final top3 = entries.take(3).toList();
    if (top3.length < 3) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _buildPodiumItem(top3[1], 2, 130)),
            const SizedBox(width: 8),
            Expanded(child: _buildPodiumItem(top3[0], 1, 160)),
            const SizedBox(width: 8),
            Expanded(child: _buildPodiumItem(top3[2], 3, 110)),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumItem(LeaderboardEntry entry, int place, double height) {
    final colors = {
      1: const Color(0xFFFFD700),
      2: const Color(0xFFC0C0C0),
      3: const Color(0xFFCD7F32),
    };
    final color = colors[place]!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (place == 1)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: AppColors.gold, size: 28),
          )
        else
          const SizedBox(height: 40),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: place == 1 ? 22 : 18,
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text(
            entry.name.substring(0, 1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: place == 1 ? 18 : 14,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entry.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${entry.points} نقطة',
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: height * 0.4,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(
              '#$place',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: (place * 100).ms).slideY(begin: 0.3, curve: Curves.easeOutBack);
  }

  Widget _buildCurrentUserCard(LeaderboardEntry entry) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ترتيبي',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  '#${entry.rank} - ${entry.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${entry.points} نقطة',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
  }

  Widget _buildLeaderboardRow(LeaderboardEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              entry.name.substring(0, 1),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (entry.badge.isNotEmpty)
                  Text(
                    entry.badge,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.gold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 12, color: AppColors.gold),
                const SizedBox(width: 4),
                Text(
                  '${entry.points}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (entry.rank * 30).ms).slideX(begin: 0.05);
  }
}
