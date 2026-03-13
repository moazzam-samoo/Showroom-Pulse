import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';

import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';

class SalesFilterBar extends GetView<SalesController> {
  const SalesFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Search
        Expanded(
          flex: 2,
          child: Obx(() => AppTextField(
            controller: controller.searchController,
            hint: 'Search invoice, customer, or bike...',
            prefixIcon: LucideIcons.search,
            showClearIcon: controller.searchQuery.value.isNotEmpty,
            onClear: () {
              controller.searchController.clear();
              controller.setSearchQuery('');
            },
            onChanged: (val) {
              controller.setSearchQuery(val);
            },
          )),
        ),
        const SizedBox(width: AppSpacing.md),
        
        // Date Range Filter
        _buildDropdown(
          context, 
          icon: LucideIcons.calendar, 
          value: controller.selectedDateRange, 
          items: controller.dateRangeOptions,
          onSelected: controller.setDateRange,
        ),
        const SizedBox(width: AppSpacing.md),

        // Status Filter
        _buildDropdown(
          context, 
          icon: LucideIcons.filter, 
          value: controller.selectedStatus, 
          items: controller.statusOptions,
          onSelected: controller.setStatusFilter,
        ),
        
        const SizedBox(width: AppSpacing.md),

        // Clear Filters Button
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: controller.clearFilters,
              icon: const Icon(LucideIcons.filterX, size: 18),
              label: const Text(
                'Clear Filters',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.redAccent.shade200 : Colors.redAccent,
                side: BorderSide(
                  color: (isDark ? Colors.redAccent.shade200 : Colors.redAccent).withOpacity(0.5)
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
          ),
        ),

        // Export Button
        IconButton(
          onPressed: controller.exportReport, 
          icon: const Icon(LucideIcons.download),
          tooltip: 'Export Report',
          style: IconButton.styleFrom(
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required IconData icon,
    required RxString value,
    required List<String> items,
    required Function(String) onSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Obx(() => PopupMenuButton<String>(
      onSelected: onSelected,
      offset: const Offset(0, 48),
      itemBuilder: (context) => items.map((item) => PopupMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isDark ? Colors.white70 : Colors.black54),
            const SizedBox(width: 8),
            Text(
              value.value,
               style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(width: 4),
            Icon(LucideIcons.chevronDown, size: 16, color: isDark ? Colors.white70 : Colors.black54),
          ],
        ),
      ),
    ));
  }
}
