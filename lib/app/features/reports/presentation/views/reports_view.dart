import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import '../controllers/reports_controller.dart';
import '../widgets/kpi_summary_cards.dart';
import '../widgets/monthly_profit_chart.dart';
import '../widgets/stock_distribution_chart.dart';
import '../widgets/profit_summary_table.dart';
import '../widgets/revenue_line_chart.dart';
import '../widgets/expense_tracker.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_overlay.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_target.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  int _selectedNavIndex = 6; // Reports is index 6 in sidebar

  // Coach mark keys
  final GlobalKey _filterModeSelectorKey = GlobalKey();
  final GlobalKey _kpiSummaryKey = GlobalKey();
  final GlobalKey _chartsSectionKey = GlobalKey();
  final GlobalKey _profitSummaryTableKey = GlobalKey();
  final GlobalKey _revenueLineChartKey = GlobalKey();
  final GlobalKey _expenseTrackerKey = GlobalKey();
  
  bool _showCoachMarks = false;

  @override
  void initState() {
    super.initState();
    _checkWalkthroughStatus();
  }

  Future<void> _checkWalkthroughStatus() async {
    final walkthroughService = Get.find<WalkthroughService>();
    if (!walkthroughService.hasCompletedTab('reports')) {
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
    Get.find<WalkthroughService>().markTabComplete('reports');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<ReportsController>();
    final currencyFormat = NumberFormat('#,##0', 'en_PK');

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          Row(
            children: [
              // Sidebar
              SidebarNavigation(
                selectedIndex: _selectedNavIndex,
                onItemSelected: (index) {
                  setState(() => _selectedNavIndex = index);
                  switch (index) {
                    case 0: Get.offNamed('/dashboard'); break;
                    case 1: Get.offNamed('/procurement'); break;
                    case 2: Get.offNamed('/inventory'); break;
                    case 3: Get.offNamed('/sales'); break;
                    case 4: Get.offNamed('/installments'); break;
                    case 5: Get.offNamed('/customers'); break;
                    case 6: break; // Already on Reports
                    case 7:

                      Get.offNamed('/investment');

                      break;

                    case 8:

                      Get.offNamed('/settings');

                      break;
                  }
                },
              ),
              // Main Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    children: [
                      // Header
                      _buildHeader(isDark, controller),
                      // Content
                      Expanded(
                        child: Obx(() => controller.selectedTab.value == 0
                            ? _buildReportsTab(isDark, controller, currencyFormat)
                            : _buildRevenueTab(isDark, controller, currencyFormat)),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          
          // Coach Marks Overlay
          if (_showCoachMarks)
            Positioned.fill(
              child: CoachMarkOverlay(
                targets: [
                  CoachMarkTarget(
                    targetKey: _filterModeSelectorKey,
                    title: 'Report Period',
                    description: 'Switch between Monthly, Yearly, and All-Time views.',
                    position: CoachMarkPosition.bottom,
                  ),
                  CoachMarkTarget(
                    targetKey: _kpiSummaryKey,
                    title: 'Financial Summary',
                    description: 'See total revenue, expenses, and net profit at a glance.',
                    position: CoachMarkPosition.bottom,
                  ),
                  CoachMarkTarget(
                    targetKey: _chartsSectionKey,
                    title: 'Profit & Stock Charts',
                    description: 'Monthly profit bar chart and stock distribution donut chart.',
                    position: CoachMarkPosition.top,
                  ),
                  CoachMarkTarget(
                    targetKey: _profitSummaryTableKey,
                    title: 'Brand-wise Profits',
                    description: 'Detailed breakdown of profit by brand in table format.',
                    position: CoachMarkPosition.top,
                  ),
                  CoachMarkTarget(
                    targetKey: _revenueLineChartKey,
                    title: 'Revenue Trends',
                    description: 'Track revenue over time with interactive line chart filters.',
                    position: CoachMarkPosition.bottom,
                    onBeforeTarget: () async {
                      // Switch to Revenue tab before showing this target
                      Get.find<ReportsController>().selectedTab.value = 1;
                    },
                  ),
                  CoachMarkTarget(
                    targetKey: _expenseTrackerKey,
                    title: 'Expense Management',
                    description: 'Add, edit, and delete business expenses to track net profit vs total expenses.',
                    position: CoachMarkPosition.top,
                  ),
                ],
                onComplete: _completeTour,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, ReportsController controller) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Title
          Text(
            'Revenue & Reports',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Filter Mode Selectors
          Obx(() => Container(
            key: _filterModeSelectorKey,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                _buildFilterModeButton('Monthly', ReportFilterMode.monthly, controller, isDark),
                _buildFilterModeButton('Yearly', ReportFilterMode.yearly, controller, isDark),
                _buildFilterModeButton('All', ReportFilterMode.allTime, controller, isDark),
              ],
            ),
          )),
          const SizedBox(width: AppSpacing.md),
          // Period Selector (Month/Year or Year)
          Obx(() {
            final mode = controller.filterMode.value;
            if (mode == ReportFilterMode.allTime) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: mode == ReportFilterMode.monthly
                ? DropdownButton<String>(
                    isDense: true,
                    value: '${controller.selectedMonth.value}-${controller.selectedYear.value}',
                    dropdownColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 14,
                    ),
                    icon: Icon(
                      LucideIcons.chevronDown,
                      size: 16,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    items: _buildMonthDropdownItems(monthNames, isDark),
                    onChanged: (value) {
                      if (value != null) {
                        final parts = value.split('-');
                        controller.changeMonth(int.parse(parts[0]), int.parse(parts[1]));
                      }
                    },
                  )
                : DropdownButton<int>(
                    isDense: true,
                    value: controller.selectedYear.value,
                    dropdownColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 14,
                    ),
                    icon: Icon(
                      LucideIcons.chevronDown,
                      size: 16,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    items: _buildYearDropdownItems(isDark),
                    onChanged: (value) {
                      if (value != null) {
                        controller.changeYear(value);
                      }
                    },
                  ),
              ),
            );
          }),
          const Spacer(),
          // Tab Switcher
          Obx(() => Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildTabButton('Reports', 0, controller, isDark),
                _buildTabButton('Revenue', 1, controller, isDark),
              ],
            ),
          )),
          const SizedBox(width: AppSpacing.md),
          // Download PDF
          FilledButton.icon(
            onPressed: () => _downloadReport(controller),
            icon: const Icon(LucideIcons.download, size: 16),
            label: const Text('Download PDF'),
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildMonthDropdownItems(List<String> monthNames, bool isDark) {
    final now = DateTime.now();
    final items = <DropdownMenuItem<String>>[];
    
    // List for dropdown
    for (int i = 0; i < 24; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      final value = '${date.month}-${date.year}';
      items.add(DropdownMenuItem(
        value: value,
        child: Text('${monthNames[date.month - 1]} ${date.year}'),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<int>> _buildYearDropdownItems(bool isDark) {
    final now = DateTime.now();
    final items = <DropdownMenuItem<int>>[];
    
    for (int i = 0; i < 5; i++) {
      final year = now.year - i;
      items.add(DropdownMenuItem(
        value: year,
        child: Text('$year'),
      ));
    }
    return items;
  }

  Widget _buildFilterModeButton(String label, ReportFilterMode mode, ReportsController controller, bool isDark) {
    final isActive = controller.filterMode.value == mode;
    return GestureDetector(
      onTap: () => controller.setFilterMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                : (isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int tabIndex, ReportsController controller, bool isDark) {
    final isActive = controller.selectedTab.value == tabIndex;
    return GestureDetector(
      onTap: () => controller.selectedTab.value = tabIndex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : (isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ─── Reports Tab ─────────────────────────────────────────────
  Widget _buildReportsTab(bool isDark, ReportsController controller, NumberFormat currencyFormat) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // KPI Cards
          Container(
            key: _kpiSummaryKey,
            child: KpiSummaryCards(
              totalRevenue: controller.totalRevenue.value,
              totalExpenses: controller.totalExpenses.value,
              netProfit: controller.netProfit.value,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Charts Row
          Container(
            key: _chartsSectionKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Monthly Profit Bar Chart
                Expanded(
                  flex: 3,
                  child: MonthlyProfitChart(
                    data: controller.monthlyProfitData,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                // Stock Distribution Donut
                Expanded(
                  flex: 2,
                  child: StockDistributionChart(
                    data: controller.stockDistribution,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Net Profit Summary Table
          Container(
            key: _profitSummaryTableKey,
            child: ProfitSummaryTable(
              data: controller.profitByBrand,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Revenue Tab ─────────────────────────────────────────────
  Widget _buildRevenueTab(bool isDark, ReportsController controller, NumberFormat currencyFormat) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Revenue Line Chart
          Obx(() => Container(
            key: _revenueLineChartKey,
            child: RevenueLineChart(
              data: controller.revenueTrend,
              filter: controller.revenueChartFilter.value,
              onFilterChanged: controller.changeRevenueChartFilter,
            ),
          )),
          const SizedBox(height: AppSpacing.lg),
          // Expense Tracker
          Container(
            key: _expenseTrackerKey,
            child: ExpenseTracker(
              expenses: controller.expenses,
              categories: controller.expenseCategories,
              onAdd: (expense) => controller.addExpense(expense),
              onUpdate: (expense) => controller.updateExpense(expense),
              onDelete: (id) => controller.deleteExpense(id),
              totalExpenses: controller.totalExpenses.value,
              totalRevenue: controller.totalRevenue.value,
              netProfit: controller.netProfit.value,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadReport(ReportsController controller) {
    controller.downloadReport();
  }
}
