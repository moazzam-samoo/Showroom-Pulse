import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/witness.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/utils/installment_calculator.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';
import 'package:tahir_showroom/app/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/core/utils/form_navigation_manager.dart';
import 'package:tahir_showroom/app/features/settings/data/repositories/settings_repository.dart';
import 'package:tahir_showroom/app/core/services/report_pdf_service.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

class NewSaleController extends GetxController {
  // Navigation Manager
  final formNavigationManager = FormNavigationManager();

  // Focus Nodes
  final FocusNode completeSaleFocus = FocusNode();

  // Step 1: Bike Selector
  final FocusNode searchBikeFocus = FocusNode();

  // Step 2: Customer Data
  final FocusNode searchCustomerFocus = FocusNode();
  final FocusNode customerNameFocus = FocusNode();
  final FocusNode customerFatherNameFocus = FocusNode();
  final FocusNode customerPhoneFocus = FocusNode();
  final FocusNode customerCnicFocus = FocusNode();
  final FocusNode customerAddressFocus = FocusNode();
  final FocusNode customerProfileImagePathFocus = FocusNode();
  final FocusNode customerCnicFrontPathFocus = FocusNode();
  final FocusNode customerCnicBackPathFocus = FocusNode();

  // Step 3: Witness 1
  final FocusNode witness1NameFocus = FocusNode();
  final FocusNode witness1CnicFocus = FocusNode();
  final FocusNode witness1PhoneFocus = FocusNode();
  final FocusNode witness1AddressFocus = FocusNode();
  final FocusNode witness1CnicFrontPathFocus = FocusNode();
  final FocusNode witness1CnicBackPathFocus = FocusNode();

  // Step 3: Witness 2
  final FocusNode witness2NameFocus = FocusNode();
  final FocusNode witness2CnicFocus = FocusNode();
  final FocusNode witness2PhoneFocus = FocusNode();
  final FocusNode witness2AddressFocus = FocusNode();
  final FocusNode witness2CnicFrontPathFocus = FocusNode();
  final FocusNode witness2CnicBackPathFocus = FocusNode();

  // Step 4: Payment
  final FocusNode cashAmountFocus = FocusNode();
  final FocusNode discountFocus = FocusNode(); // Added for discount
  final FocusNode downPaymentFocus = FocusNode();
  final FocusNode monthsFocus = FocusNode();
  final FocusNode markupValueFocus = FocusNode();

  // Stepper State
  final currentStep = 0.obs;

  // Step 1: Selected Bike
  final selectedBike = Rxn<Bike>();

  // Step 2: Customer Data
  final selectedCustomer = Rxn<Customer>();
  final customerSearchController = TextEditingController();
  final isNewCustomer = true.obs; // Default: New Customer

  // New Customer Form Controllers
  final customerNameController = TextEditingController();
  final customerFatherNameController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final customerCnicController = TextEditingController();
  final customerAddressController = TextEditingController();

  // Customer Image Paths
  final customerProfileImagePath = RxnString();
  final customerCnicFrontPath = RxnString();
  final customerCnicBackPath = RxnString();

  // Search State
  final searchResults = <CustomerWithTransactions>[].obs;
  final isSearching = false.obs;
  late final CustomerRepository _customerRepository;

  void _initCustomerRepository() {
    final isarService = Get.find<IsarService>();
    _customerRepository = CustomerRepository(isarService.isar);
  }

