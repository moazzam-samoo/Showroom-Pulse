import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_assets.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/features/settings/presentation/controllers/settings_controller.dart';

/// Centralized Showroom Logo Widget
/// 
/// Priority:
/// 1. Custom Logo from AppSettings (if exists and is valid)
/// 2. Default Asset: assets/app_logo.jpeg
/// 3. Fallback: LucideIcons.motorcycle
class AppShowroomLogo extends StatelessWidget {
  final double size;
  final double borderRadius;
  final BoxFit fit;

  const AppShowroomLogo({
    super.key,
    this.size = 100,
    this.borderRadius = 12,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Get settings controller if not already present
    // Using Get.find<SettingsController>() instead of GetView to make it easy to drop in anywhere
    return GetX<SettingsController>(
      builder: (controller) {
        final settings = controller.settings.value;
        final String? customLogoPath = settings?.showroomLogoPath;
        
        bool hasCustomFile = false;
        if (customLogoPath != null && customLogoPath.isNotEmpty) {
          hasCustomFile = File(customLogoPath).existsSync();
        }

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(borderRadius + 4), // Outer container
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: _buildImage(hasCustomFile, customLogoPath, isDark),
          ),
        );
      },
    );
  }

  Widget _buildImage(bool hasCustomFile, String? customLogoPath, bool isDark) {
    // 1. Custom Logo
    if (hasCustomFile && customLogoPath != null) {
      return Image.file(
        File(customLogoPath),
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(isDark),
      );
    }

    // 2. Default Asset
    return Image.asset(
      AppAssets.logo,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildFallback(isDark),
    );
  }

  Widget _buildFallback(bool isDark) {
    return Center(
      child: Icon(
        LucideIcons.bike,
        size: size * 0.5,
        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      ),
    );
  }
}
