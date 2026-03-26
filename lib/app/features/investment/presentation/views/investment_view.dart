import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/features/investment/presentation/controllers/investment_controller.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/add_investment_dialog.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/investment_history_card.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/investment_summary_card.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';

class InvestmentView extends GetView<InvestmentController> {
  const InvestmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgCol = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final currencyFormat = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: bgCol,
      body: Row(
        children: [
          SidebarNavigation(
            selectedIndex: 7,
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
                  Get.offNamed('/customers');
                  break;
                case 6:
                  Get.offNamed('/reports');
                  break;
                case 7:
                  // Already on investment
                  break;
                case 8:
                  Get.offNamed('/settings');
                  break;
              }
            },
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: bgCol,
      appBar: AppBar(
        title: Text('Investment Management', style: TextStyle(color: textCol, fontWeight: FontWeight.bold)),
        backgroundColor: bgCol,
        elevation: 0,
        iconTheme: IconThemeData(color: textCol),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: textCol),
            tooltip: 'Export Report',
            onPressed: controller.exportToPdf,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'withdraw_btn',
            onPressed: () => Get.dialog(const AddInvestmentDialog(isWithdrawal: true)),
            backgroundColor: Colors.orange,
            icon: const Icon(Icons.remove, color: Colors.white),
            label: const Text('Withdraw', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add_btn',
            onPressed: () => Get.dialog(const AddInvestmentDialog(isWithdrawal: false)),
            backgroundColor: Colors.blue,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Capital', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // KPI Dashboard Area
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => GridView.count(
                        crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 3 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: MediaQuery.of(context).size.width > 1100 ? 2.0 : 1.5,
                        children: [
                          InvestmentSummaryCard(
                            title: 'Total Invested',
                            amount: currencyFormat.format(controller.totalCapital.value),
                            icon: Icons.account_balance_wallet,
                            color: const Color(0xFF3B82F6), // Blue
                            subtitle: 'Lifetime capital',
                          ),
                          InvestmentSummaryCard(
                            title: 'Available Cash',
                            amount: currencyFormat.format(controller.availableBalance.value),
                            icon: Icons.savings,
                            color: const Color(0xFF22C55E), // Green
                            subtitle: controller.lockedCapital.value > 0
                                ? '${currencyFormat.format(controller.lockedCapital.value)} Locked'
                                : 'Ready to invest',
                          ),
                          InvestmentSummaryCard(
                            title: 'Cash on Bikes',
                            amount: currencyFormat.format(controller.cashOnBikes.value),
                            icon: Icons.motorcycle,
                            color: const Color(0xFFF59E0B), // Amber
                            subtitle: '${controller.unsoldBikesCount.value} bikes in inventory',
                          ),
                          InvestmentSummaryCard(
                            title: 'Net Profit',
                            amount: currencyFormat.format(controller.totalProfit.value),
                            icon: controller.totalProfit.value >= 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: controller.totalProfit.value >= 0
                                ? const Color(0xFF10B981) // Emerald
                                : const Color(0xFFEF4444), // Red
                            subtitle: controller.accumulatedLoss.value > 0
                                ? '${currencyFormat.format(controller.accumulatedLoss.value)} loss pending • ROI: ${controller.roiPercentage.value.toStringAsFixed(1)}%'
                                : 'ROI: ${controller.roiPercentage.value.toStringAsFixed(1)}%',
                          ),
                          InvestmentSummaryCard(
                            title: 'Future Payments',
                            amount: currencyFormat.format(controller.futurePayments.value),
                            icon: Icons.schedule,
                            color: const Color(0xFF06B6D4), // Cyan
                            subtitle: '${controller.activeContractsCount.value} active contracts',
                          ),
                          InvestmentSummaryCard(
                            title: 'Future Profit',
                            amount: currencyFormat.format(controller.futureProfit.value),
                            icon: Icons.auto_graph,
                            color: const Color(0xFF8B5CF6), // Violet
                            subtitle: 'Expected on installment completion',
                          ),
                        ],
                      )),
                  const SizedBox(height: 32),
                  
                  // Filter Row
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Investment History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textCol,
                            ),
                          ),
                          
                          // Search Box
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 280,
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  ),
                                  child: TextField(
                                    controller: controller.searchController,
                                    onChanged: (val) => controller.searchQuery.value = val,
                                    style: TextStyle(color: textCol, fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: 'Search by type, category...',
                                      hintStyle: TextStyle(color: textCol.withOpacity(0.4), fontSize: 14),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.search, size: 20, color: textCol.withOpacity(0.5)),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Double row of chips (Type & Date)
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 12,
                        children: [
                          // Type Filters (Left Side)
                          Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("Type:", style: TextStyle(color: textCol.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold)),
                              Obx(() => _buildCategoryChip(context, 'All', CategoryFilter.all, textCol)),
                              Obx(() => _buildCategoryChip(context, 'Investments', CategoryFilter.investments, textCol)),
                              Obx(() => _buildCategoryChip(context, 'Withdrawals', CategoryFilter.withdrawals, textCol)),
                              Obx(() => _buildCategoryChip(context, 'Bike Purchases', CategoryFilter.bikeInvestments, textCol)),
                              Obx(() => _buildCategoryChip(context, 'Revenue & Others', CategoryFilter.revenue, textCol)),
                            ],
                          ),
                          
                          // Time Filters (Right Side)
                          Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("Time:", style: TextStyle(color: textCol.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold)),
                              Obx(() => _buildDateChip(context, 'All Time', InvestmentFilter.all, textCol)),
                              Obx(() => _buildDateChip(context, 'This Week', InvestmentFilter.weekly, textCol)),
                              Obx(() => _buildDateChip(context, 'This Month', InvestmentFilter.monthly, textCol)),
                              Obx(() => _buildDateChip(context, 'This Year', InvestmentFilter.yearly, textCol)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          // History List
          Obx(() {
            if (controller.filteredHistory.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: textCol.withOpacity(0.2)),
                      const SizedBox(height: 16),
                      Text(
                        'No investment records found',
                        style: TextStyle(color: textCol.withOpacity(0.6), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final inv = controller.filteredHistory[index];
                    return InvestmentHistoryCard(investment: inv);
                  },
                  childCount: controller.filteredHistory.length,
                ),
              ),
            );
          }),
          
          const SliverToBoxAdapter(child: SizedBox(height: 80)), // Padding for FAB
        ],
      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, CategoryFilter filter, Color textCol) {
    final isSelected = controller.selectedCategoryFilter.value == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.setCategoryFilter(filter),
      selectedColor: Colors.orange.withOpacity(0.2), // Differentiation color
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelStyle: TextStyle(
        color: isSelected ? Colors.orange : textCol.withOpacity(0.7),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      side: BorderSide(
        color: isSelected ? Colors.orange.withOpacity(0.5) : Colors.transparent,
      ),
    );
  }

  Widget _buildDateChip(BuildContext context, String label, InvestmentFilter filter, Color textCol) {
    final isSelected = controller.selectedFilter.value == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.setFilter(filter),
      selectedColor: Colors.blue.withOpacity(0.2),
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue : textCol.withOpacity(0.7),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      side: BorderSide(
        color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.transparent,
      ),
    );
  }
}

// Authored by: Moazzam Samoo
