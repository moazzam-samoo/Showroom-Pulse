import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';

class ProfitSummaryTable extends StatelessWidget {
  final Map<String, Map<String, double>> data;

  const ProfitSummaryTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat('#,##0', 'en_PK');

    // Calculate totals
    double totalCash = 0, totalInstallment = 0, totalProfit = 0, totalEarned = 0;
    for (final brand in data.values) {
      totalCash += brand['cash'] ?? 0;
      totalInstallment += brand['installment'] ?? 0;
      totalProfit += brand['total'] ?? 0;
      totalEarned += brand['earned'] ?? 0;
    }

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
            'Net Profit Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          data.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text(
                      'No sales data for this month',
                      style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ),
                )
              : Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    // Header
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
                          ),
                        ),
                      ),
                      children: [
                        _headerCell('Category', isDark),
                        _headerCell('Base Profit', isDark),
                        _headerCell('Installment Markup', isDark),
                        _headerCell('Total Profit', isDark),
                        _headerCell('Earned', isDark),
                      ],
                    ),
                    // Data rows
                    ...data.entries.map((entry) {
                      final installmentValue = entry.value['installment'] ?? 0;
                      final isCashOnly = installmentValue == 0;

                      return TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isDark
                                  ? AppColors.darkBorder.withValues(alpha: 0.5)
                                  : AppColors.lightBorderLight,
                            ),
                          ),
                        ),
                        children: [
                          _dataCell(entry.key, isDark, isBold: false),
                          _dataCell('Rs ${currencyFormat.format(entry.value['cash'] ?? 0)}', isDark),
                          _dataCell(
                            isCashOnly ? 'Sold on Cash' : 'Rs ${currencyFormat.format(installmentValue)}',
                            isDark,
                            color: isCashOnly
                                ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary)
                                : null,
                          ),
                          _dataCell(
                            'Rs ${currencyFormat.format(entry.value['total'] ?? 0)}',
                            isDark,
                            color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                            isBold: true,
                          ),
                          _dataCell(
                            'Rs ${currencyFormat.format(entry.value['earned'] ?? 0)}',
                            isDark,
                            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                            isBold: true,
                          ),
                        ],
                      );
                    }),
                    // Total row
                    TableRow(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkPrimary.withValues(alpha: 0.1)
                            : AppColors.lightPrimaryLight,
                      ),
                      children: [
                        _dataCell('TOTAL', isDark, isBold: true),
                        _dataCell('Rs ${currencyFormat.format(totalCash)}', isDark, isBold: true),
                        _dataCell('Rs ${currencyFormat.format(totalInstallment)}', isDark, isBold: true),
                        _dataCell(
                          'Rs ${currencyFormat.format(totalProfit)}',
                          isDark,
                          color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                          isBold: true,
                        ),
                        _dataCell(
                          'Rs ${currencyFormat.format(totalEarned)}',
                          isDark,
                          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          isBold: true,
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _headerCell(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _dataCell(String text, bool isDark, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
      ),
    );
  }
}
