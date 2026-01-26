/// Tahir Showroom Shadow System
/// Based on UI_colors_and_design_file.md
import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  /// Small shadow - Cards, subtle elevation
  /// 0 1px 2px rgba(0,0,0,0.05)
  static List<BoxShadow> get sm => [
    BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: 2,
      color: Colors.black.withOpacity(0.05),
    ),
  ];

  /// Medium shadow - Dropdowns, popovers
  /// 0 4px 6px rgba(0,0,0,0.1)
  static List<BoxShadow> get md => [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 6,
      color: Colors.black.withOpacity(0.1),
    ),
  ];

  /// Large shadow - Modals, hero cards on hover
  /// 0 10px 15px rgba(0,0,0,0.1)
  static List<BoxShadow> get lg => [
    BoxShadow(
      offset: const Offset(0, 10),
      blurRadius: 15,
      color: Colors.black.withOpacity(0.1),
    ),
  ];

  /// No shadow (for dark theme cards)
  static List<BoxShadow> get none => [];
}

// Authored by: Moazzam Samoo
