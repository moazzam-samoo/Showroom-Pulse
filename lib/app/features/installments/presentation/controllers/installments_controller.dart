import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/installments/data/repositories/installment_repository.dart';
import 'package:tahir_showroom/app/core/services/statement_service.dart';
import 'package:tahir_showroom/app/core/services/notification_service.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

enum DateFilter { all, thisMonth, lastMonth, last3Months, thisYear }

/// Data class for displaying contract with related info
class ContractDisplayData {
  final InstallmentContract contract;
  final Customer customer;
  final Bike bike;
  final List<Payment> payments;

  ContractDisplayData({
    required this.contract,
    required this.customer,
    required this.bike,
    required this.payments,
  });

  /// Get status display text
  String get statusText {
    switch (contract.status) {
      case ContractStatusEnum.active:
        return 'Active';
      case ContractStatusEnum.partiallyPaid:
        return 'Partial';
      case ContractStatusEnum.overdue:
        return 'Overdue';
      case ContractStatusEnum.completed:
        return 'Completed';
      case ContractStatusEnum.defaulted:
        return 'Defaulted';
    }
  }

  /// Get progress text (e.g., "7/12")
  String get progressText => contract.status == ContractStatusEnum.completed
      ? '${contract.paymentsMade}/${contract.paymentsMade}'
      : '${contract.paymentsMade}/${contract.months}';

  /// Calculate days until next due
  int? get daysUntilDue {
    if (contract.nextDueDate == null) return null;
    return contract.nextDueDate!.difference(DateTime.now()).inDays;
  }
}

/// Controller for the Installments feature
class InstallmentsController extends GetxController {
  late final InstallmentRepository _repository;

  // Observable state
  final contracts = <ContractDisplayData>[].obs;
  final isLoading = true.obs;
  final selectedContractId = Rxn<int>();
  final searchQuery = ''.obs;
  final dateFilter = DateFilter.all.obs;
  final searchController = TextEditingController();
  final statusFilter = Rxn<ContractStatusEnum>();
  final showDueThisWeek = false.obs;

  bool get hasActiveFilters =>
      searchQuery.value.isNotEmpty ||
      showDueThisWeek.value ||
      statusFilter.value != null ||
      dateFilter.value != DateFilter.all;

  void clearFilters() {
    searchQuery.value = '';
    searchController.clear();
    showDueThisWeek.value = false;
    statusFilter.value = null;
    dateFilter.value = DateFilter.all;
    loadContracts();
  }

