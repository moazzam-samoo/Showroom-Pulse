import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';

/// Sidebar Navigation Widget
/// 
/// Analyzed from: Dark Theme UI/Dashboard Page.png
/// - Collapsed sidebar (64px width)
/// - Icon-only navigation
/// - Active state with cyan glow (Dark) / light blue (Light)
class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 64,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.base),
          // Logo
          _buildLogo(isDark),
          const SizedBox(height: AppSpacing.xl),
          // Navigation Items
          Expanded(
            child: Column(
              children: [
                _buildNavItem(0, LucideIcons.layoutDashboard, 'Dashboard', isDark),
                _buildNavItem(1, LucideIcons.truck, 'Dealers', isDark), // New Tab
                _buildNavItem(2, LucideIcons.bike, 'Inventory', isDark),
                _buildNavItem(3, LucideIcons.shoppingCart, 'Sales', isDark),
                _buildNavItem(4, LucideIcons.users, 'Customers', isDark),
                _buildNavItem(5, LucideIcons.barChart3, 'Reports', isDark),
              ],
            ),
          ),
          // Bottom Items
          _buildNavItem(6, LucideIcons.settings, 'Settings', isDark),
          const SizedBox(height: AppSpacing.base),
          _buildNavItem(7, LucideIcons.logOut, 'Logout', isDark, isLogout: true),
          const SizedBox(height: AppSpacing.base),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        LucideIcons.bike,
        size: 20,
        color: primaryColor,
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String tooltip,
    bool isDark, {
    bool isLogout = false,
  }) {
    final isSelected = selectedIndex == index && !isLogout;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: InkWell(
        onTap: () {
          if (isLogout) {
            _handleLogout();
          } else {
            onItemSelected(index);
          }
        },
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? primaryColor.withOpacity(0.15)
                    : AppColors.lightPrimaryLight)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected
                ? primaryColor
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  void _handleLogout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      Get.offAllNamed('/login');
    }
  }
}

// Authored by: Moazzam Samoo
