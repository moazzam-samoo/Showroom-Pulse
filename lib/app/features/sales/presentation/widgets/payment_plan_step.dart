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
import 'package:tahir_showroom/app/core/utils/thousands_separator_input_formatter.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/price_summary_card.dart';

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
          inputFormatters: [ThousandsSeparatorInputFormatter()],
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
                      inputFormatters: [ThousandsSeparatorInputFormatter()],
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
                inputFormatters: [ThousandsSeparatorInputFormatter()],
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

            final downPayment = double.tryParse(controller.downPaymentController.text) ?? 0;

            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: PriceSummaryCard(
                result: result,
                downPayment: downPayment,
              ),
            );
        }),
      ],
    );
  }
}
