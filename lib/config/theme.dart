import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.purple.shade400,
      secondary: Colors.purpleAccent,
      background: const Color(0xFF1A1A2E),
      surface: const Color(0xFF2A2A3E),
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A2E),
    cardTheme: CardTheme(
      color: const Color(0xFF2A2A3E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
