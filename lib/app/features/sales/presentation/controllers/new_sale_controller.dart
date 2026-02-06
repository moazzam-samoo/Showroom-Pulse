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
import 'package:isar/isar.dart';


class NewSaleController extends GetxController {
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

  // Scroll Controller for auto-scroll on bike selection
  final scrollController = ScrollController();
  final customerSectionKey = GlobalKey();
  
  // Step 3: Payment Plan
  final saleType = SaleType.cash.obs; // Enum to be defined or inferred
  final cashAmountController = TextEditingController();
  
  // Installment Controllers
  final downPaymentController = TextEditingController();
  final monthsController = TextEditingController(text: '12');
  final markupType = MarkupType.percentage.obs;
  final markupValueController = TextEditingController(text: '40');
  
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

  // Processing State
  final isProcessingSale = false.obs;

  // Available Inventory
  final availableBikes = <Bike>[].obs;

  Map<String, List<Bike>> get groupedBikes {
    final grouped = <String, List<Bike>>{};
    for (var bike in availableBikes) {
      if (!grouped.containsKey(bike.model)) {
        grouped[bike.model] = [];
      }
      grouped[bike.model]!.add(bike);
    }
    return grouped;
  }

  @override
  void onInit() {
    super.onInit();
    loadAvailableBikes();
    // Listen to changes for auto-calculation
    downPaymentController.addListener(_calculateInstallment);
    monthsController.addListener(_calculateInstallment);
    markupValueController.addListener(_calculateInstallment);
    ever(markupType, (_) => _calculateInstallment());
    ever(selectedBike, (_) => _calculateInstallment()); // Recalculate if bike changes (price changes)
  }

