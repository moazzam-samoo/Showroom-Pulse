import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';

class CustomerFormStep extends StatelessWidget {
  const CustomerFormStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewSaleController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle: Search vs New
        Obx(() => Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Existing Customer'),
                value: false,
                groupValue: controller.isNewCustomer.value,
                onChanged: (val) => controller.isNewCustomer.value = val!,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('New Customer'),
                value: true,
                groupValue: controller.isNewCustomer.value,
                onChanged: (val) => controller.isNewCustomer.value = val!,
              ),
            ),
          ],
        )),
        const SizedBox(height: AppSpacing.lg),

        Obx(() {
          if (controller.isNewCustomer.value) {
            return _buildNewCustomerForm(context, controller);
          } else {
            return _buildSearchCustomer(context);
          }
        }),
      ],
    );
  }

  Widget _buildSearchCustomer(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Enter CNIC (e.g. 41303-1234567-8)',
            prefixIcon: Icon(LucideIcons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const Center(child: Text('Search results will appear here')),
      ],
    );
  }

  Widget _buildNewCustomerForm(BuildContext context, NewSaleController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: AppTextField(
                label: 'Full Name', 
                prefixIcon: LucideIcons.user,
                controller: controller.customerNameController,
              )),
              const SizedBox(width: 16),
              Expanded(child: AppTextField(
                label: 'Phone Number', 
                prefixIcon: LucideIcons.phone,
                controller: controller.customerPhoneController,
              )),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'CNIC Number', 
            prefixIcon: LucideIcons.creditCard,
            controller: controller.customerCnicController,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Address', 
            prefixIcon: LucideIcons.mapPin, 
            maxLines: 2,
            controller: controller.customerAddressController,
          ),
          const SizedBox(height: 16),
          
          // Image Upload Placeholders
          Row(
            children: [
              Expanded(child: _imagePlaceholder('Profile Photo')),
              const SizedBox(width: 16),
              Expanded(child: _imagePlaceholder('CNIC Front')),
              const SizedBox(width: 16),
              Expanded(child: _imagePlaceholder('CNIC Back')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(String label) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.camera, color: Colors.grey),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
