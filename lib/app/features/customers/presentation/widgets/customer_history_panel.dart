import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/customers/presentation/controllers/customers_controller.dart';
import 'package:tahir_showroom/app/features/customers/presentation/widgets/vehicle_card.dart';
import 'package:tahir_showroom/app/features/customers/presentation/widgets/transaction_details_dialog.dart';
import 'package:intl/intl.dart';

class CustomerHistoryPanel extends GetView<CustomersController> {
  const CustomerHistoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Expanded(
      child: Obx(() {
        final customer = controller.selectedCustomer.value;
        
        if (customer == null) {
          // Empty State
          return Container(
            decoration: BoxDecoration(
               color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.mousePointerClick, size: 48, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  const SizedBox(height: 16),
                  Text(
                    'Select a customer to view history',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // KPI Section (Top - matching image)
            _buildKPISection(context, controller, isDark),
            const SizedBox(height: 24),

            // Main Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                     // Header
                     Padding(
                       padding: const EdgeInsets.all(AppSpacing.lg),
                       child: Row(
                         children: [
                           Text(
                             'CUSTOMER DATA & TRANSACTIONS',
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 14,
                               color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                               letterSpacing: 1,
                             ),
                           ),
                           const Spacer(),
                           // Search
                           SizedBox(
                             width: 200,
                             height: 36,
                             child: TextField(
                               decoration: InputDecoration(
                                 hintText: 'Search...',
                                 contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                 prefixIcon: const Icon(LucideIcons.search, size: 16),
                                 filled: true,
                                 fillColor: isDark ? AppColors.darkElevated : Colors.grey[100],
                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                               ),
                             ),
                           ),
                           const SizedBox(width: 8),
                           OutlinedButton.icon(
                             onPressed: () {},
                             icon: const Icon(LucideIcons.fileUp, size: 16),
                             label: const Text('EXPORT DATA'),
                             style: OutlinedButton.styleFrom(
                               foregroundColor: primaryColor,
                               side: BorderSide(color: primaryColor),
                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                             ),
                           )
                         ],
                       ),
                     ),
                     
                     // Content (Grid of Vehicle Cards)
                     Expanded(
                       child: Padding(
                         padding: const EdgeInsets.all(AppSpacing.lg),
                         child: customer.transactions.isEmpty 
                         ? Center(child: Text('No transactions found', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)))
                         : GridView.builder(
                             gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                               maxCrossAxisExtent: 350,
                               childAspectRatio: 0.85, 
                               crossAxisSpacing: 16,
                               mainAxisSpacing: 16,
                             ),
                             itemCount: customer.transactions.length,
                             itemBuilder: (ctx, index) {
                               final tx = customer.transactions[index];
                               return VehicleCard(
                                 transaction: tx,
                                 onTap: () {
                                    Get.dialog(TransactionDetailsDialog(transaction: tx, customer: customer));
                                 },
                               );
                             },
                           ),
                       ),
                     ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildKPISection(BuildContext context, CustomersController controller, bool isDark) {
    // Reusing the same KPI logic or slightly adapted for the panel
    // The design image shows KPIs at the top of the main screen area.
    return Row(
      children: [
        Expanded(child: _buildKPICard('TOTAL CUSTOMERS', controller.totalCustomers.value.toString(), '+100% last month', LucideIcons.users, isDark, AppColors.darkInfo)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard('ACTIVE INSTALLMENTS', controller.activeInstallmentsCount.value.toString(), 'Rs${_formatCurrency(controller.activeInstallmentsValue.value)} Total Value', LucideIcons.bike, isDark, AppColors.darkPrimary)),
        const SizedBox(width: 16),
         Expanded(child: _buildKPICard('PENDING PAYMENTS', controller.pendingPaymentsCount.value.toString(), 'Rs${_formatCurrency(controller.pendingPaymentsDueSoon.value)} Due Soon', LucideIcons.wallet, isDark, AppColors.darkError)),
      ],
    );
  }
  
   Widget _buildKPICard(String title, String value, String subtitle, IconData icon, bool isDark, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: accentColor,
                ),
              ),
            ],
          ),
          Positioned(
             right: 0,
             top: 0,
             child: Container(
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(
                 color: accentColor.withOpacity(0.1),
                 borderRadius: BorderRadius.circular(8),
               ),
               child: Icon(icon, color: accentColor, size: 20),
             ),
          )
        ],
      ),
    );
  }
  
  String _formatCurrency(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }
}