  Future<void> loadAvailableBikes() async {
    final service = Get.find<IsarService>();
    final bikes = await service.isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.available)
        .findAll();
    availableBikes.assignAll(bikes);
  }

  void _calculateInstallment() {
    // Only calculate if in Installment mode
    if (saleType.value != SaleType.installment) return;

    final bike = selectedBike.value;
    if (bike == null) return;

    // Parse inputs
    final downPayment = double.tryParse(downPaymentController.text) ?? 0;
    final months = int.tryParse(monthsController.text) ?? 0;
    final markupVal = double.tryParse(markupValueController.text) ?? 0;

    if (months <= 0) {
      calculationResult.value = null;
      return;
    }

    try {
      final result = InstallmentCalculator.calculate(
        cashPrice: bike.cashSalePrice ?? 0, // Fallback if 0
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
      final cashAmount = double.tryParse(cashAmountController.text);
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
      
      final downPayment = double.tryParse(downPaymentController.text);
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
        
        await _isarService.isar.customers.put(customer);

        // B. Update Bike Status
        final bike = selectedBike.value!;
        bike.status = saleType.value == SaleType.cash ? BikeStatusEnum.sold : BikeStatusEnum.installment;
        await _isarService.isar.bikes.put(bike);

        // C. Create Sale Record
        final sale = Sale()
          ..saleDate = DateTime.now()
          ..saleType = saleType.value
          ..bikeId = bike.id
          ..customerId = customer.id
          ..totalAmount = saleType.value == SaleType.cash 
              ? (double.tryParse(cashAmountController.text) ?? 0)
              : (calculationResult.value?.grandTotal ?? 0)
          ..receivedAmount = saleType.value == SaleType.cash 
              ? (double.tryParse(cashAmountController.text) ?? 0) 
              : (double.tryParse(downPaymentController.text) ?? 0);
        
        await _isarService.isar.sales.put(sale);

        // D. If Installment, Create Contract & Witnesses
        if (saleType.value == SaleType.installment && calculationResult.value != null) {
           final contract = InstallmentContract()
             ..bikeId = bike.id
             ..customerId = customer.id
             ..cashPrice = bike.cashSalePrice
             ..markupType = markupType.value
             ..markupValue = double.tryParse(markupValueController.text) ?? 0
             ..totalMarkupAmount = calculationResult.value!.totalMarkup
             ..totalAmount = calculationResult.value!.grandTotal
             ..downPayment = double.tryParse(downPaymentController.text) ?? 0
             ..months = int.tryParse(monthsController.text) ?? 0
             ..monthlyEMI = calculationResult.value!.monthlyEMI
             ..firstDueDate = DateTime.now().add(const Duration(days: 30))
             ..status = ContractStatusEnum.active;
           
           await _isarService.isar.installmentContracts.put(contract);
           
           // Link Contract to Sale
           sale.installmentContractId = contract.id;
           await _isarService.isar.sales.put(sale);
         }

         // D2. Create and Save Witness Records (for both cash and installment sales)
         // For installment sales, use contract ID. For cash sales, use sale ID (as negative to distinguish)
         // This ensures witnesses are properly linked to their specific sale
         final witnessContractId = (saleType.value == SaleType.installment && sale.installmentContractId != null) 
             ? sale.installmentContractId! 
             : -sale.id; // Use negative sale ID for cash sales to distinguish from contract IDs
         
         // Save Witness 1 (Mandatory)
         final witness1 = Witness()
           ..fullName = witness1NameController.text
           ..cnicNumber = witness1CnicController.text
           ..phoneNumber = witness1PhoneController.text.isNotEmpty ? witness1PhoneController.text : ''
           ..address = witness1AddressController.text.isNotEmpty ? witness1AddressController.text : null
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
             ..phoneNumber = witness2PhoneController.text.isNotEmpty ? witness2PhoneController.text : ''
             ..address = witness2AddressController.text.isNotEmpty ? witness2AddressController.text : null
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
          ..notes = saleType.value == SaleType.cash ? 'Full Cash Payment' : 'Down Payment'
          ..contractId = (saleType.value == SaleType.installment && sale.installmentContractId != null)
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

      // Show success confirmation dialog
      await Get.dialog(
        WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            backgroundColor: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.green.shade200, width: 2),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Sale Completed!',
                  style: TextStyle(
                    color: Colors.green.shade900,
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
                    color: Colors.green.shade800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSuccessDetailRow(
                        'Customer:', 
                        customerNameController.text,
                      ),
                      const SizedBox(height: 8),
                      _buildSuccessDetailRow(
                        'Bike:', 
                        selectedBike.value?.model ?? 'N/A',
                      ),
                      const SizedBox(height: 8),
                      _buildSuccessDetailRow(
                        'Type:', 
                        saleType.value == SaleType.cash ? 'Cash Sale' : 'Installment Sale',
                      ),
                      const SizedBox(height: 8),
                      _buildSuccessDetailRow(
                        'Amount:', 
                        saleType.value == SaleType.cash
                            ? 'Rs. ${cashAmountController.text}'
                            : 'Rs. ${calculationResult.value?.grandTotal.toStringAsFixed(0) ?? '0'} (Down: Rs. ${downPaymentController.text})',
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
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      if (errorMessage.contains('unique') || errorMessage.contains('UniqueViolation') || 
          errorMessage.contains('duplicate') || errorMessage.contains('already exists')) {
        title = 'Sale Failed - Duplicate Customer';
        
        if (errorMessage.contains('cnic') || errorMessage.contains('CNIC')) {
          errorMessage = 'A customer with CNIC "${customerCnicController.text}" already exists in the database. '
                         'Please either:\n'
                         '• Use the existing customer (search in step 2), or\n'
                         '• Enter a different CNIC number for this new customer.';
        } else {
          errorMessage = 'This customer information already exists in the database. Please check if the customer is already registered or use different details.';
        }
      } else if (errorMessage.contains('LateInitialization') || 
          errorMessage.contains('has not been initialized')) {
        title = 'Sale Failed - Missing Data';
        
        // Identify which field
        if (errorMessage.contains('cashSalePrice')) {
          errorMessage = 'The selected bike does not have a price configured. Please select a different bike or contact the administrator.';
        } else if (errorMessage.contains('fullName') || errorMessage.contains('cnicNumber') || errorMessage.contains('phoneNumber')) {
          errorMessage = 'Customer information is incomplete. Please fill all required fields (Name, CNIC, Phone).';
        } else {
          final errorStr = e.toString();
          errorMessage = 'Some required data is missing. Please ensure all fields are filled. Error: ${errorStr.length > 100 ? errorStr.substring(0, 100) : errorStr}';
        }
      } else if (errorMessage.contains('Invalid') || errorMessage.contains('null')) {
        title = 'Sale Failed - Invalid Data';
        errorMessage = 'Some data is invalid. Please check all fields and try again.';
      } else if (errorMessage.contains('Isar') || errorMessage.contains('database')) {
        title = 'Sale Failed - Database Error';
        // Provide more details in the error message
        final errorDetails = errorMessage.length > 200 ? errorMessage.substring(0, 200) + '...' : errorMessage;
        errorMessage = 'A database error occurred while saving the sale.\n\n'
                       'Details: $errorDetails\n\n'
                       'Please try again or contact support if the problem persists.';
      } else {
        // Generic error with more details
        title = 'Sale Failed';
        errorMessage = 'Could not complete the sale. Error: ${errorMessage.length > 150 ? errorMessage.substring(0, 150) + '...' : errorMessage}';
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
  Widget _buildSuccessDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade900,
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
}
// Removed duplicate SaleType Enum
