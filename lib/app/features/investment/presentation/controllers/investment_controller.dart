import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/investment/domain/investment_service.dart';
import 'package:tahir_showroom/app/data/models/investment.dart';
import 'package:tahir_showroom/app/core/services/report_pdf_service.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';

enum InvestmentFilter { all, weekly, monthly, yearly, custom }

class InvestmentController extends GetxController {
  final InvestmentService _investmentService = Get.find<InvestmentService>();
  final WalkthroughService _walkthroughService = Get.find<WalkthroughService>();
  final ReportPdfService _pdfService = ReportPdfService();
  final scrollController = ScrollController();

  // === Coaching / Walkthrough Keys ===
  final investedCardKey = GlobalKey();
  final availableCardKey = GlobalKey();
  final profitCardKey = GlobalKey();
  final historyTitleKey = GlobalKey();
  final filterRowKey = GlobalKey();
  final addCapitalFabKey = GlobalKey();

  // === KPIs — Core ===
  final totalCapital = 0.0.obs;
  final totalAllocated = 0.0.obs;
  final availableBalance = 0.0.obs;
  final totalBalance = 0.0.obs; // Includes locked
  final totalProfit = 0.0.obs;
  final totalWithdrawals = 0.0.obs;
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
  final cashOnMaintenance = 0.0.obs;
  final cashOnExpenses = 0.0.obs;
  final totalAssets = 0.0.obs;
  final soldAndCompletedPriceValuation = 0.0.obs;
  final activeInventoryPriceValuation = 0.0.obs;
  final categoryFinancials = <CategoryFinancials>[].obs;

  // History & Filters
  final investmentHistory = <Investment>[].obs;
  final filteredHistory = <Investment>[].obs;
  final kpiFilter = ''.obs;

