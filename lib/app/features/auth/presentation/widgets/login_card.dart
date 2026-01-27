import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/widgets/app_button.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';

import '../controllers/login_controller.dart';

/// Login Card Widget - Main authentication card
/// 
/// Analyzed from: Dark Theme UI/Login Page.png
/// Components:
/// - Motorcycle icon in rounded container (cyan on dark, blue on light)
/// - "Tahir Showroom" title
/// - "Inventory Management System" subtitle
/// - Username input with user icon
/// - Password input with lock icon
/// - Keep me logged in checkbox
/// - Sign In button (full width, cyan/blue)
class LoginCard extends GetView<LoginController> {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    
    return Container(
      width: 400,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: isDark 
            ? Border.all(color: AppColors.darkBorder) 
            : null,
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo Container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                LucideIcons.bike,
                size: 32,
                color: primaryColor,
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Title
            Text(
              'Tahir Showroom',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xs),
            
            // Subtitle
            Text(
              'Inventory Management System',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark 
                    ? AppColors.darkTextSecondary 
                    : AppColors.lightTextSecondary,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Username Field
            AppTextField(
              label: 'Username',
              hint: 'Enter your username',
              controller: controller.usernameController,
              prefixIcon: LucideIcons.user,
              textInputAction: TextInputAction.next,
              validator: controller.validateUsername,
            ),
            
            const SizedBox(height: AppSpacing.base),
            
            // Password Field
            Obx(() => AppTextField(
              label: 'Password',
              hint: 'Enter your password',
              controller: controller.passwordController,
              obscureText: controller.obscurePassword.value,
              prefixIcon: LucideIcons.lock,
              suffixIcon: controller.obscurePassword.value 
                  ? LucideIcons.eyeOff 
                  : LucideIcons.eye,
              onSuffixTap: controller.togglePasswordVisibility,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => controller.login(),
              validator: controller.validatePassword,
            )),
            
            const SizedBox(height: AppSpacing.md),
            
            // Keep Me Logged In Checkbox
            Obx(() => Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: controller.keepMeLoggedIn.value,
                    onChanged: controller.toggleKeepMeLoggedIn,
                    activeColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: () => controller.toggleKeepMeLoggedIn(
                    !controller.keepMeLoggedIn.value,
                  ),
                  child: Text(
                    'Keep me logged in',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark 
                          ? AppColors.darkTextSecondary 
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            )),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Sign In Button
            Obx(() => AppButton(
              text: 'Sign In',
              onPressed: controller.login,
              isLoading: controller.isLoading.value,
              isFullWidth: true,
              variant: AppButtonVariant.primary,
            )),
          ],
        ),
      ),
    );
  }
}

// Authored by: Moazzam Samoo
