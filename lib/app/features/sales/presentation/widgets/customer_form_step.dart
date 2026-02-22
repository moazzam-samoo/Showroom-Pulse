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
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';

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
    final controller = Get.find<NewSaleController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final selectedCustomer = controller.selectedCustomer.value;
      if (selectedCustomer != null) {
        // Option A: Selected Customer Profile Card
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkPrimary.withOpacity(0.1) : AppColors.lightPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkPrimary.withOpacity(0.5) : AppColors.lightPrimary.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                radius: 26,
                child: Text(
                  selectedCustomer.fullName.isNotEmpty ? selectedCustomer.fullName[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          selectedCustomer.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.withOpacity(0.5)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.checkCircle2, size: 12, color: Colors.green),
                              SizedBox(width: 4),
                              Text('Selected', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(LucideIcons.phone, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(selectedCustomer.phoneNumber, style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(width: 16),
                        Icon(LucideIcons.creditCard, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(selectedCustomer.cnicNumber, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => controller.clearSelectedCustomer(),
                icon: const Icon(LucideIcons.x, size: 28),
                tooltip: 'Change Customer',
                color: Colors.red,
              ),
            ],
          ),
        );
      }

      // Default Search UI
      return Column(
        children: [
          BlinkingFocusBuilder(
            focusNode: controller.searchCustomerFocus,
            child: TextField(
              controller: controller.customerSearchController,
              focusNode: controller.searchCustomerFocus,
              onChanged: (value) => controller.searchCustomers(value),
              decoration: InputDecoration(
                hintText: 'Search by Name, CNIC (with/without dashes) or Phone',
                prefixIcon: const Icon(LucideIcons.search),
                suffixIcon: Obx(() => controller.isSearching.value
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const SizedBox.shrink()),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.searchResults.isEmpty) {
              if (controller.customerSearchController.text.isNotEmpty &&
                  !controller.isSearching.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(LucideIcons.searchX, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No customers found',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: Text('Search results will appear here'));
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.searchResults.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final customer = controller.searchResults[index];
                return _buildSearchResultItem(context, customer, controller);
              },
            );
          }),
        ],
      );
    });
  }

  Widget _buildSearchResultItem(
    BuildContext context,
    CustomerWithTransactions customerWithTxn,
    NewSaleController controller,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final customer = customerWithTxn.customer;
    final hasActiveInstallments = customerWithTxn.pendingAmount > 0;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          child: Text(
            customerWithTxn.initials,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          customer.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(LucideIcons.creditCard, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(customer.cnicNumber,
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(width: 16),
                Icon(LucideIcons.phone, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(customer.phoneNumber,
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            if (hasActiveInstallments) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: Text(
                  'Pending: Rs. ${customerWithTxn.pendingAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => controller.selectCustomer(customerWithTxn),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Select'),
        ),
      ),
    );
  }

  Widget _buildNewCustomerForm(
      BuildContext context, NewSaleController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BlinkingFocusBuilder(
                  focusNode: controller.customerNameFocus,
                  child: AppTextField(
                    label: 'Full Name',
                    prefixIcon: LucideIcons.user,
                    controller: controller.customerNameController,
                    focusNode: controller.customerNameFocus,
                    textInputAction: TextInputAction.next,
                    formNavigationManager: controller.formNavigationManager,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BlinkingFocusBuilder(
                  focusNode: controller.customerFatherNameFocus,
                  child: AppTextField(
                    label: 'Father Name',
                    prefixIcon: LucideIcons.users,
                    controller: controller.customerFatherNameController,
                    focusNode: controller.customerFatherNameFocus,
                    textInputAction: TextInputAction.next,
                    formNavigationManager: controller.formNavigationManager,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: BlinkingFocusBuilder(
                  focusNode: controller.customerPhoneFocus,
                  child: AppTextField(
                    label: 'Phone Number',
                    hint: '03XX-XXXXXXX',
                    prefixIcon: LucideIcons.phone,
                    controller: controller.customerPhoneController,
                    focusNode: controller.customerPhoneFocus,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [PhoneNumberInputFormatter()],
                    formNavigationManager: controller.formNavigationManager,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BlinkingFocusBuilder(
                  focusNode: controller.customerCnicFocus,
                  child: AppTextField(
                    label: 'CNIC Number',
                    hint: '35201-1234567-8',
                    prefixIcon: LucideIcons.creditCard,
                    controller: controller.customerCnicController,
                    focusNode: controller.customerCnicFocus,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [CnicInputFormatter()],
                    formNavigationManager: controller.formNavigationManager,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlinkingFocusBuilder(
            focusNode: controller.customerAddressFocus,
            child: AppTextField(
              label: 'Address',
              prefixIcon: LucideIcons.mapPin,
              maxLines: 2,
              controller: controller.customerAddressController,
              focusNode: controller.customerAddressFocus,
              textInputAction: TextInputAction.next,
              formNavigationManager: controller.formNavigationManager,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImagePicker(
                context,
                label: 'Profile Photo',
                imagePath: controller.customerProfileImagePath,
                focusNode: controller.customerProfileImagePathFocus,
                onPick: () {
                  controller.customerProfileImagePathFocus.requestFocus();
                  _pickImage(controller.customerProfileImagePath);
                },
              ),
              const SizedBox(width: 16),
              _buildImagePicker(
                context,
                label: 'CNIC Front',
                imagePath: controller.customerCnicFrontPath,
                focusNode: controller.customerCnicFrontPathFocus,
                onPick: () {
                  controller.customerCnicFrontPathFocus.requestFocus();
                  _pickImage(controller.customerCnicFrontPath);
                },
              ),
              const SizedBox(width: 16),
              _buildImagePicker(
                context,
                label: 'CNIC Back',
                imagePath: controller.customerCnicBackPath,
                focusNode: controller.customerCnicBackPathFocus,
                onPick: () {
                  controller.customerCnicBackPathFocus.requestFocus();
                  _pickImage(controller.customerCnicBackPath);
                },
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
    required FocusNode focusNode,
    required VoidCallback onPick,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final hasImage = imagePath.value != null;

      return BlinkingFocusBuilder(
          focusNode: focusNode,
          child: InkWell(
            onTap: onPick,
            child: Container(
              width: 270,
              height: 148,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasImage
                      ? (isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary)
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
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
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
          ));
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
