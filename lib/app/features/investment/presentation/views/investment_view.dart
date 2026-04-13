import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/features/investment/presentation/controllers/investment_controller.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/add_investment_dialog.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/investment_history_card.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/investment_summary_card.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/kpi_detail_popups.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/investment_intro_overlay.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/investment_filter_bar.dart';


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
                                          onTap: () => KpiDetailPopups.showTotalInvested(context),
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
                                          subtitle: 'Ready to invest',
                                          onTap: () => KpiDetailPopups.showAvailableCash(context),
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
                                          onTap: () => KpiDetailPopups.showNetProfit(context),
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
                                            onTap: () => KpiDetailPopups.showSoldAndCompleted(context),
                                          ),
                                          InvestmentSummaryCard(
                                            title: 'Active Inventory Bikes Purchasing Value',
                                            amount: currencyFormat.format(controller.activeInventoryPriceValuation.value),
                                            icon: Icons.inventory_2,
                                            color: const Color(0xFF6366F1), // Indigo
                                            subtitle: 'Value currently in showroom/pending',
                                            onTap: () => KpiDetailPopups.showActiveInventory(context),
                                          ),
                                            InvestmentSummaryCard(
                                              title: 'Maintenance Spent',
                                              amount: currencyFormat.format(controller.cashOnMaintenance.value),
                                              icon: Icons.build,
                                              color: const Color(0xFFEAB308), // Amber
                                              subtitle: 'Lifetime maintenance expenses',
                                              onTap: () => KpiDetailPopups.showMaintenance(context),
                                            ),
                                            InvestmentSummaryCard(
                                              title: 'Total Expenses',
                                              amount: currencyFormat.format(controller.cashOnExpenses.value),
                                              icon: Icons.receipt_long,
                                              color: const Color(0xFFF97316), // Orange
                                              subtitle: 'All operating expenses & maintenance',
                                              onTap: () => KpiDetailPopups.showTotalExpenses(context),
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
                                            onTap: () => KpiDetailPopups.showFuturePayments(context),
                                          ),
                                          InvestmentSummaryCard(
                                            title: 'Future Profit',
                                            amount: currencyFormat.format(controller.futureProfit.value),
                                            icon: Icons.auto_graph,
                                            color: const Color(0xFF8B5CF6), // Purple
                                            subtitle: 'Expected from active contracts',
                                            onTap: () => KpiDetailPopups.showFutureProfit(context),
                                          ),
                                        ],
                                        aspectRatio: MediaQuery.of(context).size.width > 1100 ? 2.0 : 1.5,
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  )),
                              const SizedBox(height: 32),
                              
                              // History List Header
                              Row(
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
                                  const SizedBox(width: 12),
                                  Obx(() => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6366F1).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${controller.filteredHistory.length} Records',
                                      style: const TextStyle(
                                        color: Color(0xFF6366F1),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const InvestmentFilterBar(),

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
        
        // Intro Overlay - keeping only dismiss functionality if it auto-shows
        if (controller.showTourRequested.value)
          InvestmentIntroOverlay(
            onStartTour: () {
              controller.showTourRequested.value = false;
              controller.markTourAsComplete();
            },
            onDismiss: () => controller.markTourAsComplete(),
          ),
      ],
    ));
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
