import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';

/// Controller for Customers screen
class CustomersController extends GetxController {
  late final CustomerRepository _repository;

  // Observable state
  final customers = <CustomerWithTransactions>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  
  // Expanded row tracking
  final expandedCustomerId = Rxn<int>();

  // Stats
  final totalCustomers = 0.obs;
  final customerGrowth = 0.0.obs;
  final activeInstallmentsCount = 0.obs;
  final activeInstallmentsValue = 0.0.obs;
  final pendingPaymentsCount = 0.obs;
  final pendingPaymentsDueSoon = 0.0.obs;

  // Sorting
  final sortByDateDesc = true.obs;
  final sortByPriceDesc = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initRepository();
    loadData();
  }

  void _initRepository() {
    final isarService = Get.find<IsarService>();
    _repository = CustomerRepository(isarService.isar);
  }

  /// Load all customer data and stats
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadCustomers(),
        loadStats(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load customers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load customers with transactions
  Future<void> loadCustomers() async {
    final data = await _repository.getAllCustomersWithTransactions(
      searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
      sortByDateDesc: sortByDateDesc.value,
      sortByPriceDesc: sortByPriceDesc.value,
    );
    customers.value = data;
  }

  /// Load dashboard stats
  Future<void> loadStats() async {
    // Total customers
    totalCustomers.value = await _repository.getTotalCustomerCount();
    
    // Growth percentage
    customerGrowth.value = await _repository.getCustomerGrowthPercentage();

    // Active installments
    final installmentStats = await _repository.getActiveInstallmentsStats();
    activeInstallmentsCount.value = installmentStats['count'];
    activeInstallmentsValue.value = installmentStats['totalValue'];

    // Pending payments
    final pendingStats = await _repository.getPendingPaymentsStats();
    pendingPaymentsCount.value = pendingStats['count'];
    pendingPaymentsDueSoon.value = pendingStats['dueSoon'];
  }

  /// Update search query
  void updateSearch(String query) {
    searchQuery.value = query;
    loadCustomers();
  }

  /// Toggle row expansion
  void toggleExpand(int customerId) {
    if (expandedCustomerId.value == customerId) {
      expandedCustomerId.value = null;
    } else {
      expandedCustomerId.value = customerId;
    }
  }

  /// Check if a customer row is expanded
  bool isExpanded(int customerId) {
    return expandedCustomerId.value == customerId;
  }

  /// Toggle date sorting
  void toggleDateSort() {
    sortByDateDesc.value = !sortByDateDesc.value;
    loadCustomers();
  }

  /// Toggle price sorting
  void togglePriceSort() {
    sortByPriceDesc.value = !sortByPriceDesc.value;
    loadCustomers();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadData();
  }
}

// Authored by: Moazzam Samoo
