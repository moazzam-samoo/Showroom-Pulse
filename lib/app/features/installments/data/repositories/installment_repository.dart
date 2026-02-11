import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull

/// Repository for managing installment contracts and payments
class InstallmentRepository {
  final Isar _isar;

  InstallmentRepository(this._isar);

  // ==================== CONTRACT QUERIES ====================

  /// Get all active installment contracts
  Future<List<InstallmentContract>> getActiveContracts() async {
    return await _isar.installmentContracts
        .filter()
        .statusEqualTo(ContractStatusEnum.active)
        .or()
        .statusEqualTo(ContractStatusEnum.partiallyPaid)
        .or()
        .statusEqualTo(ContractStatusEnum.overdue)
        .findAll();
  }

  /// Get all contracts (for display purposes)
  Future<List<InstallmentContract>> getAllContracts() async {
    return await _isar.installmentContracts.where().findAll();
  }

  /// Get contracts by status
  Future<List<InstallmentContract>> getContractsByStatus(ContractStatusEnum status) async {
    return await _isar.installmentContracts
        .filter()
        .statusEqualTo(status)
        .findAll();
  }

  /// Get contracts due within N days
  Future<List<InstallmentContract>> getContractsDueSoon(int days) async {
    final now = DateTime.now();
    final deadline = now.add(Duration(days: days));
    
    return await _isar.installmentContracts
        .filter()
        .nextDueDateIsNotNull()
        .nextDueDateBetween(now, deadline)
        .statusEqualTo(ContractStatusEnum.active)
        .or()
        .statusEqualTo(ContractStatusEnum.partiallyPaid)
        .findAll();
  }

  /// Get overdue contracts
  Future<List<InstallmentContract>> getOverdueContracts() async {
    final now = DateTime.now();
    
    return await _isar.installmentContracts
        .filter()
        .nextDueDateIsNotNull()
        .nextDueDateLessThan(now)
        .not()
        .statusEqualTo(ContractStatusEnum.completed)
        .not()
        .statusEqualTo(ContractStatusEnum.defaulted)
        .findAll();
  }

  /// Get contract by ID
  Future<InstallmentContract?> getContractById(int id) async {
    return await _isar.installmentContracts.get(id);
  }

  // ==================== PAYMENT QUERIES ====================

  /// Get all payments for a contract
  Future<List<Payment>> getPaymentsForContract(int contractId) async {
    return await _isar.payments
        .filter()
        .contractIdEqualTo(contractId)
        .sortByPaymentDateDesc()
        .findAll();
  }

  /// Get total payments count for a contract
  Future<int> getPaymentsCount(int contractId) async {
    return await _isar.payments
        .filter()
        .contractIdEqualTo(contractId)
        .count();
  }

  // ==================== CUSTOMER & BIKE DATA ====================

  /// Get customer for a contract
  Future<Customer?> getCustomerForContract(InstallmentContract contract) async {
    return await _isar.customers.get(contract.customerId);
  }

  /// Get bike for a contract
  Future<Bike?> getBikeForContract(InstallmentContract contract) async {
    return await _isar.bikes.get(contract.bikeId);
  }

  // ==================== PAYMENT RECORDING ====================

  /// Record a new payment for a contract
  Future<void> recordPayment({
    required int contractId,
    required double amount,
    required PaymentMethod method,
    String? collectorName,
    String? notes,
    DateTime? paymentDate,
  }) async {
    await _isar.writeTxn(() async {
      // Create payment record
      final payment = Payment()
        ..contractId = contractId
        ..amount = amount
        ..method = method
        ..collectorName = collectorName
        ..notes = notes
        ..paymentDate = paymentDate ?? DateTime.now();

      await _isar.payments.put(payment);

      // Update contract
      final contract = await _isar.installmentContracts.get(contractId);
      if (contract != null) {
        contract.totalPaid += amount;
        contract.paymentsMade += 1;
        contract.lastPaymentDate = payment.paymentDate;
        
        // Update status based on payment
        if (contract.totalPaid >= contract.totalAmount) {
          contract.status = ContractStatusEnum.completed;
        } else if (contract.totalPaid > 0) {
          contract.status = ContractStatusEnum.partiallyPaid;
        }

        // Calculate next due date
        if (contract.status != ContractStatusEnum.completed) {
          contract.nextDueDate = _calculateNextDueDate(contract);
        } else {
          contract.nextDueDate = null;
        }

        await _isar.installmentContracts.put(contract);
      }
    });
  }

  /// Calculate next due date based on contract terms
  DateTime _calculateNextDueDate(InstallmentContract contract) {
    final lastPayment = contract.lastPaymentDate ?? contract.contractDate;
    final nextMonth = DateTime(
      lastPayment.year,
      lastPayment.month + 1,
      contract.dayOfMonth,
    );
    return nextMonth;
  }

  // ==================== STATUS UPDATES ====================

  /// Update contract status
  Future<void> updateContractStatus(int contractId, ContractStatusEnum status) async {
    await _isar.writeTxn(() async {
      final contract = await _isar.installmentContracts.get(contractId);
      if (contract != null) {
        contract.status = status;
        await _isar.installmentContracts.put(contract);
      }
    });
  }

