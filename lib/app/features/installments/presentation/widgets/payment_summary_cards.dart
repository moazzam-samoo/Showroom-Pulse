import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';

/// Payment summary cards showing Total, Paid, Down Payment, Remaining, Next Due, Monthly EMI
class PaymentSummaryCards extends StatelessWidget {
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final DateTime? nextDueDate;
  final double downPayment;
  final double monthlyEMI;
  final bool isCompleted;

  const PaymentSummaryCards({
    super.key,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    this.nextDueDate,
    required this.downPayment,
    required this.monthlyEMI,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(
      locale: 'en_PK',
      symbol: 'Rs ',
      decimalDigits: 0,
    );

    return Column(
      children: [
        // Row 1: Total Amount + Paid + Down Payment
        Row(
          children: [
            Expanded(
              child: _buildCard(
                context: context,
                title: 'Total Amount',
                value: currencyFormat.format(totalAmount),
                valueColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                icon: LucideIcons.wallet,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildCard(
                context: context,
                title: 'Paid',
                value: currencyFormat.format(paidAmount),
                valueColor: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                icon: LucideIcons.checkCircle,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildCard(
                context: context,
                title: 'Down Payment',
                value: currencyFormat.format(downPayment),
                valueColor: const Color(0xFF8B5CF6),
                icon: LucideIcons.banknote,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Row 2: Remaining + Next Due + Monthly EMI
        Row(
          children: [
            Expanded(
              child: _buildCard(
                context: context,
                title: 'Remaining',
                value: isCompleted && remainingAmount <= 0
                    ? 'Rs 0 - All payment done'
                    : currencyFormat.format(remainingAmount),
                valueColor: isCompleted && remainingAmount <= 0
                    ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                    : (isDark ? AppColors.darkWarning : AppColors.lightWarning),
                icon: LucideIcons.clock,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildNextDueCard(context, isDark),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildCard(
                context: context,
                title: 'Monthly EMI',
                value: currencyFormat.format(monthlyEMI),
                valueColor: const Color(0xFF06B6D4),
                icon: LucideIcons.calendar,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String value,
    required Color valueColor,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                icon,
                size: 16,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextDueCard(BuildContext context, bool isDark) {
    final dateFormat = DateFormat('d MMM, yyyy');
    final daysUntil = nextDueDate?.difference(DateTime.now()).inDays;

    String? subtitle;
    Color subtitleColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    if (!isCompleted && daysUntil != null) {
      if (daysUntil < 0) {
        subtitle = '${daysUntil.abs()} days overdue';
        subtitleColor = isDark ? AppColors.darkError : AppColors.lightError;
      } else if (daysUntil == 0) {
        subtitle = 'Due today';
        subtitleColor = isDark ? AppColors.darkWarning : AppColors.lightWarning;
      } else {
        subtitle = 'in $daysUntil days';
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Due',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 11,
                ),
              ),
              Icon(
                LucideIcons.calendarClock,
                size: 16,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              isCompleted
                  ? 'Completed'
                  : (nextDueDate != null ? dateFormat.format(nextDueDate!) : 'N/A'),
              style: TextStyle(
                color: isCompleted
                    ? (isDark ? AppColors.darkSuccess : AppColors.lightSuccess)
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(LucideIcons.clock, size: 12, color: subtitleColor),
                const SizedBox(width: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Authored by: Moazzam Samoo
