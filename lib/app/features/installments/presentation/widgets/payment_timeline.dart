import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';

/// Payment timeline/table showing payment history
class PaymentTimeline extends StatelessWidget {
  final List<Payment> payments;
  final VoidCallback onRecordPayment;

  const PaymentTimeline({
    super.key,
    required this.payments,
    required this.onRecordPayment,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment History',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Record Payment Button
                TextButton.icon(
                  onPressed: onRecordPayment,
                  icon: Icon(
                    LucideIcons.plus,
                    size: 16,
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                  label: Text(
                    'Record Payment',
                    style: TextStyle(
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          // Table Header
          _buildTableHeader(isDark),
          // Divider
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          // Payment rows
          if (payments.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.receipt,
                      size: 48,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'No payments recorded yet',
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payments.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              itemBuilder: (context, index) => _buildPaymentRow(payments[index], isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(bool isDark) {
    final headerStyle = TextStyle(
      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
      color: isDark ? AppColors.darkCard.withOpacity(0.5) : AppColors.lightBackground,
      child: Row(
        children: [
          SizedBox(width: 100, child: Text('Date', style: headerStyle)),
          SizedBox(width: 100, child: Text('Amount', style: headerStyle)),
          SizedBox(width: 110, child: Text('Method', style: headerStyle)),
          Expanded(child: Text('Collector', style: headerStyle)),
          SizedBox(width: 90, child: Text('Status', style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(Payment payment, bool isDark) {
    final dateFormat = DateFormat('d MMM yyyy');
    final currencyFormat = NumberFormat.currency(
      locale: 'en_PK',
      symbol: 'Rs ',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
      child: Row(
        children: [
          // Date
          SizedBox(
            width: 100,
            child: Text(
              dateFormat.format(payment.paymentDate),
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
          // Amount
          SizedBox(
            width: 100,
            child: Text(
              currencyFormat.format(payment.amount),
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Method
          SizedBox(
            width: 110,
            child: Text(
              _getMethodText(payment.method),
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
          // Collector
          Expanded(
            child: Text(
              payment.collectorName ?? 'Online',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Status Badge
          SizedBox(
            width: 90,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: payment.isDownPayment
                    ? const Color(0xFF3b82f6).withOpacity(0.15)
                    : (isDark ? AppColors.darkSuccess : AppColors.lightSuccess).withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                payment.isDownPayment ? 'Down Payment' : 'Paid',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: payment.isDownPayment
                      ? const Color(0xFF3b82f6)
                      : (isDark ? AppColors.darkSuccess : AppColors.lightSuccess),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.jazzCash:
        return 'JazzCash';
      case PaymentMethod.easyPaisa:
        return 'EasyPaisa';
      case PaymentMethod.cheque:
        return 'Cheque';
    }
  }
}

// Authored by: Moazzam Samoo
