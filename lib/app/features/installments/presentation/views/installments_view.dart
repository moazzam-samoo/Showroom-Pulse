import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_overlay.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_target.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart';

/// Installments View - Split layout with customer list and detail panel
class InstallmentsView extends StatefulWidget {
  const InstallmentsView({super.key});

  @override
  State<InstallmentsView> createState() => _InstallmentsViewState();
}

class _InstallmentsViewState extends State<InstallmentsView> {
  // Coach mark keys
  final GlobalKey _searchBarKey = GlobalKey();
  final GlobalKey _customerListKey = GlobalKey();
  final GlobalKey _detailPanelKey = GlobalKey();
  
  bool _showCoachMarks = false;

  @override
  void initState() {
    super.initState();
    _checkWalkthroughStatus();
  }

  Future<void> _checkWalkthroughStatus() async {
    final walkthroughService = Get.find<WalkthroughService>();
    if (!walkthroughService.hasCompletedTab('installments')) {
      // Delay slightly to ensure layout is built
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _showCoachMarks = true;
          });
        }
      });
    }
  }

  void _completeTour() {
    setState(() {
      _showCoachMarks = false;
    });
    Get.find<WalkthroughService>().markTabComplete('installments');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InstallmentsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          Get.offNamed('/dashboard');
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Stack(
          children: [
            Row(
              children: [
                // Sidebar Navigation
                SidebarNavigation(
                  selectedIndex: 4, // Installments index
                  onItemSelected: (index) {
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
                        // Already on Installments
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
                  },
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
            
            // Coach Marks Overlay
            if (_showCoachMarks)
              Positioned.fill(
                child: CoachMarkOverlay(
                  targets: [
                    CoachMarkTarget(
                      targetKey: _searchBarKey,
                      title: 'Search Contracts',
                      description: 'Find installment contracts by customer name quickly.',
                      position: CoachMarkPosition.bottom,
                    ),
                    CoachMarkTarget(
                      targetKey: _customerListKey,
                      title: 'Active Contracts',
                      description: 'Browse all active installment customers here.',
                      position: CoachMarkPosition.right,
                    ),
                    CoachMarkTarget(
                      targetKey: _detailPanelKey,
                      title: 'Payment Details',
                      description: 'View payment timeline, record payments, and track remaining balance.',
                      position: CoachMarkPosition.left,
                    ),
                  ],
                  onComplete: _completeTour,
                ),
              ),
          ],
        ),
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
            key: _searchBarKey,
            width: 280,
            height: 40,
            child: Obx(() => TextField(
              controller: controller.searchController,
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
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, size: 16),
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        onPressed: () {
                          controller.searchController.clear();
                          controller.updateSearch('');
                        },
                        tooltip: 'Clear Search',
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.lightBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
            )),
          ),
          const SizedBox(width: AppSpacing.base),
          // Due This Week Filter
          SizedBox(
            height: 40,
            child: Obx(() => FilterChip(
              selected: controller.showDueThisWeek.value,
              onSelected: (_) => controller.toggleDueThisWeek(),
              label: const Text('Due This Week'),
              labelStyle: TextStyle(
                color: controller.showDueThisWeek.value
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              selectedColor: isDark ? AppColors.darkWarning : AppColors.lightWarning,
              backgroundColor: isDark ? AppColors.darkCard : AppColors.lightBackground,
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            )),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Status Filter Dropdown
          Obx(() => Container(
            height: 40,
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, size: 20),
                dropdownColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                items: [
                  const DropdownMenuItem<ContractStatusEnum?>(
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

          // Date Filter Dropdown
          Obx(() => Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<DateFilter>(
                value: controller.dateFilter.value,
                icon: const Icon(LucideIcons.calendar, size: 16),
                dropdownColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                items: const [
                  DropdownMenuItem(value: DateFilter.all, child: Text('All Time')),
                  DropdownMenuItem(value: DateFilter.thisMonth, child: Text('This Month')),
                  DropdownMenuItem(value: DateFilter.lastMonth, child: Text('Last Month')),
                  DropdownMenuItem(value: DateFilter.last3Months, child: Text('Last 3 Months')),
                  DropdownMenuItem(value: DateFilter.thisYear, child: Text('This Year')),
                ],
                onChanged: (val) {
                  if (val != null) controller.setDateFilter(val);
                },
              ),
            ),
          )),
          const SizedBox(width: AppSpacing.sm),

          // Clear Filters Button
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: SizedBox(
              height: 40, // Match typical button heights
              child: OutlinedButton.icon(
                onPressed: controller.clearFilters,
                icon: const Icon(LucideIcons.filterX, size: 16),
                label: const Text(
                  'Clear Filters',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.redAccent.shade200 : Colors.redAccent,
                  side: BorderSide(
                    color: (isDark ? Colors.redAccent.shade200 : Colors.redAccent).withOpacity(0.5)
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            ),
          ),

          // Export All Button
          SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () => controller.downloadAllStatements(),
              icon: const Icon(LucideIcons.download, size: 16),
              label: const Text('Export All', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList(InstallmentsController controller, bool isDark) {
    return Container(
      key: _customerListKey,
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
          padding: const EdgeInsets.only(right: AppSpacing.sm),
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
      key: _detailPanelKey,
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
                isCompleted: selected.contract.status == ContractStatusEnum.completed,
              ),
              const SizedBox(height: AppSpacing.base),

              // Admin Action: Complete Installment
              if (selected.contract.status != ContractStatusEnum.completed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.base),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCompleteInstallmentDialog(context, controller),
                      icon: const Icon(LucideIcons.checkCircle2, size: 18),
                      label: const Text('Complete Installment Manually'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                        side: BorderSide(color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                ),

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
              _buildInfoChip('Horse Power: ${data.bike.model}', isDark),
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
    final cleanName = name.trim();
    if (cleanName.isEmpty) return '?';
    
    final parts = cleanName.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    
    return cleanName.substring(0, cleanName.length >= 2 ? 2 : 1).toUpperCase();
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

  /// Show dialog to manually complete an installment
  void _showCompleteInstallmentDialog(BuildContext context, InstallmentsController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete This Installment?'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to mark this installment as completed.'),
            SizedBox(height: 16),
            Text(
              'Was all remaining payment received?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.adminComplete(allPaymentReceived: false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkWarning : AppColors.lightWarning,
              foregroundColor: Colors.white,
            ),
            child: const Text('No, Waive It'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.adminComplete(allPaymentReceived: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, All Paid'),
          ),
        ],
      ),
    );
  }
}

// Authored by: Moazzam Samoo
