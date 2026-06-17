import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/shared_prefs_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/localization/locale_provider.dart';
import 'core/localization/generated/app_localizations.dart';
import 'core/providers/font_provider.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final firebaseService = FirebaseService();
  await firebaseService.initialize();

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final fontFamily = ref.watch(fontProvider);

    return MaterialApp.router(
      title: 'Sanad App',
      locale: locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('fa'),
      ],
      localizationsDelegates: const [
        SanadLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: _withFont(AppTheme.light, fontFamily),
      darkTheme: _withFont(AppTheme.dark, fontFamily),
      themeMode: themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final dir = _isRtl(context) ? TextDirection.rtl : TextDirection.ltr;
        return Directionality(textDirection: dir, child: child!);
      },
    );
  }
}

bool _isRtl(BuildContext context) {
  final locale = Localizations.localeOf(context);
  return locale.languageCode == 'ar' || locale.languageCode == 'fa';
}

ThemeData _withFont(ThemeData theme, String fontFamily) {
  GoogleFonts.getFont(fontFamily);
  return ThemeData(
    useMaterial3: theme.useMaterial3,
    fontFamily: fontFamily,
    brightness: theme.brightness,
    colorScheme: theme.colorScheme,
    scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
    appBarTheme: theme.appBarTheme,
    cardTheme: theme.cardTheme,
    bottomNavigationBarTheme: theme.bottomNavigationBarTheme,
    dialogTheme: theme.dialogTheme,
    bottomSheetTheme: theme.bottomSheetTheme,
    iconTheme: theme.iconTheme,
    dividerTheme: theme.dividerTheme,
    extensions: theme.extensions.values.toList(),
  );
}
