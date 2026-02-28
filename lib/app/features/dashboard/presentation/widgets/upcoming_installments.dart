import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/utils/price_formatter.dart';

class UpcomingInstallment {
  final String customerName;
  final String bikeModel;
  final double amount;
  final DateTime dueDate;
  final bool isOverdue;

  const UpcomingInstallment({
    required this.customerName,
    required this.bikeModel,
    required this.amount,
    required this.dueDate,
    this.isOverdue = false,
  });
}

class UpcomingInstallmentsWidget extends StatelessWidget {
  final List<UpcomingInstallment> installments;

  const UpcomingInstallmentsWidget({
    super.key,
    this.installments = const [],
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
              Row(
                children: [
                  Icon(
                    LucideIcons.calendarClock,
                    size: 18,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Upcoming Installments',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Get.offNamed('/installments'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkElevated : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'CUSTOMER',
                    style: _headerStyle(isDark),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'BIKE',
                    style: _headerStyle(isDark),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'AMOUNT',
                    style: _headerStyle(isDark),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'DUE DATE',
                    style: _headerStyle(isDark),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'STATUS',
                    style: _headerStyle(isDark),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Rows
          if (installments.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.checkCircle,
                      size: 40,
                      color: Colors.green.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No upcoming installments',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: installments.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
                itemBuilder: (context, index) {
                  final item = installments[index];
                  return _buildRow(item, isDark, primaryColor);
                },
              ),
            ),
        ],
      ),
    );
  }

  TextStyle _headerStyle(bool isDark) {
    return TextStyle(
      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  Widget _buildRow(UpcomingInstallment item, bool isDark, Color primaryColor) {
    final dateFormat = DateFormat('dd MMM');
    final now = DateTime.now();
    final daysUntil = item.dueDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    String statusText;
    Color statusColor;

    if (item.isOverdue || daysUntil < 0) {
      statusText = 'Overdue';
      statusColor = Colors.red;
    } else if (daysUntil == 0) {
      statusText = 'Today';
      statusColor = Colors.orange;
    } else if (daysUntil <= 3) {
      statusText = '${daysUntil}d';
      statusColor = Colors.amber;
    } else {
      statusText = '${daysUntil}d';
      statusColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.customerName,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.bikeModel,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              PriceFormatter.formatPKR(item.amount),
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dateFormat.format(item.dueDate),
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
