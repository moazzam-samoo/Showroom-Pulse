import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';

class SaleCardData {
  final String bikeModel;
  final String bikeImage; // Path to asset or file
  final String customerName;
  final String customerCnic;
  final String customerContact;
  final String saleDate;
  final double amountPaid;
  final double? amountRemaining;
  final bool isCash;
  final int? installmentDuration;
  final double? installmentMonthlyPayment;
  final String? installmentDueDate;

  SaleCardData({
    required this.bikeModel,
    required this.bikeImage,
    required this.customerName,
    required this.customerCnic,
    required this.customerContact,
    required this.saleDate,
    required this.amountPaid,
    this.amountRemaining,
    required this.isCash,
    this.installmentDuration,
    this.installmentMonthlyPayment,
    this.installmentDueDate,
  });
}

class SaleCard extends StatelessWidget {
  final SaleCardData data;

  const SaleCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Status Badge Details
    final badgeColor = data.isCash ? AppColors.darkPrimary : const Color(0xFFD946EF); // Cyan vs Fuchsia
    final badgeLabel = data.isCash ? 'Cash' : 'Installment';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Header with Badge
          Stack(
            children: [
              // Bike Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.asset(
                    data.bikeImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade200,
                      child: Center(
                        child: Icon(
                          LucideIcons.bike,
                          size: 48,
                          color: isDark ? Colors.white12 : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Status Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow: [
                      BoxShadow(
                        color: badgeColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    badgeLabel,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. Details Section
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bike Model
                Row(
                  children: [
                    Icon(
                      LucideIcons.bike,
                      size: 16,
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data.bikeModel,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Financials
                _buildInfoRow(
                  label: 'Amount Paid:',
                  value: 'Rs ${Get.find<SalesController>().currencyFormat(data.amountPaid)}',
                  valueColor: const Color(0xFF22C55E), // Green
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                if (data.isCash) ...[
                   _buildInfoRow(
                    label: 'Sale Date:',
                    value: data.saleDate,
                    isDark: isDark,
                  ),
                ] else ...[
                   // Installment Details
                   _buildInfoRow(
                    label: 'Sale Date:',
                    value: data.saleDate,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    label: 'Duration:',
                    value: '${data.installmentDuration ?? 0} Months',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    label: 'Monthly:',
                    value: 'Rs ${Get.find<SalesController>().currencyFormat(data.installmentMonthlyPayment ?? 0)}',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    label: 'Due Date:',
                    value: data.installmentDueDate ?? '-',
                    valueColor: const Color(0xFFEF4444), // Red for due date
                    isDark: isDark,
                  ),
                ],

                const SizedBox(height: AppSpacing.sm),
                Divider(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
                  height: 1,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Customer Info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.user,
                        size: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.customerName,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NIC: ${data.customerCnic}',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.black45,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                           Text(
                            data.customerContact,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }
}
