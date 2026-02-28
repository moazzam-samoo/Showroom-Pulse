import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sale_card.dart';

class CashSaleDetailDialog extends StatelessWidget {
  final SaleCardData data;

  const CashSaleDetailDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    print('Cash Dialog - Purchaser Image: ${data.purchaserImage}');

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
        width: 850, // Wider to accommodate witness section
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(context, isDark),

            // Content Body (Scrollable for witnesses)
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, 
                  vertical: AppSpacing.lg
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Row: Customer and Bike
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Column: Customer Details
                          Expanded(
                            flex: 5,
                            child: _buildCustomerSection(isDark),
                          ),
                          
                          const SizedBox(width: AppSpacing.xl),
                          VerticalDivider(color: isDark ? Colors.white12 : Colors.grey.shade200),
                          const SizedBox(width: AppSpacing.xl),

                          // Right Column: Bike Details
                          Expanded(
                            flex: 4, 
                            child: _buildBikeSection(isDark),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                    Divider(color: isDark ? Colors.white12 : Colors.grey.shade200),
                    const SizedBox(height: AppSpacing.xl),

                    // Witness Section
                    _buildWitnessSection(isDark),

                    const SizedBox(height: AppSpacing.xl),
                    Divider(color: isDark ? Colors.white12 : Colors.grey.shade200),
                    const SizedBox(height: AppSpacing.lg),

                    // Price Section
                    _buildPriceSection(isDark),
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

  Widget _buildCustomerSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Purchaser Details', LucideIcons.user, isDark),
        const SizedBox(height: AppSpacing.lg),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Photo
            Container(
               width: 80,
               height: 80,
               decoration: BoxDecoration(
                 color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                 borderRadius: BorderRadius.circular(AppRadius.lg),
                 border: Border.all(
                   color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
                 ),
               ),
               child: data.purchaserImage != null && data.purchaserImage!.isNotEmpty
                 ? ClipRRect(
                     borderRadius: BorderRadius.circular(AppRadius.lg),
                     child: Image.file(
                        File(data.purchaserImage!),
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        errorBuilder: (_,__,___) {
                          print('Error loading purchaser image (Cash): ${data.purchaserImage}');
                          return _buildPlaceholderIcon(isDark);
                        },
                     ),
                   )
                 : _buildPlaceholderIcon(isDark),
            ),
            const SizedBox(width: AppSpacing.md),

            // Text Info
             Expanded(
              child: Column(
                children: [
                  _buildDetailRow('Name', data.customerName, isDark, isBold: true),
                  const SizedBox(height: 6),
                  _buildDetailRow('Contact', data.customerContact, isDark),
                  const SizedBox(height: 6),
                  _buildDetailRow('CNIC', data.customerCnic, isDark),
                  const SizedBox(height: 6),
                  _buildDetailRow('Address', data.customerAddress, isDark, maxLines: 5),
                ],
              ),
            ),
          ],
        ),
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
             Container(
               width: 60,
               height: 60,
               decoration: BoxDecoration(
                 color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                 borderRadius: BorderRadius.circular(AppRadius.md),
                 border: Border.all(
                   color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
                 ),
               ),
               child: data.bikeImage.isNotEmpty
                 ? ClipRRect(
                     borderRadius: BorderRadius.circular(AppRadius.md),
                     child: Image.file(
                        File(data.bikeImage),
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        errorBuilder: (_,__,___) => const Icon(LucideIcons.bike, size: 24, color: Colors.grey),
                     ),
                   )
                 : const Icon(LucideIcons.bike, size: 24, color: Colors.grey),
            ),
             const SizedBox(width: AppSpacing.md),
             Expanded(
               child: Text(
                  data.bikeModel,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
               ),
             ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        
        _buildDetailRow('Chassis', data.bikeChassisNumber, isDark, isMono: true),
        const SizedBox(height: 6),
        _buildDetailRow('Engine', data.bikeEngineNumber, isDark, isMono: true),
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
          // Display witnesses in a row or column based on count
          if (hasMultipleWitnesses)
            // Multiple witnesses - display in columns for better space usage
            Wrap(
              spacing: AppSpacing.xl,
              runSpacing: AppSpacing.lg,
              children: data.witnesses!.asMap().entries.map((entry) {
                final index = entry.key;
                final witness = entry.value;
                final witnessNumber = index + 1;
                
                return Container(
                  width: (850 - (AppSpacing.xl * 4)) / 2, // Two columns
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Witness header
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
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Photo
                          _buildPhotoBox(witness.cnicFrontFilename, isDark, icon: LucideIcons.userCheck),
                          const SizedBox(width: AppSpacing.md),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                );
              }).toList(),
            )
          else
            // Single witness - centered display
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo
                _buildPhotoBox(data.witnesses!.first.cnicFrontFilename, isDark, icon: LucideIcons.userCheck),
                const SizedBox(width: AppSpacing.md),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      _buildDetailRow('Name', data.witnesses!.first.fullName, isDark, isBold: true),
                      const SizedBox(height: 6),
                      _buildDetailRow('Contact', data.witnesses!.first.phoneNumber.isNotEmpty ? data.witnesses!.first.phoneNumber : '-', isDark),
                      const SizedBox(height: 6),
                      _buildDetailRow('CNIC', data.witnesses!.first.cnicNumber, isDark),
                      if (data.witnesses!.first.address != null && data.witnesses!.first.address!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _buildDetailRow('Address', data.witnesses!.first.address!, isDark, maxLines: 2),
                      ],
                    ],
                  ),
                ),
              ],
            ),
        ] else ...[
          // Fallback to single witness display if witnesses list is not available
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo
              _buildPhotoBox(data.witnessImage, isDark, icon: LucideIcons.userCheck),
              const SizedBox(width: AppSpacing.md),
              Flexible(
                fit: FlexFit.tight,
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

  Widget _buildPhotoBox(String? imagePath, bool isDark, {required IconData icon, bool isAsset = false, double width = 60, double height = 60}) {
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

  Widget _buildPriceSection(bool isDark) {
    final controller = Get.find<SalesController>();
    
    return Row(
      children: [
        // Date Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
             color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
             borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
               Icon(LucideIcons.calendar, size: 16, color: isDark ? Colors.white70 : Colors.black54),
               const SizedBox(width: 8),
               Text(
                 _formatDate(data.saleDate), 
                 style: GoogleFonts.outfit(
                   fontSize: 14,
                   fontWeight: FontWeight.w500,
                   color: isDark ? Colors.white : Colors.black87,
                 ),
               ),
            ],
          ),
        ),
        
        const Spacer(),

        // Prices
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             if (data.discountAmount > 0) ...[
               Text(
                 'Original Price: Rs ${controller.currencyFormat(data.bikePrice ?? data.amountPaid)}',
                 style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey, decoration: TextDecoration.lineThrough),
               ),
               Text(
                 'Discount: -Rs ${controller.currencyFormat(data.discountAmount)} (${data.discountPercentage.toStringAsFixed(1)}%)',
                 style: GoogleFonts.outfit(fontSize: 12, color: Colors.orange),
               ),
               const SizedBox(height: 4),
             ],
             Text(
               data.discountAmount > 0 ? 'Final Sale Price' : 'Sale Price',
               style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF22C55E)),
             ),
             Text(
               'Rs ${controller.currencyFormat(data.amountPaid)}',
               style: GoogleFonts.outfit(
                 fontSize: 24,
                 fontWeight: FontWeight.bold,
                 color: const Color(0xFF22C55E),
               ),
             ),
          ],
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

  // Helpers
  String _formatDate(String dateStr) {
    try {
      // Assuming mock data is DD/MM/YYYY
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

  Widget _buildPlaceholderIcon(bool isDark) {
    return Center(
      child: Icon(
        LucideIcons.user,
        size: 32,
        color: isDark ? Colors.white24 : Colors.black26,
      ),
    );
  }

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
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.checkCircle, color: Color(0xFFEF4444), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cash Sale Details',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Invoice #${data.saleDate.replaceAll("/", "")}001', 
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
            textStyle: const TextStyle(fontFeatures: [FontFeature.enable('smcp')]), // Small Caps for elegance
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark, {bool isBold = false, bool isMono = false, int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 80,
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
            style: isMono 
              ? GoogleFonts.robotoMono(
                  fontSize: 13,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                )
              : GoogleFonts.outfit(
                  fontSize: 14,
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
}
