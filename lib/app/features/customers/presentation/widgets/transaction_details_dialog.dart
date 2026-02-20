import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/core/widgets/app_dialog.dart';

class TransactionDetailsDialog extends StatelessWidget {
  final TransactionRecord transaction;
  final CustomerWithTransactions customer;

  const TransactionDetailsDialog({
    super.key,
    required this.transaction,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = transaction.isInstallment 
        ? const Color(0xFFF59E0B) 
        : const Color(0xFFEF4444);

    return AppDialog(
      title: transaction.isInstallment ? 'Installment Sale Details' : 'Cash Sale Details',
      subtitle: 'Invoice #${transaction.sale.id}',
      width: 800,
      
      // Removed onSubmit to just have a Close/Print button at bottom
      // But AppDialog enforces buttons. We can hijack them.
      actions: [
         TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey.shade400)
            )
          ),
          child: const Text('Close'),
        ),
        const SizedBox(width: AppSpacing.md),
        ElevatedButton.icon(
          onPressed: () {
             // TODO: Implement Print Invoice
             Get.snackbar('Print', 'Print functionality pending');
          },
          icon: const Icon(LucideIcons.printer, size: 16),
          label: const Text('Print Invoice'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Col: Purchaser
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Purchaser Details', LucideIcons.user, primaryColor),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         _buildImageThumb(customer.customer.profileImageFilename, isDark, primaryColor),
                         const SizedBox(width: AppSpacing.md),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               _buildInfoRow('Name', customer.customer.fullName, isDark, isBold: true),
                               _buildInfoRow('Contact', customer.customer.phoneNumber, isDark),
                               _buildInfoRow('CNIC', customer.customer.cnicNumber, isDark),
                               _buildInfoRow('Address', customer.customer.address ?? 'N/A', isDark),
                             ],
                           ),
                         )
                      ],
                    )
                  ],
                ),
              ),
              Container(width: 1, height: 150, color: isDark ? AppColors.darkBorder : Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg)),
              // Right Col: Bike
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Bike Details', LucideIcons.bike, primaryColor),
                      const SizedBox(height: AppSpacing.md),
                       Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         _buildImageThumb(transaction.bike.imageFilename, isDark, primaryColor, isBike: true),
                         const SizedBox(width: AppSpacing.md),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               _buildInfoRow('Model', '${transaction.bike.modelYear} ${transaction.bike.model}', isDark, isBold: true),
                               _buildInfoRow('Chassis', transaction.bike.chassisNumber, isDark),
                               _buildInfoRow('Engine', transaction.bike.engineNumber, isDark),
                             ],
                           ),
                         )
                      ],
                    )
                    ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(),
          const SizedBox(height: AppSpacing.xl),
          
          // Witness Details (if any)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Witness Details', LucideIcons.users, primaryColor),
                const SizedBox(height: AppSpacing.md),
                if (transaction.witnesses.isNotEmpty)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < transaction.witnesses.length; i++) ...[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Witness ${i + 1}${transaction.witnesses[i].isPrimary ? " (Primary)" : ""}',
                                    style: TextStyle(
                                      fontSize: 12, 
                                      fontWeight: FontWeight.bold, 
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary
                                    ),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildImageThumb(
                                      transaction.witnesses[i].cnicFrontFilename != null 
                                          ? Get.find<FileService>().getWitnessCnicImagePath(transaction.witnesses[i].cnicFrontFilename!, customer.customer.cnicNumber)
                                          : null, 
                                      isDark, 
                                      primaryColor
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildInfoRow('Name', transaction.witnesses[i].fullName, isDark, isBold: true),
                                          _buildInfoRow('Contact', transaction.witnesses[i].phoneNumber, isDark),
                                          _buildInfoRow('CNIC', transaction.witnesses[i].cnicNumber, isDark),
                                          _buildInfoRow('Address', transaction.witnesses[i].address ?? 'N/A', isDark),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (i < transaction.witnesses.length - 1)
                            Container(
                              width: 1,
                              color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                            ),
                        ],
                      ],
                    ),
                  )
                else
                  // Fallback for backward compatibility or missing data
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        _buildImageThumb(null, isDark, primaryColor),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Name', transaction.witnessName ?? 'N/A', isDark, isBold: true),
                              _buildInfoRow('Contact', transaction.witnessPhone ?? 'N/A', isDark),
                              _buildInfoRow('CNIC', transaction.witnessId ?? 'N/A', isDark),
                              _buildInfoRow('Address', transaction.witnessAddress ?? 'N/A', isDark),
                            ],
                          ),
                        )
                    ],
                  )
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildImageThumb(String? path, bool isDark, Color primaryColor, {bool isBike = false}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : Colors.grey[200],
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
      ),
      child: path != null && File(path).existsSync()
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.file(File(path), fit: BoxFit.cover),
            )
          : Icon(
              isBike ? LucideIcons.bike : LucideIcons.user,
              size: 32,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
