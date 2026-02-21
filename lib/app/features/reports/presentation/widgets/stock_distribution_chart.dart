import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';

class StockDistributionChart extends StatelessWidget {
  final Map<String, int> data;

  const StockDistributionChart({super.key, required this.data});

  static const List<Color> _chartColors = [
    Color(0xFF06b6d4), // Cyan
    Color(0xFF3b82f6), // Blue
    Color(0xFF8b5cf6), // Purple
    Color(0xFF10b981), // Green
    Color(0xFFf59e0b), // Amber
    Color(0xFFef4444), // Red
    Color(0xFFec4899), // Pink
    Color(0xFF64748b), // Slate
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = data.values.fold(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
          Text(
            'Stock Distribution by Brand',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
            child: data.isEmpty
                ? Center(
                    child: Text(
                      'No inventory data',
                      style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  )
                : PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: _buildSections(total),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 500),
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Legend
          ...data.entries.toList().asMap().entries.map((entry) {
            final color = _chartColors[entry.key % _chartColors.length];
            final brand = entry.value.key;
            final count = entry.value.value;
            final pct = total > 0 ? (count / total * 100).toStringAsFixed(0) : '0';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      brand,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Text(
                    '$pct%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(int total) {
    return data.entries.toList().asMap().entries.map((entry) {
      final color = _chartColors[entry.key % _chartColors.length];
      final count = entry.value.value;
      final pct = total > 0 ? count / total * 100 : 0.0;

      return PieChartSectionData(
        color: color,
        value: pct,
        title: '',
        radius: 25,
      );
    }).toList();
  }
}
