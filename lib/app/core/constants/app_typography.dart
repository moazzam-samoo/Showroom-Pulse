import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tahir Showroom Typography System
/// Based on UI_colors_and_design_file.md
class AppTypography {
  AppTypography._();

  // Font Family - Outfit with Roboto fallback
  static String get fontFamily => 'Outfit';

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPE SCALE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Display - 30px, Bold (700) - Hero titles, main page headers
  static TextStyle display({Color? color}) => GoogleFonts.outfit(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: color,
  );

  /// Heading 1 - 24px, Bold (700) - Page titles, form headers
  static TextStyle h1({Color? color}) => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: color,
  );

  /// Heading 2 - 20px, Bold (700) - Section titles
  static TextStyle h2({Color? color}) => GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: color,
  );

  /// Heading 3 - 16px, SemiBold (600) - Card titles, panel headers
  static TextStyle h3({Color? color}) => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: color,
  );

  /// Body - 14px, Regular (400) - Body text, descriptions
  static TextStyle body({Color? color}) => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );

  /// Body Medium - 14px, Medium (500) - Table cells, form values
  static TextStyle bodyMedium({Color? color}) => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: color,
  );

  /// Body Bold - 14px, SemiBold (600) - Emphasis, amounts
  static TextStyle bodyBold({Color? color}) => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: color,
  );

  /// Caption - 12px, Regular (400) - Timestamps, metadata, hints
  static TextStyle caption({Color? color}) => GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: color,
  );

  /// Micro - 10px, Regular (400) - Navigation labels, badges
  static TextStyle micro({Color? color}) => GoogleFonts.outfit(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: color,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // KPI SPECIFIC STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// KPI Value - 24px, Bold - Large numbers on KPI cards
  static TextStyle kpiValue({Color? color}) => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: color,
  );

  /// KPI Label - 14px, Regular - Labels on KPI cards
  static TextStyle kpiLabel({Color? color}) => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // FORM SPECIFIC STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Input Label - 14px, Regular
  static TextStyle inputLabel({Color? color}) => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
  );

  /// Input Value - 14px, Regular
  static TextStyle inputValue({Color? color}) => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
  );

  /// Input Placeholder - 14px, Regular
  static TextStyle placeholder({Color? color}) => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TABLE SPECIFIC STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Table Header - 14px, Medium
  static TextStyle tableHeader({Color? color}) => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
  );

  /// Table Cell - 14px, Regular
  static TextStyle tableCell({Color? color}) => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
  );
}
}

// Authored by: Moazzam Samoo
