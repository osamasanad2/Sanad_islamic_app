import 'package:go_router/go_router.dart';
import 'features/main/presentation/main_scaffold.dart';
import 'features/quran/presentation/screens/quran_screen.dart';
import 'features/tasbeeh/presentation/screens/tasbeeh_screen.dart';
import 'features/azkar/presentation/screens/azkar_screen.dart';
import 'features/prayer_times/presentation/screens/monthly_prayer_times_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScaffold(),
    ),
    GoRoute(
      path: '/quran',
      builder: (context, state) => const QuranScreen(),
    ),
    GoRoute(
      path: '/tasbeeh',
      builder: (context, state) => const TasbeehScreen(),
    ),
    GoRoute(
      path: '/azkar',
      builder: (context, state) => const AzkarScreen(),
    ),
    GoRoute(
      path: '/monthly-prayers',
      builder: (context, state) => const MonthlyPrayerTimesScreen(),
    ),
  ],
);
