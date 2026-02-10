import 'package:flutter/material.dart';

/// Tahir Showroom Color System
/// Based on UI_colors_and_design_file.md
/// 
/// Dark Theme is the DEFAULT (Executive Command Center)
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME (DEFAULT - Executive Command Center)
  // ═══════════════════════════════════════════════════════════════════════════

  // Primary Colors (Dark)
  static const Color darkPrimary = Color(0xFF06b6d4);        // Cyan
  static const Color darkPrimaryHover = Color(0xFF0891b2);   // Cyan darker
  static const Color darkPrimaryLight = Color(0x1A06b6d4);   // Cyan 10% opacity

  // Background Colors (Dark)
  static const Color darkBackground = Color(0xFF0a0e17);     // Deepest navy
  static const Color darkSurface = Color(0xFF0f172a);        // Cards, panels
  static const Color darkCard = Color(0xFF1e293b);           // Elevated cards
  static const Color darkElevated = Color(0xFF1e293b);       // Inputs, hover
  static const Color darkBorder = Color(0xFF1e293b);         // Card borders
  static const Color darkBorderInput = Color(0xFF334155);    // Input borders

  // Text Colors (Dark)
  static const Color darkTextPrimary = Color(0xFFFFFFFF);    // White
  static const Color darkTextSecondary = Color(0xFFcbd5e1);  // Slate 300
  static const Color darkTextMuted = Color(0xFF94a3b8);      // Slate 400
  static const Color darkTextDisabled = Color(0xFF64748b);   // Slate 500

  // Semantic Colors (Dark)
  static const Color darkSuccess = Color(0xFF10b981);        // Emerald
  static const Color darkWarning = Color(0xFFf59e0b);        // Amber
  static const Color darkError = Color(0xFFef4444);          // Red
  static const Color darkInfo = Color(0xFF06b6d4);           // Cyan

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME (Windows 11 Fluent)
  // ═══════════════════════════════════════════════════════════════════════════

  // Primary Colors (Light)
  static const Color lightPrimary = Color(0xFF0078D4);       // Blue
  static const Color lightPrimaryHover = Color(0xFF106EBE);  // Blue darker
  static const Color lightPrimaryLight = Color(0xFFE8F4FD);  // Blue light bg

  // Gradient Colors (Light)
  static const Color lightGradientDark = Color(0xFF1a5276);  // KPI gradient start
  static const Color lightGradientLight = Color(0xFF2980b9); // KPI gradient end

  // Background Colors (Light)
  static const Color lightBackground = Color(0xFFF3F4F6);    // Grey 100 (Off-white background)
  static const Color lightSurface = Color(0xFFFFFFFF);       // Pure White (Cards, Sidebar)
  static const Color lightFormBgStart = Color(0xFFE3F2FD);   // Form gradient start
  static const Color lightFormBgEnd = Color(0xFFBBDEFB);     // Form gradient end
  static const Color lightRowAlternate = Color(0xFFF9FAFB);  // Table rows

  // Text Colors (Light)
  static const Color lightTextPrimary = Color(0xFF111827);   // Grey 900 (High contrast)
  static const Color lightTextSecondary = Color(0xFF4B5563); // Grey 600
  static const Color lightTextMuted = Color(0xFF9CA3AF);     // Grey 400
  static const Color lightTextWhite = Color(0xFFFFFFFF);
  static const Color lightTextWhiteMuted = Color(0xCCFFFFFF); // 80% opacity

  // Semantic Colors (Light)
  static const Color lightSuccess = Color(0xFF16A34A);       // Green 600
  static const Color lightSuccessLight = Color(0xFFDCFCE7);  // Green 100
  static const Color lightWarning = Color(0xFFF97316);       // Orange 500
  static const Color lightError = Color(0xFFDC2626);         // Red 600

  // Border Colors (Light)
  static const Color lightBorder = Color(0xFFD1D5DB);        // Grey 300 (Visible border)
  static const Color lightBorderLight = Color(0xFFE5E7EB);   // Grey 200
  static const Color lightBorderDashed = Color(0xFF9CA3AF);  // Grey 400

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS BADGE COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color badgeAvailableBg = Color(0xFFDCFCE7);   // Green 100
  static const Color badgeAvailableText = Color(0xFF16A34A); // Green 600
  static const Color badgePendingBg = Color(0xFFFEF3C7);     // Amber 100
  static const Color badgePendingText = Color(0xFFD97706);   // Amber 600
  static const Color badgeSoldBg = Color(0xFFDBEAFE);        // Blue 100
  static const Color badgeSoldText = Color(0xFF2563EB);      // Blue 600

  // ═══════════════════════════════════════════════════════════════════════════
  // KPI GRADIENT
  // ═══════════════════════════════════════════════════════════════════════════

  static const LinearGradient kpiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightGradientDark, lightGradientLight],
  );
}

// Authored by: Moazzam Samoo
