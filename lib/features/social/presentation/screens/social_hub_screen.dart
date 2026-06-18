import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/social_provider.dart';
import 'leaderboard_screen.dart';
import 'challenges_screen.dart';
import 'group_khatmah_screen.dart';

class SocialHubScreen extends ConsumerStatefulWidget {
  const SocialHubScreen({super.key});

  @override
  ConsumerState<SocialHubScreen> createState() => _SocialHubScreenState();
}

class _SocialHubScreenState extends ConsumerState<SocialHubScreen> {
  int _currentTab = 0;

  static const _tabs = [
    ('لوحة المتصدرين', Icons.emoji_events),
    ('التحديات', Icons.local_fire_department),
    ('الختمات', Icons.group),
  ];

  @override
  Widget build(BuildContext context) {
    final social = ref.watch(socialProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(social),
            ),
            SliverToBoxAdapter(
              child: _buildTabBar(),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: IndexedStack(
                index: _currentTab,
                children: const [
                  LeaderboardScreen(),
                  ChallengesScreen(),
                  GroupKhatmahScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(SocialState social) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.06,
              child: CustomPaint(
                size: const Size(120, 120),
                painter: _IslamicPatternPainter(),
              ),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.06,
              child: CustomPaint(
                size: const Size(80, 80),
                painter: _IslamicPatternPainter(),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المجتمع',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${social.userLevel}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'المستوى ${social.userLevel}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.diversity_3,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildStatChip(Icons.star, '${social.userPoints} XP'),
                  const SizedBox(width: 8),
                  _buildStatChip(Icons.local_fire_department, '${social.userStreak} يوم'),
                  const SizedBox(width: 8),
                  _buildStatChip(Icons.emoji_events, 'المستوى ${social.userLevel}'),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (social.userPoints % 100) / 100,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${social.userPoints % 100}/100 XP إلى المستوى ${social.userLevel + 1}',
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, curve: Curves.easeOutBack);
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.gold, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(4),
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
        children: List.generate(_tabs.length, (index) {
          final label = _tabs[index].$1;
          final icon = _tabs[index].$2;
          final isSelected = index == _currentTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.35;

    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 3.14159 * 2 / 8) - 3.14159 / 8;
      final x = cx + r * _cos(angle);
      final y = cy + r * _sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double a) => math.cos(a);
  double _sin(double a) => math.sin(a);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
