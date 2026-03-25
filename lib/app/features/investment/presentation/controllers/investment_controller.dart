import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/investment/domain/investment_service.dart';
import 'package:tahir_showroom/app/data/models/investment.dart';
import 'package:tahir_showroom/app/core/services/report_pdf_service.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';

enum InvestmentFilter { all, weekly, monthly, yearly }

class InvestmentController extends GetxController {
  final InvestmentService _investmentService = Get.find<InvestmentService>();
  final ReportPdfService _pdfService = ReportPdfService();

  // === KPIs — Core ===
  final totalCapital = 0.0.obs;
  final totalAllocated = 0.0.obs;
  final lockedCapital = 0.0.obs;
  final availableBalance = 0.0.obs;
  final totalBalance = 0.0.obs; // Includes locked
  final totalProfit = 0.0.obs;
  final roiPercentage = 0.0.obs;

  // === KPIs — New (Bikes + Installments) ===
  final cashOnBikes = 0.0.obs;
  final futurePayments = 0.0.obs;
  final futureProfit = 0.0.obs;
  final accumulatedLoss = 0.0.obs;
  final activeContractsCount = 0.obs;
  final unsoldBikesCount = 0.obs;
  final cashFromSales = 0.0.obs;
  final cashFromInstallments = 0.0.obs;

  // History & Filters
  final investmentHistory = <Investment>[].obs;
  final filteredHistory = <Investment>[].obs;
  final selectedFilter = InvestmentFilter.all.obs;