  Future<void> searchCustomers(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isSearching.value = true;
      final results = await _customerRepository.getAllCustomersWithTransactions(
        searchQuery: query,
        sortByDateDesc: true,
      );
      searchResults.assignAll(results);
    } catch (e) {
      print('Error searching customers: $e');
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void selectCustomer(CustomerWithTransactions customerWithTxn) {
    final customer = customerWithTxn.customer;
    selectedCustomer.value = customer;

    // Auto-fill form fields (in case we switch back to new customer mode or for display)
    customerNameController.text = customer.fullName;
    customerFatherNameController.text = customer.fatherName ?? '';
    customerPhoneController.text = customer.phoneNumber;
    customerCnicController.text = customer.cnicNumber;
    customerAddressController.text = customer.address ?? '';

    // Clear search results to hide list
    searchResults.clear();
    customerSearchController.clear();

    Get.snackbar(
      'Customer Selected',
      'Selected: ${customer.fullName}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      duration: const Duration(seconds: 2),
    );
  }

  void clearSelectedCustomer() {
    selectedCustomer.value = null;
    customerSearchController.clear();
    searchResults.clear();

    // Clear auto-filled fields
    customerNameController.clear();
    customerFatherNameController.clear();
    customerPhoneController.clear();
    customerCnicController.clear();
    customerAddressController.clear();
  }

  // Scroll Controller for auto-scroll on bike selection
  final scrollController = ScrollController();
  final customerSectionKey = GlobalKey();

  // Step 3: Payment Plan
  final saleType = SaleType.cash.obs; // Enum to be defined or inferred
  final cashAmountController = TextEditingController();

  // Installment Controllers
  final discountController = TextEditingController(text: '0'); // Shared or Installment specific
  final downPaymentController = TextEditingController();
  final monthsController = TextEditingController(text: '12');
  final markupType = MarkupType.fixed.obs;
  final markupValueController = TextEditingController(text: '0');

  // Witness 1 (Mandatory)
  final witness1NameController = TextEditingController();
  final witness1CnicController = TextEditingController();
  final witness1PhoneController = TextEditingController();
  final witness1AddressController = TextEditingController();
  final witness1CnicFrontPath = RxnString();
  final witness1CnicBackPath = RxnString();

  // Witness 2 (Optional)
  final showWitness2 = false.obs;
  final witness2NameController = TextEditingController();
  final witness2CnicController = TextEditingController();
  final witness2PhoneController = TextEditingController();
  final witness2AddressController = TextEditingController();
  final witness2CnicFrontPath = RxnString();
  final witness2CnicBackPath = RxnString();

  // Calculations
  final calculationResult = Rxn<InstallmentCalculationResult>();
  
  // Settings
  double _defaultMarkupPercentage = 40.0; // Default, will be overwritten by settings

  // Processing State
  final isProcessingSale = false.obs;

  // Available Inventory
  final availableBikes = <Bike>[].obs;

  // Expansion state for accordion behavior (only one model expanded at a time)
  final expandedModel = RxnString();

  Map<String, List<Bike>> get groupedBikes {
    final grouped = <String, List<Bike>>{};
    final displayNames = <String, String>{}; // Track original capitalization

    // Use InventoryController's filtered bikes for comprehensive search support
    final invController = Get.find<InventoryController>();
    final bikesToDisplay = invController.filteredBikes
        .where((bike) => bike.status == BikeStatusEnum.available)
        .toList();

    for (var bike in bikesToDisplay) {
      // Normalize to lowercase for grouping key
      final normalizedModel = bike.model.toLowerCase().trim();

      // Track the first occurrence's capitalization for display
      if (!displayNames.containsKey(normalizedModel)) {
        displayNames[normalizedModel] = bike.model;
      }

      // Group bikes by normalized model name
      if (!grouped.containsKey(normalizedModel)) {
        grouped[normalizedModel] = [];
      }
      grouped[normalizedModel]!.add(bike);
    }

    // Convert back to Map with original capitalization for keys (for UI display)
    final result = <String, List<Bike>>{};
    for (var entry in grouped.entries) {
      final displayName = displayNames[entry.key]!;
      result[displayName] = entry.value;
    }

    return result;
  }

  @override
  void onClose() {
    searchBikeFocus.dispose();
    searchCustomerFocus.dispose();
    customerNameFocus.dispose();
    customerFatherNameFocus.dispose();
    customerPhoneFocus.dispose();
    customerCnicFocus.dispose();
    customerAddressFocus.dispose();
    customerProfileImagePathFocus.dispose();
    customerCnicFrontPathFocus.dispose();
    customerCnicBackPathFocus.dispose();

    witness1NameFocus.dispose();
    witness1CnicFocus.dispose();
    witness1PhoneFocus.dispose();
    witness1AddressFocus.dispose();
    witness1CnicFrontPathFocus.dispose();
    witness1CnicBackPathFocus.dispose();

    witness2NameFocus.dispose();
    witness2CnicFocus.dispose();
    witness2PhoneFocus.dispose();
    witness2AddressFocus.dispose();
    witness2CnicFrontPathFocus.dispose();
    witness2CnicBackPathFocus.dispose();

    cashAmountFocus.dispose();
    discountFocus.dispose();
    downPaymentFocus.dispose();
    monthsFocus.dispose();
    markupValueFocus.dispose();
    completeSaleFocus.dispose();

    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _initCustomerRepository();
    loadAvailableBikes();

    // Register fields in Navigation Manager in logical order
    _registerNavigationFields();
    
    _loadDefaultSettings();

    downPaymentController.addListener(_calculateInstallment);
    discountController.addListener(_calculateInstallment);
    monthsController.addListener(_calculateInstallment);
    markupValueController.addListener(_calculateInstallment);
    ever(markupType, (type) {
      // If user switches to Percentage and the field is currently 0, pre-fill it with the settings default
      if (type == MarkupType.percentage && 
         (markupValueController.text == '0' || markupValueController.text.isEmpty)) {
        markupValueController.text = _defaultMarkupPercentage.toStringAsFixed(0);
      } 
      // If user switches back to Fixed and it's equal to the percentage default, reset to 0
      else if (type == MarkupType.fixed && 
               markupValueController.text == _defaultMarkupPercentage.toStringAsFixed(0)) {
        markupValueController.text = '0';
      }
      _calculateInstallment();
    });
    ever(
        selectedBike,
        (_) =>
            _calculateInstallment()); // Recalculate if bike changes (price changes)
  }

  void _registerNavigationFields() {
    // 1. Search Bike
    formNavigationManager.registerField(
      focusNode: searchBikeFocus,
      isFilled: () =>
          Get.find<InventoryController>().searchController.text.isNotEmpty ||
          selectedBike.value != null,
      order: 10,
    );

    // 2. Customer
    formNavigationManager.registerField(
      focusNode: customerNameFocus,
      isFilled: () => customerNameController.text.trim().isNotEmpty,
      order: 20,
    );
    formNavigationManager.registerField(
      focusNode: customerFatherNameFocus,
      isFilled: () => customerFatherNameController.text.trim().isNotEmpty,
      order: 21,
    );
    formNavigationManager.registerField(
      focusNode: customerCnicFocus,
      isFilled: () =>
          customerCnicController.text.trim().length >= 15, // Basic check
      order: 22,
    );
    formNavigationManager.registerField(
      focusNode: customerPhoneFocus,
      isFilled: () => customerPhoneController.text.trim().length >= 12,
      order: 23,
    );
    formNavigationManager.registerField(
      focusNode: customerAddressFocus,
      isFilled: () => customerAddressController.text.trim().isNotEmpty,
      order: 24,
    );

    // 3. Witness 1
    formNavigationManager.registerField(
      focusNode: witness1NameFocus,
      isFilled: () => witness1NameController.text.trim().isNotEmpty,
      order: 30,
    );
    formNavigationManager.registerField(
      focusNode: witness1CnicFocus,
      isFilled: () => witness1CnicController.text.trim().length >= 15,
      order: 31,
    );
    formNavigationManager.registerField(
      focusNode: witness1PhoneFocus,
      isFilled: () => witness1PhoneController.text.trim().length >= 12,
      order: 32,
    );
    formNavigationManager.registerField(
      focusNode: witness1AddressFocus,
      isFilled: () => witness1AddressController.text.trim().isNotEmpty,
      order: 33,
    );

    // 4. Witness 2
    formNavigationManager.registerField(
      focusNode: witness2NameFocus,
      isFilled: () => witness2NameController.text.trim().isNotEmpty,
      order: 40,
    );
    formNavigationManager.registerField(
      focusNode: witness2CnicFocus,
      isFilled: () => witness2CnicController.text.trim().length >= 15,
      order: 41,
    );
    formNavigationManager.registerField(
      focusNode: witness2PhoneFocus,
      isFilled: () => witness2PhoneController.text.trim().length >= 12,
      order: 42,
    );
    formNavigationManager.registerField(
      focusNode: witness2AddressFocus,
      isFilled: () => witness2AddressController.text.trim().isNotEmpty,
      order: 43,
    );

    // 5. Payment Details
    formNavigationManager.registerField(
      focusNode: cashAmountFocus,
      isFilled: () => cashAmountController.text.trim().isNotEmpty,
      order: 50,
    );
    formNavigationManager.registerField(
      focusNode: downPaymentFocus,
      isFilled: () => downPaymentController.text.trim().isNotEmpty,
      order: 60,
    );
    formNavigationManager.registerField(
      focusNode: monthsFocus,
      isFilled: () => monthsController.text.trim().isNotEmpty,
      order: 61,
    );
    formNavigationManager.registerField(
      focusNode: markupValueFocus,
      isFilled: () => markupValueController.text.trim().isNotEmpty,
      order: 62,
    );
  }

  Future<void> _loadDefaultSettings() async {
    try {
      final settingsRepo = SettingsRepository(Get.find<IsarService>());
      final settings = await settingsRepo.getSettings();
      
      // Store default markup but DO NOT instantly apply it to the UI (user requested Fixed/0 behavior by default)
      _defaultMarkupPercentage = settings.defaultMarkupPercentage;
    } catch (e) {
      print('Could not load default settings: $e');
    }
  }

  Future<void> loadAvailableBikes() async {
    final service = Get.find<IsarService>();
    final fileService = Get.find<FileService>();
    final bikes = await service.isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.available)
        .findAll();

    // Convert image filenames to full paths
    for (var bike in bikes) {
      if (bike.imageFilename != null) {
        bike.imageFilename = fileService.getBikeImagePath(bike.imageFilename!);
      }
    }

    availableBikes.assignAll(bikes);
  }