  /// Check and update overdue contracts
  Future<void> updateOverdueContracts() async {
    final now = DateTime.now();
    
    await _isar.writeTxn(() async {
      final contracts = await _isar.installmentContracts
          .filter()
          .nextDueDateIsNotNull()
          .nextDueDateLessThan(now)
          .not()
          .statusEqualTo(ContractStatusEnum.completed)
          .not()
          .statusEqualTo(ContractStatusEnum.defaulted)
          .not()
          .statusEqualTo(ContractStatusEnum.overdue)
          .findAll();

      for (final contract in contracts) {
        contract.status = ContractStatusEnum.overdue;
        await _isar.installmentContracts.put(contract);
      }
    });
  }

  // ==================== DATA REPAIR ====================

  /// Repair legacy data (aggressive fix for missing down payments)
  Future<void> repairLegacyData() async {
    print('Starting Legacy Data Repair...');
    try {
      await _isar.writeTxn(() async {
        // 1. Check ALL contracts to avoid filter issues
        final allContracts = await _isar.installmentContracts.where().findAll();
        print('Found ${allContracts.length} contracts to check.');

        int fixedCount = 0;

        for (final contract in allContracts) {
          // Check if down payment is 0 or missing
          if (contract.downPayment <= 0) {
            // Find payments for this contract
            final payments = await _isar.payments
                .filter()
                .contractIdEqualTo(contract.id)
                .sortByPaymentDate() // Get earliest first
                .findAll();

            if (payments.isNotEmpty) {
              // Find first payment with amount > 0
              final validPayment = payments.firstWhereOrNull((p) => p.amount > 0);
              
              if (validPayment != null) {
                print('Fixing Contract #${contract.id}: Found 0 down payment. Using payment #${validPayment.id} of ${validPayment.amount}');
                
                // Update Contract
                contract.downPayment = validPayment.amount;
                await _isar.installmentContracts.put(contract);
                fixedCount++;

                // Update Payment visibility
                if (!validPayment.isDownPayment) {
                  validPayment.isDownPayment = true;
                  if (validPayment.notes == null || validPayment.notes!.isEmpty || validPayment.notes == 'Purchase') {
                     validPayment.notes = 'Down Payment (Repaired)';
                  }
                  await _isar.payments.put(validPayment);
                  print('  - Marked Payment #${validPayment.id} as Down Payment');
                }
              } else {
                 print('Skipping Contract #${contract.id}: No valid (>0) payments found.');
              }
            } else {
               print('Skipping Contract #${contract.id}: No payments found.');
            }
          }
        }
        print('Legacy Repair Complete. Fixed $fixedCount contracts.');
      });
      
      // Run the Rounding & Overpayment Fix
      await fixOverpaymentAndRounding();
      
    } catch (e) {
      print('Error in legacy repair: $e');
    }
  }

  /// Fixes rounding issues (EMI to nearest 50) and recalculates totals/counts
  Future<void> fixOverpaymentAndRounding() async {
    try {
      print('Starting Rounding & Overpayment Fix...');
      int fixedCount = 0;
      
      final contracts = await _isar.installmentContracts
          .filter()
          .statusEqualTo(ContractStatusEnum.active)
          .or()
          .statusEqualTo(ContractStatusEnum.partiallyPaid)
          .or()
          .statusEqualTo(ContractStatusEnum.overdue)
          .findAll();
          
      await _isar.writeTxn(() async {
        for (var contract in contracts) {
          bool changed = false;
          
          // 1. Fix Rounding (EMI)
          // Round existing EMI to nearest 50
          double currentEMI = contract.monthlyEMI;
          double roundedEMI = (currentEMI / 50).ceil() * 50.0;
          
          if (roundedEMI != currentEMI) {
            print('Fixing Contract #${contract.id} EMI: $currentEMI -> $roundedEMI');
            contract.monthlyEMI = roundedEMI;
            
            // Recalculate Grand Total based on new EMI
            // Total = DownPayment + (EMI * Months)
            double newTotal = contract.downPayment + (roundedEMI * contract.months);
            if (newTotal != contract.totalAmount) {
               print('  - Updated Total Amount: ${contract.totalAmount} -> $newTotal');
               contract.totalAmount = newTotal;
            }
            changed = true;
          }
          
          // 2. Fix Counts & Totals (13/12 Issue)
          final payments = await _isar.payments
              .filter()
              .contractIdEqualTo(contract.id)
              .findAll();
              
          // Calculate true totals from payment records
          double validTotalPaid = payments.fold(0, (sum, p) => sum + p.amount);
          
          // Count only INSTALLMENT payments (exclude down payment)
          int installmentCount = payments.where((p) => !p.isDownPayment).length;
          
          if (contract.totalPaid != validTotalPaid || contract.paymentsMade != installmentCount) {
             print('Fixing Contract #${contract.id} Counts:');
             print('  - TotalPaid: ${contract.totalPaid} -> $validTotalPaid');
             print('  - PaymentsMade: ${contract.paymentsMade} -> $installmentCount');
             
             contract.totalPaid = validTotalPaid;
             contract.paymentsMade = installmentCount;
             changed = true;
          }
          
          // 3. Update Remaining Balance & Status
          double remaining = contract.totalAmount - contract.totalPaid;
          if (remaining < 0) remaining = 0; // Handle overpayment
          

          
          // Check Completion
          if (remaining <= 0) {
             print('  - marking as COMPLETED (Balance 0)');
             contract.status = ContractStatusEnum.completed;
             changed = true;
          }
          
          if (changed) {
            await _isar.installmentContracts.put(contract);
            fixedCount++;
          }
        }
      });
      
      print('Rounding & Overpayment Fix Complete. Updated $fixedCount contracts.');
      
    } catch (e) {
      print('Error in Rounding/Overpayment fix: $e');
    }
  }
}
