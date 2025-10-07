import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (PawVerse Brand)
  static const Color primary = Color(0xFFFF6B35);        // #ff6b35
  static const Color primaryDark = Color(0xFFE85A2B);
  static const Color primaryLight = Color(0xFFFF8C61);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF2D3748);      // #2d3748
  static const Color secondaryDark = Color(0xFF1A202C);
  static const Color secondaryLight = Color(0xFF4A5568);
  
  // Background Colors
  static const Color background = Color(0xFFF7FAFC);
  static const Color surfaceWhite = Colors.white;
  static const Color surfaceGrey = Color(0xFFF5F5F5);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textHint = Color(0xFFA0AEC0);
  static const Color textWhite = Colors.white;
  
  // Status Colors
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF3182CE);
  
  // Additional Colors
  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFCBD5E0);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);
  
  // Input Colors
  static const Color inputBackground = Color(0xFFF7FAFC);
  static const Color inputBorder = Color(0xFFE2E8F0);
  
  // Badge Colors
  static const Color badgeRed = Color(0xFFE53E3E);
  static const Color badgeGreen = Color(0xFF38A169);
  static const Color badgeBlue = Color(0xFF3182CE);
  static const Color badgeYellow = Color(0xFFF59E0B);
  static const Color badgeGrey = Color(0xFF718096);
  
  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
