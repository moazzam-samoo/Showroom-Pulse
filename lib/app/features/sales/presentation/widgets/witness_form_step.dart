import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:tahir_showroom/app/core/utils/cnic_input_formatter.dart';
import 'package:tahir_showroom/app/core/utils/phone_number_input_formatter.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';

class WitnessFormStep extends StatelessWidget {
  const WitnessFormStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewSaleController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Witness 1 Header
        _buildWitnessHeader(
          context,
          title: 'Witness 1',
          subtitle: 'Required',
          isRequired: true,
        ),
        const SizedBox(height: AppSpacing.md),

        // Witness 1 Form
        _buildWitnessForm(
          context,
          nameController: controller.witness1NameController,
          cnicController: controller.witness1CnicController,
          phoneController: controller.witness1PhoneController,
          addressController: controller.witness1AddressController,
          nameFocus: controller.witness1NameFocus,
          cnicFocus: controller.witness1CnicFocus,
          phoneFocus: controller.witness1PhoneFocus,
          addressFocus: controller.witness1AddressFocus,
          cnicFrontFocus: controller.witness1CnicFrontPathFocus,
          cnicBackFocus: controller.witness1CnicBackPathFocus,
          cnicFrontPath: controller.witness1CnicFrontPath,
          cnicBackPath: controller.witness1CnicBackPath,
          onCnicFrontPick: () {
            controller.witness1CnicFrontPathFocus.requestFocus();
            _pickImage(controller.witness1CnicFrontPath);
          },
          onCnicBackPick: () {
            controller.witness1CnicBackPathFocus.requestFocus();
            _pickImage(controller.witness1CnicBackPath);
          },
        ),

        const SizedBox(height: AppSpacing.xl),

        // Witness 2 Toggle
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => controller.showWitness2.toggle(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isDark ? Colors.white12 : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.showWitness2.value
                              ? LucideIcons.chevronDown
                              : LucideIcons.chevronRight,
                          size: 20,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add Witness 2 (Optional)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          LucideIcons.userPlus,
                          size: 18,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                        ),
                      ],
                    ),
                  ),
                ),

                // Witness 2 Form (Collapsible)
                if (controller.showWitness2.value) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _buildWitnessHeader(
                    context,
                    title: 'Witness 2',
                    subtitle: 'Optional',
                    isRequired: false,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildWitnessForm(
                    context,
                    nameController: controller.witness2NameController,
                    cnicController: controller.witness2CnicController,
                    phoneController: controller.witness2PhoneController,
                    addressController: controller.witness2AddressController,
                    nameFocus: controller.witness2NameFocus,
                    cnicFocus: controller.witness2CnicFocus,
                    phoneFocus: controller.witness2PhoneFocus,
                    addressFocus: controller.witness2AddressFocus,
                    cnicFrontFocus: controller.witness2CnicFrontPathFocus,
                    cnicBackFocus: controller.witness2CnicBackPathFocus,
                    cnicFrontPath: controller.witness2CnicFrontPath,
                    cnicBackPath: controller.witness2CnicBackPath,
                    onCnicFrontPick: () {
                      controller.witness2CnicFrontPathFocus.requestFocus();
                      _pickImage(controller.witness2CnicFrontPath);
                    },
                    onCnicBackPick: () {
                      controller.witness2CnicBackPathFocus.requestFocus();
                      _pickImage(controller.witness2CnicBackPath);
                    },
                  ),
                ],
              ],
            )),
      ],
    );
  }

  Widget _buildWitnessHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isRequired,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isRequired
                ? AppColors.darkPrimary.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.userCheck,
            size: 20,
            color: isRequired ? AppColors.darkPrimary : Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isRequired ? AppColors.darkPrimary : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWitnessForm(
    BuildContext context, {
    required TextEditingController nameController,
    required TextEditingController cnicController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required FocusNode nameFocus,
    required FocusNode cnicFocus,
    required FocusNode phoneFocus,
    required FocusNode addressFocus,
    required FocusNode cnicFrontFocus,
    required FocusNode cnicBackFocus,
    required RxnString cnicFrontPath,
    required RxnString cnicBackPath,
    required VoidCallback onCnicFrontPick,
    required VoidCallback onCnicBackPick,
  }) {
    return Column(
      children: [
        // Row 1: Name & CNIC
        Row(
          children: [
            Expanded(
              child: BlinkingFocusBuilder(
                focusNode: nameFocus,
                child: AppTextField(
                  label: 'Full Name',
                  prefixIcon: LucideIcons.user,
                  controller: nameController,
                  focusNode: nameFocus,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                  formNavigationManager: Get.find<NewSaleController>().formNavigationManager,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlinkingFocusBuilder(
                focusNode: cnicFocus,
                child: AppTextField(
                  label: 'CNIC Number',
                  hint: '35201-1234567-8',
                  prefixIcon: LucideIcons.creditCard,
                  controller: cnicController,
                  focusNode: cnicFocus,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [CnicInputFormatter()],
                  formNavigationManager: Get.find<NewSaleController>().formNavigationManager,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 15) return 'Invalid CNIC';
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 2: Phone & Address
        Row(
          children: [
            Expanded(
              child: BlinkingFocusBuilder(
                focusNode: phoneFocus,
                child: AppTextField(
                  label: 'Phone Number',
                  hint: '03XX-XXXXXXX',
                  prefixIcon: LucideIcons.phone,
                  controller: phoneController,
                  focusNode: phoneFocus,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [PhoneNumberInputFormatter()],
                  formNavigationManager: Get.find<NewSaleController>().formNavigationManager,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 12) return 'Invalid Phone';
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlinkingFocusBuilder(
                focusNode: addressFocus,
                child: AppTextField(
                  label: 'Address',
                  prefixIcon: LucideIcons.mapPin,
                  controller: addressController,
                  focusNode: addressFocus,
                  textInputAction: TextInputAction.next,
                  formNavigationManager: Get.find<NewSaleController>().formNavigationManager,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 3: CNIC Images
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImagePicker(
              context,
              label: 'CNIC Front *',
              imagePath: cnicFrontPath,
              focusNode: cnicFrontFocus,
              onPick: onCnicFrontPick,
              isRequired: true,
            ),
            const SizedBox(width: 16),
            _buildImagePicker(
              context,
              label: 'CNIC Back',
              imagePath: cnicBackPath,
              focusNode: cnicBackFocus,
              onPick: onCnicBackPick,
              isRequired: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePicker(
    BuildContext context, {
    required String label,
    required RxnString imagePath,
    required FocusNode focusNode,
    required VoidCallback onPick,
    required bool isRequired,
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
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isRequired && !hasImage
                      ? Colors.red.withOpacity(0.5)
                      : (isDark ? Colors.white12 : Colors.grey.shade300),
                ),
              ),
              child: hasImage
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Image.file(
                            File(imagePath.value!),
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
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
                        Icon(
                          LucideIcons.upload,
                          color: isDark ? Colors.white38 : Colors.grey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isDark ? Colors.white54 : Colors.grey.shade700,
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
