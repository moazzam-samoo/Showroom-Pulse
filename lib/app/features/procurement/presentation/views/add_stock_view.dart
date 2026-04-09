import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:tahir_showroom/app/core/utils/thousands_separator_input_formatter.dart';
import 'package:tahir_showroom/app/core/utils/cnic_input_formatter.dart';
import 'package:tahir_showroom/app/core/utils/phone_number_input_formatter.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/procurement/presentation/controllers/supplier_controller.dart';
import 'package:tahir_showroom/app/data/models/supplier.dart';
import 'package:tahir_showroom/app/core/widgets/color_skin_selector.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';
import 'package:tahir_showroom/app/features/settings/presentation/controllers/settings_controller.dart';

class AddStockView extends GetView<SupplierController> {
  const AddStockView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    void handleKeyboardNavigation(KeyEvent event) {
      if (event is! KeyDownEvent) return;
      
      if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
        if (controller.isNewSupplier.value) {
          if (controller.newSupplierNameFocus.hasFocus) { controller.newSupplierPhoneFocus.requestFocus(); return; }
          else if (controller.newSupplierPhoneFocus.hasFocus) { controller.newSupplierCnicFocus.requestFocus(); return; }
          else if (controller.newSupplierCnicFocus.hasFocus) { controller.newSupplierProfilePicFocus.requestFocus(); return; }
          else if (controller.newSupplierProfilePicFocus.hasFocus) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              controller.pickSupplierProfilePic();
            } else {
              controller.newSupplierCnicPicFocus.requestFocus();
            }
            return;
          } else if (controller.newSupplierCnicPicFocus.hasFocus) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              controller.pickSupplierCnicPic();
            } else {
              controller.purchaseDateFocus.requestFocus();
            }
            return;
          }
        } else {
          if (controller.existingSupplierDropdownFocus.hasFocus) { controller.purchaseDateFocus.requestFocus(); return; }
        }

        if (controller.purchaseDateFocus.hasFocus) { controller.billImageFocus.requestFocus(); return; }
        else if (controller.billImageFocus.hasFocus) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            controller.pickBatchImage();
          } else {
            controller.addRowFocus.requestFocus();
          }
          return;
        } else if (controller.addRowFocus.hasFocus) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            controller.addBikeEntry();
          } else if (controller.bikeEntries.isNotEmpty) controller.bikeEntries[0].engineFocus.requestFocus();
          else controller.saveBatchFocus.requestFocus();
          return;
        }

        for (int i = 0; i < controller.bikeEntries.length; i++) {
          final entry = controller.bikeEntries[i];
          if (entry.engineFocus.hasFocus) { entry.chassisFocus.requestFocus(); return; }
          else if (entry.chassisFocus.hasFocus) { entry.brandFocus.requestFocus(); return; }
          else if (entry.brandFocus.hasFocus) { entry.modelFocus.requestFocus(); return; }
          else if (entry.conditionFocus.hasFocus) {
            if (entry.condition == BikeConditionEnum.usedBike) {
              entry.regNumberFocus.requestFocus();
            } else {
              entry.colorFocus.requestFocus();
            }
            return;
          }
          else if (entry.regNumberFocus.hasFocus) { entry.colorFocus.requestFocus(); return; }
          else if (entry.colorFocus.hasFocus) { entry.yearFocus.requestFocus(); return; }
          else if (entry.yearFocus.hasFocus) { entry.priceFocus.requestFocus(); return; }
          else if (entry.priceFocus.hasFocus) { entry.imageFocus.requestFocus(); return; }
          else if (entry.imageFocus.hasFocus) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              controller.pickEntryImage(i);
            } else if (i + 1 < controller.bikeEntries.length) controller.bikeEntries[i + 1].engineFocus.requestFocus();
            else controller.saveBatchFocus.requestFocus();
            return;
          }
        }
        
        if (controller.saveBatchFocus.hasFocus) {
           if (event.logicalKey == LogicalKeyboardKey.enter) controller.saveBatch();
           return;
        }

      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (controller.saveBatchFocus.hasFocus) {
          if (controller.bikeEntries.isNotEmpty) {
            controller.bikeEntries.last.imageFocus.requestFocus();
          } else {
            controller.addRowFocus.requestFocus();
          }
          return;
        }

        for (int i = controller.bikeEntries.length - 1; i >= 0; i--) {
          final entry = controller.bikeEntries[i];
          if (entry.imageFocus.hasFocus) { entry.priceFocus.requestFocus(); return; }
          else if (entry.priceFocus.hasFocus) { entry.yearFocus.requestFocus(); return; }
          else if (entry.yearFocus.hasFocus) { entry.colorFocus.requestFocus(); return; }
          else if (entry.colorFocus.hasFocus) {
            if (entry.condition == BikeConditionEnum.usedBike) {
              entry.regNumberFocus.requestFocus();
            } else {
              entry.conditionFocus.requestFocus();
            }
            return;
          }
          else if (entry.regNumberFocus.hasFocus) { entry.conditionFocus.requestFocus(); return; }
          else if (entry.conditionFocus.hasFocus) { entry.modelFocus.requestFocus(); return; }
          else if (entry.modelFocus.hasFocus) { entry.brandFocus.requestFocus(); return; }
          else if (entry.brandFocus.hasFocus) { entry.chassisFocus.requestFocus(); return; }
          else if (entry.chassisFocus.hasFocus) { entry.engineFocus.requestFocus(); return; }
          else if (entry.engineFocus.hasFocus) {
            if (i > 0) {
              controller.bikeEntries[i - 1].imageFocus.requestFocus();
            } else {
              controller.addRowFocus.requestFocus();
            }
            return;
          }
        }

        if (controller.addRowFocus.hasFocus) { controller.billImageFocus.requestFocus(); return; }
        else if (controller.billImageFocus.hasFocus) { controller.purchaseDateFocus.requestFocus(); return; }
        else if (controller.purchaseDateFocus.hasFocus) {
          if (controller.isNewSupplier.value) {
            controller.newSupplierCnicPicFocus.requestFocus();
          } else {
            controller.existingSupplierDropdownFocus.requestFocus();
          }
          return;
        }

        if (controller.isNewSupplier.value) {
          if (controller.newSupplierCnicPicFocus.hasFocus) { controller.newSupplierProfilePicFocus.requestFocus(); return; }
          else if (controller.newSupplierProfilePicFocus.hasFocus) { controller.newSupplierCnicFocus.requestFocus(); return; }
          else if (controller.newSupplierCnicFocus.hasFocus) { controller.newSupplierPhoneFocus.requestFocus(); return; }
          else if (controller.newSupplierPhoneFocus.hasFocus) { controller.newSupplierNameFocus.requestFocus(); return; }
        }
      }
    }

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          Get.back();
        } else {
          handleKeyboardNavigation(event);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: AppBar(
          title: Obx(() => Text(controller.editingBatch.value != null ? 'Edit Stock (Batch ${controller.editingBatch.value!.id})' : 'Add Stock (Batch Entry)')),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(LucideIcons.arrowLeft, color: isDark ? Colors.white : Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Header Section (Batch Info)
            _buildBatchHeader(context, isDark, primaryColor),
            
            const SizedBox(height: AppSpacing.xl),

            // Bikes Grid/List
            _buildBikesGrid(context, isDark, primaryColor),

            const SizedBox(height: AppSpacing.xl),

            // Footer Actions
            _buildFooter(context, isDark, primaryColor),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildBatchHeader(BuildContext context, bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batch Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Supplier Section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Supplier Tabs
                    Row(
                      children: [
                        Text('Supplier Details', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                        const Spacer(),
                        _buildSupplierToggle(isDark, primaryColor),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Toggle Content
                    Obx(() {
                      if (controller.isNewSupplier.value) {
                         return Column(
                           children: [
                             BlinkingFocusBuilder(
                               focusNode: controller.newSupplierNameFocus,
                               child: TextFormField(
                                 controller: controller.newSupplierName,
                                 focusNode: controller.newSupplierNameFocus,
                                 autofocus: true,
                                 textInputAction: TextInputAction.next,
                                 inputFormatters: [
                                   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                 ],
                                 decoration: _inputDecoration('Supplier Name', isDark),
                                 style: TextStyle(color: isDark ? Colors.white : Colors.black),
                               ),
                             ),
                             const SizedBox(height: 8),
                             Row(
                               children: [
                                 Expanded(
                                   child: BlinkingFocusBuilder(
                                     focusNode: controller.newSupplierPhoneFocus,
                                     child: TextFormField(
                                       controller: controller.newSupplierPhone,
                                       focusNode: controller.newSupplierPhoneFocus,
                                       textInputAction: TextInputAction.next,
                                       decoration: _inputDecoration('Phone', isDark),
                                       style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                       keyboardType: TextInputType.phone,
                                       inputFormatters: [PhoneNumberInputFormatter()],
                                     ),
                                   ),
                                 ),
                                 const SizedBox(width: 8),
                                  Expanded(
                                    child: BlinkingFocusBuilder(
                                      focusNode: controller.newSupplierCnicFocus,
                                      child: TextFormField(
                                        controller: controller.newSupplierCnic,
                                        focusNode: controller.newSupplierCnicFocus,
                                        textInputAction: TextInputAction.next,
                                        decoration: _inputDecoration('CNIC (Optional)', isDark),
                                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                        inputFormatters: [CnicInputFormatter()],
                                      ),
                                    ),
                                  ),
                               ],
                             ),
                             const SizedBox(height: 8),
                             // Image Uploads (Profile & CNIC)
                             Row(
                                children: [
                                  // Profile Pic
                                  Expanded(
                                    child: BlinkingFocusBuilder(
                                      focusNode: controller.newSupplierProfilePicFocus,
                                      child: InkWell(
                                        onTap: () {
                                          controller.newSupplierProfilePicFocus.requestFocus();
                                          controller.pickSupplierProfilePic();
                                        },
                                        child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Obx(() => Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(LucideIcons.user, size: 16, color: primaryColor),
                                               const SizedBox(width: 4),
                                              Text(
                                                controller.newSupplierProfilePic.value != null ? 'Profile Pic Set' : 'Profile Pic',
                                                style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ),
                                  const SizedBox(width: 8),
                                  // CNIC Pic
                                  Expanded(
                                    child: BlinkingFocusBuilder(
                                      focusNode: controller.newSupplierCnicPicFocus,
                                      child: InkWell(
                                        onTap: () {
                                          controller.newSupplierCnicPicFocus.requestFocus();
                                          controller.pickSupplierCnicPic();
                                        },
                                        child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Obx(() => Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(LucideIcons.creditCard, size: 16, color: primaryColor),
                                               const SizedBox(width: 4),
                                              Text(
                                                controller.newSupplierCnicPic.value != null ? 'CNIC Pic Set' : 'CNIC Pic',
                                                style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ),
                                ],
                             )
                           ],
                         );
                      } else {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkElevated : Colors.grey[100],
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey[300]!),
                          ),
                          child: BlinkingFocusBuilder(
                            focusNode: controller.existingSupplierDropdownFocus,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Supplier>(
                                focusNode: controller.existingSupplierDropdownFocus,
                                value: controller.selectedSupplier.value,
                              hint: Text('Choose Supplier', style: TextStyle(color: isDark ? AppColors.darkTextMuted : Colors.grey)),
                              isExpanded: true,
                              dropdownColor: isDark ? AppColors.darkElevated : Colors.white,
                              items: controller.suppliers.map((s) {
                                return DropdownMenuItem(
                                  value: s,
                                  child: Text(s.name, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                                );
                              }).toList(),
                                onChanged: (val) {
                                  controller.existingSupplierDropdownFocus.requestFocus();
                                  controller.selectedSupplier.value = val;
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              
              // Purchase Date
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Purchase Date', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    const SizedBox(height: AppSpacing.sm),
                    InkWell(
                      onTap: () async {
                        controller.purchaseDateFocus.requestFocus();
                        final date = await showDatePicker(
                          context: context,
                          initialDate: controller.purchaseDate.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) controller.purchaseDate.value = date;
                      },
                      child: Obx(() => BlinkingFocusBuilder(
                            focusNode: controller.purchaseDateFocus,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                              color: isDark ? AppColors.darkElevated : Colors.grey[100],
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(LucideIcons.calendar, size: 16, color: primaryColor),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('dd MMM yyyy').format(controller.purchaseDate.value),
                                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                ),
                              ],
                            ),
                          ))),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: AppSpacing.lg),
              
              // Bill Image Upload
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Batch Invoice', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    const SizedBox(height: AppSpacing.sm),
                      InkWell(
                      onTap: () async {
                         controller.billImageFocus.requestFocus();
                         await controller.pickBatchImage();
                      },
                      child: BlinkingFocusBuilder(
                        focusNode: controller.billImageFocus,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                          color: isDark ? AppColors.darkElevated : Colors.grey[100],
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.upload, size: 16, color: primaryColor),
                              const SizedBox(width: 8),
                              Obx(() {
                                if (controller.billImage.value != null) return const Text('Image Selected', style: TextStyle(fontWeight: FontWeight.bold));
                                if (controller.editingBatch.value?.billImageFilename != null) return const Text('Existing Image', style: TextStyle(color: Colors.blue));
                                return Text('Upload', style: TextStyle(color: isDark ? Colors.white : Colors.black));
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBikesGrid(BuildContext context, bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Purchased Units',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              BlinkingFocusBuilder(
                focusNode: controller.addRowFocus,
                child: ElevatedButton.icon(
                  focusNode: controller.addRowFocus,
                  onPressed: () {
                    controller.addRowFocus.requestFocus();
                    controller.addBikeEntry();
                  },
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: const Text('Add Row'),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: isDark ? AppColors.darkElevated : Colors.grey[200],
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Engine #')),
                Expanded(flex: 2, child: Text('Chassis #')),
                Expanded(flex: 2, child: Text('Maker')),
                Expanded(flex: 2, child: Text('Horse Power')),
                Expanded(flex: 2, child: Text('Condition')),
                Expanded(flex: 2, child: Text('Color')),
                Expanded(flex: 2, child: Text('Year')),
                Expanded(flex: 2, child: Text('Purchase Price')),
                Expanded(flex: 1, child: Text('Image')),
                Expanded(flex: 2, child: Text('Vehicle Papers')),
                SizedBox(width: 40), // Delete Action
              ],
            ),
          ),
          
          // List
          Obx(() => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.bikeEntries.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, index) {
              final entry = controller.bikeEntries[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    // Engine
                    Expanded(
                      flex: 2,
                      child: BlinkingFocusBuilder(
                        focusNode: entry.engineFocus,
                        child: TextFormField(
                          initialValue: entry.engineNumber,
                          focusNode: entry.engineFocus,
                          textInputAction: TextInputAction.next,
                          onChanged: (v) => entry.engineNumber = v,
                          autofocus: controller.bikeEntries.length == 1 && index == 0,
                          maxLength: 17,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(17),
                          ],
                          decoration: _inputDecoration('Engine #', isDark).copyWith(
                            counterText: '', // Hide default counter
                          ),
                          style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Chassis
                    Expanded(
                      flex: 2,
                      child: BlinkingFocusBuilder(
                        focusNode: entry.chassisFocus,
                        child: TextFormField(
                          initialValue: entry.chassisNumber,
                          focusNode: entry.chassisFocus,
                          textInputAction: TextInputAction.next,
                          onChanged: (v) => entry.chassisNumber = v,
                          maxLength: 17,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(17),
                          ],
                          decoration: _inputDecoration('Chassis #', isDark).copyWith(
                            counterText: '', // Hide default counter
                          ),
                          style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                     const SizedBox(width: 8),
                    // Brand / Maker
                    Expanded(
                      flex: 2,
                      child: BlinkingFocusBuilder(
                        focusNode: entry.brandFocus,
                        child: _buildCompactAutocomplete(
                           initialValue: entry.model, // Maker maps to model in app convention
                           focusNode: entry.brandFocus,
                           isDark: isDark,
                           hint: 'Maker',
                           getOptions: () => Get.isRegistered<SettingsController>()
                               ? Get.find<SettingsController>().getBikeBrandsList()
                               : [],
                           onChanged: (v) => entry.model = v,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Model / Horse Power
                    Expanded(
                      flex: 2,
                      child: BlinkingFocusBuilder(
                        focusNode: entry.modelFocus,
                        child: _buildCompactAutocomplete(
                           initialValue: entry.brand, // HP maps to brand in app convention
                           focusNode: entry.modelFocus,
                           isDark: isDark,
                           hint: 'Horse Power',
                           getOptions: () => Get.isRegistered<SettingsController>()
                               ? Get.find<SettingsController>().getBikeModelsList()
                               : [],
                           onChanged: (v) => entry.brand = v,
                        ),
                      ),
                    ),
                     const SizedBox(width: 8),
                    // Condition
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BlinkingFocusBuilder(
                            focusNode: entry.conditionFocus,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<BikeConditionEnum>(
                                focusNode: entry.conditionFocus,
                                initialValue: entry.condition,
                                decoration: _inputDecoration('Condition', isDark),
                                dropdownColor: isDark ? AppColors.darkElevated : AppColors.lightSurface,
                                style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 13),
                                items: const [
                                  DropdownMenuItem(value: BikeConditionEnum.newBike, child: Text('New', style: TextStyle(fontSize: 13))),
                                  DropdownMenuItem(value: BikeConditionEnum.usedBike, child: Text('Used', style: TextStyle(fontSize: 13))),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    entry.conditionFocus.requestFocus();
                                    entry.condition = val;
                                    controller.bikeEntries.refresh(); // Build to show/hide Reg #
                                  }
                                },
                              ),
                            ),
                          ),
                          if (entry.condition == BikeConditionEnum.usedBike) ...[
                            const SizedBox(height: 4),
                            BlinkingFocusBuilder(
                              focusNode: entry.regNumberFocus,
                              child: TextFormField(
                                initialValue: entry.registrationNumber,
                                focusNode: entry.regNumberFocus,
                                textInputAction: TextInputAction.next,
                                onChanged: (v) => entry.registrationNumber = v,
                                validator: (val) {
                                  if (entry.condition == BikeConditionEnum.usedBike && (val == null || val.trim().isEmpty)) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                                decoration: _inputDecoration('Reg #', isDark),
                                style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                     const SizedBox(width: 8),
                    // Color
                    Expanded(
                      flex: 2,
                      child: BlinkingFocusBuilder(
                        focusNode: entry.colorFocus,
                        child: Focus(
                          focusNode: entry.colorFocus,
                          child: ColorSkinSelector(
                            initialValue: entry.color,
                            onChanged: (v) {
                              entry.colorFocus.requestFocus();
                              entry.color = v;
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                            fontSize: 13,
                            iconSize: 16,
                          ),
                        ),
                      ),
                    ),
                     const SizedBox(width: 8),
                    // Year
                    Expanded(
                      flex: 2,
                      child: BlinkingFocusBuilder(
                        focusNode: entry.yearFocus,
                        child: _buildCompactAutocomplete(
                          initialValue: entry.modelYear?.toString() ?? '',
                          focusNode: entry.yearFocus,
                          isDark: isDark,
                          hint: 'Year',
                          getOptions: () => Get.isRegistered<SettingsController>()
                              ? Get.find<SettingsController>().getBikeYearsList()
                              : [],
                          onChanged: (v) => entry.modelYear = int.tryParse(v) ?? DateTime.now().year,
                        ),
                      ),
                    ),
                     const SizedBox(width: 8),
                    // Purchase Price (Per Unit)
                    Expanded(
                      flex: 2,
                      child: BlinkingFocusBuilder(
                        focusNode: entry.priceFocus,
                        child: TextFormField(
                          initialValue: entry.purchasePrice > 0 ? NumberFormat('#,###').format(entry.purchasePrice) : '',
                          focusNode: entry.priceFocus,
                          textInputAction: TextInputAction.next,
                          onChanged: (v) {
                            entry.purchasePrice = double.tryParse(v.replaceAll(',', '')) ?? 0;
                            controller.calculateTotal(); // Recalculate total on change
                          },
                           decoration: _inputDecoration('Price', isDark),
                          style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsSeparatorInputFormatter()],
                        ),
                      ),
                    ),
                     const SizedBox(width: 8),
                     // Image
                     Expanded(
                       flex: 1,
                       child: BlinkingFocusBuilder(
                         focusNode: entry.imageFocus,
                         child: InkWell(
                           onTap: () {
                             entry.imageFocus.requestFocus();
                             controller.pickEntryImage(index);
                           },
                           child: Container(
                             height: 32,
                             decoration: BoxDecoration(
                               border: Border.all(color: Colors.grey),
                               borderRadius: BorderRadius.circular(4),
                             ),
                             child: entry.imageFile != null 
                               ? Image.file(entry.imageFile!, fit: BoxFit.cover)
                               : const Icon(LucideIcons.camera, size: 16, color: Colors.grey),
                           ),
                         ),
                       ),
                     ),
                     const SizedBox(width: 8),
                     // Vehicle Papers
                     Expanded(
                       flex: 2,
                       child: StatefulBuilder(
                         builder: (context, setState) {
                           final isDatePast = entry.papersPromisedDate != null &&
                               entry.papersPromisedDate!.isBefore(DateTime.now());
                           return Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               InkWell(
                                 borderRadius: BorderRadius.circular(6),
                                 onTap: () {
                                   setState(() {
                                     entry.isPapersReceived = !entry.isPapersReceived;
                                     if (entry.isPapersReceived) entry.papersPromisedDate = null;
                                   });
                                   controller.bikeEntries.refresh();
                                 },
                                 child: Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                   decoration: BoxDecoration(
                                     color: entry.isPapersReceived
                                         ? Colors.green.withOpacity(0.1)
                                         : Colors.orange.withOpacity(0.08),
                                     borderRadius: BorderRadius.circular(6),
                                     border: Border.all(
                                       color: entry.isPapersReceived
                                           ? Colors.green.withOpacity(0.4)
                                           : Colors.orange.withOpacity(0.4),
                                     ),
                                   ),
                                   child: Row(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       SizedBox(
                                         width: 16,
                                         height: 16,
                                         child: Checkbox(
                                           value: entry.isPapersReceived,
                                           onChanged: (val) {
                                             setState(() {
                                               entry.isPapersReceived = val ?? false;
                                               if (val == true) entry.papersPromisedDate = null;
                                             });
                                             controller.bikeEntries.refresh();
                                           },
                                           activeColor: Colors.green,
                                           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                           side: BorderSide(
                                             color: entry.isPapersReceived ? Colors.green : Colors.orange,
                                             width: 1.5,
                                           ),
                                         ),
                                       ),
                                       const SizedBox(width: 5),
                                       Flexible(
                                         child: Text(
                                           entry.isPapersReceived ? 'Received' : 'Pending',
                                           overflow: TextOverflow.ellipsis,
                                           style: TextStyle(
                                             fontSize: 11,
                                             fontWeight: FontWeight.bold,
                                             color: entry.isPapersReceived ? Colors.green : Colors.orange,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                               if (!entry.isPapersReceived) ...[
                                 const SizedBox(height: 3),
                                 InkWell(
                                   borderRadius: BorderRadius.circular(5),
                                   onTap: () async {
                                     final picked = await showDatePicker(
                                       context: context,
                                       initialDate: entry.papersPromisedDate ??
                                           DateTime.now().add(const Duration(days: 7)),
                                       firstDate: DateTime(2020),
                                       lastDate: DateTime(2030),
                                     );
                                     if (picked != null) {
                                       setState(() => entry.papersPromisedDate = picked);
                                       controller.bikeEntries.refresh();
                                     }
                                   },
                                   child: Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                     decoration: BoxDecoration(
                                       color: isDatePast
                                           ? Colors.red.withOpacity(0.08)
                                           : primaryColor.withOpacity(0.06),
                                       borderRadius: BorderRadius.circular(5),
                                       border: Border.all(
                                         color: isDatePast
                                             ? Colors.red.withOpacity(0.4)
                                             : primaryColor.withOpacity(0.3),
                                       ),
                                     ),
                                     child: Row(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         Icon(LucideIcons.calendarDays, size: 11,
                                             color: isDatePast ? Colors.red : primaryColor),
                                         const SizedBox(width: 4),
                                         Flexible(
                                           child: Text(
                                             entry.papersPromisedDate == null
                                                 ? 'Set date'
                                                 : '${entry.papersPromisedDate!.day}/${entry.papersPromisedDate!.month}/${entry.papersPromisedDate!.year}',
                                             overflow: TextOverflow.ellipsis,
                                             style: TextStyle(
                                               fontSize: 10,
                                               color: isDatePast ? Colors.red : (isDark ? Colors.white70 : Colors.black54),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ],
                             ],
                           );
                         },
                       ),
                     ),
                     IconButton(
                      icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                      onPressed: () => controller.removeBikeEntry(index),
                    ),
                  ],
                ),
              );
            },
          )),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey[300]!)),
    );
  }

  Widget _buildCompactAutocomplete({
    required String initialValue,
    required FocusNode focusNode,
    required bool isDark,
    required String hint,
    required Iterable<String> Function() getOptions,
    required Function(String) onChanged,
  }) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      optionsBuilder: (TextEditingValue textEditingValue) {
        final currentOptions = getOptions();
        if (textEditingValue.text.isEmpty) {
          return currentOptions;
        }
        return currentOptions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        onChanged(selection);
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        // Keep focus synced
        focusNode.addListener(() {
          if (focusNode.hasFocus && !fieldFocusNode.hasFocus) {
             fieldFocusNode.requestFocus();
          }
        });
        fieldFocusNode.addListener(() {
          if (fieldFocusNode.hasFocus && !focusNode.hasFocus) {
             focusNode.requestFocus();
          }
        });

        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          textInputAction: TextInputAction.next,
          style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
          decoration: _inputDecoration(hint, isDark).copyWith(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            suffixIcon: Icon(Icons.arrow_drop_down, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
          onChanged: (v) => onChanged(v),
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(4),
            color: isDark ? AppColors.darkElevated : AppColors.lightSurface,
            child: Container(
              width: 150, // Compact width suitable for table
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Investment Required',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Obx(() => Text(
                'Rs ${NumberFormat("#,##0").format(controller.totalBatchCost.value)}',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )),
              const SizedBox(height: 4),
              Text(
                'This amount will be allocated from capital',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          BlinkingFocusBuilder(
            focusNode: controller.saveBatchFocus,
            child: ElevatedButton(
              focusNode: controller.saveBatchFocus,
              onPressed: () {
                controller.saveBatchFocus.requestFocus();
                controller.saveBatch();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Save Batch & Add to Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSupplierToggle(bool isDark, Color primaryColor) {
    return Obx(() => Container(
      height: 28,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : Colors.grey[200],
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          _buildToggleItem('Existing', !controller.isNewSupplier.value, isDark, primaryColor, () => controller.isNewSupplier.value = false),
          _buildToggleItem('New', controller.isNewSupplier.value, isDark, primaryColor, () => controller.isNewSupplier.value = true),
        ],
      ),
    ));
  }

  Widget _buildToggleItem(String label, bool isActive, bool isDark, Color primaryColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: isActive ? BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ) : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}
