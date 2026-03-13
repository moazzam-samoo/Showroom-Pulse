import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sale_card.dart';

class InstallmentSaleDetailDialog extends StatelessWidget {
  final SaleCardData data;

  const InstallmentSaleDetailDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<SalesController>();
    print('Installment Dialog - Purchaser Image: ${data.purchaserImage}');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 24),
      child: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
            Get.back();
          }
        },
        child: Container(
        width: 900, // Wider for more content
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.1) : AppColors.lightBorder,
          ),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Try to wrap content
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(context, isDark),

            // Content Body
            Flexible(
              child: SingleChildScrollView( // Allow scrolling if height is too small
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    // Top Row: Purchaser and Witness
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Purchaser
                          Expanded(
                            child: _buildPurchaserSection(isDark),
                          ),
                          
                          const SizedBox(width: AppSpacing.xl),
                          VerticalDivider(color: isDark ? Colors.white12 : Colors.grey.shade200),
                          const SizedBox(width: AppSpacing.xl),

                          // Witness
                          Expanded(
                            child: _buildWitnessSection(isDark),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                    Divider(color: isDark ? Colors.white12 : Colors.grey.shade200),
                    const SizedBox(height: AppSpacing.xl),

                    // Middle Row: Bike Details
                    _buildBikeSection(isDark),

                    const SizedBox(height: AppSpacing.xl),
                    Divider(color: isDark ? Colors.white12 : Colors.grey.shade200),
                    const SizedBox(height: AppSpacing.xl),

                    // Bottom Row: Financials
                    _buildFinancialSection(isDark, controller),
                  ],
                ),
              ),
            ),

            // Footer
            _buildFooter(isDark),
          ],
        ),
      ),
      ),
    );
  }

  // --- Sections ---

  Widget _buildPurchaserSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Purchaser Details', LucideIcons.user, isDark),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Photo
            _buildPhotoBox(data.purchaserImage, isDark, icon: LucideIcons.user),
            const SizedBox(width: AppSpacing.md),
             Expanded(
              child: Column(
                children: [
                  _buildDetailRow('Name', data.customerName, isDark, isBold: true),
                  const SizedBox(height: 6),
                  _buildDetailRow('Contact', data.customerContact, isDark),
                  const SizedBox(height: 6),
                  _buildDetailRow('CNIC', data.customerCnic, isDark),
                  const SizedBox(height: 6),
                  _buildDetailRow('Address', data.customerAddress, isDark, maxLines: 3),
                  const SizedBox(height: 6),
                  _buildDetailRow('Sale Date', _formatDate(data.saleDate), isDark),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWitnessSection(bool isDark) {
    // Check if we have multiple witnesses
    final hasMultipleWitnesses = data.witnesses != null && data.witnesses!.length > 1;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          hasMultipleWitnesses ? 'Witnesses Details' : 'Witness Details', 
          LucideIcons.users, 
          isDark
        ),
        const SizedBox(height: AppSpacing.lg),
        
        // Display all witnesses if available
        if (data.witnesses != null && data.witnesses!.isNotEmpty) ...[
          // Display witnesses in a column
          Column(
            children: data.witnesses!.asMap().entries.map((entry) {
              final index = entry.key;
              final witness = entry.value;
              final witnessNumber = index + 1;
              
              return Column(
                children: [
                  if (index > 0) ...[
                    const SizedBox(height: AppSpacing.md),
                    Divider(color: isDark ? Colors.white12 : Colors.grey.shade200),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  // Witness header if multiple
                  if (hasMultipleWitnesses) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            'Witness $witnessNumber',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo
                      _buildPhotoBox(witness.cnicFrontFilename, isDark, icon: LucideIcons.userCheck),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          children: [
                            _buildDetailRow('Name', witness.fullName, isDark, isBold: true),
                            const SizedBox(height: 6),
                            _buildDetailRow('Contact', witness.phoneNumber.isNotEmpty ? witness.phoneNumber : '-', isDark),
                            const SizedBox(height: 6),
                            _buildDetailRow('CNIC', witness.cnicNumber, isDark),
                            if (witness.address != null && witness.address!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              _buildDetailRow('Address', witness.address!, isDark, maxLines: 2),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        ] else ...[
          // Fallback to single witness display if witnesses list is not available
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo
              _buildPhotoBox(data.witnessImage, isDark, icon: LucideIcons.userCheck),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  children: [
                    _buildDetailRow('Name', data.witnessName ?? '-', isDark, isBold: true),
                    const SizedBox(height: 6),
                    _buildDetailRow('Contact', data.witnessPhone ?? '-', isDark),
                    const SizedBox(height: 6),
                    _buildDetailRow('CNIC', data.witnessCnic ?? '-', isDark),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildBikeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Bike Details', LucideIcons.bike, isDark),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
             // Bike Image
             _buildPhotoBox(data.bikeImage, isDark, width: 100, height: 70, icon: LucideIcons.bike),
             const SizedBox(width: AppSpacing.lg),
             
             // Details Grid
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Wrap(
                     spacing: 24,
                     runSpacing: 12,
                     children: [
                       _buildFieldBox('Bike Name', data.bikeModel, isDark, minWidth: 150),
                       _buildFieldBox('Chassis No', data.bikeChassisNumber, isDark, minWidth: 150, isMono: true),
                       _buildFieldBox('Engine No', data.bikeEngineNumber, isDark, minWidth: 150, isMono: true),
                     ],
                   ),
                   if (data.bikeCondition != null) ...[
                     const SizedBox(height: 12),
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                       decoration: BoxDecoration(
                         color: data.bikeCondition == BikeConditionEnum.newBike 
                             ? const Color(0xFF3B82F6).withOpacity(0.1) 
                             : const Color(0xFFA16207).withOpacity(0.1),
                         borderRadius: BorderRadius.circular(4),
                         border: Border.all(
                           color: data.bikeCondition == BikeConditionEnum.newBike 
                               ? const Color(0xFF3B82F6) 
                               : const Color(0xFFA16207),
                         ),
                       ),
                       child: Text(
                         data.bikeCondition == BikeConditionEnum.newBike ? '🆕 NEW' : '🔄 USED',
                         style: GoogleFonts.outfit(
                           fontSize: 10,
                           fontWeight: FontWeight.bold,
                           color: data.bikeCondition == BikeConditionEnum.newBike 
                               ? const Color(0xFF3B82F6) 
                               : const Color(0xFFA16207),
                         ),
                       ),
                     ),
                   ],
                 ],
               ),
             ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialSection(bool isDark, SalesController controller) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           _buildSectionHeader('Installment Plan', LucideIcons.calculator, isDark),
           const SizedBox(height: AppSpacing.lg),
           
           Row(
             children: [
               Expanded(
                 child: Column(
                   children: [
                     _buildPriceRow('Total Actual Price', data.bikePrice, controller, isDark),
                     if (data.discountAmount > 0) ...[
                       const SizedBox(height: 8),
                       _buildPriceRow('Discount (-)', data.discountAmount, controller, isDark, color: Colors.orange),
                     ],
                     const SizedBox(height: 8),
                     _buildPriceRow('Selling Price (Markup)', data.sellingPrice, controller, isDark, isBold: true, color: const Color(0xFFF59E0B)),
                   ],
                 ),
               ),
               Container(
                 height: 40,
                 width: 1,
                 margin: const EdgeInsets.symmetric(horizontal: 24),
                 color: isDark ? Colors.white12 : Colors.grey.shade300,
               ),
               Expanded(
                 child: Column(
                   children: [
                     _buildPriceRow('Down Payment', data.amountPaid, controller, isDark),
                     const SizedBox(height: 8),
                     _buildPriceRow('Monthly Installment', data.installmentMonthlyPayment, controller, isDark, isBold: true),
                   ],
                 ),
               ),
             ],
           ),
           const SizedBox(height: AppSpacing.lg),
           Divider(color: isDark ? Colors.white12 : Colors.grey.shade200),
           const SizedBox(height: AppSpacing.lg),
           
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               _buildBadgeInfo('Duration', '${data.installmentDuration ?? 0} Months', isDark, const Color(0xFF3B82F6)),
               if (data.isInstallmentCompleted)
                 _buildBadgeInfo('Status', 'Completed', isDark, const Color(0xFF22C55E))
               else
                 _buildBadgeInfo('Due Date', 'Monthly ${data.installmentDueDate ?? "-"}', isDark, const Color(0xFFF59E0B)),
               _buildBadgeInfo('Remaining', 'Rs ${controller.currencyFormat(data.amountRemaining ?? 0)}', isDark, const Color(0xFFEF4444)),
             ],
           ),
        ],
      ),
    );
  }

  // --- Components ---

  Widget _buildBadgeInfo(String label, String value, bool isDark, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text('$label: ', style: GoogleFonts.outfit(fontSize: 12, color: color.withOpacity(0.8))),
          Text(value, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double? amount, SalesController controller, bool isDark, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 13, color: isDark ? Colors.white54 : Colors.black54)),
        Text(
          'Rs ${controller.currencyFormat(amount ?? 0)}',
          style: GoogleFonts.outfit(
            fontSize: 15, 
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldBox(String label, String value, bool isDark, {double? minWidth, bool isMono = false}) {
    return Container(
      constraints: BoxConstraints(minWidth: minWidth ?? 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.outfit(fontSize: 11, color: isDark ? Colors.white38 : Colors.black45)),
          const SizedBox(height: 2),
          Text(
            value, 
            style: isMono 
            ? GoogleFonts.robotoMono(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87)
            : GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoBox(String? imagePath, bool isDark, {required IconData icon, double width = 60, double height = 60}) {
    return Container(
       width: width,
       height: height,
       decoration: BoxDecoration(
         color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
         borderRadius: BorderRadius.circular(AppRadius.lg),
         border: Border.all(
           color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
         ),
       ),
       child: imagePath != null && imagePath.isNotEmpty
         ? ClipRRect(
             borderRadius: BorderRadius.circular(AppRadius.lg),
             child: Image.file(
               File(imagePath),
               fit: BoxFit.cover,
               width: width,
               height: height,
               errorBuilder: (_,__,___) => Icon(icon, color: Colors.grey),
             ),
           )
         : Center(child: Icon(icon, color: isDark ? Colors.white24 : Colors.black26)),
    );
  }

  // Reuse logic from Cash Dialog or similar
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        border: Border(
          bottom: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.calendarClock, color: Color(0xFFF59E0B), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Installment Sale Details',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Invoice #${data.saleDate.replaceAll("/", "")}002', 
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(LucideIcons.x, color: isDark ? Colors.white54 : Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            letterSpacing: 0.5,
            textStyle: const TextStyle(fontFeatures: [FontFeature.enable('smcp')]),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark, {bool isBold = false, int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.xxl)),
        border: Border(
          top: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
           OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
              foregroundColor: isDark ? Colors.white : Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
            child: const Text('Close'),
          ),
           const SizedBox(width: AppSpacing.md),
           ElevatedButton.icon(
            onPressed: () {
              Get.back(); // Close dialog
              Get.find<SalesController>().exportSaleInvoice(data);
            },
            icon: const Icon(LucideIcons.download, size: 18),
            label: const Text('Download Invoice'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkPrimary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final dt = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        return DateFormat('d MMM y').format(dt);
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }
}
