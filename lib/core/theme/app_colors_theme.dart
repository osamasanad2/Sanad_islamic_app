import 'package:flutter/material.dart';

class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color gold;
  final Color goldLight;
  final Color background;
  final Color surface;
  final Color error;
  final Color textPrimary;
  final Color textSecondary;

  const AppColorsTheme({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.gold,
    required this.goldLight,
    required this.background,
    required this.surface,
    required this.error,
    required this.textPrimary,
    required this.textSecondary,
  });

  static const light = AppColorsTheme(
    primary: Color(0xFF0E6B3A),
    primaryLight: Color(0xFF4CAF50),
    primaryDark: Color(0xFF07592F),
    gold: Color(0xFFD8B25A),
    goldLight: Color(0xFFE8D48B),
    background: Color(0xFFF7F8F5),
    surface: Colors.white,
    error: Color(0xFFB00020),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF6B6B6B),
  );

  static const dark = AppColorsTheme(
    primary: Color(0xFF0E6B3A),
    primaryLight: Color(0xFF4CAF50),
    primaryDark: Color(0xFF07592F),
    gold: Color(0xFFD8B25A),
    goldLight: Color(0xFFE8D48B),
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    error: Color(0xFFCF6679),
    textPrimary: Color(0xFFE0E0E0),
    textSecondary: Color(0xFF9E9E9E),
  );

  @override
  AppColorsTheme copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? gold,
    Color? goldLight,
    Color? background,
    Color? surface,
    Color? error,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return AppColorsTheme(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      gold: gold ?? this.gold,
      goldLight: goldLight ?? this.goldLight,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppColorsTheme lerp(ThemeExtension<AppColorsTheme>? other, double t) {
    if (other is! AppColorsTheme) return this;
    return AppColorsTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldLight: Color.lerp(goldLight, other.goldLight, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}
