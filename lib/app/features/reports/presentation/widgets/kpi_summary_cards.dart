import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';

class KpiSummaryCards extends StatelessWidget {
  final double totalRevenue;
  final double totalExpenses;
  final double netProfit;

  const KpiSummaryCards({
    super.key,
    required this.totalRevenue,
    required this.totalExpenses,
    required this.netProfit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat('#,##0', 'en_PK');

    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            context: context,
            title: 'Available Cash',
            value: 'Rs ${currencyFormat.format(totalRevenue)}',
            icon: LucideIcons.wallet,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildKpiCard(
            context: context,
            title: 'Total Expenses',
            value: 'Rs ${currencyFormat.format(totalExpenses)}',
            icon: LucideIcons.trendingDown,
            color: isDark ? AppColors.darkWarning : AppColors.lightWarning,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildKpiCard(
            context: context,
            title: 'Net Profit',
            value: 'Rs ${currencyFormat.format(netProfit)}',
            icon: LucideIcons.wallet,
            color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
