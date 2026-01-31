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
import 'package:tahir_showroom/app/core/constants/app_radius.dart';

class SalesView extends GetView<SalesController> {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Padding(
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
                    Text(
                      'Sales Management',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
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

            // Data Table
            const Expanded(
              child: RecentSalesTable(),
            ),
          ],
        ),
      ),
    );
  }
}