  // Search
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Dialog Forms
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  final selectedDate = DateTime.now().obs;
  final selectedCategory = InvestmentCategoryEnum.personalCapital.obs;
  final selectedWithdrawalSources = <InvestmentCategoryEnum>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initAndLoadData();
    debounce(searchQuery, (_) => _applyFilters(), time: const Duration(milliseconds: 300));
  }

  @override
  void onReady() {
    super.onReady();
    _checkAndShowTour();
  }

  Future<void> _checkAndShowTour() async {
    if (!_walkthroughService.hasCompletedTab('investment')) {
      // Small delay to ensure layout is ready
      await Future.delayed(const Duration(milliseconds: 500));
      showTourRequested.value = true;
    }
  }

  final showTourRequested = false.obs;

  void markTourAsComplete() {
    _walkthroughService.markTabComplete('investment');
    showTourRequested.value = false;
  }

  Future<void> _initAndLoadData() async {
    // Run one-time migration if needed
    await _investmentService.migrateExistingSalesData();
    
    // Retroactive cleanup for orphaned investments (bikes deleted before sync fix)
    await _investmentService.cleanupOrphanedInvestments();
    
    await loadInvestmentData();
  }

  @override
  void onClose() {
    amountController.dispose();
    notesController.dispose();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadInvestmentData() async {
    // Core KPIs
    totalCapital.value = await _investmentService.getTotalCapital();
    totalAllocated.value = await _investmentService.getTotalAllocated();
    totalWithdrawals.value = await _investmentService.getTotalWithdrawals();
    availableBalance.value = await _investmentService.getAvailableBalance();
    totalBalance.value = await _investmentService.getTotalRemainingBalance();
    totalProfit.value = await _investmentService.getTotalProfit();
    roiPercentage.value = await _investmentService.calculateROI();

    // New KPIs — Bikes & Sales
    cashOnBikes.value = await _investmentService.getCashOnBikes();
    cashFromSales.value = await _investmentService.getCashFromSales();
    cashFromInstallments.value = await _investmentService.getCashFromInstallments();
    unsoldBikesCount.value = await _investmentService.getTotalBikesPurchasedCount();
    cashOnMaintenance.value = await _investmentService.getMaintenanceCash();
    cashOnExpenses.value = await _investmentService.getExpensesCash();
    totalAssets.value = await _investmentService.getAssetsValue();
    soldAndCompletedPriceValuation.value = await _investmentService.getSoldAndCompletedBikesValue();
    activeInventoryPriceValuation.value = await _investmentService.getActiveInventoryValue();

    // New KPIs — Installment Predictions
    futurePayments.value = await _investmentService.getFutureInstallmentPayments();
    futureProfit.value = await _investmentService.getFutureInstallmentProfit();
    activeContractsCount.value = await _investmentService.getActiveContractsCount();

    // Breakdown
    categoryFinancials.assignAll(await _investmentService.getCategoryFinancials());

    // Loss tracking
    accumulatedLoss.value = await _investmentService.getAccumulatedLoss();

    // History
    final history = await _investmentService.getInvestmentHistory();
    investmentHistory.assignAll(history);
    _applyFilters();
  }

  void setKpiFilter(String kpiName) {
    if (kpiFilter.value == kpiName) {
      kpiFilter.value = ''; // Toggle off if clicked again
    } else {
      kpiFilter.value = kpiName;
      // Reset search so the user sees all relevant history for the KPI
      searchQuery.value = '';
      searchController.clear();
    }
    _applyFilters();
  }

  void _applyFilters() {
    List<Investment> temp = investmentHistory.toList();

    // 1. Apply Search Filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      final queryNoCommas = query.replaceAll(',', '');
      
      temp = temp.where((inv) {
        final typeStr = inv.type.name.replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (Match m) => ' ${m.group(0)}').toLowerCase();
        final categoryStr = inv.category.name.replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (Match m) => ' ${m.group(0)}').toLowerCase();
        final notesStr = (inv.description ?? '').toLowerCase();
        final amountStr = inv.amount.toInt().toString();
        
        return typeStr.contains(query) ||
               categoryStr.contains(query) || 
               notesStr.contains(query) || 
               amountStr.contains(queryNoCommas);
      }).toList();
    }

    // 2. Apply KPI Filter
    if (kpiFilter.value.isNotEmpty) {
      final kpi = kpiFilter.value;
      if (kpi == 'Total Invested') {
        temp = temp.where((inv) => inv.type == InvestmentTypeEnum.capitalInjection).toList();
      } else if (kpi == 'Available Cash') {
        // Available Cash is derived from many entries. Showing all is the most logical.
      } else if (kpi == 'Net Profit') {
        temp = temp.where((inv) => inv.profitAmount != 0).toList();
      } else if (kpi == 'Total Withdrawals') {
        temp = temp.where((inv) => inv.type == InvestmentTypeEnum.withdrawal).toList();
      } else if (kpi == 'Sold & Completed') {
        temp = temp.where((inv) => inv.type == InvestmentTypeEnum.bikePurchase).toList();
      } else if (kpi == 'Active Inventory') {
        temp = temp.where((inv) => inv.type == InvestmentTypeEnum.bikePurchase).toList();
      } else if (kpi == 'Maintenance Spent') {
        temp = temp.where((inv) => inv.type == InvestmentTypeEnum.withdrawal && inv.category == InvestmentCategoryEnum.maintenance).toList();
      } else if (kpi == 'Total Expenses') {
        temp = temp.where((inv) => inv.type == InvestmentTypeEnum.withdrawal && 
          (inv.category == InvestmentCategoryEnum.maintenance || 
           inv.category == InvestmentCategoryEnum.personalUse || 
           inv.category == InvestmentCategoryEnum.expense)).toList();
      } else if (kpi == 'Future Payments') {
        temp = temp.where((inv) => inv.type == InvestmentTypeEnum.installmentPayment || (inv.type == InvestmentTypeEnum.bikeSale && (inv.description?.contains('Installment') ?? false))).toList();
      } else if (kpi == 'Future Profit') {
        temp = temp.where((inv) => inv.type == InvestmentTypeEnum.bikeSale && (inv.description?.contains('Installment') ?? false)).toList();
      }
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
      );

      Get.back(); // Close Dialog immediately for snappy feel
      
      clearDialogForm();
      await loadInvestmentData(); // Refresh UI observables
      
      AppToast.showFinancial(
        title: 'Investment Added',
        line1: '💰 Capital Added: Rs ${amount.toStringAsFixed(0)}',
        line2: 'New Available Balance: Rs ${availableBalance.value.toStringAsFixed(0)}',
      );
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

    if (selectedWithdrawalSources.isEmpty) {
      AppToast.showError(title: 'Error', message: 'Please select at least one source pool');
      return;
    }

    final financials = categoryFinancials.toList();

    // Verify all selected pools have a positive balance
    for (final source in selectedWithdrawalSources) {
       final catFin = financials.firstWhereOrNull((c) => c.category == source);
       if (catFin != null && catFin.available <= 0) {
          final poolName = _formatEnumName(source.name);
          AppToast.showError(
            title: 'Empty Pool Selected', 
            message: 'The pool "$poolName" has zero balance and cannot be used for this expense. Please uncheck it.'
          );
          return;
       }
    }

    // Determine available balance of the selected sources only
    double selectedAvailable = 0.0;
    
    for (final source in selectedWithdrawalSources) {
       final catFin = financials.firstWhereOrNull((c) => c.category == source);
       if (catFin != null) {
          selectedAvailable += catFin.available;
       }
    }

    if (amount > selectedAvailable) {
       final sourceNames = selectedWithdrawalSources.map((e) => _formatEnumName(e.name)).join(' + ');
       AppToast.showError(title: 'Insufficient Balance', 
          message: 'Your selected pools ($sourceNames) only have Rs ${selectedAvailable.toStringAsFixed(0)} available. You are trying to withdraw Rs ${amount.toStringAsFixed(0)}. Please select additional options.');
       return;
    }

    // Calculate exact proportional deductions
    double deductPersonal = 0.0;
    double deductPartnership = 0.0;
    double deductLoan = 0.0;
    double deductOther = 0.0;

    for (final source in selectedWithdrawalSources) {
       final catFin = financials.firstWhereOrNull((c) => c.category == source);
       if (catFin != null && catFin.available > 0) {
          final ratio = catFin.available / selectedAvailable;
          final deduction = amount * ratio;
          
          switch (source) {
             case InvestmentCategoryEnum.personalCapital: deductPersonal = deduction; break;
             case InvestmentCategoryEnum.partnership: deductPartnership = deduction; break;
             case InvestmentCategoryEnum.loan: deductLoan = deduction; break;
             case InvestmentCategoryEnum.other: deductOther = deduction; break;
             default: break;
          }
       }
    }

    try {
      await _investmentService.recordWithdrawal(
        amount: amount,
        date: selectedDate.value,
        category: selectedCategory.value, // Acts as Reason here (maintenance, expense, etc)
        deductPersonal: deductPersonal,
        deductPartnership: deductPartnership,
        deductLoan: deductLoan,
        deductOther: deductOther,
        description: notesController.text.trim().isEmpty ? 'Capital outflow' : notesController.text.trim(),
      );

      Get.back(); // Close Dialog immediately
      
      clearDialogForm();
      await loadInvestmentData(); // Refresh UI
      
      AppToast.showFinancial(
        title: 'Outflow Recorded',
        line1: '💸 Amount: Rs ${amount.toStringAsFixed(0)}',
        line2: 'Calculated successfully across ${selectedWithdrawalSources.length} pools.',
      );
    } catch (e) {
      AppToast.showError(title: 'Error', message: 'Failed to record outflow: $e');
    }
  }

  void clearDialogForm() {
    amountController.clear();
    notesController.clear();
    selectedDate.value = DateTime.now();
    selectedCategory.value = InvestmentCategoryEnum.personalCapital;
    selectedWithdrawalSources.clear();
  }

  String _formatEnumName(String name) {
    if (name.isEmpty) return name;
    final RegExp exp = RegExp(r'(?<=[a-z])(?=[A-Z])');
    return name.replaceAllMapped(exp, (m) => ' ').capitalizeFirst ?? name;
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
