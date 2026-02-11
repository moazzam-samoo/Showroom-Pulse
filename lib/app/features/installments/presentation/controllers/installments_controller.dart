import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/installments/data/repositories/installment_repository.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/services/statement_service.dart';

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
  String get progressText => '${contract.paymentsMade}/${contract.months}';

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
  final statusFilter = Rxn<ContractStatusEnum>();

  // Filter options
  final showDueThisWeek = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initRepository();
    loadContracts();
  }

  void _initRepository() {
    final isarService = Get.find<IsarService>();
    _repository = InstallmentRepository(isarService.isar);
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
        rawContracts = await _repository.getActiveContracts();
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
        contracts.value = displayData.where((data) {
          return data.customer.fullName.toLowerCase().contains(query) ||
              data.customer.cnicNumber.contains(query) ||
              data.bike.model.toLowerCase().contains(query);
        }).toList();
      } else {
        contracts.value = displayData;
      }

      // Auto-select first if none selected
      if (selectedContractId.value == null && contracts.isNotEmpty) {
        selectedContractId.value = contracts.first.contract.id;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load contracts: $e');
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
      Get.snackbar('Success', 'Payment recorded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to record payment: $e');
    }
  }

  /// Download individual customer's installment statement
  Future<void> downloadStatement() async {
    final data = selectedContract;
    if (data == null) return;

    final service = StatementService();
    final path = await service.generateSingleStatement(data);
    if (path != null) {
      Get.snackbar('Success', 'Statement saved to Downloads folder',
        duration: const Duration(seconds: 3));
    } else {
      Get.snackbar('Error', 'Failed to generate statement');
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
      Get.snackbar('Success', 'All statements saved to Downloads folder',
        duration: const Duration(seconds: 3));
    } else {
      Get.snackbar('Error', 'Failed to generate statements');
    }
  }
}

// Authored by: Moazzam Samoo
