import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../../quran/presentation/screens/quran_screen.dart';
import '../../profile/presentation/screens/profile_screen.dart';
import '../../activities/presentation/screens/activities_screen.dart';
import '../../groups/presentation/screens/groups_screen.dart';
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
          HomeScreen(),
          QuranScreen(),
          GroupsScreen(),
          ActivitiesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => ref.read(navigationProvider.notifier).setIndex(index),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primaryDark),
            label: 'الرئيسة',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: AppColors.primaryDark),
            label: 'القرآن',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group, color: AppColors.primaryDark),
            label: 'المجموعات',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_activity_outlined),
            selectedIcon: Icon(Icons.local_activity, color: AppColors.primaryDark),
            label: 'الأنشطة',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primaryDark),
            label: 'ملفي',
          ),
        ],
      ),
    );
  }
}
