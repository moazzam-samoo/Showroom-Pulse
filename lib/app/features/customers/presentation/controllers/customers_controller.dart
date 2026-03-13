import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart' as tahir_showroom;
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';
import 'package:tahir_showroom/app/features/customers/presentation/widgets/add_customer_dialog.dart';
import 'package:tahir_showroom/app/core/services/report_pdf_service.dart';
import 'package:tahir_showroom/app/core/services/customer_export_service.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

/// Controller for Customers screen
class CustomersController extends GetxController {
  late final CustomerRepository _repository;

  // Observable state
  final customers = <CustomerWithTransactions>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  bool get hasActiveFilters => searchQuery.value.isNotEmpty;

  void clearFilters() {
    searchQuery.value = '';
    searchController.clear();
    loadCustomers();
  }
  
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
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to load customers: $e');
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
    if (data['fullName'].toString().trim().isEmpty ||
        data['fatherName'].toString().trim().isEmpty ||
        data['cnicNumber'].toString().trim().isEmpty ||
        data['phoneNumber'].toString().trim().isEmpty ||
        data['address'].toString().trim().isEmpty ||
        data['profileImage'] == null ||
        data['cnicFrontImage'] == null ||
        data['cnicBackImage'] == null) {
      AppNotificationDialog.showError(
        title: 'Missing Information',
        message: 'Please fill all input fields and upload all 3 images (Profile, CNIC Front, CNIC Back).',
      );
      return;
    }

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

