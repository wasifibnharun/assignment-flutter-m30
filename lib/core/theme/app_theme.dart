import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const background = Color(0xFF0A0A0F);
  static const surface = Color(0xFF16151E);
  static const accent = Color(0xFFA999FF);
  static const muted = Color(0xFF92909F);
  static const text = Color(0xFFF4F2FA);
  static const border = Color(0xFF302D3D);
  static const accentGradient = LinearGradient(
    colors: [Color(0xFF9D88F9), Color(0xFF7660DC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        onPrimary: background,
        surface: surface,
        onSurface: text,
        outline: border,
      ),
    );
    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme)
          .apply(bodyColor: text, displayColor: text),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: accent.withValues(alpha: 0.25),
        selectionHandleColor: accent,
      ),
    );
  }
}
