import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/features/procurement/presentation/controllers/supplier_controller.dart';
import 'package:tahir_showroom/app/data/models/supplier.dart';

class AddStockView extends GetView<SupplierController> {
  const AddStockView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Scaffold(
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
                             TextFormField(
                               controller: controller.newSupplierName,
                               decoration: _inputDecoration('Supplier Name', isDark),
                               style: TextStyle(color: isDark ? Colors.white : Colors.black),
                             ),
                             const SizedBox(height: 8),
                             Row(
                               children: [
                                 Expanded(
                                   child: TextFormField(
                                     controller: controller.newSupplierPhone,
                                     decoration: _inputDecoration('Phone', isDark),
                                     style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                     keyboardType: TextInputType.phone,
                                   ),
                                 ),
                                 const SizedBox(width: 8),
                                 Expanded(
                                   child: TextFormField(
                                     controller: controller.newSupplierCnic,
                                     decoration: _inputDecoration('CNIC (Optional)', isDark),
                                     style: TextStyle(color: isDark ? Colors.white : Colors.black),
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
                                    child: InkWell(
                                      onTap: controller.pickSupplierProfilePic,
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
                                  const SizedBox(width: 8),
                                  // CNIC Pic
                                  Expanded(
                                    child: InkWell(
                                      onTap: controller.pickSupplierCnicPic,
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Supplier>(
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
                              onChanged: (val) => controller.selectedSupplier.value = val,
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
                        final date = await showDatePicker(
                          context: context,
                          initialDate: controller.purchaseDate.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) controller.purchaseDate.value = date;
                      },
                      child: Obx(() => Container(
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
                          )),
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
                         await controller.pickBatchImage();
                      },
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
              ElevatedButton.icon(
                onPressed: controller.addBikeEntry,
                icon: const Icon(LucideIcons.plus, size: 16),
                label: const Text('Add Row'),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: isDark ? AppColors.darkElevated : Colors.grey[200],
            child: Row(
              children: const [
                Expanded(flex: 2, child: Text('Engine #')),
                Expanded(flex: 2, child: Text('Chassis #')),
                Expanded(flex: 2, child: Text('Model')),
                Expanded(flex: 1, child: Text('Color')),
                Expanded(flex: 1, child: Text('Year')),
                Expanded(flex: 2, child: Text('Purchase Price')),
                Expanded(flex: 1, child: Text('Image')),
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
                      child: TextFormField(
                        initialValue: entry.engineNumber,
                        onChanged: (v) => entry.engineNumber = v,
                        decoration: _inputDecoration('Engine #', isDark),
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Chassis
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: entry.chassisNumber,
                        onChanged: (v) => entry.chassisNumber = v,
                        decoration: _inputDecoration('Chassis #', isDark),
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                     const SizedBox(width: 8),
                    // Model
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: entry.model,
                        onChanged: (v) => entry.model = v,
                         decoration: _inputDecoration('Model', isDark),
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                     const SizedBox(width: 8),
                    // Color
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: entry.color,
                        onChanged: (v) => entry.color = v,
                        decoration: _inputDecoration('Color', isDark),
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                     const SizedBox(width: 8),
                    // Year
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: entry.modelYear.toString(),
                        onChanged: (v) => entry.modelYear = int.tryParse(v) ?? DateTime.now().year,
                         decoration: _inputDecoration('Year', isDark),
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                     const SizedBox(width: 8),
                    // Purchase Price (Per Unit)
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: entry.purchasePrice.toStringAsFixed(0),
                        onChanged: (v) {
                          entry.purchasePrice = double.tryParse(v) ?? 0;
                          controller.calculateTotal(); // Recalculate total on change
                        },
                         decoration: _inputDecoration('Price', isDark),
                        style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                     const SizedBox(width: 8),
                     // Image
                     Expanded(
                       flex: 1,
                       child: InkWell(
                         onTap: () {
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
                    // Delete
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey[300]!)),
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
                'Total Batch Cost',
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
            ],
          ),
          ElevatedButton(
            onPressed: controller.saveBatch,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Save Batch & Add to Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
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
