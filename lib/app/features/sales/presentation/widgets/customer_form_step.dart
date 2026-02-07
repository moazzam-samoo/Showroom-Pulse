import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';
import 'package:tahir_showroom/app/core/utils/cnic_input_formatter.dart';
import 'package:tahir_showroom/app/core/utils/phone_number_input_formatter.dart';

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
                label: 'Father Name', 
                prefixIcon: LucideIcons.users,
                controller: controller.customerFatherNameController,
              )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: AppTextField(
                label: 'Phone Number', 
                hint: '03XX-XXXXXXX',
                prefixIcon: LucideIcons.phone,
                controller: controller.customerPhoneController,
                inputFormatters: [PhoneNumberInputFormatter()],
              )),
              const SizedBox(width: 16),
              Expanded(child: AppTextField(
                label: 'CNIC Number', 
                hint: '35201-1234567-8',
                prefixIcon: LucideIcons.creditCard,
                controller: controller.customerCnicController,
                inputFormatters: [CnicInputFormatter()],
              )),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Address', 
            prefixIcon: LucideIcons.mapPin, 
            maxLines: 2,
            controller: controller.customerAddressController,
          ),
          const SizedBox(height: 16),
          
          // Image Upload Pickers (Now Clickable!)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImagePicker(
                context,
                label: 'Profile Photo',
                imagePath: controller.customerProfileImagePath,
                onPick: () => _pickImage(controller.customerProfileImagePath),
              ),
              const SizedBox(width: 16),
              _buildImagePicker(
                context,
                label: 'CNIC Front',
                imagePath: controller.customerCnicFrontPath,
                onPick: () => _pickImage(controller.customerCnicFrontPath),
              ),
              const SizedBox(width: 16),
              _buildImagePicker(
                context,
                label: 'CNIC Back',
                imagePath: controller.customerCnicBackPath,
                onPick: () => _pickImage(controller.customerCnicBackPath),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(
    BuildContext context, {
    required String label,
    required RxnString imagePath,
    required VoidCallback onPick,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final hasImage = imagePath.value != null;

      return GestureDetector(
        onTap: onPick,
        child: Container(
          width: 270,
          height: 148,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasImage
                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  : Colors.grey.withOpacity(0.3),
              width: hasImage ? 2 : 1,
            ),
          ),
          child: hasImage
              ? Stack(
                  children: [
                    // Image Preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imagePath.value!),
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    // Remove Button
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => imagePath.value = null,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.x,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.camera, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Click to upload',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Future<void> _pickImage(RxnString pathVariable) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      pathVariable.value = result.files.first.path;
    }
  }
}
