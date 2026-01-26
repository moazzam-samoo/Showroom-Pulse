import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/widgets/app_button.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';

/// Login Card Widget - Main authentication card
/// 
/// Analyzed from: Dark Theme UI/Login Page.png
/// Components:
/// - Motorcycle icon in rounded container (cyan on dark, blue on light)
/// - "Tahir Showroom" title
/// - "Inventory Management System" subtitle
/// - Username input with user icon
/// - Password input with lock icon
/// - Sign In button (full width, cyan/blue)
class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      // TODO: Implement actual login logic in Phase 2 Logic step
      // For now, simulate login and navigate to dashboard
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
          // Navigate to dashboard (will be implemented later)
          Get.snackbar(
            'Login',
            'Login functionality will be added after UI approval',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    }
  }

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
        key: _formKey,
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
              controller: _usernameController,
              prefixIcon: LucideIcons.user,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppSpacing.base),
            
            // Password Field
            AppTextField(
              label: 'Password',
              hint: 'Enter your password',
              controller: _passwordController,
              obscureText: _obscurePassword,
              prefixIcon: LucideIcons.lock,
              suffixIcon: _obscurePassword 
                  ? LucideIcons.eyeOff 
                  : LucideIcons.eye,
              onSuffixTap: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleSignIn(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Sign In Button
            AppButton(
              text: 'Sign In',
              onPressed: _handleSignIn,
              isLoading: _isLoading,
              isFullWidth: true,
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// Authored by: Moazzam Samoo