  // Search
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Dialog Forms
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  final selectedDate = DateTime.now().obs;
  final selectedCategory = InvestmentCategoryEnum.personalCapital.obs;
  final isLockedToggle = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initAndLoadData();
    ever(searchQuery, (_) => _applyFilters(selectedFilter.value));
  }

  Future<void> _initAndLoadData() async {
    // Run one-time migration if needed
    await _investmentService.migrateExistingSalesData();
    await loadInvestmentData();
  }

  @override
  void onClose() {
    amountController.dispose();
    notesController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadInvestmentData() async {
    // Core KPIs
    totalCapital.value = await _investmentService.getTotalCapital();
    totalAllocated.value = await _investmentService.getTotalAllocated();
    lockedCapital.value = await _investmentService.getLockedCapital();
    availableBalance.value = await _investmentService.getAvailableBalance();
    totalBalance.value = await _investmentService.getTotalRemainingBalance();
    totalProfit.value = await _investmentService.getTotalProfit();
    roiPercentage.value = await _investmentService.calculateROI();

    // New KPIs — Bikes & Sales
    cashOnBikes.value = await _investmentService.getCashOnBikes();
    cashFromSales.value = await _investmentService.getCashFromSales();
    cashFromInstallments.value = await _investmentService.getCashFromInstallments();
    unsoldBikesCount.value = await _investmentService.getUnsoldBikesCount();

    // New KPIs — Installment Predictions
    futurePayments.value = await _investmentService.getFutureInstallmentPayments();
    futureProfit.value = await _investmentService.getFutureInstallmentProfit();
    activeContractsCount.value = await _investmentService.getActiveContractsCount();

    // Loss tracking
    accumulatedLoss.value = await _investmentService.getAccumulatedLoss();

    // History
    final history = await _investmentService.getInvestmentHistory();
    investmentHistory.assignAll(history);
    _applyFilters(selectedFilter.value);
  }

  void setFilter(InvestmentFilter filter) {
    selectedFilter.value = filter;
    _applyFilters(filter);
  }

  void _applyFilters(InvestmentFilter filter) {
    List<Investment> temp = investmentHistory.toList();

    // 1. Apply Date Filter
    final now = DateTime.now();
    switch (filter) {
      case InvestmentFilter.weekly:
        final lastWeek = now.subtract(const Duration(days: 7));
        temp = temp.where((inv) => inv.date.isAfter(lastWeek)).toList();
        break;
      case InvestmentFilter.monthly:
        final lastMonth = DateTime(now.year, now.month - 1, now.day);
        temp = temp.where((inv) => inv.date.isAfter(lastMonth)).toList();
        break;
      case InvestmentFilter.yearly:
        final lastYear = DateTime(now.year - 1, now.month, now.day);
        temp = temp.where((inv) => inv.date.isAfter(lastYear)).toList();
        break;
      case InvestmentFilter.all:
        break;
    }

    // 2. Apply Search Filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      temp = temp.where((inv) {
        final categoryStr = inv.category.name.toLowerCase();
        final notesStr = (inv.description ?? '').toLowerCase();
        return categoryStr.contains(query) || notesStr.contains(query);
      }).toList();
    }

    filteredHistory.assignAll(temp);
  }

  Future<void> saveCapitalInvestment() async {
    if (amountController.text.trim().isEmpty) {
      AppToast.showError(title: 'Error', message: 'Amount is required');
      return;
    }

    final amount = double.tryParse(amountController.text.replaceAll(',', '')) ?? 0.0;
    if (amount <= 0) {
      AppToast.showError(title: 'Error', message: 'Enter a valid positive amount');
      return;
    }

    try {
      await _investmentService.addCapitalInvestment(
        amount: amount,
        date: selectedDate.value,
        category: selectedCategory.value,
        description: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
        isLocked: isLockedToggle.value,
      );

      Get.back(); // Close Dialog immediately for snappy feel
      AppToast.showSuccess(title: 'Success', message: 'Capital investment added successfully');
      
      clearDialogForm();
      await loadInvestmentData(); // Refresh UI observables
    } catch (e) {
      AppToast.showError(title: 'Error', message: 'Failed to add investment: $e');
    }
  }

  Future<void> saveWithdrawal() async {
    if (amountController.text.trim().isEmpty) {
      AppToast.showError(title: 'Error', message: 'Amount is required');
      return;
    }

    final amount = double.tryParse(amountController.text.replaceAll(',', '')) ?? 0.0;
    if (amount <= 0) {
      AppToast.showError(title: 'Error', message: 'Enter a valid positive amount');
      return;
    }

    if (amount > availableBalance.value) {
      AppToast.showError(title: 'Error', message: 'Insufficient available balance');
      return;
    }

    try {
      await _investmentService.recordWithdrawal(
        amount: amount,
        date: selectedDate.value,
        description: notesController.text.trim().isEmpty ? 'Capital withdrawal' : notesController.text.trim(),
      );

      Get.back(); // Close Dialog immediately
      AppToast.showSuccess(title: 'Success', message: 'Withdrawal recorded successfully');
      
      clearDialogForm();
      await loadInvestmentData(); // Refresh UI
    } catch (e) {
      AppToast.showError(title: 'Error', message: 'Failed to record withdrawal: $e');
    }
  }

  void clearDialogForm() {
    amountController.clear();
    notesController.clear();
    selectedDate.value = DateTime.now();
    selectedCategory.value = InvestmentCategoryEnum.personalCapital;
    isLockedToggle.value = false;
  }

  Future<void> exportToPdf() async {
    try {
      if (filteredHistory.isEmpty) {
        AppToast.showInfo(title: 'Info', message: 'No investment data to export.');
        return;
      }
      
      AppToast.showInfo(title: 'Exporting', message: 'Generating investment report...');
      final path = await _pdfService.generateInvestmentReport(
        investments: filteredHistory.toList(),
      );

      if (path != null) {
        AppToast.showSuccess(title: 'Success', message: 'Report saved to $path');
      } else {
        AppToast.showError(title: 'Error', message: 'Failed to generate PDF Report');
      }
    } catch (e) {
      AppToast.showError(title: 'Error', message: 'PDF Generation failed: $e');
    }
  }
}

// Authored by: Moazzam Samoo
