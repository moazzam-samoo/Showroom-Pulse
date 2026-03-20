import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/features/customers/presentation/controllers/customers_controller.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';

class CustomerListSidebar extends GetView<CustomersController> {
  final GlobalKey? downloadBtnKey;

  const CustomerListSidebar({
    super.key,
    this.downloadBtnKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(LucideIcons.users, size: 20, color: primaryColor),
                const SizedBox(width: 8),
                const Text('Customers', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  key: downloadBtnKey,
                  icon: const Icon(LucideIcons.download, size: 18),
                  onPressed: () => controller.downloadAllCustomersData(), 
                  tooltip: 'Download All Customers',
                  color: primaryColor,
                ),
                IconButton(
                  icon: const Icon(LucideIcons.userPlus, size: 18),
                  // TODO: Implement Add Customer Dialog if needed, or link to sales
                  onPressed: () => controller.openAddCustomerDialog(), 
                  tooltip: 'Add Customer',
                ),
              ],
            ),
          ),
          
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Obx(() => TextField(
              controller: controller.searchController,
              onChanged: controller.updateSearch,
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                hintText: 'Search customers...',
                hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                prefixIcon: Icon(LucideIcons.search, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                suffixIcon: controller.hasActiveFilters
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, size: 16),
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        onPressed: controller.clearFilters,
                        tooltip: 'Clear Search',
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                filled: true,
                fillColor: isDark ? AppColors.darkElevated : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            )),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          
          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.customers.isEmpty) {
                return Center(
                  child: Text(
                    'No customers found',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      fontSize: 12
                    ),
                  )
                );
              }

              return Scrollbar(
                child: ListView.separated(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                itemCount: controller.customers.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final customer = controller.customers[index];
                  return Obx(() {
                    final isSelected = controller.selectedCustomer.value?.customer.id == customer.customer.id;
                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: primaryColor.withOpacity(0.1),
                      leading: _buildAvatar(customer, isDark, primaryColor, Get.find<FileService>()),
                      title: Text(
                        customer.customer.fullName, 
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        customer.customer.phoneNumber, 
                        style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                      ),
                      onTap: () => controller.selectCustomer(customer),
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
                      trailing: PopupMenuButton(
                        icon: Icon(LucideIcons.moreVertical, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            height: 32,
                            child: Row(
                              children: [
                                Icon(LucideIcons.edit, size: 14, color: isDark ? Colors.white : Colors.black87),
                                const SizedBox(width: 8),
                                const Text('Edit', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                            onTap: () => controller.editCustomer(customer),
                          ),
                          PopupMenuItem(
                            height: 32,
                            child: Row(
                              children: [
                                Icon(LucideIcons.download, size: 14, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                                const SizedBox(width: 8),
                                Text('Download ZIP', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary)),
                              ],
                            ),
                            onTap: () => controller.downloadCustomerData(customer),
                          ),
                          PopupMenuItem(
                            height: 32,
                            child: const Row(
                              children: [
                                Icon(LucideIcons.trash2, size: 14, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(fontSize: 13, color: Colors.red)),
                              ],
                            ),
                            onTap: () => controller.deleteCustomer(customer.customer.id),
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(CustomerWithTransactions customerStats, bool isDark, Color primaryColor, FileService fileService) {
    if (customerStats.customer.profileImageFilename != null && customerStats.customer.profileImageFilename!.isNotEmpty) {
      final imagePath = fileService.getCustomerProfileImagePath(customerStats.customer.profileImageFilename!, customerStats.customer.cnicNumber);
      if (File(imagePath).existsSync()) {
        return CircleAvatar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          backgroundImage: FileImage(File(imagePath)),
          radius: 18,
        );
      }
    }
  
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          customerStats.initials,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
