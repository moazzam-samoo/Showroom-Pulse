import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../widgets/login_card.dart';

/// Login View - Entry point for authentication
/// 
/// Analyzed from: Dark Theme UI/Login Page.png
/// - Centered login card on dark/gradient background
/// - Motorcycle icon in rounded container
/// - "Tahir Showroom" title + "Inventory Management System" subtitle
/// - Username and Password inputs with icons
/// - Cyan "Sign In" button
/// - Copyright footer
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Dark: solid dark background
          // Light: blue gradient
          color: isDark ? AppColors.darkBackground : null,
          gradient: isDark ? null : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lightGradientDark,
              AppColors.lightGradientLight,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login Card
                const LoginCard(),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Copyright footer
                Text(
                  '© 2026 Tahir Showroom. All rights reserved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark 
                        ? AppColors.darkTextMuted 
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Authored by: Moazzam Samoo
