import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tahir_showroom/app/data/models/expense.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/services/report_pdf_service.dart';
import '../../data/repositories/reports_repository.dart';

class ReportsController extends GetxController {
  late final ReportsRepository _repository;
  final _pdfService = ReportPdfService();

  // ─── Observable State ──────────────────────────────────────
  final isLoading = true.obs;
  final selectedTab = 0.obs; // 0 = Reports, 1 = Revenue

  // Month/Year filter
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

  // Expenses
  final expenses = <Expense>[].obs;
  final expenseCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<IsarService>().isar;
    _repository = ReportsRepository(isar);
    loadData();
  }

  /// Reload all data when month/year changes
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final month = selectedMonth.value;
      final year = selectedYear.value;

      // Load all data in parallel
      final results = await Future.wait([
        _repository.getTotalRevenue(month, year),
        _repository.getTotalExpenses(month, year),
        _repository.getMonthlyProfitTrend(6),
        _repository.getStockDistribution(),
        _repository.getProfitByBrand(month, year),
        _repository.getExpensesByMonth(month, year),
        _repository.getExpenseCategories(),
        revenueChartFilter.value == 'Monthly'
            ? _repository.getDailyRevenueTrend(month, year)
            : _repository.getAnnualRevenueTrend(year),
      ]);

      totalRevenue.value = results[0] as double;
      totalExpenses.value = results[1] as double;
      netProfit.value = totalRevenue.value - totalExpenses.value;

      monthlyProfitData.assignAll(results[2] as List<MapEntry<String, double>>);
      stockDistribution.assignAll(results[3] as Map<String, int>);
      profitByBrand.assignAll(results[4] as Map<String, Map<String, double>>);
      expenses.assignAll(results[5] as List<Expense>);
      expenseCategories.assignAll(results[6] as List<String>);
      revenueTrend.assignAll(results[7] as List<MapEntry<String, double>>);
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

    if (selectedTab.value == 0) {
      // Reports Tab → Monthly Profit Report
      path = await _pdfService.generateProfitReport(
        month: selectedMonth.value,
        year: selectedYear.value,
        totalRevenue: totalRevenue.value,
        totalExpenses: totalExpenses.value,
        netProfit: netProfit.value,
        profitByBrand: Map<String, Map<String, double>>.from(profitByBrand),
        stockDistribution: Map<String, int>.from(stockDistribution),
      );
    } else {
      // Revenue Tab → Revenue & Expense Statement
      path = await _pdfService.generateRevenueStatement(
        month: selectedMonth.value,
        year: selectedYear.value,
        totalRevenue: totalRevenue.value,
        totalExpenses: totalExpenses.value,
        netProfit: netProfit.value,
        expenses: List<Expense>.from(expenses),
      );
    }

    if (path != null) {
      Get.snackbar(
        'PDF Saved',
        'Report saved to: $path',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(12),
        backgroundColor: const Color(0xFF10B981),
        colorText: const Color(0xFFFFFFFF),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to generate PDF report.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }
}
