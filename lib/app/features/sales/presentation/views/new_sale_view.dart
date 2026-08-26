import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/app_card.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/bike_selector.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/customer_form_step.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/payment_plan_step.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/witness_form_step.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/customer_paper_tracking_step.dart';

class NewSaleView extends GetView<NewSaleController> {
  const NewSaleView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            _handleCancel(context);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            FocusManager.instance.primaryFocus?.nextFocus();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            FocusManager.instance.primaryFocus?.previousFocus();
          }
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          title: const Text('New Sale Entry'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => _handleCancel(context),
          ),
          actions: [
            TextButton(
               onPressed: () => _handleCancel(context),
               child: const Text('Cancel'),
            )
          ],
        ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Select Bike
            _buildSectionHeader(context, '1. Vehicle Selection', LucideIcons.bike),
            const SizedBox(height: AppSpacing.sm),
            const AppCard(
              child: BikeSelector(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 2: Customer Details
            Container(
              key: controller.customerSectionKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, '2. Customer Information', LucideIcons.user),
                  const SizedBox(height: AppSpacing.sm),
                  const AppCard(
                    child: CustomerFormStep(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 3: Witness Information
            _buildSectionHeader(context, '3. Witness Information', LucideIcons.userCheck),
            const SizedBox(height: AppSpacing.sm),
            const AppCard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: WitnessFormStep(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 4: Payment Plan
            _buildSectionHeader(context, '4. Payment Terms & Contract', LucideIcons.creditCard),
            const SizedBox(height: AppSpacing.sm),
            const AppCard(
              child: PaymentPlanStep(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 5: Document Tracking
            _buildSectionHeader(context, '5. Document Tracking', LucideIcons.fileText),
            const SizedBox(height: AppSpacing.sm),
            const AppCard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: CustomerPaperTrackingStep(),
              ),
            ),
            
            const SizedBox(height: 100), // Space for FAB
          ].animate(interval: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        ),
      ),
      floatingActionButton: BlinkingFocusBuilder(
        focusNode: controller.completeSaleFocus,
        child: FloatingActionButton.extended(
          focusNode: controller.completeSaleFocus,
          onPressed: () {
            controller.completeSaleFocus.requestFocus();
            controller.finalizeSale();
          },
          label: const Text('Complete Sale'),
          icon: const Icon(LucideIcons.check),
          backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        ),
      ),
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    // Check if any data has been entered
    final hasData = _hasUnsavedChanges();
    
    if (hasData) {
      // Show confirmation dialog
      Get.dialog(
        AlertDialog(
          title: const Text('Cancel Entry?'),
          content: const Text('Are you sure you want to cancel this entry? All unsaved data will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Close dialog
              child: const Text('No, Continue'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Go back to previous screen
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Yes, Cancel'),
            ),
          ],
        ),
      );
    } else {
      // No data entered, go back directly
      Get.back();
    }
  }

  bool _hasUnsavedChanges() {
    // Check if bike is selected
    if (controller.selectedBike.value != null) return true;
    
    // Check customer form
    if (controller.customerNameController.text.isNotEmpty) return true;
    if (controller.customerFatherNameController.text.isNotEmpty) return true;
    if (controller.customerPhoneController.text.isNotEmpty) return true;
    if (controller.customerCnicController.text.isNotEmpty) return true;
    if (controller.customerAddressController.text.isNotEmpty) return true;
    
    // Check witness form
    if (controller.witness1NameController.text.isNotEmpty) return true;
    if (controller.witness1CnicController.text.isNotEmpty) return true;
    
    // Check payment
    if (controller.cashAmountController.text.isNotEmpty) return true;
    if (controller.downPaymentController.text.isNotEmpty && controller.downPaymentController.text != '0') return true;
    
    return false;
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