      AppToast.showSuccess(title: 'Success', message: 'Customer added successfully');
      loadData(); // Refresh list
    } catch (e) {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to add customer: $e');
    } finally {
      isLoading.value = false;
    }
  }
  /// Open Edit Customer Dialog
  void editCustomer(CustomerWithTransactions customerData) {
    Get.dialog(
      AddCustomerDialog(
        customer: customerData.customer,
        onSave: (data) => _updateCustomer(customerData.customer.id, data),
      ),
    );
  }

  /// Delete customer
  Future<void> deleteCustomer(int id) async {
    // 1. Check if safe to delete (no history)
    final canDelete = await _repository.canDeleteCustomer(id);
    
    if (!canDelete) {
      // Show special "Delete with History" dialog
      final confirmAll = await Get.dialog<bool>(
        AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete History?'),
            ],
          ),
          content: const Text(
            'This customer has transaction history (Sales/Installments).\n\n'
            'Do you want to delete the customer AND their entire history? This action is IRREVERSIBLE.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false), 
              child: const Text('Cancel')
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('DELETE EVERYTHING'),
            ),
          ],
        )
      );

      if (confirmAll == true) {
        await _executeDelete(id, withHistory: true);
      }
      return;
    }

    // 2. Standard Confirm (No history case)
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Customer?'),
        content: const Text('Are you sure you want to delete this customer? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true), 
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      )
    );

    if (confirm == true) {
      await _executeDelete(id, withHistory: false);
    }
  }

  /// Internal helper to execute deletion and refresh UI
  Future<void> _executeDelete(int id, {required bool withHistory}) async {
    isLoading.value = true;
    try {
      if (withHistory) {
        await _repository.deleteCustomerWithHistory(id);
      } else {
        await _repository.deleteCustomer(id);
      }
      
      AppToast.showSuccess(title: 'Success', message: 'Customer ${withHistory ? 'and history ' : ''}deleted successfully');
      
      // Clear selection if deleted
      if (selectedCustomer.value?.customer.id == id) {
        selectedCustomer.value = null;
      }
      
      loadData();
    } catch (e) {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to delete customer: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Internal method to update customer
  Future<void> _updateCustomer(int id, Map<String, dynamic> data) async {
    bool hasProfile = data['profileImage'] != null || data['existingProfileImage'] != null;
    bool hasCnicFront = data['cnicFrontImage'] != null || data['existingCnicFrontImage'] != null;
    bool hasCnicBack = data['cnicBackImage'] != null || data['existingCnicBackImage'] != null;

    if (data['fullName'].toString().trim().isEmpty ||
        data['fatherName'].toString().trim().isEmpty ||
        data['cnicNumber'].toString().trim().isEmpty ||
        data['phoneNumber'].toString().trim().isEmpty ||
        data['address'].toString().trim().isEmpty ||
        !hasProfile ||
        !hasCnicFront ||
        !hasCnicBack) {
      AppNotificationDialog.showError(
        title: 'Missing Information',
        message: 'Please fill all input fields and ensure all 3 images (Profile, CNIC Front, CNIC Back) are provided.',
      );
      return;
    }

    isLoading.value = true;
    try {
      String? profileImageFilename = data['existingProfileImage'];
      String? cnicFrontFilename = data['existingCnicFrontImage'];
      String? cnicBackFilename = data['existingCnicBackImage'];
      
      final fileService = Get.find<tahir_showroom.FileService>();

      // Update Profile Image if changed
      if (data['profileImage'] != null) {
        profileImageFilename = await fileService.saveCustomerImage(
          data['profileImage'],
          data['cnicNumber'],
          'profile',
        );
      }

      // Update CNIC Front if changed
      if (data['cnicFrontImage'] != null) {
        cnicFrontFilename = await fileService.saveCustomerImage(
          data['cnicFrontImage'],
          data['cnicNumber'],
          'cnic_front',
        );
      }

      // Update CNIC Back if changed
      if (data['cnicBackImage'] != null) {
        cnicBackFilename = await fileService.saveCustomerImage(
          data['cnicBackImage'],
          data['cnicNumber'],
          'cnic_back',
        );
      }

      // Start with a clean copy or fetch fresh
      // Since models are effectively immutable in Isar unless generated otherwise, 
      // we usually copy with changes. But Isar object updates work by ID.
      // So we can create a new object with the SAME ID.
      
      // We need to fetch the original to preserve dateRegistered etc if needed, 
      // or we just trust the inputs if we had them all.
      // Better to fetch fresh? Or just re-construct.
      // We don't have dateRegistered in data map easily unless passed.
      // Let's rely on repository logic or fetch first.
      
      final existingCust = customers.firstWhereOrNull((c) => c.customer.id == id)?.customer;
      if (existingCust == null) throw Exception('Customer not found in list');

      final updatedCustomer = existingCust
        ..fullName = data['fullName']
        ..fatherName = data['fatherName']
        ..cnicNumber = data['cnicNumber']
        ..phoneNumber = data['phoneNumber']
        ..address = data['address']
        ..profileImageFilename = profileImageFilename
        ..cnicFrontFilename = cnicFrontFilename
        ..cnicBackFilename = cnicBackFilename;
        // dateRegistered remains unchanged

      await _repository.updateCustomer(updatedCustomer);

      AppToast.showSuccess(title: 'Success', message: 'Customer updated successfully');
      loadData(); // Refresh list
    } catch (e) {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed to update customer: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> exportCustomerData() async {
    final customerObj = selectedCustomer.value;
    if (customerObj == null) {
      AppNotificationDialog.showError(title: 'Export Failed', message: 'No customer is selected.');
      return;
    }
  }

  /// Download single customer data (Hybrid Zip)
  Future<void> downloadCustomerData(CustomerWithTransactions customerData) async {
    try {
      AppToast.showInfo(title: 'Exporting', message: 'Generating customer statement...');
      final pdfService = Get.find<ReportPdfService>();

      final customerMap = {
        'fullName': customerObj.customer.fullName,
        'phoneNumber': customerObj.customer.phoneNumber,
        'cnicNumber': customerObj.customer.cnicNumber,
        'address': customerObj.customer.address,
      };

      // Create transactions list mapped
      final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      final txList = customerObj.transactions.map((tx) {
        final date = dateFormat.format(tx.sale.saleDate);
        final vehicle = tx.bike.model;
        final type = tx.isInstallment ? 'Installment' : 'Cash';
        final total = tx.isInstallment ? (tx.contract?.totalAmount ?? tx.sale.totalAmount) : tx.sale.totalAmount;
        final paid = tx.sale.receivedAmount;
        final bal = total - paid;
        
        return {
          'date': date,
          'vehicle': vehicle,
          'type': type,
          'totalPrice': total,
          'amountPaid': paid,
          'amountRemaining': bal,
        };
      }).toList();

      final filePath = await pdfService.generateCustomerStatement(
        customerData: customerMap,
        transactions: txList,
      );

      if (filePath != null) {
        AppToast.showSuccess(title: 'Success', message: 'Statement saved to $filePath');
      } else {
        AppNotificationDialog.showError(title: 'Error', message: 'Failed to generate statement');
      }
    } catch (e) {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed during export: $e');
    }
  }
}

// Authored by: Moazzam Samoo
