import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';

class VehicleCard extends StatelessWidget {
  final TransactionRecord transaction;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final bike = transaction.bike;
    
    // Determine payment type badge
    final isCash = !transaction.isInstallment;
    final badgeColor = isCash ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);
    final badgeText = isCash ? 'SOLD (NOT AVAILABLE)' : 'INSTALLMENT (RESERVED)';

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
          boxShadow: [
            if (!isDark) BoxShadow(
               color: Colors.black.withOpacity(0.05),
               blurRadius: 10,
               offset: const Offset(0, 4),
            )
          ]
        ),
        clipBehavior: Clip.antiAlias,
         // Use column for vertical layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section with Badge
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (bike.imageFilename != null && bike.imageFilename!.isNotEmpty)
                    Image.file(
                      File(bike.imageFilename!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(isDark),
                    )
                  else
                    _buildPlaceholder(isDark),
                  
                  // Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details Section
            Expanded(
              flex: 4, // More space for details
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Model Name
                    Row(
                      children: [
                        Icon(LucideIcons.bike, size: 20, color: primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${bike.modelYear} ${bike.model}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Amount Paid
                    _buildDetailRow(
                        'Amount Paid:', 
                        'Rs ${NumberFormat("#,##0").format(transaction.isInstallment ? (transaction.contract?.downPayment ?? 0) : transaction.sale.totalAmount)}',
                        isDark, 
                        isAmount: true
                    ),
                    const Spacer(),
                     // Sale Date
                    _buildDetailRow(
                        'Sale Date:', 
                        DateFormat('dd/MM/yyyy').format(transaction.sale.saleDate),
                        isDark,
                        isDate: true
                    ),
                    
                    const SizedBox(height: AppSpacing.md),
                    const Divider(height: 1),
                    const SizedBox(height: AppSpacing.md),

                    // Customer info (Mini)
                    Row(
                      children: [
                         Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkElevated : Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                           child: const Icon(LucideIcons.user, size: 16),
                         ),
                        const SizedBox(width: 8),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               // We might need to pass customer name or it might be redundant since we are IN the customer view.
                               // But the design shows it.
                               // Since we don't have cust name inside transaction record (only witness), we skip or assume context.
                               // Wait, TransactionRecord doesn't have customer name, but we are in context of one customer.
                               // Actually the design shows "Tameer Khyber" at bottom of card.
                               Text(
                                 transaction.isInstallment ? 'Installment Plan' : 'Cash Sale', // Placeholder or use context
                                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                               ),
                               Text(
                                 bike.chassisNumber.isNotEmpty == true ? bike.chassisNumber : 'Ref: ${transaction.sale.id}',
                                 style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                               ),
                             ],
                           ),
                         )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? AppColors.darkElevated : Colors.grey[200],
      child: Center(
        child: Icon(
          LucideIcons.image,
          size: 48,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark, {bool isAmount = false, bool isDate = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isDate ? 14 : 13,
             fontWeight: isDate ? FontWeight.bold : FontWeight.normal,
            color: isAmount ? AppColors.darkSuccess : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }
}
