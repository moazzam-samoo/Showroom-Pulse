import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';

class PaymentPlanStep extends StatelessWidget {
  const PaymentPlanStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewSaleController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sale Type Switch
          Obx(() => Row(
            children: [
              Expanded(
                child: _buildToggle(
                  context, 
                  'Cash Sale', 
                  controller.saleType.value == SaleType.cash,
                  () => controller.saleType.value = SaleType.cash,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildToggle(
                  context, 
                  'Installment', 
                  controller.saleType.value == SaleType.installment,
                  () => controller.saleType.value = SaleType.installment,
                ),
              ),
            ],
          )),
          const SizedBox(height: AppSpacing.lg),

          // Dynamic Content
          Obx(() {
            if (controller.saleType.value == SaleType.cash) {
              return _buildCashForm(controller);
            } else {
              return _buildInstallmentForm(context, controller);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildToggle(BuildContext context, String text, bool isSelected, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? primary : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: isSelected ? Border.all(color: primary, width: 2) : Border.all(color: Colors.transparent),
          boxShadow: isSelected ? [BoxShadow(color: primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCashForm(NewSaleController controller) {
    return Column(
      children: [
        AppTextField(
          label: 'Received Amount (Rs)',
          prefixIcon: LucideIcons.banknote,
          controller: controller.cashAmountController,
          hint: 'Enter full cash amount',
        ),
        const SizedBox(height: 20),
        const Text('Cash sale marks bike as SOLD immediately.', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildInstallmentForm(BuildContext context, NewSaleController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // MARKUP CONFIGURATION
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
            color: isDark ? Colors.black26 : Colors.grey[50],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Markup Configuration', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  // Type Dropdown
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<MarkupType>(
                      value: controller.markupType.value,
                      items: const [
                        DropdownMenuItem(value: MarkupType.percentage, child: Text('Percentage (%)')),
                        DropdownMenuItem(value: MarkupType.fixed, child: Text('Fixed Amount (Rs)')),
                      ],
                      onChanged: (val) => controller.markupType.value = val!,
                      decoration: const InputDecoration(labelText: 'Markup Type'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Value Input
                  Expanded(
                    flex: 3,
                    child: AppTextField(
                      label: 'Markup Value', 
                      prefixIcon: LucideIcons.trendingUp,
                      controller: controller.markupValueController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // TERMS
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Down Payment (Rs)',
                prefixIcon: LucideIcons.download,
                controller: controller.downPaymentController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'Installments (Months)',
                prefixIcon: LucideIcons.calendar,
                controller: controller.monthsController,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Live Calculation Result
        Obx(() {
            final result = controller.calculationResult.value;
            if (result == null) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                children: [
                  _summaryRow('Base Price', 'Rs ???', isDark),
                  _summaryRow('Total Markup', 'Rs ${result.totalMarkup.toStringAsFixed(0)}', isDark),
                  _summaryRow('Grand Total', 'Rs ${result.grandTotal.toStringAsFixed(0)}', isDark, isBold: true),
                  const Divider(),
                  _summaryRow('Loan Amount', 'Rs ${(result.grandTotal - (double.tryParse(controller.downPaymentController.text) ?? 0)).toStringAsFixed(0)}', isDark),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkPrimary.withOpacity(0.2) : AppColors.lightPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Monthly Installment', style: TextStyle(color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary, fontWeight: FontWeight.bold)),
                        Text('Rs ${result.monthlyEMI.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            );
        }),
      ],
    );
  }

  Widget _summaryRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          Text(value, style: TextStyle(
            color: isDark ? Colors.white : Colors.black87, 
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal
          )),
        ],
      ),
    );
  }
}
