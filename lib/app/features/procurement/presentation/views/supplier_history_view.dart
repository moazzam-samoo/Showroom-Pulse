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
import 'package:tahir_showroom/app/core/widgets/app_dialog.dart';
import 'package:tahir_showroom/app/data/models/supplier.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';
import 'package:tahir_showroom/app/data/models/purchase_batch.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:flutter/services.dart';
import 'package:tahir_showroom/app/core/utils/phone_number_input_formatter.dart';
import 'package:tahir_showroom/app/core/utils/cnic_input_formatter.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:tahir_showroom/app/core/utils/data_refresher.dart';

class SupplierHistoryView extends GetView<SupplierController> {
  final GlobalKey? addSupplierKey;
  final GlobalKey? supplierListKey;
  final GlobalKey? historyPanelKey;

  const SupplierHistoryView({
    super.key,
    this.addSupplierKey,
    this.supplierListKey,
    this.historyPanelKey,
  });

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
              Row(
                children: [
                   IconButton(
                    onPressed: () => controller.exportAllSuppliersPdf(),
                    icon: const Icon(LucideIcons.download),
                    tooltip: 'Download All Suppliers Report',
                    color: primaryColor,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton.icon(
                    key: addSupplierKey,
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
                    key: supplierListKey,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                          child: Obx(() => AppTextField(
                            controller: controller.searchController,
                            hint: 'Search dealers...',
                            prefixIcon: LucideIcons.search,
                            showClearIcon: controller.searchQuery.value.isNotEmpty,
                            onClear: () {
                              controller.searchController.clear();
                              controller.searchQuery.value = '';
                            },
                            onChanged: (val) {
                              controller.searchQuery.value = val;
                            },
                          )),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: Obx(() {
                            final displaySuppliers = controller.filteredSuppliers;
                            if (displaySuppliers.isEmpty) {
                              return const Center(child: Text('No suppliers found'));
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.only(right: AppSpacing.sm),
                              itemCount: displaySuppliers.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (ctx, index) {
                                final supplier = displaySuppliers[index];
                                return Obx(() {
                                    final isSelected = controller.selectedSupplier.value?.id == supplier.id;
                                    return ListTile(
                                      selected: isSelected,
                                      selectedTileColor: primaryColor.withOpacity(0.1),
                                      leading: InkWell(
                                        onTap: () => _showSupplierDetailCard(context, supplier),
                                        borderRadius: BorderRadius.circular(20),
                                        child: _buildSupplierAvatar(supplier, isDark, primaryColor, Get.find<FileService>()),
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
                                              final dialogIsDark = Theme.of(context).brightness == Brightness.dark;
                                              final dialogPrimary = dialogIsDark ? AppColors.darkPrimary : AppColors.lightPrimary;
                                              final dialogBg = dialogIsDark ? AppColors.darkSurface : AppColors.lightSurface;
                                              final cardBg = dialogIsDark ? AppColors.darkElevated : Colors.grey[50]!;
                                              final textPrimary = dialogIsDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
                                              final textSecondary = dialogIsDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
                                              final borderColor = dialogIsDark ? AppColors.darkBorder : Colors.grey.shade300;

                                              final result = await showDialog<String>(
                                                context: Get.context!,
                                                barrierDismissible: true,
                                                builder: (ctx) => Dialog(
                                                  backgroundColor: dialogBg,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(AppRadius.lg),
                                                  ),
                                                  child: Container(
                                                    width: 480,
                                                    padding: const EdgeInsets.all(24),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        // Warning Icon
                                                        Container(
                                                          width: 56,
                                                          height: 56,
                                                          decoration: BoxDecoration(
                                                            color: Colors.red.withOpacity(0.1),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                            LucideIcons.alertTriangle,
                                                            color: Colors.red,
                                                            size: 28,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 16),

                                                        // Title
                                                        Text(
                                                          'Delete "${supplier.name}"?',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            color: textPrimary,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Text(
                                                          'Choose how you want to handle the bikes purchased from this dealer.',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: textSecondary,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 24),

                                                        // Two Option Cards
                                                        Row(
                                                          children: [
                                                            // Option 1: Delete Everything
                                                            Expanded(
                                                              child: MouseRegion(
                                                                cursor: SystemMouseCursors.click,
                                                                child: GestureDetector(
                                                                  onTap: () => Navigator.of(ctx).pop('deleteAll'),
                                                                  child: AnimatedContainer(
                                                                    duration: const Duration(milliseconds: 200),
                                                                    padding: const EdgeInsets.all(16),
                                                                    decoration: BoxDecoration(
                                                                      color: cardBg,
                                                                      borderRadius: BorderRadius.circular(AppRadius.md),
                                                                      border: Border.all(
                                                                        color: Colors.red.withOpacity(0.4),
                                                                        width: 1.5,
                                                                      ),
                                                                    ),
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          width: 40,
                                                                          height: 40,
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.red.withOpacity(0.1),
                                                                            borderRadius: BorderRadius.circular(10),
                                                                          ),
                                                                          child: const Icon(
                                                                            LucideIcons.trash2,
                                                                            color: Colors.red,
                                                                            size: 20,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 12),
                                                                        Text(
                                                                          'Delete Everything',
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: textPrimary,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 4),
                                                                        Text(
                                                                          'Remove dealer, all batches & bikes permanently',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: textSecondary,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 12),

                                                            // Option 2: Keep Bikes
                                                            Expanded(
                                                              child: MouseRegion(
                                                                cursor: SystemMouseCursors.click,
                                                                child: GestureDetector(
                                                                  onTap: () => Navigator.of(ctx).pop('dealerOnly'),
                                                                  child: AnimatedContainer(
                                                                    duration: const Duration(milliseconds: 200),
                                                                    padding: const EdgeInsets.all(16),
                                                                    decoration: BoxDecoration(
                                                                      color: cardBg,
                                                                      borderRadius: BorderRadius.circular(AppRadius.md),
                                                                      border: Border.all(
                                                                        color: dialogPrimary.withOpacity(0.4),
                                                                        width: 1.5,
                                                                      ),
                                                                    ),
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          width: 40,
                                                                          height: 40,
                                                                          decoration: BoxDecoration(
                                                                            color: dialogPrimary.withOpacity(0.1),
                                                                            borderRadius: BorderRadius.circular(10),
                                                                          ),
                                                                          child: Icon(
                                                                            LucideIcons.bike,
                                                                            color: dialogPrimary,
                                                                            size: 20,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 12),
                                                                        Text(
                                                                          'Keep Bikes',
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: textPrimary,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 4),
                                                                        Text(
                                                                          'Remove dealer info only, bikes stay in inventory',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: textSecondary,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 20),

                                                        // Cancel Button
                                                        SizedBox(
                                                          width: double.infinity,
                                                          child: TextButton(
                                                            onPressed: () => Navigator.of(ctx).pop(null),
                                                            style: TextButton.styleFrom(
                                                              foregroundColor: textSecondary,
                                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(AppRadius.md),
                                                                side: BorderSide(color: borderColor),
                                                              ),
                                                            ),
                                                            child: const Text('Cancel'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );

                                              if (result == 'deleteAll') {
                                                await controller.deleteSupplier(supplier);
                                              } else if (result == 'dealerOnly') {
                                                await controller.deleteSupplierOnly(supplier);
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
                    key: historyPanelKey,
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
                                const Spacer(),
                                IconButton(
                                  onPressed: () => controller.exportSupplierDetailPdf(supplier),
                                  icon: const Icon(LucideIcons.download, size: 18),
                                  tooltip: 'Download Purchase History PDF',
                                  color: primaryColor,
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
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
                                
                                // Convert to list and sort by date desc then total amount desc
                                final batches = supplier.batches.toList();
                                batches.sort((a, b) {
                                  final dateComparison = b.purchaseDate.compareTo(a.purchaseDate);
                                  if (dateComparison == 0) {
                                    return b.totalAmount.compareTo(a.totalAmount);
                                  }
                                  return dateComparison;
                                });
                                
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

  Widget _buildSupplierAvatar(Supplier supplier, bool isDark, Color primaryColor, FileService fileService) {
    if (supplier.profilePicFilename != null && supplier.profilePicFilename!.isNotEmpty) {
      final imagePath = fileService.getSupplierProfileImagePathSync(supplier.profilePicFilename!, supplier.name);
      if (File(imagePath).existsSync()) {
        return CircleAvatar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          backgroundImage: FileImage(File(imagePath)),
          radius: 20,
        );
      }
    }
    
    return CircleAvatar(
      backgroundColor: primaryColor.withOpacity(0.2),
      radius: 20,
      child: Text(supplier.name.isNotEmpty ? supplier.name[0].toUpperCase() : '?', 
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)
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
                  builder: (ctx) => AppDialog(
                    title: 'Delete Batch?',
                    subtitle: 'Warning',
                    width: 400,
                    onSubmit: () => Get.back(result: true),
                    onCancel: () => Get.back(result: false),
                    actions: [
                      TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel (Esc)')),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        onPressed: () => Get.back(result: true), 
                        child: const Text('Delete (Enter)'),
                      ),
                    ],
                    child: const Text('This will delete the batch and all associated bikes. This action cannot be undone.'),
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
                 itemBuilder: (context, i) {
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
                     onTap: () => _showBikeDetailDialog(context, bike, batch.purchaseDate),
                   );
                 },
               );
            },
          ),
        ],
      ),
    );
  }

  void _showSupplierDetailCard(BuildContext context, Supplier supplier) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final fileService = Get.find<FileService>();

    Get.dialog(
      Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Pic
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 2),
                  image: supplier.profilePicFilename != null
                      ? DecorationImage(
                          image: FileImage(File(fileService.getSupplierProfileImagePathSync(supplier.profilePicFilename!, supplier.name))),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: supplier.profilePicFilename == null
                    ? Icon(LucideIcons.user, size: 60, color: primaryColor)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                supplier.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              _buildDetailInfoRow(LucideIcons.phone, 'Phone', supplier.phone, textSecondary, textPrimary),
              const SizedBox(height: 12),
              _buildDetailInfoRow(LucideIcons.creditCard, 'CNIC', supplier.cnic, textSecondary, textPrimary),
              
              if (supplier.cnicPicFilename != null) ...[
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('CNIC Image', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textSecondary)),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.file(
                    File(fileService.getSupplierCnicImagePathSync(supplier.cnicPicFilename!, supplier.name)),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: const Text('Okay', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBikeDetailDialog(BuildContext context, Bike bike, DateTime purchaseDate) {
    Get.dialog(
      _BikeDetailDialog(bike: bike, purchaseDate: purchaseDate),
      barrierDismissible: true,
    );
  }

  Widget _buildDetailInfoRow(IconData icon, String label, String value, Color labelColor, Color valueColor, {bool isMono = false, bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: labelColor.withOpacity(0.7)),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: labelColor, fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontFamily: isMono ? 'monospace' : null,
          ),
        ),
      ],
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

    final nameFocus = FocusNode();
    final phoneFocus = FocusNode();
    final cnicFocus = FocusNode();
    final profilePicFocus = FocusNode();
    final cnicPicFocus = FocusNode();
    final submitFocus = FocusNode();

    void handleKeyboardNavigation(KeyEvent event) {
      if (event is KeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.enter) {
          if (nameFocus.hasFocus) {
            phoneFocus.requestFocus();
          } else if (phoneFocus.hasFocus) {
            cnicFocus.requestFocus();
          } else if (cnicFocus.hasFocus) {
            profilePicFocus.requestFocus();
          } else if (profilePicFocus.hasFocus) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              controller.pickSupplierProfilePic();
            } else {
              cnicPicFocus.requestFocus();
            }
          } else if (cnicPicFocus.hasFocus) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              controller.pickSupplierCnicPic();
            } else {
              submitFocus.requestFocus();
            }
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          if (submitFocus.hasFocus) {
            cnicPicFocus.requestFocus();
          } else if (cnicPicFocus.hasFocus) {
            profilePicFocus.requestFocus();
          } else if (profilePicFocus.hasFocus) {
            cnicFocus.requestFocus();
          } else if (cnicFocus.hasFocus) {
            phoneFocus.requestFocus();
          } else if (phoneFocus.hasFocus) {
            nameFocus.requestFocus();
          }
        }
      }
    }

    void handleSave() {
      final List<String> missingFields = [];
      if (controller.newSupplierName.text.trim().isEmpty) missingFields.add('Supplier Name');
      if (controller.newSupplierPhone.text.trim().isEmpty) missingFields.add('Phone');
      if (controller.newSupplierCnic.text.trim().isEmpty) missingFields.add('CNIC');
      if (controller.newSupplierProfilePic.value == null) missingFields.add('Profile Picture');
      if (controller.newSupplierCnicPic.value == null) missingFields.add('CNIC Image');

      void executeSave() async {
        if (supplier != null) {
          await controller.updateSupplier(
            supplier,
            controller.newSupplierName.text,
            controller.newSupplierCnic.text,
            controller.newSupplierPhone.text,
            profilePic: controller.newSupplierProfilePic.value,
            cnicPic: controller.newSupplierCnicPic.value,
          );
          Get.back(); // close Add/Edit dialog
          AppToast.showSuccess(title: 'Success', message: 'Supplier updated successfully');
        } else {
          await controller.createSupplier(
            controller.newSupplierName.text,
            controller.newSupplierCnic.text,
            controller.newSupplierPhone.text,
            controller.newSupplierProfilePic.value, 
            cnicPic: controller.newSupplierCnicPic.value,
          );
          Get.back(); // close Add/Edit dialog
          AppToast.showSuccess(title: 'Success', message: 'Supplier added successfully');
        }
      }

      if (missingFields.isNotEmpty) {
        AppNotificationDialog.showOptionalFieldsWarning(
          missingFields: missingFields,
          onProceed: executeSave,
        );
      } else {
        executeSave();
      }
    }

    Get.dialog(
      AppDialog(
        title: supplier == null ? 'Add New Supplier' : 'Edit Supplier',
        subtitle: 'Manage Supplier Details',
        width: 500,
        onSubmit: handleSave,
        child: KeyboardListener(
          focusNode: FocusNode(), // Not requested focus because inputs have focus
          onKeyEvent: handleKeyboardNavigation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form
              BlinkingFocusBuilder(
                focusNode: nameFocus,
                child: TextFormField(
                  controller: controller.newSupplierName,
                  focusNode: nameFocus,
                  autofocus: true, // Auto-focus first field
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                  decoration: _inputDecoration('Supplier Name', isDark),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: BlinkingFocusBuilder(
                      focusNode: phoneFocus,
                      child: TextFormField(
                        controller: controller.newSupplierPhone,
                        focusNode: phoneFocus,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration('Phone', isDark),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          PhoneNumberInputFormatter(),
                          LengthLimitingTextInputFormatter(12),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: BlinkingFocusBuilder(
                      focusNode: cnicFocus,
                      child: TextFormField(
                        controller: controller.newSupplierCnic,
                        focusNode: cnicFocus,
                        textInputAction: TextInputAction.done,
                        decoration: _inputDecoration('CNIC', isDark),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CnicInputFormatter(),
                          LengthLimitingTextInputFormatter(15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Images
              Row(
                children: [
                  Expanded(
                    child: BlinkingFocusBuilder(
                      focusNode: profilePicFocus,
                      child: _buildImagePicker(
                        label: supplier?.profilePicFilename != null && controller.newSupplierProfilePic.value == null 
                            ? 'Update Profile Pic' 
                            : 'Profile Picture',
                        imageRx: controller.newSupplierProfilePic,
                        onTap: () {
                          profilePicFocus.requestFocus();
                          controller.pickSupplierProfilePic();
                        },
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: BlinkingFocusBuilder(
                      focusNode: cnicPicFocus,
                      child: _buildImagePicker(
                        label: supplier?.cnicPicFilename != null && controller.newSupplierCnicPic.value == null 
                            ? 'Update CNIC Img' 
                            : 'CNIC Image',
                        imageRx: controller.newSupplierCnicPic,
                        onTap: () {
                          cnicPicFocus.requestFocus();
                          controller.pickSupplierCnicPic();
                        },
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
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
                    child: const Text('Cancel (Esc)'),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  BlinkingFocusBuilder(
                    focusNode: submitFocus,
                    child: ElevatedButton(
                      focusNode: submitFocus,
                      onPressed: handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(supplier == null ? 'Add Supplier (Enter)' : 'Update Supplier (Enter)'),
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Bike Detail Dialog — StatefulWidget with Vehicle Papers tracking
// ─────────────────────────────────────────────────────────────────────────────

class _BikeDetailDialog extends StatefulWidget {
  final Bike bike;
  final DateTime purchaseDate;

  const _BikeDetailDialog({required this.bike, required this.purchaseDate});

  @override
  State<_BikeDetailDialog> createState() => _BikeDetailDialogState();
}

class _BikeDetailDialogState extends State<_BikeDetailDialog> {
  late bool _papersReceived;
  DateTime? _promisedDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _papersReceived = widget.bike.isDealerPapersCollected;
    _promisedDate = widget.bike.dealerPapersPromisedDate;
  }

  Future<void> _savePaperStatus() async {
    setState(() => _isSaving = true);
    try {
      final isar = Get.find<IsarService>().isar;
      await isar.writeTxn(() async {
        final fresh = await isar.bikes.get(widget.bike.id);
        if (fresh != null) {
          fresh.isDealerPapersCollected = _papersReceived;
          fresh.dealerPapersPromisedDate = _papersReceived ? null : _promisedDate;
          await isar.bikes.put(fresh);
        }
      });
      if (Get.isRegistered<InventoryController>()) {
        Get.find<InventoryController>().loadBikes();
        DataRefresher.refreshAll();
      }
    } catch (e) {
      debugPrint('Error saving paper status: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceColor = isDark ? AppColors.darkElevated : Colors.grey[50]!;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : Colors.grey.shade200;
    final fileService = Get.find<FileService>();
    final currencyFormat = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ', decimalDigits: 0);

    final isOverdue = !_papersReceived &&
        _promisedDate != null &&
        _promisedDate!.isBefore(DateTime.now());

    return Dialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: SingleChildScrollView(
        child: Container(
          width: 460,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Bike Image ──────────────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  width: double.infinity,
                  height: 180,
                  color: isDark ? const Color(0xFF1A2035) : Colors.grey[100],
                  child: widget.bike.imageFilename != null
                      ? Image.file(
                          File(fileService.getBikeImagePathSync(widget.bike.imageFilename!)),
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(LucideIcons.bike, size: 64, color: primaryColor.withOpacity(0.4)),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Title ────────────────────────────────────────────────────
              Text(
                '${widget.bike.model} ${widget.bike.brand}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  '${widget.bike.color} • ${widget.bike.modelYear}',
                  style: TextStyle(fontSize: 13, color: textSecondary),
                ),
              ),

              const SizedBox(height: 20),

              // ── Info Rows ─────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _infoRow(LucideIcons.hash, 'Engine No.', widget.bike.engineNumber, textSecondary, textPrimary, isMono: true),
                    _divider(borderColor),
                    _infoRow(LucideIcons.hash, 'Chassis No.', widget.bike.chassisNumber, textSecondary, textPrimary, isMono: true),
                    if (widget.bike.condition == BikeConditionEnum.usedBike) ...[
                      _divider(borderColor),
                      _infoRow(
                        LucideIcons.hash,
                        'Reg. No.',
                        (widget.bike.registrationNumber?.isNotEmpty == true)
                            ? widget.bike.registrationNumber!
                            : 'N/A',
                        textSecondary, textPrimary, isMono: true,
                      ),
                    ],
                    _divider(borderColor),
                    _infoRow(LucideIcons.list, 'Condition',
                        widget.bike.condition.name == 'usedBike' ? 'USED' : 'NEW',
                        textSecondary, textPrimary),
                    _divider(borderColor),
                    _infoRow(LucideIcons.calendar, 'Purchase Date',
                        DateFormat('dd MMM yyyy').format(widget.purchaseDate),
                        textSecondary, textPrimary),
                    _divider(borderColor),
                    _infoRow(LucideIcons.banknote, 'Purchase Price',
                        currencyFormat.format(widget.bike.purchasePrice),
                        textSecondary, primaryColor, isBold: true),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Vehicle Papers Section ────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isOverdue
                        ? Colors.red.withOpacity(0.5)
                        : _papersReceived
                            ? Colors.green.withOpacity(0.4)
                            : Colors.orange.withOpacity(0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Section header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _papersReceived
                            ? Colors.green.withOpacity(0.08)
                            : isOverdue
                                ? Colors.red.withOpacity(0.08)
                                : Colors.orange.withOpacity(0.06),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.fileCheck2,
                            size: 15,
                            color: _papersReceived
                                ? Colors.green
                                : isOverdue
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Vehicle Papers',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _papersReceived
                                  ? Colors.green
                                  : isOverdue
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                          ),
                          const Spacer(),
                          // Status chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: _papersReceived
                                  ? Colors.green.withOpacity(0.15)
                                  : isOverdue
                                      ? Colors.red.withOpacity(0.15)
                                      : Colors.orange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _papersReceived ? 'Received' : isOverdue ? 'Overdue' : 'Pending',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _papersReceived
                                    ? Colors.green
                                    : isOverdue
                                        ? Colors.red
                                        : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Overdue warning banner
                    if (isOverdue)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        color: Colors.red.withOpacity(0.08),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.alertTriangle, size: 13, color: Colors.red),
                            const SizedBox(width: 6),
                            Text(
                              'Papers promised by ${DateFormat('dd MMM yyyy').format(_promisedDate!)} — now overdue!',
                              style: const TextStyle(fontSize: 11, color: Colors.red),
                            ),
                          ],
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Toggle row
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () async {
                              setState(() {
                                _papersReceived = !_papersReceived;
                                if (_papersReceived) _promisedDate = null;
                              });
                              await _savePaperStatus();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: _papersReceived
                                    ? Colors.green.withOpacity(0.06)
                                    : (isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _papersReceived
                                      ? Colors.green.withOpacity(0.3)
                                      : borderColor,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: _papersReceived,
                                      onChanged: (val) async {
                                        setState(() {
                                          _papersReceived = val ?? false;
                                          if (_papersReceived) _promisedDate = null;
                                        });
                                        await _savePaperStatus();
                                      },
                                      activeColor: Colors.green,
                                      side: BorderSide(
                                        color: _papersReceived ? Colors.green : textSecondary,
                                        width: 1.5,
                                      ),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _papersReceived
                                              ? 'Papers received from dealer'
                                              : 'Papers NOT yet received from dealer',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: _papersReceived ? Colors.green : textPrimary,
                                          ),
                                        ),
                                        if (!_papersReceived)
                                          Text(
                                            'Tap to mark as received',
                                            style: TextStyle(fontSize: 11, color: textSecondary),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (_isSaving)
                                    const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // Date picker (only when pending)
                          if (!_papersReceived) ...[
                            const SizedBox(height: 10),
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _promisedDate ??
                                      DateTime.now().add(const Duration(days: 7)),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (picked != null) {
                                  setState(() => _promisedDate = picked);
                                  await _savePaperStatus();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isOverdue
                                      ? Colors.red.withOpacity(0.06)
                                      : primaryColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isOverdue
                                        ? Colors.red.withOpacity(0.4)
                                        : primaryColor.withOpacity(0.25),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.calendarDays,
                                      size: 15,
                                      color: isOverdue ? Colors.red : primaryColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Promised Delivery Date',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _promisedDate == null
                                                ? 'Tap to set a date'
                                                : DateFormat('dd MMM yyyy').format(_promisedDate!),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: isOverdue
                                                  ? Colors.red
                                                  : _promisedDate == null
                                                      ? textSecondary
                                                      : textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      LucideIcons.chevronRight,
                                      size: 14,
                                      color: isOverdue ? Colors.red : textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Okay Button ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text('Okay', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color labelColor, Color valueColor,
      {bool isMono = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: labelColor.withOpacity(0.6)),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: labelColor, fontSize: 13)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontFamily: isMono ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(Color color) => Divider(height: 1, color: color);
}
