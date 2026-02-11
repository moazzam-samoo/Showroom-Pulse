import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart' as tahir_showroom;
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';
import 'package:tahir_showroom/app/features/customers/presentation/widgets/add_customer_dialog.dart';

/// Controller for Customers screen
class CustomersController extends GetxController {
  late final CustomerRepository _repository;

  // Observable state
  final customers = <CustomerWithTransactions>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  
  // Expanded row tracking - DEPRECATED for Sidebar Layout but kept for compatibility during migration
  final expandedCustomerId = Rxn<int>();
  
  // Selection for Sidebar Layout API
  final selectedCustomer = Rxn<CustomerWithTransactions>();

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
    
    // If we have a selected customer, verify they still exist in the list and update data
    if (selectedCustomer.value != null) {
      final updatedSelection = data.firstWhereOrNull(
        (c) => c.customer.id == selectedCustomer.value!.customer.id
      );
      if (updatedSelection != null) {
        selectedCustomer.value = updatedSelection;
      } else {
        selectedCustomer.value = null; // Selection no longer in list (filtered out?)
      }
    }
  }

  void selectCustomer(CustomerWithTransactions customer) {
    selectedCustomer.value = customer;
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
  /// Open Add Customer Dialog
  void openAddCustomerDialog() {
    Get.dialog(
      AddCustomerDialog(
        onSave: (data) => _addCustomer(data),
      ),
    );
  }

  /// Internal method to save customer
  Future<void> _addCustomer(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      String? profileImageFilename;
      String? cnicFrontFilename;
      String? cnicBackFilename;
      
      final fileService = Get.find<tahir_showroom.FileService>();

      // Save Profile Image
      if (data['profileImage'] != null) {
        profileImageFilename = await fileService.saveCustomerImage(
          data['profileImage'],
          data['cnicNumber'],
          'profile',
        );
      }

      // Save CNIC Front
      if (data['cnicFrontImage'] != null) {
        cnicFrontFilename = await fileService.saveCustomerImage(
          data['cnicFrontImage'],
          data['cnicNumber'],
          'cnic_front',
        );
      }

      // Save CNIC Back
      if (data['cnicBackImage'] != null) {
        cnicBackFilename = await fileService.saveCustomerImage(
          data['cnicBackImage'],
          data['cnicNumber'],
          'cnic_back',
        );
      }

      await _repository.addCustomer(
        fullName: data['fullName'],
        fatherName: data['fatherName'],
        cnicNumber: data['cnicNumber'],
        phoneNumber: data['phoneNumber'],
        address: data['address'],
        profileImageFilename: profileImageFilename,
        cnicFrontFilename: cnicFrontFilename,
        cnicBackFilename: cnicBackFilename,
      );

      Get.snackbar('Success', 'Customer added successfully');
      loadData(); // Refresh list
    } catch (e) {
      Get.snackbar('Error', 'Failed to add customer: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

// Authored by: Moazzam Samoo
