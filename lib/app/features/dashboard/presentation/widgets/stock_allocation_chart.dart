import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';

/// Stock Allocation Chart
/// 
/// Analyzed from: Dark Theme UI/Dashboard Page.png
/// - Donut chart showing New Models vs Pre-Owned
/// - 70% New Models, 30% Pre-Owned (example)
/// - Legend on the right side
class StockAllocationChart extends StatelessWidget {
  final double newModelsPercent;
  final int newModelsCount;
  final double preOwnedPercent;
  final int preOwnedCount;

  const StockAllocationChart({
    super.key,
    this.newModelsPercent = 70,
    this.newModelsCount = 82,
    this.preOwnedPercent = 30,
    this.preOwnedCount = 63,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock Allocation',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'INVENTORY DISTRIBUTION',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          // Chart and Legend
          Expanded(
            child: Row(
              children: [
                // Donut Chart
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          value: newModelsPercent,
                          color: primaryColor,
                          radius: 30,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: preOwnedPercent,
                          color: isDark ? AppColors.darkElevated : Colors.grey.shade300,
                          radius: 30,
                          showTitle: false,
                        ),
                      ],
                    ),
                  ),
                ),
                // Legend
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                        context,
                        '${newModelsPercent.toInt()}%',
                        'New Models',
                        '$newModelsCount Units in showroom',
                        primaryColor,
                        isDark,
                      ),
                      const SizedBox(height: AppSpacing.base),
                      _buildLegendItem(
                        context,
                        '${preOwnedPercent.toInt()}%',
                        'Pre-Owned',
                        '$preOwnedCount Units certified',
                        isDark ? AppColors.darkElevated : Colors.grey.shade400,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Footer
          InkWell(
            onTap: () {
              // TODO: Navigate to inventory audit
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FULL INVENTORY AUDIT',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Icon(
                    LucideIcons.arrowUpRight,
                    size: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String percent,
    String title,
    String subtitle,
    Color color,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    percent,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Authored by: Moazzam Samoo
