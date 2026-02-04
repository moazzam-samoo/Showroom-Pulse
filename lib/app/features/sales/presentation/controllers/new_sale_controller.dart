import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/utils/installment_calculator.dart';
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
    if (selectedBike.value == null) {
      Get.snackbar('Error', 'Please select a bike');
      return;
    }

    // 1. Prepare Customer
    // TODO: Handle search existing vs create new properly
    // For now, assuming NEW customer or validation
    // Simple validation
    /*
    if (isNewCustomer.value) {
       // Check inputs
    }
    */

    try {
      await _isarService.isar.writeTxn(() async {
        // A. Create/Get Customer
        final customer = Customer()
          ..fullName = customerNameController.text
          ..fatherName = customerFatherNameController.text.isNotEmpty 
              ? customerFatherNameController.text 
              : null
          ..cnicNumber = customerCnicController.text 
          ..phoneNumber = customerPhoneController.text
          ..address = customerAddressController.text
          ..dateRegistered = DateTime.now();
        
        await _isarService.isar.customers.put(customer);

        // B. Update Bike Status
        final bike = selectedBike.value!;
        // Fixed: Use BikeStatusEnum
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
             ..cashPrice = bike.cashSalePrice ?? 0
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

        // E. Create Initial Payment Record
        final payment = Payment()
          ..amount = sale.receivedAmount
          ..paymentDate = DateTime.now() // Fixed: date -> paymentDate
          ..notes = saleType.value == SaleType.cash ? 'Full Cash Payment' : 'Down Payment';
          // ..contractId = ... (if needed)

        await _isarService.isar.payments.put(payment);
      });

      Get.snackbar('Success', 'Sale recorded successfully!');
      Get.back(); // Return to dashboard
    } catch (e) {
      Get.snackbar('Error', 'Failed to process sale: $e');
      print(e);
    }
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
