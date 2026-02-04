import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';

/// Bike Filter Bar Widget
/// 
/// Analyzed from: Dark Theme UI/Inventory Page.png
/// - Search input on left
/// - "+ Add Bike" button (cyan)
/// - Filter dropdowns: Brand, Engine CC, Status
class BikeFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedBrand;
  final String? selectedCC;
  final String? selectedStatus;
  final ValueChanged<String?>? onBrandChanged;
  final ValueChanged<String?>? onCCChanged;
  final ValueChanged<String?>? onStatusChanged;
  final VoidCallback? onAddBike;

  const BikeFilterBar({
    super.key,
    required this.searchController,
    this.selectedBrand,
    this.selectedCC,
    this.selectedStatus,
    this.onBrandChanged,
    this.onCCChanged,
    this.onStatusChanged,
    this.onAddBike,
  });

  // Sample data - can be customized
  static const List<String> brands = ['Honda', 'Suzuki', 'Yamaha', 'Road Prince', 'United'];
  static const List<String> engineCCs = ['70cc', '100cc', '110cc', '125cc', '150cc'];
  static const List<String> statuses = ['Available', 'Sold', 'Pending'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Row(
      children: [
        // Search Bar
        Expanded(
          flex: 3,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.search,
                  size: 18,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search inventory...',
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        // Add Bike Button
        ElevatedButton.icon(
          onPressed: onAddBike,
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Add Bike'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        // Brand Filter
        _buildDropdown(
          value: selectedBrand,
          hint: 'Brand',
          items: brands,
          onChanged: onBrandChanged,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        // Engine CC Filter
        _buildDropdown(
          value: selectedCC,
          hint: 'Engine CC',
          items: engineCCs,
          onChanged: onCCChanged,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        // Status Filter
        _buildDropdown(
          value: selectedStatus,
          hint: 'Status',
          items: statuses,
          onChanged: onStatusChanged,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    required bool isDark,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontSize: 13,
            ),
          ),
          icon: Icon(
            LucideIcons.chevronDown,
            size: 16,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'All $hint',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            ...items.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 13,
                ),
              ),
            )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// Authored by: Moazzam Samoo
