import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/features/investment/presentation/controllers/investment_controller.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/add_investment_dialog.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/investment_history_card.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/investment_summary_card.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_overlay.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_target.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/investment_intro_overlay.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InvestmentView extends GetView<InvestmentController> {
  const InvestmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgCol = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final currencyFormat = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ', decimalDigits: 0);

    return Obx(() => Stack(
      children: [
        Scaffold(
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
                        icon: Icon(LucideIcons.helpCircle, color: textCol),
                        tooltip: 'Show Tour',
                        onPressed: () => _startCoachingTour(context),
                      ),
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
                        key: controller.addCapitalFabKey,
                        heroTag: 'add_btn',
                        onPressed: () => Get.dialog(const AddInvestmentDialog(isWithdrawal: false)),
                        backgroundColor: Colors.blue,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Add Capital', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  body: CustomScrollView(
                    controller: controller.scrollController,
                    slivers: [
                      // KPI Dashboard Area
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle('Core Financials', textCol),
                                      _buildGrid(context, [
                                        InvestmentSummaryCard(
                                          title: 'Total Invested',
                                          amount: currencyFormat.format(controller.totalCapital.value),
                                          icon: Icons.account_balance_wallet,
                                          color: const Color(0xFF3B82F6), // Blue
                                          subtitle: 'Lifetime capital',
                                          onTap: () => controller.setKpiFilter('Total Invested'),
                                          extraContent: _buildBreakdownList(
                                            context,
                                            controller.categoryFinancials.map((c) => 
                                              MapEntry(_formatEnum(c.category.name), c.injected)
                                            ).toList(),
                                            textCol,
                                            currencyFormat,
                                          ),
                                        ),
                                        InvestmentSummaryCard(
                                          title: 'Available Cash',
                                          amount: currencyFormat.format(controller.availableBalance.value),
                                          icon: Icons.savings,
                                          color: const Color(0xFF22C55E), // Green
                                          subtitle: controller.lockedCapital.value > 0
                                              ? '${currencyFormat.format(controller.lockedCapital.value)} Locked'
                                              : 'Ready to invest',
                                          onTap: () => controller.setKpiFilter('Available Cash'),
                                          extraContent: _buildBreakdownList(
                                            context,
                                            [
                                              ...controller.categoryFinancials.map((c) => 
                                                MapEntry(_formatEnum(c.category.name), c.available)
                                              ),
                                            ],
                                            textCol,
                                            currencyFormat,
                                          ),
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
                                          onTap: () => controller.setKpiFilter('Net Profit'),
                                          extraContent: _buildBreakdownList(
                                            context,
                                            [
                                              ...controller.categoryFinancials.map((c) => 
                                                MapEntry(_formatEnum(c.category.name), c.earnedProfit)
                                              ),
                                            ],
                                            textCol,
                                            currencyFormat,
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: 24),

                                      _buildSectionTitle('Asset Valuation', textCol),
                                      _buildGrid(
                                        context,
                                        [
                                          InvestmentSummaryCard(
                                            title: 'Sold & Completed Bikes Purchasing Value',
                                            amount: currencyFormat.format(controller.soldAndCompletedPriceValuation.value),
                                            icon: Icons.assignment_turned_in,
                                            color: const Color(0xFF10B981), // Green
                                            subtitle: 'Purchase cost of sold items',
                                            onTap: () => controller.setKpiFilter('Sold & Completed'),
                                          ),
                                          InvestmentSummaryCard(
                                            title: 'Active Inventory Bikes Purchasing Value',
                                            amount: currencyFormat.format(controller.activeInventoryPriceValuation.value),
                                            icon: Icons.inventory_2,
                                            color: const Color(0xFF6366F1), // Indigo
                                            subtitle: 'Value currently in showroom/pending',
                                            onTap: () => controller.setKpiFilter('Active Inventory'),
                                          ),
                                            InvestmentSummaryCard(
                                              title: 'Maintenance Spent',
                                              amount: currencyFormat.format(controller.cashOnMaintenance.value),
                                              icon: Icons.build,
                                              color: const Color(0xFFEAB308), // Amber
                                              subtitle: 'Lifetime maintenance expenses',
                                              onTap: () => controller.setKpiFilter('Maintenance Spent'),
                                            ),
                                            InvestmentSummaryCard(
                                              title: 'Total Expenses',
                                              amount: currencyFormat.format(controller.cashOnExpenses.value),
                                              icon: Icons.receipt_long,
                                              color: const Color(0xFFF97316), // Orange
                                              subtitle: 'All operating expenses & maintenance',
                                              onTap: () => controller.setKpiFilter('Total Expenses'),
                                            ),
                                          ],
                                          aspectRatio: MediaQuery.of(context).size.width > 1100 ? 2.0 : 1.5,
                                        ),
                                      const SizedBox(height: 24),

                                      _buildSectionTitle('Installment Predictions', textCol),
                                      _buildGrid(
                                        context,
                                        [
                                          InvestmentSummaryCard(
                                            title: 'Future Payments',
                                            amount: currencyFormat.format(controller.futurePayments.value),
                                            icon: Icons.update,
                                            color: const Color(0xFFF59E0B), // Orange-Amber
                                            subtitle: '${controller.activeContractsCount.value} Active contracts',
                                            onTap: () => controller.setKpiFilter('Future Payments'),
                                          ),
                                          InvestmentSummaryCard(
                                            title: 'Future Profit',
                                            amount: currencyFormat.format(controller.futureProfit.value),
                                            icon: Icons.auto_graph,
                                            color: const Color(0xFF8B5CF6), // Purple
                                            subtitle: 'Expected from active contracts',
                                            onTap: () => controller.setKpiFilter('Future Profit'),
                                          ),
                                        ],
                                        aspectRatio: MediaQuery.of(context).size.width > 1100 ? 2.0 : 1.5,
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  )),
                              const SizedBox(height: 32),
                              
                              // Filter Row
                              Column(
                                key: controller.filterRowKey,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Investment History',
                                            key: controller.historyTitleKey,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: textCol,
                                            ),
                                          ),
                                          Obx(() {
                                            if (controller.kpiFilter.value.isNotEmpty) {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Chip(
                                                  label: Text(
                                                    'Filtered by: ${controller.kpiFilter.value}',
                                                    style: const TextStyle(fontSize: 12),
                                                  ),
                                                  deleteIcon: const Icon(Icons.close, size: 16),
                                                  onDeleted: () => controller.setKpiFilter(controller.kpiFilter.value),
                                                  backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
                                                  labelStyle: const TextStyle(color: Color(0xFF3B82F6)),
                                                  side: const BorderSide(color: Color(0xFF3B82F6), width: 1),
                                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          }),
                                        ],
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
        ),
        
        // Intro Overlay
        if (controller.showTourRequested.value)
          InvestmentIntroOverlay(
            onStartTour: () {
              controller.showTourRequested.value = false;
              _startCoachingTour(context);
            },
            onDismiss: () => controller.markTourAsComplete(),
          ),
      ],
    ));
  }

  void _startCoachingTour(BuildContext context) {
    final List<CoachMarkTarget> targets = [
      CoachMarkTarget(
        targetKey: controller.investedCardKey,
        title: 'Total Capital',
        description: 'This shows the lifetime capital injected into the showroom since start. It represents your total ownership stake.',
        position: CoachMarkPosition.bottom,
        onBeforeTarget: () async {
          // KPIs are usually at the top, scroll there just in case
          await Scrollable.ensureVisible(
            controller.investedCardKey.currentContext!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
      ),
      CoachMarkTarget(
        targetKey: controller.availableCardKey,
        title: 'Available Cash',
        description: 'This is your liquid balance. Funds here are ready to be used for bike purchases or withdrawals.',
        position: CoachMarkPosition.bottom,
      ),
      CoachMarkTarget(
        targetKey: controller.profitCardKey,
        title: 'Net Profit & ROI',
        description: 'Track your real-time earnings. ROI (Return on Investment) helps you measure how efficiently your capital is working.',
        position: CoachMarkPosition.bottom,
      ),
      CoachMarkTarget(
        targetKey: controller.historyTitleKey,
        title: 'Transaction History',
        description: 'A complete audit log of every investment, withdrawal, and bike purchase associated with your capital.',
        position: CoachMarkPosition.bottom,
        onBeforeTarget: () async {
          await Scrollable.ensureVisible(
            controller.historyTitleKey.currentContext!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
      ),
      CoachMarkTarget(
        targetKey: controller.filterRowKey,
        title: 'Advanced Filters',
        description: 'Easily slice your data by transaction types (Bikes, Revenue, Capital) or time periods (Weekly, Monthly).',
        position: CoachMarkPosition.top,
        onBeforeTarget: () async {
          await Scrollable.ensureVisible(
            controller.filterRowKey.currentContext!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
      ),
      CoachMarkTarget(
        targetKey: controller.addCapitalFabKey,
        title: 'Quick Actions',
        description: 'Inject fresh capital or record withdrawals instantly using these action buttons.',
        position: CoachMarkPosition.top,
      ),
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CoachMarkOverlay(
        targets: targets,
        onComplete: () {
          Navigator.of(context).pop();
          controller.markTourAsComplete();
        },
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
  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Widget> children, {double? aspectRatio}) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 3 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: aspectRatio ?? (MediaQuery.of(context).size.width > 1100 ? 1.1 : 0.85),
      children: children,
    );
  }

  Widget _buildBreakdownList(BuildContext context, List<MapEntry<String, double>> data, Color textCol, NumberFormat format) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Ensure it only takes needed space
      children: [
        const Divider(height: 12),
        ...data.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.5), // Reduced from 2
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                e.key,
                style: TextStyle(
                  color: textCol.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
              Text(
                format.format(e.value),
                style: TextStyle(
                  color: textCol.withOpacity(0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  String _formatEnum(String name) {
    final RegExp exp = RegExp(r'(?<=[a-z])(?=[A-Z])');
    return name.replaceAllMapped(exp, (m) => ' ').capitalizeFirst ?? name;
  }
}

// Authored by: Moazzam Samoo
