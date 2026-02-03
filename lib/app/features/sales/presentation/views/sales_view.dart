import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/views/new_sale_view.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/recent_sales_table.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sales_filter_bar.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sales_card_grid.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';

class SalesView extends GetView<SalesController> {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Row(
        children: [
          // Sidebar
          SidebarNavigation(
            selectedIndex: 3, // Sales Index
            onItemSelected: (index) {
              switch (index) {
                case 0:
                  Get.offNamed('/dashboard');
                  // Or Get.back() if we came from dashboard? 
                  // Usually Navigation Bar implies replacing routes.
                  // Implemented consistent logic:
                  break;
                case 1:
                  Get.offNamed('/procurement');
                  break;
                case 2:
                  Get.offNamed('/inventory');
                  break;
                case 3:
                  // Already on Sales
                  break;
                case 4:
                  Get.offNamed('/customers');
                  break;
                case 5:
                  Get.offNamed('/reports');
                  break;
                case 6:
                  Get.offNamed('/settings');
                  break;
              }
            },
          ),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                 // Custom Header (Optional: If user wants specific header, we can add it here or keep page specific header)
                 // Keeping page specific header inside padding for now as per design
                 
                 Expanded(
                   child: SingleChildScrollView(
                     padding: const EdgeInsets.all(AppSpacing.lg),
                     child: Column(
                       children: [
                         // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Optional Back Button logic if requested
                                    // IconButton(onPressed: () => Get.back(), icon: Icon(LucideIcons.arrowLeft)),
                                    // But Sidebar is usually top level.
                                    Text(
                                      'Sales Management',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Manage invoices, payments, and installment contracts',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Get.to(() => const NewSaleView(), binding: BindingsBuilder(() {
                                  Get.put(NewSaleController());
                                }));
                              },
                              icon: const Icon(LucideIcons.plusCircle, size: 20),
                              label: const Text('New Sale'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Filters
                        const SalesFilterBar(),
                        const SizedBox(height: AppSpacing.lg),

                        const SizedBox(height: AppSpacing.lg),

                        // Sales Grid
                        // Must be sized for GridView inside SingleChildScrollView
                        // Or use ShrinkWrap? Better to use CustomScrollView but for quick fix:
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 250, // Approximate remaining height
                          child: const SalesCardGrid(),
                        ),
                       ],
                     ),
                   ),
                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
