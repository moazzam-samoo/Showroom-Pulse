import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';

class RevenueLineChart extends StatelessWidget {
  final List<MapEntry<String, double>> data;
  final String filter;
  final Function(String) onFilterChanged;

  const RevenueLineChart({
    super.key,
    required this.data,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.compact(locale: 'en');

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                filter == 'Monthly' ? 'Daily Revenue Breakdown' : 'Annual Revenue Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              // Filter Toggle
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggleButton('Monthly', isDark),
                    _buildToggleButton('Annual', isDark),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 220,
            child: data.isEmpty
                ? Center(
                    child: Text(
                      'No revenue data available',
                      style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (spots) {
                            return spots.map((spot) {
                              return LineTooltipItem(
                                'Rs ${currencyFormat.format(spot.y)}',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: (_getMaxY() / 4).clamp(1.0, double.infinity),
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1, // Force exactly one label per discrete data point
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && value.toInt() < data.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    data[value.toInt()].key,
                                    style: TextStyle(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                currencyFormat.format(value),
                                style: TextStyle(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (data.length - 1).toDouble(),
                      minY: 0,
                      maxY: _getMaxY(),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value.value);
                          }).toList(),
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, pct, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(alpha: 0.3),
                                (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    if (data.isEmpty) return 100;
    final max = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    if (max <= 0) return 100;
    return max * 1.2;
  }

  Widget _buildToggleButton(String type, bool isDark) {
    final isSelected = filter == type;
    return GestureDetector(
      onTap: () => onFilterChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkCard : AppColors.lightSurface)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ) : null,
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ] : [],
        ),
        child: Text(
          type,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
        ),
      ),
    );
  }
}
