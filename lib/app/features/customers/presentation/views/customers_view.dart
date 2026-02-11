import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/features/customers/presentation/controllers/customers_controller.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';

/// Customers View - Customer data with expandable transaction history
class CustomersView extends StatelessWidget {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomersController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Row(
        children: [
          // Sidebar Navigation
          SidebarNavigation(
            selectedIndex: 5, // Customers tab
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
                  Get.offNamed('/installments');
                  break;
                case 5:
                  // Already on Customers
                  break;
                case 6:
                  Get.offNamed('/reports');
                  break;
              }
            },
          ),
          // Main Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPI Cards Row
                    _buildKPICards(context, controller, isDark),
                    const SizedBox(height: 24),
                    // Customer Data Table
                    _buildCustomerTable(context, controller, isDark),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Build 3 KPI Cards
  Widget _buildKPICards(BuildContext context, CustomersController controller, bool isDark) {
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkPrimary.withOpacity(0.3) : AppColors.lightBorder;

    return Row(
      children: [
        // Total Customers
        Expanded(
          child: _buildKPICard(
            title: 'TOTAL CUSTOMERS',
            value: controller.totalCustomers.value.toString(),
            subtitle: '${controller.customerGrowth.value >= 0 ? '+' : ''}${controller.customerGrowth.value.toStringAsFixed(0)}% last month',
            icon: LucideIcons.users,
            cardBg: cardBg,
            borderColor: borderColor,
            primaryColor: primaryColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 16),
        // Active Installments
        Expanded(
          child: _buildKPICard(
            title: 'ACTIVE INSTALLMENTS',
            value: controller.activeInstallmentsCount.value.toString(),
            subtitle: '₨${_formatCurrency(controller.activeInstallmentsValue.value)} Total Value',
            icon: LucideIcons.bike,
            cardBg: cardBg,
            borderColor: borderColor,
            primaryColor: primaryColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 16),
        // Pending Payments
        Expanded(
          child: _buildKPICard(
            title: 'PENDING PAYMENTS',
            value: controller.pendingPaymentsCount.value.toString(),
            subtitle: '₨${_formatCurrency(controller.pendingPaymentsDueSoon.value)} Due Soon',
            icon: LucideIcons.wallet,
            cardBg: cardBg,
            borderColor: borderColor,
            primaryColor: primaryColor,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color cardBg,
    required Color borderColor,
    required Color primaryColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Build Customer Data Table with expandable rows
  Widget _buildCustomerTable(BuildContext context, CustomersController controller, bool isDark) {
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkPrimary.withOpacity(0.3) : AppColors.lightBorder;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title, search, and export button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CUSTOMER DATA & TRANSACTIONS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Row(
                    children: [
                      // Search field
                      SizedBox(
                        width: 200,
                        height: 36,
                        child: TextField(
                          onChanged: controller.updateSearch,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            prefixIcon: Icon(
                              LucideIcons.search,
                              size: 18,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            filled: true,
                            fillColor: isDark ? AppColors.darkElevated : AppColors.lightBackground,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Export button
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Export functionality
                          Get.snackbar('Export', 'Export feature coming soon');
                        },
                        icon: Icon(LucideIcons.fileUp, size: 16, color: primaryColor),
                        label: Text(
                          'EXPORT DATA',
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryColor),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkElevated.withOpacity(0.5) : AppColors.lightBackground,
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
              ),
              child: Row(
                children: [
                  _buildTableHeader('CUSTOMER\n(Avatar+Name)', flex: 3, isDark: isDark, onSort: null),
                  _buildTableHeader('PHONE', flex: 2, isDark: isDark, onSort: null),
                  _buildTableHeader('TOTAL\nTRANSACTIONS', flex: 2, isDark: isDark, onSort: null),
                  _buildTableHeader('PENDING\nAMOUNT', flex: 2, isDark: isDark, onSort: controller.togglePriceSort, showSort: true),
                  _buildTableHeader('LAST PURCHASE\nDATE', flex: 2, isDark: isDark, onSort: controller.toggleDateSort, showSort: true),
                ],
              ),
            ),
            // Customer Rows
            Expanded(
              child: Obx(() {
                if (controller.customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.users,
                          size: 64,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No customers found',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.customers.length,
                  itemBuilder: (context, index) {
                    final customer = controller.customers[index];
                    final isExpanded = controller.isExpanded(customer.customer.id);
                    return _buildCustomerRow(
                      context,
                      customer,
                      isExpanded,
                      isDark,
                      primaryColor,
                      borderColor,
                      controller,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String label, {required int flex, required bool isDark, VoidCallback? onSort, bool showSort = false}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: onSort,
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                letterSpacing: 0.5,
              ),
            ),
            if (showSort) ...[
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevronsUpDown,
                size: 14,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerRow(
    BuildContext context,
    CustomerWithTransactions customer,
    bool isExpanded,
    bool isDark,
    Color primaryColor,
    Color borderColor,
    CustomersController controller,
  ) {
    return Column(
      children: [
        // Main Row
        InkWell(
          onTap: () => controller.toggleExpand(customer.customer.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isExpanded
                  ? (isDark ? primaryColor.withOpacity(0.1) : AppColors.lightPrimaryLight)
                  : Colors.transparent,
              border: isExpanded
                  ? Border.all(color: primaryColor.withOpacity(0.5), width: 1)
                  : Border(bottom: BorderSide(color: borderColor.withOpacity(0.5))),
              borderRadius: isExpanded ? BorderRadius.circular(8) : null,
            ),
            child: Row(
              children: [
                // Avatar + Name
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      _buildAvatar(customer.initials, isDark, primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        customer.customer.fullName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Phone
                Expanded(
                  flex: 2,
                  child: Text(
                    customer.customer.phoneNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                // Total Transactions
                Expanded(
                  flex: 2,
                  child: Text(
                    customer.totalTransactions.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                // Pending Amount
                Expanded(
                  flex: 2,
                  child: Text(
                    customer.pendingAmount > 0
                        ? '₨${_formatCurrency(customer.pendingAmount)}'
                        : '₨0',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: customer.pendingAmount > 0 ? primaryColor : (isDark ? AppColors.darkSuccess : AppColors.lightSuccess),
                    ),
                  ),
                ),
                // Last Purchase Date
                Expanded(
                  flex: 2,
                  child: Text(
                    customer.lastPurchaseDate != null
                        ? DateFormat('MMM dd, yyyy').format(customer.lastPurchaseDate!)
                        : 'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Expanded Transaction History
        if (isExpanded)
          _buildTransactionHistory(customer, isDark, primaryColor, borderColor),
      ],
    );
  }

  Widget _buildAvatar(String initials, bool isDark, Color primaryColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.8),
            primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHistory(
    CustomerWithTransactions customer,
    bool isDark,
    Color primaryColor,
    Color borderColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated.withOpacity(0.3) : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRANSACTION HISTORY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          // Transaction Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                _buildMiniHeader('VEHICLE DETAILS', 3, isDark),
                _buildMiniHeader('WITNESS INFO', 2, isDark),
                _buildMiniHeader('PAYMENT TIMELINE', 3, isDark),
                _buildMiniHeader('STATUS', 2, isDark),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Transaction Rows
          ...customer.transactions.map((tx) => _buildTransactionRow(tx, isDark, primaryColor)),
        ],
      ),
    );
  }

  Widget _buildMiniHeader(String label, int flex, bool isDark) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTransactionRow(TransactionRecord tx, bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder.withOpacity(0.3) : AppColors.lightBorder.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          // Vehicle Details
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  LucideIcons.bike,
                  size: 18,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tx.bike.modelYear} ${tx.bike.model}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'VIN: ${tx.bike.chassisNumber ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Witness Info
          Expanded(
            flex: 2,
            child: Text(
              tx.witnessName ?? 'N/A',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          // Payment Timeline
          Expanded(
            flex: 3,
            child: tx.isInstallment && tx.contract != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Down Payment: ₨${_formatCurrency(tx.contract!.downPayment)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      Text(
                        'Paid: ${tx.contract!.paymentsMade}/${tx.contract!.months} installments',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Cash: ₨${_formatCurrency(tx.sale.totalAmount)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                    ),
                  ),
          ),
          // Status

          Expanded(
            flex: 2,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(tx.statusText, isDark).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(tx.statusText, isDark).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _getStatusColor(tx.statusText, isDark),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tx.statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(tx.statusText, isDark),
                        ),
                      ),
                    ],
                  ),
                ),
                if (tx.isInstallment)
                  OutlinedButton(
                    onPressed: () {
                      Get.toNamed('/installments');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'View Contract',
                      style: TextStyle(
                        fontSize: 10,
                        color: primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Color _getStatusColor(String status, bool isDark) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
      case 'active installment':
      case 'partially paid':
        return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
      case 'overdue':
      case 'defaulted':
        return isDark ? AppColors.darkError : AppColors.lightError;
      default:
        return isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return NumberFormat('#,##0').format(amount);
    }
    return amount.toStringAsFixed(0);
  }
}

// Authored by: Moazzam Samoo
