import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/auth/presentation/widgets/login_card.dart';

/// Login View - Entry point for authentication
/// 
/// Analyzed from: Dark Theme UI/Login Page.png
/// - Centered login card on dark/gradient background
/// - Motorcycle icon in rounded container
/// - "Showroom Pulse" title + "Inventory Management System" subtitle
/// - Username and Password inputs with icons
/// - Cyan "Sign In" button
/// - Copyright footer
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Dark: solid dark background
          // Light: blue gradient
          color: isDark ? AppColors.darkBackground : null,
          gradient: isDark ? null : const LinearGradient(
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
                  '© 2026 Showroom Pulse. All rights reserved.',
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
      ),
    );
  }
}

// Authored by: Moazzam Samoo
