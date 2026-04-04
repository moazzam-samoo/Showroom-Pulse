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
    double totalCash = 0, totalInstallment = 0, totalProfit = 0, totalAssetValue = 0;
    for (final brand in data.values) {
      totalCash += brand['cash'] ?? 0;
      totalInstallment += brand['installment'] ?? 0;
      totalProfit += brand['total'] ?? 0;
      totalAssetValue += brand['assetValue'] ?? 0;
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
              columnWidths: data.keys.any((k) => k.contains(' | '))
                  ? const {
                      0: FlexColumnWidth(2), // Brand
                      1: FlexColumnWidth(1.5), // Base
                      2: FlexColumnWidth(1.5), // Markup
                      3: FlexColumnWidth(1.5), // Total
                      4: FlexColumnWidth(1.5), // Earned
                      5: FlexColumnWidth(1.5), // Month
                    }
                  : const {
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
                        _headerCell('Maker / Description', isDark),
                        _headerCell('Base Profit', isDark),
                        _headerCell('Markup', isDark),
                        _headerCell('Total Profit', isDark),
                        _headerCell('Asset Value', isDark),
                        if (data.keys.any((k) => k.contains(' | '))) _headerCell('Month', isDark),
                      ],
                    ),
                    // Data rows
                    ...data.entries.map((entry) {
                      final installmentValue = entry.value['installment'] ?? 0;
                      final isCashOnly = installmentValue == 0;

                          final displayKey = entry.key.split(' | ');
                          final brandName = displayKey.length > 1 ? displayKey[1] : displayKey[0];
                          final monthName = displayKey.length > 1 ? displayKey[0] : '';
                          final isMultiMonth = data.keys.any((k) => k.contains(' | '));

                          return TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.lightBorderLight,
                                ),
                              ),
                            ),
                            children: [
                              _dataCell(brandName, isDark, isBold: false),
                              _dataCell('Rs ${currencyFormat.format(entry.value['cash'] ?? 0)}', isDark),
                              _dataCell(
                                isCashOnly ? 'N/A' : 'Rs ${currencyFormat.format(installmentValue)}',
                                isDark,
                                color: isCashOnly ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary) : null,
                              ),
                              _dataCell(
                                'Rs ${currencyFormat.format(entry.value['total'] ?? 0)}',
                                  isDark,
                                  color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                                  isBold: true,
                              ),
                              _dataCell(
                                'Rs ${currencyFormat.format(entry.value['assetValue'] ?? 0)}',
                                isDark,
                                isBold: true,
                              ),
                              if (isMultiMonth) _dataCell(monthName, isDark),
                            ],
                          );
                        }),
                    // Total row
                    TableRow(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkPrimary.withValues(alpha: 0.15)
                            : AppColors.lightPrimary.withValues(alpha: 0.1),
                        border: Border(
                          top: BorderSide(
                            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                            width: 1,
                          ),
                        ),
                      ),
                      children: [
                        _totalCell('TOTAL', isDark),
                        _totalCell('Rs ${currencyFormat.format(totalCash)}', isDark),
                        _totalCell('Rs ${currencyFormat.format(totalInstallment)}', isDark),
                        _totalCell(
                          'Rs ${currencyFormat.format(totalProfit)}',
                          isDark,
                          color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                        ),
                        _totalCell(
                          'Rs ${currencyFormat.format(totalAssetValue)}',
                          isDark,
                        ),
                        if (data.keys.any((k) => k.contains(' | '))) _totalCell('', isDark),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _totalCell(String text, bool isDark, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
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
