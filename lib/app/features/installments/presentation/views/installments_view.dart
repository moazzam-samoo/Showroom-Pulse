import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/features/installments/presentation/controllers/installments_controller.dart';
import 'package:tahir_showroom/app/features/installments/presentation/widgets/customer_card.dart';
import 'package:tahir_showroom/app/features/installments/presentation/widgets/payment_summary_cards.dart';
import 'package:tahir_showroom/app/features/installments/presentation/widgets/payment_timeline.dart';
import 'package:tahir_showroom/app/features/installments/presentation/widgets/record_payment_dialog.dart';

/// Installments View - Split layout with customer list and detail panel
class InstallmentsView extends StatelessWidget {
  const InstallmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InstallmentsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Row(
        children: [
          // Sidebar Navigation
          SidebarNavigation(
            selectedIndex: 4, // Installments index
            onItemSelected: (index) => _handleNavigation(index),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar with Search and Filters
                _buildTopBar(context, controller, isDark),
                // Split Layout
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Panel - Customer List
                      SizedBox(
                        width: 320,
                        child: _buildCustomerList(controller, isDark),
                      ),
                      // Right Panel - Detail
                      Expanded(
                        child: _buildDetailPanel(controller, isDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, InstallmentsController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          // Title
          Text(
            'Track Installments',
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Search Box
          SizedBox(
            width: 280,
            child: TextField(
              onChanged: controller.updateSearch,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name or CNIC...',
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: 18,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.lightBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          // Due This Week Filter
          Obx(() => FilterChip(
            selected: controller.showDueThisWeek.value,
            onSelected: (_) => controller.toggleDueThisWeek(),
            label: const Text('Due This Week'),
            labelStyle: TextStyle(
              color: controller.showDueThisWeek.value
                  ? Colors.white
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              fontSize: 12,
            ),
            selectedColor: isDark ? AppColors.darkWarning : AppColors.lightWarning,
            backgroundColor: isDark ? AppColors.darkCard : AppColors.lightBackground,
            side: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          )),
          const SizedBox(width: AppSpacing.sm),
          // Status Filter Dropdown
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ContractStatusEnum?>(
                value: controller.statusFilter.value,
                hint: Text(
                  'All Status',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 13,
                  ),
                ),
                dropdownColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 13,
                ),
                items: [
                  DropdownMenuItem<ContractStatusEnum?>(
                    value: null,
                    child: Text('All Status'),
                  ),
                  ...ContractStatusEnum.values.map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(_getStatusText(status)),
                  )),
                ],
                onChanged: controller.setStatusFilter,
              ),
            ),
          )),
          const SizedBox(width: AppSpacing.sm),
          // Export All Button
          ElevatedButton.icon(
            onPressed: () => controller.downloadAllStatements(),
            icon: const Icon(LucideIcons.download, size: 16),
            label: const Text('Export All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList(InstallmentsController controller, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.base),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
          );
        }

        if (controller.contracts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.users,
                  size: 64,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                const SizedBox(height: AppSpacing.base),
                Text(
                  'No installment contracts found',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.contracts.length,
          itemBuilder: (context, index) {
            final data = controller.contracts[index];
            return Obx(() => CustomerCard(
              data: data,
              isSelected: controller.selectedContractId.value == data.contract.id,
              onTap: () => controller.selectContract(data.contract.id),
            ));
          },
        );
      }),
    );
  }

  Widget _buildDetailPanel(InstallmentsController controller, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(
        top: AppSpacing.base,
        right: AppSpacing.base,
        bottom: AppSpacing.base,
      ),
      child: Obx(() {
        final selected = controller.selectedContract;

        if (selected == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.mousePointerClick,
                  size: 64,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                const SizedBox(height: AppSpacing.base),
                Text(
                  'Select a customer to view details',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Header Card
              _buildCustomerHeader(selected, isDark),
              const SizedBox(height: AppSpacing.base),
              // Payment Summary Cards
              PaymentSummaryCards(
                totalAmount: selected.contract.totalAmount,
                paidAmount: selected.contract.totalPaid,
                remainingAmount: selected.contract.remainingBalance,
                nextDueDate: selected.contract.nextDueDate,
                downPayment: selected.contract.downPayment,
                monthlyEMI: selected.contract.monthlyEMI,
              ),
              const SizedBox(height: AppSpacing.base),
              // Payment Timeline (exclude initial Down Payment record)
              PaymentTimeline(
                payments: selected.payments.where((p) => !p.isDownPayment && p.notes != 'Down Payment').toList(),
                onRecordPayment: () => _showRecordPaymentDialog(controller),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCustomerHeader(ContractDisplayData data, bool isDark) {
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Center(
              child: Text(
                _getInitials(data.customer.fullName),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          // Customer Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.customer.fullName,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(LucideIcons.phone, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    const SizedBox(width: 4),
                    Text(
                      data.customer.phoneNumber,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(LucideIcons.creditCard, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    const SizedBox(width: 4),
                    Text(
                      'CNIC: ${data.customer.cnicNumber}',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bike Info + Download
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildInfoChip('Model: ${data.bike.model}', isDark),
              const SizedBox(height: 4),
              _buildInfoChip('Chassis: ${data.bike.chassisNumber ?? 'N/A'}', isDark),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          // Download Statement Button
          IconButton(
            onPressed: () => Get.find<InstallmentsController>().downloadStatement(),
            icon: Icon(
              LucideIcons.fileDown,
              size: 22,
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
            tooltip: 'Download Statement',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          fontSize: 11,
        ),
      ),
    );
  }

  void _showRecordPaymentDialog(InstallmentsController controller) {
    final selected = controller.selectedContract;
    Get.dialog(
      RecordPaymentDialog(
        defaultAmount: selected?.contract.monthlyEMI,
        onSubmit: (amount, method, collector, notes) {
          controller.recordPayment(
            amount: amount,
            method: method,
            collectorName: collector,
            notes: notes,
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  String _getStatusText(ContractStatusEnum status) {
    switch (status) {
      case ContractStatusEnum.active:
        return 'Active';
      case ContractStatusEnum.partiallyPaid:
        return 'Partially Paid';
      case ContractStatusEnum.overdue:
        return 'Overdue';
      case ContractStatusEnum.completed:
        return 'Completed';
      case ContractStatusEnum.defaulted:
        return 'Defaulted';
    }
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Get.offNamed('/dashboard');
        break;
      case 1:
        Get.offNamed('/procurement');
        break;
      case 2:
        Get.offNamed('/inventory');
        break;
      case 3:
        Get.offNamed('/sales');
        break;
      case 4:
        // Already on installments
        break;
      case 5:
        Get.offNamed('/customers');
        break;
      case 6:
        Get.offNamed('/reports');
        break;
      case 7:
        Get.offNamed('/settings');
        break;
    }
  }
}

// Authored by: Moazzam Samoo