  void _calculateInstallment() {
    // Only calculate if in Installment mode
    if (saleType.value != SaleType.installment) return;

    final bike = selectedBike.value;
    if (bike == null) return;

    // Parse inputs
    final downPayment =
        double.tryParse(downPaymentController.text.replaceAll(',', '')) ?? 0;
    final discount =
        double.tryParse(discountController.text.replaceAll(',', '')) ?? 0;
    final months = int.tryParse(monthsController.text) ?? 0;
    final markupVal =
        double.tryParse(markupValueController.text.replaceAll(',', '')) ?? 0;

    if (months <= 0) {
      calculationResult.value = null;
      return;
    }

    try {
      final basePrice = ((bike.cashSalePrice as num?)?.toDouble() ?? 0.0) - discount;
      final result = InstallmentCalculator.calculate(
        cashPrice: basePrice > 0 ? basePrice : 0.0,
        markupType: markupType.value,
        markupValue: markupVal,
        downPayment: downPayment,
        months: months,
      );
      calculationResult.value = result;
    } catch (e) {
      print('Calculation Error: $e');
      calculationResult.value = null;
    }
  }

  // Dependencies
  final IsarService _isarService = Get.find<IsarService>();

  // ... (existing On Init) ...

  Future<void> finalizeSale() async {
    // Prevent multiple submissions
    if (isProcessingSale.value) {
      return;
    }

    // Validate bike selection
    if (selectedBike.value == null) {
      Get.snackbar(
        'Missing Information',
        'Please select a bike before completing the sale.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    // Validate payment details based on sale type
    if (saleType.value == SaleType.cash) {
      final cashAmount =
          double.tryParse(cashAmountController.text.replaceAll(',', ''));
      if (cashAmount == null || cashAmount <= 0) {
        Get.snackbar(
          'Invalid Amount',
          'Please enter a valid cash amount for the sale.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }
    } else {
      // Installment validation
      final bike = selectedBike.value;

      // Check if bike has a valid price
      try {
        final bikePrice = bike?.cashSalePrice;
        if (bikePrice == null || bikePrice <= 0) {
          Get.snackbar(
            'Invalid Bike Price',
            'The selected bike does not have a valid price set. Please contact administrator.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            duration: const Duration(seconds: 5),
          );
          return;
        }
      } catch (e) {
        Get.snackbar(
          'Invalid Bike Price',
          'The selected bike does not have a price set. Please select a different bike or contact administrator.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 5),
        );
        return;
      }

      if (calculationResult.value == null) {
        Get.snackbar(
          'Calculation Required',
          'The installment calculation is not complete. Please ensure the down payment and months are filled correctly. The calculation should update automatically.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
          duration: const Duration(seconds: 6),
        );
        return;
      }

      final downPayment =
          double.tryParse(downPaymentController.text.replaceAll(',', ''));
      if (downPayment == null || downPayment < 0) {
        Get.snackbar(
          'Invalid Down Payment',
          'Please enter a valid down payment amount.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }
    }

    // Validate customer information for new customers
    if (isNewCustomer.value) {
      if (customerNameController.text.trim().isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter the customer\'s full name.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }

      if (customerCnicController.text.trim().isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter the customer\'s CNIC number.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }

      if (customerPhoneController.text.trim().isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter the customer\'s phone number.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }
    }

    // Validate witness information (Witness 1 is mandatory for all sales)
    if (witness1NameController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please enter Witness 1\'s full name.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (witness1CnicController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please enter Witness 1\'s CNIC number.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    // Set processing state to show loading indicator
    isProcessingSale.value = true;

    try {
      // Execute the database transaction
      await _isarService.isar.writeTxn(() async {
        // A. Create/Get Customer
        Customer? customer;

        // Check if customer with this CNIC already exists
        customer = await _isarService.isar.customers
            .filter()
            .cnicNumberEqualTo(customerCnicController.text)
            .findFirst();

        if (customer != null) {
          // Customer exists, update their information
          customer
            ..fullName = customerNameController.text
            ..fatherName = customerFatherNameController.text.isNotEmpty
                ? customerFatherNameController.text
                : null
            ..phoneNumber = customerPhoneController.text
            ..address = customerAddressController.text.isNotEmpty
                ? customerAddressController.text
                : customer.address; // Keep existing address if new one is empty
        } else {
          // Create new customer
          customer = Customer()
            ..fullName = customerNameController.text
            ..fatherName = customerFatherNameController.text.isNotEmpty
                ? customerFatherNameController.text
                : null
            ..cnicNumber = customerCnicController.text
            ..phoneNumber = customerPhoneController.text
            ..address = customerAddressController.text
            ..dateRegistered = DateTime.now();
        }

        // Save customer images if any are provided
        final fileService = Get.find<FileService>();

        if (customerProfileImagePath.value != null) {
          final profileFile = File(customerProfileImagePath.value!);
          customer.profileImageFilename = await fileService.saveCustomerImage(
            profileFile,
            customer.cnicNumber,
            'profile',
          );
        }

        if (customerCnicFrontPath.value != null) {
          final cnicFrontFile = File(customerCnicFrontPath.value!);
          customer.cnicFrontFilename = await fileService.saveCustomerImage(
            cnicFrontFile,
            customer.cnicNumber,
            'cnic_front',
          );
        }

        if (customerCnicBackPath.value != null) {
          final cnicBackFile = File(customerCnicBackPath.value!);
          customer.cnicBackFilename = await fileService.saveCustomerImage(
            cnicBackFile,
            customer.cnicNumber,
            'cnic_back',
          );
        }

        await _isarService.isar.customers.put(customer);

        // B. Update Bike Status
        final bike = selectedBike.value!;
        bike.status = saleType.value == SaleType.cash
            ? BikeStatusEnum.sold
            : BikeStatusEnum.installment;
        await _isarService.isar.bikes.put(bike);

        // C. Create Sale Record
        final sale = Sale()
          ..saleDate = DateTime.now()
          ..saleType = saleType.value
          ..bikeId = bike.id
          ..customerId = customer.id
          ..totalAmount = saleType.value == SaleType.cash
              ? (double.tryParse(
                      cashAmountController.text.replaceAll(',', '')) ??
                  0)
              : (calculationResult.value?.grandTotal ?? 0)
          ..receivedAmount = saleType.value == SaleType.cash
              ? (double.tryParse(
                      cashAmountController.text.replaceAll(',', '')) ??
                  0)
              : (double.tryParse(
                      downPaymentController.text.replaceAll(',', '')) ??
                  0);

        // Calculate and apply discount
        if (saleType.value == SaleType.cash) {
          final double basePrice = bike.cashSalePrice;
          final double receivedAmt = double.tryParse(cashAmountController.text.replaceAll(',', '')) ?? 0.0;
          sale.discountAmount = basePrice > receivedAmt ? (basePrice - receivedAmt) : 0.0;
          sale.discountPercentage = basePrice > 0 ? (sale.discountAmount / basePrice) * 100 : 0.0;
        } else {
          final double basePrice = bike.cashSalePrice;
          final double discountAmt = double.tryParse(discountController.text.replaceAll(',', '')) ?? 0.0;
          sale.discountAmount = discountAmt;
          sale.discountPercentage = basePrice > 0 ? (discountAmt / basePrice) * 100 : 0.0;
        }

        await _isarService.isar.sales.put(sale);

        // D. If Installment, Create Contract & Witnesses
        if (saleType.value == SaleType.installment &&
            calculationResult.value != null) {
          final firstDue = DateTime.now().add(const Duration(days: 30));
          final dpAmount =
              double.tryParse(downPaymentController.text.replaceAll(',', '')) ??
                  0;
          final contract = InstallmentContract()
            ..bikeId = bike.id
            ..customerId = customer.id
            ..cashPrice = bike.cashSalePrice
            ..discountAmount = sale.discountAmount
            ..discountPercentage = sale.discountPercentage
            ..markupType = markupType.value
            ..markupValue = double.tryParse(
                    markupValueController.text.replaceAll(',', '')) ??
                0
            ..totalMarkupAmount = calculationResult.value!.totalMarkup
            ..totalAmount = calculationResult.value!.grandTotal
            ..downPayment = dpAmount
            ..months = int.tryParse(monthsController.text) ?? 0
            ..monthlyEMI = calculationResult.value!.monthlyEMI
            ..firstDueDate = firstDue
            ..nextDueDate = firstDue
            ..dayOfMonth = firstDue.day
            ..totalPaid = dpAmount
            ..paymentsMade = 1
            ..status = ContractStatusEnum.active;

          await _isarService.isar.installmentContracts.put(contract);

          // Link Contract to Sale
          sale.installmentContractId = contract.id;
          await _isarService.isar.sales.put(sale);
        }

        // D2. Create and Save Witness Records (for both cash and installment sales)
        // For installment sales, use contract ID. For cash sales, use sale ID (as negative to distinguish)
        // This ensures witnesses are properly linked to their specific sale
        final witnessContractId = (saleType.value == SaleType.installment &&
                sale.installmentContractId != null)
            ? sale.installmentContractId!
            : -sale
                .id; // Use negative sale ID for cash sales to distinguish from contract IDs

        // Save Witness 1 (Mandatory)
        final witness1 = Witness()
          ..fullName = witness1NameController.text
          ..cnicNumber = witness1CnicController.text
          ..phoneNumber = witness1PhoneController.text.isNotEmpty
              ? witness1PhoneController.text
              : ''
          ..address = witness1AddressController.text.isNotEmpty
              ? witness1AddressController.text
              : null
          ..cnicFrontFilename = witness1CnicFrontPath.value
          ..cnicBackFilename = witness1CnicBackPath.value
          ..contractId = witnessContractId
          ..isPrimary = true;

        await _isarService.isar.witness.put(witness1);

        // Save Witness 2 (Optional)
        if (witness2NameController.text.trim().isNotEmpty &&
            witness2CnicController.text.trim().isNotEmpty) {
          final witness2 = Witness()
            ..fullName = witness2NameController.text
            ..cnicNumber = witness2CnicController.text
            ..phoneNumber = witness2PhoneController.text.isNotEmpty
                ? witness2PhoneController.text
                : ''
            ..address = witness2AddressController.text.isNotEmpty
                ? witness2AddressController.text
                : null
            ..cnicFrontFilename = witness2CnicFrontPath.value
            ..cnicBackFilename = witness2CnicBackPath.value
            ..contractId = witnessContractId
            ..isPrimary = false;

          await _isarService.isar.witness.put(witness2);
        }

        // E. Create Initial Payment Record
        final payment = Payment()
          ..amount = sale.receivedAmount
          ..paymentDate = DateTime.now()
          ..notes = saleType.value == SaleType.cash
              ? 'Full Cash Payment'
              : 'Down Payment'
          ..isDownPayment = saleType.value == SaleType.installment
          ..contractId = (saleType.value == SaleType.installment &&
                  sale.installmentContractId != null)
              ? sale.installmentContractId!
              : 0; // For cash sales, use 0 as there's no contract

        await _isarService.isar.payments.put(payment);
      });

      // If we reach here, transaction was successful
      // Refresh sales data and dashboard stats (non-critical, errors won't affect success message)
      try {
        final salesController = Get.find<SalesController>();
        await salesController.refreshSales();
      } catch (e) {
        print('SalesController refresh warning: $e');
      }

      // Only refresh dashboard if controller is registered
      if (Get.isRegistered<DashboardController>()) {
        try {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.refreshStats();
        } catch (e) {
          print('DashboardController refresh warning: $e');
        }
      }

      // IMPORTANT: Close the dialog FIRST, then show success message
      Get.back(); // Close the new sale dialog

      // Get theme info
      final context = Get.context!;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final successColor =
          isDark ? AppColors.darkSuccess : Colors.green.shade700;
      final bgColor = isDark ? AppColors.darkSurface : Colors.green.shade50;
      final borderColor = isDark
          ? AppColors.darkSuccess.withOpacity(0.3)
          : Colors.green.shade200;
      final titleColor =
          isDark ? AppColors.darkTextPrimary : Colors.green.shade900;
      final messageColor =
          isDark ? AppColors.darkTextSecondary : Colors.green.shade800;
      final detailBgColor = isDark ? AppColors.darkCard : Colors.white;
      final labelColor =
          isDark ? AppColors.darkTextMuted : Colors.grey.shade700;
      final valueColor =
          isDark ? AppColors.darkTextPrimary : Colors.grey.shade900;

      // Show success confirmation dialog
      await Get.dialog(
        WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: borderColor, width: 2),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: successColor, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Sale Completed!',
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The sale has been successfully recorded in the database.',
                  style: TextStyle(
                    color: messageColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: detailBgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSuccessDetailRow(
                        'Customer:',
                        customerNameController.text,
                        labelColor,
                        valueColor,
                      ),
                      const SizedBox(height: 8),
                      _buildSuccessDetailRow(
                        'Bike:',
                        selectedBike.value?.model ?? 'N/A',
                        labelColor,
                        valueColor,
                      ),
                      const SizedBox(height: 8),
                      _buildSuccessDetailRow(
                        'Type:',
                        saleType.value == SaleType.cash
                            ? 'Cash Sale'
                            : 'Installment Sale',
                        labelColor,
                        valueColor,
                      ),
                      const SizedBox(height: 8),
                      _buildSuccessDetailRow(
                        'Amount:',
                        saleType.value == SaleType.cash
                            ? 'Rs. ${cashAmountController.text}'
                            : 'Rs. ${calculationResult.value?.grandTotal.toStringAsFixed(0) ?? '0'} (Down: Rs. ${downPaymentController.text})',
                        labelColor,
                        valueColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the success dialog
                },
                style: TextButton.styleFrom(
                  backgroundColor: successColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  Get.back();
                  _generateInvoiceForCompletedSale();
                },
                icon: const Icon(LucideIcons.download, size: 18),
                label: const Text(
                  'Generate Invoice',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: true,
      );
    } catch (e, stackTrace) {
      // Only reach here if the transaction actually failed
      print('======= SALE CREATION ERROR =======');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('Stack trace: $stackTrace');
      print('==================================');

      String errorMessage = e.toString();
      String title = 'Sale Failed';

      // Check for specific error types
      if (errorMessage.contains('unique') ||
          errorMessage.contains('UniqueViolation') ||
          errorMessage.contains('duplicate') ||
          errorMessage.contains('already exists')) {
        title = 'Sale Failed - Duplicate Customer';

        if (errorMessage.contains('cnic') || errorMessage.contains('CNIC')) {
          errorMessage =
              'A customer with CNIC "${customerCnicController.text}" already exists in the database. '
              'Please either:\n'
              '• Use the existing customer (search in step 2), or\n'
              '• Enter a different CNIC number for this new customer.';
        } else {
          errorMessage =
              'This customer information already exists in the database. Please check if the customer is already registered or use different details.';
        }
      } else if (errorMessage.contains('LateInitialization') ||
          errorMessage.contains('has not been initialized')) {
        title = 'Sale Failed - Missing Data';

        // Identify which field
        if (errorMessage.contains('cashSalePrice')) {
          errorMessage =
              'The selected bike does not have a price configured. Please select a different bike or contact the administrator.';
        } else if (errorMessage.contains('fullName') ||
            errorMessage.contains('cnicNumber') ||
            errorMessage.contains('phoneNumber')) {
          errorMessage =
              'Customer information is incomplete. Please fill all required fields (Name, CNIC, Phone).';
        } else {
          final errorStr = e.toString();
          errorMessage =
              'Some required data is missing. Please ensure all fields are filled. Error: ${errorStr.length > 100 ? errorStr.substring(0, 100) : errorStr}';
        }
      } else if (errorMessage.contains('Invalid') ||
          errorMessage.contains('null')) {
        title = 'Sale Failed - Invalid Data';
        errorMessage =
            'Some data is invalid. Please check all fields and try again.';
      } else if (errorMessage.contains('Isar') ||
          errorMessage.contains('database')) {
        title = 'Sale Failed - Database Error';
        // Provide more details in the error message
        final errorDetails = errorMessage.length > 200
            ? errorMessage.substring(0, 200) + '...'
            : errorMessage;
        errorMessage = 'A database error occurred while saving the sale.\n\n'
            'Details: $errorDetails\n\n'
            'Please try again or contact support if the problem persists.';
      } else {
        // Generic error with more details
        title = 'Sale Failed';
        errorMessage =
            'Could not complete the sale. Error: ${errorMessage.length > 150 ? errorMessage.substring(0, 150) + '...' : errorMessage}';
      }

      // Show error dialog instead of just snackbar for better visibility
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.red.shade200, width: 2),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red.shade700, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            errorMessage,
            style: TextStyle(
              color: Colors.red.shade800,
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the error dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    } finally {
      // Reset processing state
      isProcessingSale.value = false;
    }
  }

  // Helper method for success dialog detail rows
  Widget _buildSuccessDetailRow(
      String label, String value, Color labelColor, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: labelColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    } else {
      // Last Step -> Finalize
      finalizeSale();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> _generateInvoiceForCompletedSale() async {
    try {
      Get.snackbar('Exporting', 'Generating invoice...');
      final pdfService = Get.find<ReportPdfService>();
      final isCash = saleType.value == SaleType.cash;
      final today = DateFormat('dd/MM/yyyy').format(DateTime.now());

      final witnesses = <Map<String, String>>[];
      if (witness1NameController.text.isNotEmpty) {
        witnesses.add({
          'fullName': witness1NameController.text,
          'cnicNumber': witness1CnicController.text,
          'phoneNumber': witness1PhoneController.text,
        });
      }
      if (showWitness2.value && witness2NameController.text.isNotEmpty) {
        witnesses.add({
          'fullName': witness2NameController.text,
          'cnicNumber': witness2CnicController.text,
          'phoneNumber': witness2PhoneController.text,
        });
      }

      final saleMap = <String, dynamic>{
        'customerName': customerNameController.text,
        'customerCnic': customerCnicController.text,
        'customerContact': customerPhoneController.text,
        'customerAddress': customerAddressController.text,
        'bikeModel': selectedBike.value?.model ?? '',
        'bikeColor': selectedBike.value?.color ?? '',
        'bikeChassisNumber': selectedBike.value?.chassisNumber ?? '',
        'bikeEngineNumber': selectedBike.value?.engineNumber ?? '',
        'isCash': isCash,
        'saleDate': today,
        'witnesses': witnesses,
      };

      if (isCash) {
        final amount = double.tryParse(cashAmountController.text.replaceAll(',', '')) ?? 0;
        saleMap['amountPaid'] = amount;
        saleMap['sellingPrice'] = amount;
        saleMap['amountRemaining'] = 0.0;
      } else {
        final calc = calculationResult.value;
        final downPayment = double.tryParse(downPaymentController.text.replaceAll(',', '')) ?? 0;
        saleMap['amountPaid'] = downPayment;
        saleMap['sellingPrice'] = calc?.grandTotal ?? 0;
        saleMap['amountRemaining'] = (calc?.grandTotal ?? 0) - downPayment;
        saleMap['installmentMonthlyPayment'] = calc?.monthlyEMI ?? 0;
        saleMap['installmentDuration'] = int.tryParse(monthsController.text) ?? 12;
      }

      final filePath = await pdfService.generateSaleInvoice(saleData: saleMap);
      if (filePath != null) {
        Get.snackbar('Success', 'Invoice saved to $filePath', duration: const Duration(seconds: 4));
      } else {
        Get.snackbar('Error', 'Failed to generate invoice');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
// Removed duplicate SaleType Enum
