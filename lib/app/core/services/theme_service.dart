import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ThemeService - Handles theme switching
/// Default theme is Dark (Executive Command Center)
class ThemeService extends GetxService {
  final _isDarkMode = true.obs;
  
  bool get isDarkMode => _isDarkMode.value;

  /// Toggle between dark and light theme
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Set specific theme mode
  void setThemeMode(bool isDark) {
    _isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  /// Get current theme mode
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}

// Authored by: Moazzam Samoo
