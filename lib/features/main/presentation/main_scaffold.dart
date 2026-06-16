import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/quran_native_service.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../../explore/presentation/screens/explore_screen.dart';
import '../../groups/presentation/screens/groups_screen.dart';
import '../../activities/presentation/screens/activities_screen.dart';
import '../../profile/presentation/screens/profile_screen.dart';
import '../logic/navigation_provider.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),          // 0 = الرئيسية
          SizedBox.shrink(),     // 1 = القرآن (external app)
          ExploreScreen(),       // 2 = الاستكشاف
          GroupsScreen(),        // 3 = المجتمع
          ActivitiesScreen(),    // 4 = الأنشطة
          ProfileScreen(),       // 5 = الملف الشخصي
        ],
      ),
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(
          color: context.appColors.surface,
          border: Border(
            top: BorderSide(color: context.appColors.textSecondary.withValues(alpha: 0.2), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'الرئيسية',
              index: 0,
              currentIndex: currentIndex,
              onTap: () => ref.read(navigationProvider.notifier).setIndex(0),
            ),
            _NavItem(
              icon: Icons.menu_book_outlined,
              activeIcon: Icons.menu_book_rounded,
              label: 'القرآن',
              index: 1,
              currentIndex: currentIndex,
              onTap: () => QuranNativeService.openQuran(),
            ),
            _NavItem(
              icon: Icons.explore_outlined,
              activeIcon: Icons.explore_rounded,
              label: 'استكشاف',
              index: 2,
              currentIndex: currentIndex,
              onTap: () => ref.read(navigationProvider.notifier).setIndex(2),
            ),
            _NavItem(
              icon: Icons.group_outlined,
              activeIcon: Icons.group_rounded,
              label: 'المجتمع',
              index: 3,
              currentIndex: currentIndex,
              onTap: () => ref.read(navigationProvider.notifier).setIndex(3),
            ),
            _NavItem(
              icon: Icons.local_activity_outlined,
              activeIcon: Icons.local_activity_rounded,
              label: 'الأنشطة',
              index: 4,
              currentIndex: currentIndex,
              onTap: () => ref.read(navigationProvider.notifier).setIndex(4),
            ),
            _NavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person_rounded,
              label: 'ملفي',
              index: 5,
              currentIndex: currentIndex,
              onTap: () => ref.read(navigationProvider.notifier).setIndex(5),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isActive ? context.appColors.primary.withValues(alpha: 0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  size: 24,
                  color: isActive ? context.appColors.primaryLight : const Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isActive ? context.appColors.primaryLight : const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
