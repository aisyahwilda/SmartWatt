// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color lightTeal = Color(0xFFCDE8E5); // #CDE8E5
  static const Color paleBlue = Color(0xFFEFF1F5); // #EFF1F5
  static const Color teal = Color(0xFF7AB2B2); // #7AB2B2
  static const Color deepTeal = Color(0xFF4D869C); // #4D869C

  static const Color textDark = Color(0xFF0B2B2B);
  static const Color textLight = Colors.white;

  static const Color background = Color(0xFFEFF1F5); // #EFF1F5

  // Predefined opacity variants (avoid runtime .withOpacity calls)
  static const Color deepTeal50 = Color(0x804D869C); // deepTeal 50%
  static const Color deepTeal40 = Color(0x664D869C); // deepTeal 40%
  static const Color deepTeal12 = Color(0x1F4D869C); // deepTeal 12%

  static const Color teal50 = Color(0x807AB2B2); // teal 50%
  static const Color teal95 = Color(0xF27AB2B2); // teal 95%

  static const Color textDark80 = Color(0xCC0B2B2B); // textDark 80%

  static const Color black80 = Color(0xCC000000); // black 80%
  static const Color black90 = Color(0xE6000000); // black 90%
  static const Color black06 = Color(0x0F000000); // black 6%

  static const Color red10 = Color(0x1AFF0000); // red 10%

  // Success color for check icons and snackbars
  static const Color successGreen = Color(0xFF2E7D32); // Material Green 800
}
