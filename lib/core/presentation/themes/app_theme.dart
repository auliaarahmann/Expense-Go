import 'package:flutter/material.dart';

class AppColors {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color onBackground;
  final Color onSurface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onError;

  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.onBackground,
    required this.onSurface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onError,
  });

  factory AppColors.light() {
    return const AppColors(
      primary: Color(0xFF3F51B5),
      primaryDark: Color(0xFF303F9F),
      primaryLight: Color(0xFFC5CAE9),
      secondary: Color(0xFFFF9800),
      accent: Color(0xFFE91E63),
      background: Color(0xFFFAFAFA),
      surface: Color(0xFFFFFFFF),
      onBackground: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      error: Color(0xFFB00020),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFF000000),
      onError: Color(0xFFFFFFFF),
    );
  }

  factory AppColors.dark() {
    return const AppColors(
      primary: Color(0xFF7986CB),
      primaryDark: Color(0xFF5C6BC0),
      primaryLight: Color(0xFF9FA8DA),
      secondary: Color(0xFFFFA726),
      accent: Color(0xFFEC407A),
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      onBackground: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      error: Color(0xFFCF6679),
      onPrimary: Color(0xFF000000),
      onSecondary: Color(0xFF000000),
      onError: Color(0xFF000000),
    );
  }
}

class AppTextTheme {
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  const AppTextTheme({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  factory AppTextTheme.light() {
    return AppTextTheme(
      displayLarge: const TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: const TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.15,
      ),
      displaySmall: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
      ),
      headlineLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
      headlineMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.29,
      ),
      headlineSmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
      titleLarge: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.27,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
}

class AppTheme {
  final AppColors colors;
  final AppTextTheme textTheme;
  final Brightness brightness;

  const AppTheme({
    required this.colors,
    required this.textTheme,
    required this.brightness,
  });

  factory AppTheme.light() {
    return AppTheme(
      colors: AppColors.light(),
      textTheme: AppTextTheme.light(),
      brightness: Brightness.light,
    );
  }

  factory AppTheme.dark() {
    return AppTheme(
      colors: AppColors.dark(),
      textTheme: AppTextTheme.light(), // Using same text theme for dark mode
      brightness: Brightness.dark,
    );
  }

  ThemeData toThemeData() {
    return ThemeData(
      colorScheme: ColorScheme(
        primary: colors.primary,
        primaryContainer: colors.primaryDark,
        secondary: colors.secondary,
        // ignore: deprecated_member_use
        secondaryContainer: colors.secondary.withOpacity(0.8),
        surface: colors.surface,
        // ignore: deprecated_member_use
        background: colors.background,
        error: colors.error,
        onPrimary: colors.onPrimary,
        onSecondary: colors.onSecondary,
        onSurface: colors.onSurface,
        // ignore: deprecated_member_use
        onBackground: colors.onBackground,
        onError: colors.onError,
        brightness: brightness,
      ),
      textTheme: TextTheme(
        displayLarge: textTheme.displayLarge,
        displayMedium: textTheme.displayMedium,
        displaySmall: textTheme.displaySmall,
        headlineLarge: textTheme.headlineLarge,
        headlineMedium: textTheme.headlineMedium,
        headlineSmall: textTheme.headlineSmall,
        titleLarge: textTheme.titleLarge,
        titleMedium: textTheme.titleMedium,
        titleSmall: textTheme.titleSmall,
        bodyLarge: textTheme.bodyLarge,
        bodyMedium: textTheme.bodyMedium,
        bodySmall: textTheme.bodySmall,
        labelLarge: textTheme.labelLarge,
        labelMedium: textTheme.labelMedium,
        labelSmall: textTheme.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
    );
  }

  static AppTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark
        ? AppTheme.dark()
        : AppTheme.light();
  }
}