  @override
  void onInit() {
    super.onInit();
    _initRepository();
    loadContracts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _initRepository() {
    _repository = InstallmentRepository();
  }

  /// Load all contracts with related data
  Future<void> loadContracts() async {
    isLoading.value = true;
    try {
      // Update overdue status first
      await _repository.updateOverdueContracts();
      
      // Repair legacy data (fix 0 down payments)
      await _repository.repairLegacyData();

      List<InstallmentContract> rawContracts;
      
      if (statusFilter.value != null) {
        rawContracts = await _repository.getContractsByStatus(statusFilter.value!);
      } else if (showDueThisWeek.value) {
        rawContracts = await _repository.getContractsDueSoon(7);
      } else {
        // Default to showing all contracts
        rawContracts = await _repository.getAllContracts();
      }

      // Load display data for each contract
      final displayData = <ContractDisplayData>[];
      for (final contract in rawContracts) {
        final customer = await _repository.getCustomerForContract(contract);
        final bike = await _repository.getBikeForContract(contract);
        final payments = await _repository.getPaymentsForContract(contract.id);

        if (customer != null && bike != null) {
          // Fallback: fix legacy contracts missing nextDueDate
          if (contract.nextDueDate == null && contract.status != ContractStatusEnum.completed) {
            contract.nextDueDate = contract.firstDueDate;
            contract.dayOfMonth = contract.firstDueDate.day;
          }
          displayData.add(ContractDisplayData(
            contract: contract,
            customer: customer,
            bike: bike,
            payments: payments,
          ));
        }
      }

      // Apply search filter
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final queryNoCommas = query.replaceAll(',', '');
        displayData.retainWhere((data) {
          final totalAmountStr = data.contract.totalAmount.toInt().toString();
          return data.customer.fullName.toLowerCase().contains(query) ||
              data.customer.cnicNumber.contains(query) ||
              data.bike.model.toLowerCase().contains(query) ||
              totalAmountStr.contains(queryNoCommas);
        });
      }

      // Apply date filter
      if (dateFilter.value != DateFilter.all) {
        final now = DateTime.now();
        DateTime startDate;
        DateTime? endDate;

        switch (dateFilter.value) {
          case DateFilter.thisMonth:
            startDate = DateTime(now.year, now.month, 1);
            break;
          case DateFilter.lastMonth:
            startDate = DateTime(now.year, now.month - 1, 1);
            endDate = DateTime(now.year, now.month, 1);
            break;
          case DateFilter.last3Months:
            startDate = DateTime(now.year, now.month - 3, 1);
            break;
          case DateFilter.thisYear:
            startDate = DateTime(now.year, 1, 1);
            break;
          default:
            startDate = DateTime(2000);
        }
        
        displayData.removeWhere((d) {
          final date = d.contract.contractDate;
          final tooEarly = date.isBefore(startDate);
          final tooLate = endDate != null && (date.isAfter(endDate) || date.isAtSameMomentAs(endDate));
          return tooEarly || tooLate;
        });
      }

      // Sort: Date Descending -> Total Amount Descending
      displayData.sort((a, b) {
        final dateComparison = b.contract.contractDate.compareTo(a.contract.contractDate);
        if (dateComparison == 0) {
          return b.contract.totalAmount.compareTo(a.contract.totalAmount);
        }
        return dateComparison;
      });

      contracts.value = displayData;

      // Auto-select first if none selected
      if (selectedContractId.value == null && contracts.isNotEmpty) {
        selectedContractId.value = contracts.first.contract.id;
      }
    } catch (e) {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to load contracts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get currently selected contract display data
  ContractDisplayData? get selectedContract {
    if (selectedContractId.value == null) return null;
    try {
      return contracts.firstWhere(
        (c) => c.contract.id == selectedContractId.value,
      );
    } catch (_) {
      return null;
    }
  }

  /// Select a contract
  void selectContract(int id) {
    selectedContractId.value = id;
  }

  /// Update search query
  void updateSearch(String query) {
    searchQuery.value = query;
    loadContracts();
  }

  /// Set status filter
  void setStatusFilter(ContractStatusEnum? status) {
    statusFilter.value = status;
    loadContracts();
  }

  /// Set date filter
  void setDateFilter(DateFilter filter) {
    dateFilter.value = filter;
    loadContracts();
  }

  /// Toggle due this week filter
  void toggleDueThisWeek() {
    showDueThisWeek.value = !showDueThisWeek.value;
    if (showDueThisWeek.value) {
      statusFilter.value = null;
    }
    loadContracts();
  }

  /// Record a payment
  Future<void> recordPayment({
    required double amount,
    required PaymentMethod method,
    String? collectorName,
    String? notes,
  }) async {
    if (selectedContractId.value == null) return;

    try {
      await _repository.recordPayment(
        contractId: selectedContractId.value!,
        amount: amount,
        method: method,
        collectorName: collectorName,
        notes: notes,
      );
      await loadContracts();
      AppToast.showSuccess(title: 'Success', message: 'Payment recorded successfully');
      
      // Refresh notifications to clear any alerts that are now paid
      try {
        await Get.find<NotificationService>().checkAndNotify();
      } catch (_) {}
    } catch (e) {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to record payment: $e');
    }
  }

  /// Admin manually completes a contract
  Future<void> adminComplete({required bool allPaymentReceived}) async {
    if (selectedContractId.value == null) return;

    try {
      await _repository.adminCompleteContract(
        contractId: selectedContractId.value!,
        allPaymentReceived: allPaymentReceived,
      );
      await loadContracts();
      AppToast.showSuccess(
        title: 'Success',
        message: allPaymentReceived
            ? 'Installment completed successfully'
            : 'Installment completed (Balance waived)',
      );

      // Refresh notifications
      try {
        await Get.find<NotificationService>().checkAndNotify();
      } catch (_) {}
    } catch (e) {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to complete installment: $e');
    }
  }

  /// Download individual customer's installment statement
  Future<void> downloadStatement() async {
    final data = selectedContract;
    if (data == null) return;

    final service = StatementService();
    final path = await service.generateSingleStatement(data);
    if (path != null) {
      AppToast.showSuccess(title: 'Success', message: 'Statement saved to Downloads folder');
    } else {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to generate statement');
    }
  }

  /// Download all installment statements (combined PDF + ZIP)
  Future<void> downloadAllStatements() async {
    if (contracts.isEmpty) return;

    final service = StatementService();

    // Generate combined PDF
    final pdfPath = await service.generateGlobalStatement(contracts.toList());

    // Generate ZIP with individual PDFs
    final zipPath = await service.generateGlobalZip(contracts.toList());

    if (pdfPath != null && zipPath != null) {
      AppToast.showSuccess(title: 'Success', message: 'All statements saved to Downloads folder');
    } else {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to generate statements');
    }
  }
}

// Authored by: Moazzam Samoo
