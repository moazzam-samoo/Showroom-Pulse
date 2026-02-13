import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/customers/presentation/controllers/customers_controller.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';

class CustomerListSidebar extends GetView<CustomersController> {
  const CustomerListSidebar({super.key});

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
            child: TextField(
              onChanged: controller.updateSearch,
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                hintText: 'Search customers...',
                hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                prefixIcon: Icon(LucideIcons.search, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                filled: true,
                fillColor: isDark ? AppColors.darkElevated : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
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
                      leading: _buildAvatar(customer.initials, isDark, primaryColor),
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

  Widget _buildAvatar(String initials, bool isDark, Color primaryColor) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
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
