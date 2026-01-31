import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/app_card.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/bike_selector.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/customer_form_step.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/payment_plan_step.dart';

class NewSaleView extends GetView<NewSaleController> {
  const NewSaleView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('New Sale Entry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
             onPressed: () => Get.back(),
             child: const Text('Cancel'),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Select Bike
            _buildSectionHeader(context, '1. Vehicle Selection', LucideIcons.bike),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 450), // Use constraints instead of fixed height
                child: const BikeSelector(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 2: Customer Details
            _buildSectionHeader(context, '2. Customer Information', LucideIcons.user),
            const SizedBox(height: AppSpacing.sm),
            const AppCard(
              child: CustomerFormStep(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 3: Payment Plan
            _buildSectionHeader(context, '3. Payment Terms & Contract', LucideIcons.creditCard),
            const SizedBox(height: AppSpacing.sm),
            const AppCard(
              child: PaymentPlanStep(),
            ),
            
            const SizedBox(height: 100), // Space for FAB
          ].animate(interval: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.finalizeSale,
        label: const Text('Complete Sale'),
        icon: const Icon(LucideIcons.check),
        backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}
