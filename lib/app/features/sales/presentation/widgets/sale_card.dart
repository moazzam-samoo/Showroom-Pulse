import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/app_bike_image.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/cash_sale_detail_dialog.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/installment_sale_detail_dialog.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

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
  final BikeConditionEnum? bikeCondition;
  final String bikeImage; 
  final String bikeChassisNumber;
  final String bikeEngineNumber;
  final String? bikeYear;
  final String? bikeMaker;
  final String? bikeRegistrationNumber; // Only for used bikes
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

  // Sale ID for deletion/updates
  final int id;

  SaleCardData({
    required this.id,
    required this.bikeModel,
    this.bikeBrand,
    required this.bikeColor,
    this.bikeCondition,
    required this.bikeImage,
    required this.bikeChassisNumber,
    required this.bikeEngineNumber,
    this.bikeYear,
    this.bikeMaker,
    this.bikeRegistrationNumber,
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

class SaleCard extends StatefulWidget {
  final SaleCardData data;

  const SaleCard({super.key, required this.data});

  @override
  State<SaleCard> createState() => _SaleCardState();
}

class _SaleCardState extends State<SaleCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Status Badge Details
    final badgeColor = data.isCash ? const Color(0xFFEF4444) : const Color(0xFFF59E0B); // Red (Sold) vs Amber (Installment)
    final badgeLabel = data.isCash ? 'SOLD (NOT AVAILABLE)' : 'INSTALLMENT (RESERVED)';

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (data.isCash) {
            Get.dialog(CashSaleDetailDialog(data: data));
          } else {
            Get.dialog(InstallmentSaleDetailDialog(data: data));
          }
        },
        child: AnimatedScale(
          scale: isHovered ? 1.015 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: isDark 
                    ? (isHovered ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.05))
                    : (isHovered ? AppColors.lightPrimary.withOpacity(0.5) : AppColors.lightBorder),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
                if (isHovered)
                  BoxShadow(
                    color: AppColors.lightPrimary.withOpacity(isDark ? 0.4 : 0.25),
                    blurRadius: isDark ? 25 : 20,
                    spreadRadius: isDark ? 2 : 1,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // 1. Image Header with Badge
              Stack(
                children: [
                    AppBikeImage(
                      imagePath: data.bikeImage,
                      height: 120,
                      borderRadius: AppRadius.xl,
                      heroTag: 'sale_bike_${data.bikeEngineNumber}',
                      iconSize: 48,
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
                // Download & Delete Buttons
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                             Get.find<SalesController>().exportSaleInvoice(data);
                          },
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.download, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showDeleteConfirmation(context),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.trash2, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                            fontSize: 10,
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
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (data.bikeCondition != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: data.bikeCondition == BikeConditionEnum.newBike 
                                ? const Color(0xFF3B82F6) // Blue
                                : const Color(0xFFA16207), // Brownish
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            boxShadow: [
                              BoxShadow(
                                color: (data.bikeCondition == BikeConditionEnum.newBike 
                                    ? const Color(0xFF3B82F6) 
                                    : const Color(0xFFA16207)).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(data.bikeCondition == BikeConditionEnum.newBike ? '🆕 ' : '🔄 ', style: const TextStyle(fontSize: 10)),
                              Text(
                                data.bikeCondition == BikeConditionEnum.newBike ? 'NEW' : 'USED',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                            fontSize: 15,
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

  void _showDeleteConfirmation(BuildContext context) {
    AppNotificationDialog.showConfirmation(
      title: 'Delete Sale',
      message: 'Are you sure you want to delete this sale for ${widget.data.bikeModel}?\n\n'
               'This will:\n'
               '• Remove this bike from the customer\'s history\n'
               '• Revert the bike status to "Available" in inventory\n'
               '• Delete all associated payments and witness records\n\n'
               'This action cannot be undone.',
      confirmText: 'Delete Everything',
      confirmColor: Colors.red,
      onConfirm: () => Get.find<SalesController>().deleteSale(widget.data.id),
    );
  }
}
