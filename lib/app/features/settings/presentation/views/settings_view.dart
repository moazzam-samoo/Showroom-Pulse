import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sidebar_navigation.dart';
import '../controllers/settings_controller.dart';
import '../widgets/financial_settings_view.dart';
import '../widgets/database_settings_view.dart';
import '../widgets/general_settings_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final int _selectedNavIndex = 7; // Settings is index 7 in main sidebar

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Row(
        children: [
          // ═══ Main App Sidebar (same as every other page) ═══
          SidebarNavigation(
            selectedIndex: _selectedNavIndex,
          ),

          // ═══ Settings Content Area ═══
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Settings Category Sidebar ───
                Container(
                  width: 220,
                  margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, 0, AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildCategoryItem(controller, 'Financials', LucideIcons.percent, isDark),
                      _buildCategoryItem(controller, 'Database', LucideIcons.database, isDark),
                      _buildCategoryItem(controller, 'General', LucideIcons.settings, isDark),
                    ],
                  ),
                ),

                // ─── Right Content Panel ───
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
                      ),
                    ),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      switch (controller.selectedCategory.value) {
                        case 'Financials':
                          return const FinancialSettingsView();
                        case 'Database':
                          return const DatabaseSettingsView();
                        case 'General':
                          return const GeneralSettingsView();
                        default:
                          return Center(
                            child: Text('Select a category'),
                          );
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(SettingsController controller, String title, IconData icon, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == title;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.changeCategory(title),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.darkCard : AppColors.lightPrimary.withValues(alpha: 0.1))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected
                        ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                        : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
