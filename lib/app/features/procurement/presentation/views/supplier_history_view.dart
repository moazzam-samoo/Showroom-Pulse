import 'dart:io';
import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/features/procurement/presentation/views/add_stock_view.dart';
import 'package:tahir_showroom/app/features/procurement/presentation/controllers/supplier_controller.dart';
import 'package:tahir_showroom/app/data/models/supplier.dart';
import 'package:tahir_showroom/app/data/models/purchase_batch.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/procurement/presentation/views/add_stock_view.dart';

class SupplierHistoryView extends GetView<SupplierController> {
  const SupplierHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is loaded if not already (it might be lazy loaded by binding)
    // But since this is a view inside ProcurementView, bindings should handle it.
    // If not, use Get.put/find logic in ProcurementView or here.
    // controller is available via GetView if registered.
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dealers & Purchases',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Get.to(() => const AddStockView()),
                icon: const Icon(LucideIcons.plus),
                label: const Text('Add Stock (Batch)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Content
          Expanded(
            child: Row(
              children: [
                // Left Panel: Suppliers List
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Icon(LucideIcons.users, size: 20, color: primaryColor),
                              const SizedBox(width: 8),
                              const Text('Suppliers', style: TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(LucideIcons.userPlus, size: 18),
                                onPressed: () => _showSupplierDialog(context),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: Obx(() {
                            if (controller.suppliers.isEmpty) {
                              return const Center(child: Text('No suppliers found'));
                            }
                            return ListView.separated(
                              itemCount: controller.suppliers.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (ctx, index) {
                                final supplier = controller.suppliers[index];
                                return Obx(() {
                                    final isSelected = controller.selectedSupplier.value?.id == supplier.id;
                                    return ListTile(
                                      selected: isSelected,
                                      selectedTileColor: primaryColor.withOpacity(0.1),
                                      leading: CircleAvatar(
                                        backgroundColor: primaryColor.withOpacity(0.2),
                                        child: Text(supplier.name[0].toUpperCase()),
                                      ),
                                      title: Text(supplier.name, style: const TextStyle(fontSize: 14)),
                                      subtitle: Text(supplier.phone, style: const TextStyle(fontSize: 12)),
                                      onTap: () => controller.selectedSupplier.value = supplier,
                                      trailing: isSelected ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(LucideIcons.pencil, size: 16),
                                            tooltip: 'Edit Supplier',
                                            onPressed: () => _showSupplierDialog(context, supplier: supplier),
                                          ),
                                          IconButton(
                                            icon: const Icon(LucideIcons.trash2, size: 16),
                                            tooltip: 'Delete Supplier',
                                            color: Colors.red[400],
                                            onPressed: () async {
                                              final confirm = await showDialog<bool>(
                                                context: Get.context!,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text('Delete Supplier?'),
                                                  content: const Text('This will delete the supplier AND ALL their history (Batches, Bikes, Images). This cannot be undone.'),
                                                  actions: [
                                                    TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
                                                    TextButton(
                                                      onPressed: () => Get.back(result: true), 
                                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirm == true) {
                                                await controller.deleteSupplier(supplier);
                                              }
                                            },
                                          ),
                                        ],
                                      ) : null,
                                    );
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                // Right Panel: Purchase History
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
                    ),
                    child: Obx(() {
                      final supplier = controller.selectedSupplier.value;
                      if (supplier == null) {
                        return const Center(child: Text('Select a supplier to view history'));
                      }
                      
                      // Need to load batches?
                      // Assuming IsarLinks are accessible. Since we can't await easily in build,
                      // we might need a FutureBuilder or pre-load in controller.
                      // For now, let's use a FutureBuilder on supplier.batches.load()
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Icon(LucideIcons.history, size: 20, color: primaryColor),
                                const SizedBox(width: 8),
                                Text('Purchase History - ${supplier.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: FutureBuilder(
                              future: supplier.batches.load(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                
                                // Convert to list and sort by date desc
                                final batches = supplier.batches.toList();
                                batches.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
                                
                                if (batches.isEmpty) {
                                  return const Center(child: Text('No purchase history'));
                                }

                                return ListView.builder(
                                  itemCount: batches.length,
                                  itemBuilder: (ctx, index) {
                                    final batch = batches[index];
                                    return _buildBatchCard(batch, isDark, primaryColor);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchCard(PurchaseBatch batch, bool isDark, Color primaryColor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      elevation: 0,
      color: isDark ? AppColors.darkElevated : Colors.grey[50],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(DateFormat('dd MMM yyyy').format(batch.purchaseDate), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${batch.totalUnits} Units',
                style: TextStyle(color: primaryColor, fontSize: 12),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(LucideIcons.pencil, size: 16),
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              tooltip: 'Edit Batch',
              onPressed: () {
                controller.initEditBatch(batch);
                Get.to(() => const AddStockView());
              },
            ),
            IconButton(
              icon: const Icon(LucideIcons.trash2, size: 16),
              color: Colors.red[400],
              tooltip: 'Delete Batch',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: Get.context!,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Batch?'),
                    content: const Text('This will delete the batch and all associated bikes. This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => Get.back(result: true), 
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await controller.deleteBatch(batch);
                }
              },
            ),
          ],
        ),
        subtitle: Text(
          'Total: Rs ${NumberFormat("#,##0").format(batch.totalAmount)}',
          style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        children: [
          FutureBuilder<List<Bike>>(
            future: batch.bikes.filter().findAll(),
            builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return const Padding(
                   padding: EdgeInsets.all(16.0),
                   child: Center(child: CircularProgressIndicator()),
                 );
               }
               
               if (!snapshot.hasData || snapshot.data!.isEmpty) {
                 return const Padding(
                   padding: EdgeInsets.all(16.0),
                   child: Text('No bikes found in this batch.'),
                 );
               }
               
               final bikes = snapshot.data!;
               
               return ListView.separated(
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 itemCount: bikes.length,
                 separatorBuilder: (_, __) => const Divider(height: 1, indent: 16),
                 itemBuilder: (ctx, i) {
                   final bike = bikes[i];
                   return ListTile(
                     dense: true,
                     leading: const Icon(LucideIcons.bike, size: 16),
                     title: Text('${bike.model} (${bike.color})'),
                     subtitle: Text('Eng: ${bike.engineNumber}'),
                     trailing: Text(
                       'Rs ${NumberFormat("#,##0").format(bike.purchasePrice)}',
                       style: const TextStyle(fontWeight: FontWeight.w500),
                     ),
                   );
                 },
               );
            },
          ),
        ],
      ),
    );
  }

  void _showSupplierDialog(BuildContext context, {Supplier? supplier}) {
    // Clear previous state or populate for edit
    controller.clearBatchForm(); 
    
    if (supplier != null) {
      controller.newSupplierName.text = supplier.name;
      controller.newSupplierPhone.text = supplier.phone;
      controller.newSupplierCnic.text = supplier.cnic;
      // Note: We don't verify existing images here visually in this simple dialog implementation 
      // but if user picks new ones they will be replaced.
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                supplier == null ? 'Add New Supplier' : 'Edit Supplier',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Form
              TextFormField(
                controller: controller.newSupplierName,
                decoration: _inputDecoration('Supplier Name', isDark),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: AppSpacing.md),
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
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: controller.newSupplierCnic,
                      decoration: _inputDecoration('CNIC', isDark),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Images
              Row(
                children: [
                  Expanded(
                    child: _buildImagePicker(
                      label: supplier?.profilePicFilename != null && controller.newSupplierProfilePic.value == null 
                          ? 'Update Profile Pic' 
                          : 'Profile Picture',
                      imageRx: controller.newSupplierProfilePic,
                      onTap: controller.pickSupplierProfilePic,
                      isDark: isDark,
                      primaryColor: primaryColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildImagePicker(
                      label: supplier?.cnicPicFilename != null && controller.newSupplierCnicPic.value == null 
                          ? 'Update CNIC Img' 
                          : 'CNIC Image',
                      imageRx: controller.newSupplierCnicPic,
                      onTap: controller.pickSupplierCnicPic,
                      isDark: isDark,
                      primaryColor: primaryColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () async {
                      if (controller.newSupplierName.text.isEmpty || 
                          controller.newSupplierPhone.text.isEmpty) {
                        Get.snackbar('Error', 'Name and Phone are required');
                        return;
                      }

                      if (supplier != null) {
                        await controller.updateSupplier(
                          supplier,
                          controller.newSupplierName.text,
                          controller.newSupplierCnic.text,
                          controller.newSupplierPhone.text,
                          profilePic: controller.newSupplierProfilePic.value,
                          cnicPic: controller.newSupplierCnicPic.value,
                        );
                        Get.snackbar('Success', 'Supplier updated successfully');
                      } else {
                        await controller.createSupplier(
                          controller.newSupplierName.text,
                          controller.newSupplierCnic.text,
                          controller.newSupplierPhone.text,
                          controller.newSupplierProfilePic.value, 
                          cnicPic: controller.newSupplierCnicPic.value,
                        );
                        Get.snackbar('Success', 'Supplier added successfully');
                      }
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(supplier == null ? 'Add Supplier' : 'Update Supplier'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required Rx<File?> imageRx,
    required VoidCallback onTap,
    required bool isDark,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkElevated : Colors.grey[100],
          border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Obx(() {
          if (imageRx.value != null) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.file(imageRx.value!, fit: BoxFit.cover, width: double.infinity),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.camera, color: primaryColor, size: 24),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : Colors.grey)),
            ],
          );
        }),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
