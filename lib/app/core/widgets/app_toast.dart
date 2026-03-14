import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';

class AppToast {
  static void showSuccess({required String title, required String message}) {
    final color = Get.isDarkMode ? AppColors.darkSuccess : AppColors.lightSuccess;
    _showToast(title, message, LucideIcons.checkCircle2, color);
  }

  static void showError({required String title, required String message}) {
    final color = Get.isDarkMode ? AppColors.darkError : AppColors.lightError;
    _showToast(title, message, LucideIcons.alertCircle, color);
  }

  static void showInfo({required String title, required String message}) {
    final color = Get.isDarkMode ? AppColors.darkInfo : AppColors.lightPrimary;
    _showToast(title, message, LucideIcons.info, color);
  }

  static void _showToast(String title, String message, IconData icon, Color iconColor) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    final isDark = Get.isDarkMode;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: iconColor),
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgColor,
      colorText: textColor,
      borderRadius: 12,
      margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      maxWidth: 400,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
