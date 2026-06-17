import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/main/presentation/main_scaffold.dart';
import 'features/tasbeeh/presentation/screens/tasbeeh_screen.dart';
import 'features/azkar/presentation/screens/azkar_screen.dart';
import 'features/prayer_times/presentation/screens/monthly_prayer_times_screen.dart';
import 'features/hisn/presentation/screens/hisn_screen.dart';
import 'features/hisn/presentation/screens/hisn_details_screen.dart';
import 'features/hisn/data/models/hisn_model.dart';
import 'features/qibla/presentation/screens/qibla_screen.dart';
import 'features/dua/presentation/screens/dua_screen.dart';
import 'features/seerah/presentation/screens/seerah_screen.dart';
import 'features/profile/presentation/screens/about_screen.dart';
import 'features/profile/presentation/screens/privacy_policy_screen.dart';
import 'features/profile/presentation/screens/terms_screen.dart';
import 'features/profile/presentation/screens/notifications_screen.dart';
import 'features/explore/presentation/screens/library_screen.dart';
import 'features/explore/presentation/screens/book_detail_screen.dart';
import 'features/explore/presentation/screens/zakat_screen.dart';
import 'features/explore/presentation/screens/asma_al_husna_screen.dart';
import 'features/explore/presentation/screens/islamic_event_detail_screen.dart';
import 'features/explore/presentation/screens/ruqyah_screen.dart';
import 'features/explore/presentation/screens/tajweed_screen.dart';
import 'features/explore/presentation/screens/muslim_woman_screen.dart';
import 'features/explore/presentation/screens/fiqh_screen.dart';
import 'features/explore/data/book_model.dart';
import 'features/explore/data/islamic_event_model.dart';
import 'features/profile/presentation/screens/font_settings_screen.dart';
import 'features/quran/presentation/screens/quran_screen.dart';
import 'features/quran/presentation/screens/quran_audio_screen.dart';
import 'features/profile/presentation/screens/adhan_settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/', builder: (context, state) => const MainScaffold()),
    GoRoute(path: '/tasbeeh', builder: (context, state) => const TasbeehScreen()),
    GoRoute(path: '/azkar', builder: (context, state) => const AzkarScreen()),
    GoRoute(path: '/qibla', builder: (context, state) => const QiblaScreen()),
    GoRoute(path: '/dua', builder: (context, state) => const DuaScreen()),
    GoRoute(path: '/seerah', builder: (context, state) => const SeerahScreen()),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    GoRoute(path: '/library', builder: (context, state) => const LibraryScreen()),
    GoRoute(path: '/zakat', builder: (context, state) => const ZakatScreen()),
    GoRoute(
      path: '/library/book',
      builder: (context, state) {
        final book = state.extra as Book;
        return BookDetailScreen(book: book);
      },
    ),
    GoRoute(path: '/asma-al-husna',
        builder: (context, state) => const AsmaAlHusnaScreen()),
    GoRoute(path: '/ruqyah',
        builder: (context, state) => const RuqyahScreen()),
    GoRoute(path: '/tajweed',
        builder: (context, state) => const TajweedScreen()),
    GoRoute(path: '/muslim-woman',
        builder: (context, state) => const MuslimWomanScreen()),
    GoRoute(path: '/fiqh',
        builder: (context, state) => const FiqhScreen()),
    GoRoute(
      path: '/islamic-event',
      builder: (context, state) {
        final event = state.extra as IslamicEvent;
        return IslamicEventDetailScreen(event: event);
      },
    ),
    GoRoute(path: '/fonts', builder: (context, state) => const FontSettingsScreen()),
    GoRoute(path: '/privacy-policy', builder: (context, state) => const PrivacyPolicyScreen()),
    GoRoute(path: '/terms', builder: (context, state) => const TermsScreen()),
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    GoRoute(path: '/quran', builder: (context, state) => const QuranScreen()),
    GoRoute(path: '/quran-audio', builder: (context, state) => const QuranAudioScreen()),
    GoRoute(path: '/adhan-settings', builder: (context, state) => const AdhanSettingsScreen()),
    GoRoute(path: '/hisn', builder: (context, state) => const HisnScreen()),
    GoRoute(
      path: '/monthly-prayers',
      builder: (context, state) => const MonthlyPrayerTimesScreen(),
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
