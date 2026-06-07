import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/main/presentation/main_scaffold.dart';
import 'features/tasbeeh/presentation/screens/tasbeeh_screen.dart';
import 'features/azkar/presentation/screens/azkar_screen.dart';
import 'features/prayer_times/presentation/screens/monthly_prayer_times_screen.dart';
import 'features/hisn/presentation/screens/hisn_screen.dart';
import 'features/hisn/presentation/screens/hisn_details_screen.dart';
import 'features/hisn/data/models/hisn_model.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScaffold(),
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
    GoRoute(
      path: '/hisn',
      builder: (context, state) => const HisnScreen(),
    ),
    GoRoute(
      path: '/hisn/details',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return HisnDetailsScreen(
          category: extra['category'] as HisnCategory,
          color: extra['color'] as Color,
        );
      },
    ),
  ],
);
