import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:tahir_showroom/app/data/models/expense.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/features/investment/domain/investment_service.dart';
import 'package:tahir_showroom/app/core/services/report_pdf_service.dart';
import 'package:tahir_showroom/app/features/reports/data/repositories/reports_repository.dart';
import 'package:tahir_showroom/app/features/settings/data/repositories/settings_repository.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

enum ReportFilterMode { monthly, yearly, allTime }

class ReportsController extends GetxController {
  late final ReportsRepository _repository;
  final _pdfService = ReportPdfService();

  // ─── Observable State ──────────────────────────────────────
  final isLoading = true.obs;
  final selectedTab = 0.obs; // 0 = Reports, 1 = Revenue

  // Filter state
  final filterMode = ReportFilterMode.monthly.obs;
  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;

  // KPI values
  final totalRevenue = 0.0.obs;
  final totalExpenses = 0.0.obs;
  final netProfit = 0.0.obs;

  // Chart data
  final monthlyProfitData = <MapEntry<String, double>>[].obs;
  final stockDistribution = <String, int>{}.obs;
  final profitByBrand = <String, Map<String, double>>{}.obs;
  final revenueTrend = <MapEntry<String, double>>[].obs;
  final revenueChartFilter = 'Monthly'.obs; // 'Monthly' or 'Annual'
  final yearlyBreakdownData = <MapEntry<String, double>>[].obs; // For yearly PDF

  // Expenses
  final expenses = <Expense>[].obs;
  final expenseCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _repository = ReportsRepository();
    loadData();
  }

  /// Reload all data when month/year changes
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final mode = filterMode.value;
      final month = mode == ReportFilterMode.monthly ? selectedMonth.value : null;
      final year = mode == ReportFilterMode.allTime ? null : selectedYear.value;

      if (!Get.isRegistered<InvestmentService>()) {
        Get.put(InvestmentService());
      }
      final invService = Get.find<InvestmentService>();

      // Load data in parallel
      final results = await Future.wait([
        invService.getAvailableBalance(),
        invService.getTotalWithdrawals(),
        invService.getTotalProfit(),
        _repository.getMonthlyProfitTrend(6),
        _repository.getStockDistribution(),
        _repository.getProfitByBrand(month: month, year: year),
        _repository.getExpensesInPeriod(month: month, year: year),
        _repository.getExpenseCategories(),
        (mode == ReportFilterMode.monthly && revenueChartFilter.value == 'Monthly')
            ? _repository.getDailyRevenueTrend(selectedMonth.value, selectedYear.value)
            : _repository.getAnnualRevenueTrend(selectedYear.value),
        mode == ReportFilterMode.yearly ? _repository.getYearlyRevenueBreakdown(selectedYear.value) : Future.value(<MapEntry<String, double>>[]),
      ]);

      totalRevenue.value = results[0] as double; // Represents Available Cash
      totalExpenses.value = results[1] as double; // Represents Total Withdrawals
      netProfit.value = results[2] as double;

      monthlyProfitData.assignAll(results[3] as List<MapEntry<String, double>>);
      stockDistribution.assignAll(results[4] as Map<String, int>);
      profitByBrand.assignAll(results[5] as Map<String, Map<String, double>>);
      expenses.assignAll(results[6] as List<Expense>);
      expenseCategories.assignAll(results[7] as List<String>);
      revenueTrend.assignAll(results[8] as List<MapEntry<String, double>>);
      yearlyBreakdownData.assignAll(results[9] as List<MapEntry<String, double>>);

      // Merge default categories from settings
      try {
        final settingsRepo = SettingsRepository(Get.find<IsarService>());
        final settings = await settingsRepo.getSettings();
        if (settings.defaultExpenseCategories.isNotEmpty) {
          final defaults = settings.defaultExpenseCategories
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          
          bool addedNew = false;
          for (final cat in defaults) {
            if (!expenseCategories.contains(cat)) {
              expenseCategories.add(cat);
              addedNew = true;
            }
          }
          if (addedNew) {
            expenseCategories.sort();
          }
        }
      } catch (e) {
        debugPrint('Error merging default expense categories: $e');
      }

      // If still empty, provide basic defaults
      if (expenseCategories.isEmpty) {
        expenseCategories.assignAll([
          'Rent',
          'Salaries',
          'Utilities',
          'Marketing',
          'Maintenance',
          'Supplies',
          'Other',
        ]);
      }
    } catch (e) {
      debugPrint('Error loading reports data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Change selected month/year and reload
  void changeMonth(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
    filterMode.value = ReportFilterMode.monthly;
    loadData();
  }

  /// Change selected filtering mode (Monthly/Yearly/AllTime)
  void setFilterMode(ReportFilterMode mode) {
    filterMode.value = mode;
    // For AllTime, we reset chart to annual
    if (mode == ReportFilterMode.allTime) {
      revenueChartFilter.value = 'Annual';
    } else if (mode == ReportFilterMode.yearly) {
      revenueChartFilter.value = 'Annual';
    }
    loadData();
  }

  /// Change selected year and reload
  void changeYear(int year) {
    selectedYear.value = year;
    loadData();
  }

  /// Change revenue chart filter (Monthly/Annual)
  void changeRevenueChartFilter(String filter) {
    revenueChartFilter.value = filter;
    loadData();
  }

  // ─── Expense CRUD ──────────────────────────────────────────

  Future<void> addExpense(Expense expense) async {
    await _repository.addExpense(expense);
    await loadData();
  }

  Future<void> updateExpense(Expense expense) async {
    await _repository.updateExpense(expense);
    await loadData();
  }

  Future<void> deleteExpense(int id) async {
    await _repository.deleteExpense(id);
    await loadData();
  }

  // ─── PDF Download ──────────────────────────────────────────

  Future<void> downloadReport() async {
    String? path;

    final mode = filterMode.value;
    String dateRangeLabel;
    if (mode == ReportFilterMode.monthly) {
      dateRangeLabel = DateFormat('MMMM yyyy').format(DateTime(selectedYear.value, selectedMonth.value));
    } else if (mode == ReportFilterMode.yearly) {
      dateRangeLabel = 'Year ${selectedYear.value}';
    } else {
      dateRangeLabel = 'All Time';
    }

    if (selectedTab.value == 0) {
      // Reports Tab → Profit Report
      path = await _pdfService.generateProfitReport(
        dateRangeLabel: dateRangeLabel,
        totalRevenue: totalRevenue.value,
        totalExpenses: totalExpenses.value,
        netProfit: netProfit.value,
        profitByBrand: Map<String, Map<String, double>>.from(profitByBrand),
        stockDistribution: Map<String, int>.from(stockDistribution),
        yearlyBreakdown: mode == ReportFilterMode.yearly ? List<MapEntry<String, double>>.from(yearlyBreakdownData) : null,
      );
    } else {
      // Revenue Tab → Revenue & Expense Statement
      path = await _pdfService.generateRevenueStatement(
        dateRangeLabel: dateRangeLabel,
        totalRevenue: totalRevenue.value,
        totalExpenses: totalExpenses.value,
        netProfit: netProfit.value,
        expenses: List<Expense>.from(expenses),
      );
    }

    if (path != null) {
      AppToast.showSuccess(title: 'PDF Saved', message: 'Report saved to: $path');
    } else {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to generate PDF report.');
    }
  }
}
