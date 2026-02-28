import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/cash_sale_detail_dialog.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/installment_sale_detail_dialog.dart';

/// WitnessData - Data class for witness information
class WitnessData {
  final String fullName;
  final String cnicNumber;
  final String phoneNumber;
  final String? address;
  final String? cnicFrontFilename;
  final bool isPrimary;

  WitnessData({
    required this.fullName,
    required this.cnicNumber,
    required this.phoneNumber,
    this.address,
    this.cnicFrontFilename,
    required this.isPrimary,
  });
}

class SaleCardData {
  final String bikeModel;
  final String? bikeBrand; // Added for filtering
  final String bikeColor; // Added for filtering
  final String bikeImage; 
  final String bikeChassisNumber;
  final String bikeEngineNumber;
  final String customerName;
  final String customerCnic;
  final String customerContact;
  final String? purchaserImage; // Optional photo
  final String customerAddress;
  final String saleDate;
  final double amountPaid;
  final double? bikePrice; // Original Price
  final double? sellingPrice; // Markup Price
  final double? amountRemaining;
  final bool isCash;
  final int? installmentDuration;
  final double? installmentMonthlyPayment;
  final String? installmentDueDate;
  
  final String? witnessName;
  final String? witnessCnic;
  final String? witnessPhone;
  final String? witnessImage;

  // Discount details
  final double discountAmount;
  final double discountPercentage;
  
  // All witnesses (supports multiple witnesses)
  final List<WitnessData>? witnesses;
  
  // Installment completion status
  final bool isInstallmentCompleted;

  SaleCardData({
    required this.bikeModel,
    this.bikeBrand,
    required this.bikeColor,
    required this.bikeImage,
    required this.bikeChassisNumber,
    required this.bikeEngineNumber,
    required this.customerName,
    required this.customerCnic,
    required this.customerContact,
    this.purchaserImage,
    required this.customerAddress,
    required this.saleDate,
    required this.amountPaid,
    this.bikePrice,
    this.sellingPrice,
    this.amountRemaining,
    required this.isCash,
    this.installmentDuration,
    this.installmentMonthlyPayment,
    this.installmentDueDate,
    this.witnessName,
    this.witnessCnic,
    this.witnessPhone,
    this.witnessImage,
    this.witnesses = const [],
    this.discountAmount = 0.0,
    this.discountPercentage = 0.0,
    this.isInstallmentCompleted = false,
  });
}

class SaleCard extends StatelessWidget {
  final SaleCardData data;

  const SaleCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Status Badge Details
    final badgeColor = data.isCash ? const Color(0xFFEF4444) : const Color(0xFFF59E0B); // Red (Sold) vs Amber (Installment)
    final badgeLabel = data.isCash ? 'SOLD (NOT AVAILABLE)' : 'INSTALLMENT (RESERVED)';

    return GestureDetector(
      onTap: () {
        if (data.isCash) {
          Get.dialog(CashSaleDetailDialog(data: data));
        } else {
          Get.dialog(InstallmentSaleDetailDialog(data: data));
        }
      },
      child: Container(
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
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                    child: SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: data.bikeImage.isNotEmpty
                          ? Image.file(
                              File(data.bikeImage),
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
                            )
                          : Container(
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
                // Download Button
                Positioned(
                  top: 12,
                  left: 12,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                         Get.find<SalesController>().exportSaleInvoice(data);
                      },
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.download, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // Status Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
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
                      if (data.isInstallmentCompleted) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF22C55E).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                'Completed',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (data.discountAmount > 0) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(LucideIcons.tags, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                '- ${data.discountPercentage.toStringAsFixed(1)}%',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
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
                    if (data.isInstallmentCompleted) ...[
                      _buildInfoRow(
                        label: 'Status:',
                        value: 'Completed',
                        valueColor: const Color(0xFF22C55E), // Green
                        isDark: isDark,
                      ),
                    ] else ...[
                      _buildInfoRow(
                        label: 'Due Date:',
                        value: data.installmentDueDate ?? '-',
                        valueColor: const Color(0xFFEF4444), // Red for due date
                        isDark: isDark,
                      ),
                    ],
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
