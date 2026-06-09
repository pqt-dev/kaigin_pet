import 'package:flutter/material.dart';
import 'package:kaigin_pet/presentation/theme/app_theme_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _seedColor = Color(0xFFFF8C69); // warm coral
  static const _lightBg = Color(0xFFFFF5EF);
  static const _lightSecondaryBg = Color(0xFFFFEDE3);
  static const _darkBg = Color(0xFF1C1410);
  static const _darkSecondaryBg = Color(0xFF2A1F1A);
  static const _darkText = Color(0xFF3D2B1F);
  static const _lightText = Color(0xFFFDF0E8);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: _lightBg,
    textTheme: GoogleFonts.titilliumWebTextTheme(ThemeData.light().textTheme),
    extensions: [_lightThemeExtension],
    appBarTheme: AppBarTheme(
      backgroundColor: _lightBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.titilliumWeb(
        color: _darkText,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: _darkText),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: _seedColor.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.titilliumWeb(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _seedColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );

  static final _lightThemeExtension = AppThemeExtension(
    colors: {
      Palette.primaryTextColor: _darkText,
      Palette.primaryBackground: _lightBg,
      Palette.secondaryBackground: _lightSecondaryBg,
      Palette.errorColor: Colors.red,
      Palette.primaryTextFieldBackground: const Color(0xFFFFF0E8),
      Palette.primaryButtonBackground: _seedColor,
      Palette.primaryButtonText: Colors.white,
    },
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: _darkBg,
    textTheme: GoogleFonts.titilliumWebTextTheme(ThemeData.dark().textTheme),
    extensions: [_darkThemeExtension],
    appBarTheme: AppBarTheme(
      backgroundColor: _darkBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.titilliumWeb(
        color: _lightText,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: _lightText),
    ),
    cardTheme: CardThemeData(
      color: _darkSecondaryBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkSecondaryBg,
      indicatorColor: _seedColor.withValues(alpha: 0.25),
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.titilliumWeb(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _seedColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );

  static final _darkThemeExtension = AppThemeExtension(
    colors: {
      Palette.primaryTextColor: _lightText,
      Palette.primaryBackground: _darkBg,
      Palette.secondaryBackground: _darkSecondaryBg,
      Palette.errorColor: Colors.redAccent,
      Palette.primaryTextFieldBackground: const Color(0xFF2E1F18),
      Palette.primaryButtonBackground: _seedColor,
      Palette.primaryButtonText: Colors.white,
    },
  );
}
