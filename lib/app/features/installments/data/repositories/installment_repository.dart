import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/investment/domain/investment_service.dart';
import 'package:tahir_showroom/app/features/investment/presentation/controllers/investment_controller.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull

import 'package:tahir_showroom/app/core/services/isar_service.dart';

/// Repository for managing installment contracts and payments
class InstallmentRepository {
  Isar get _isar => Get.find<IsarService>().isar;

  InstallmentRepository();

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

  /// Get ALL contracts (active + completed + defaulted)
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
        final previousTotalPaid = contract.totalPaid;
        contract.totalPaid += amount;
        contract.paymentsMade += 1;
        contract.lastPaymentDate = payment.paymentDate;
        
        // Update status based on payment
        if (contract.totalPaid >= contract.totalAmount) {
          contract.status = ContractStatusEnum.completed;
          contract.months = contract.paymentsMade; // Adjust duration for early completion
          contract.nextDueDate = null;
        } else if (contract.totalPaid > 0) {
          contract.status = ContractStatusEnum.partiallyPaid;
        }

        // Calculate next due date
        if (contract.status != ContractStatusEnum.completed) {
          contract.nextDueDate = _calculateNextDueDate(contract);
        }

        await _isar.installmentContracts.put(contract);

        // === INVESTMENT TRACKING: Record installment payment revenue ===
        if (Get.isRegistered<InvestmentService>()) {
          try {
            final investmentService = Get.find<InvestmentService>();
            final bike = await _isar.bikes.get(contract.bikeId);
            await investmentService.recordInstallmentPaymentRevenue(
              contractId: contractId,
              amount: amount,
              bikeId: contract.bikeId,
              previousTotalPaid: previousTotalPaid,
              purchasePrice: bike?.purchasePrice ?? 0.0,
              description: bike != null
                  ? 'Monthly Payment \u2014 ${bike.model} ${bike.brand}'
                  : 'Monthly Payment \u2014 Contract #$contractId',
              inTransaction: true,
            );
            // Profit is now finalized continuously inside recordInstallmentPaymentRevenue
          } catch (e) {
            debugPrint('InvestmentService payment recording warning: $e');
          }
        }

        // Refresh investment KPIs
        _refreshInvestmentKPIs();
      }
    });
  }

  /// Admin manually completes a contract (Paid vs Waived)
  Future<void> adminCompleteContract({
    required int contractId,
    required bool allPaymentReceived,
  }) async {
    await _isar.writeTxn(() async {
      final contract = await _isar.installmentContracts.get(contractId);
      if (contract == null) return;
      
      final previousTotalPaid = contract.totalPaid;

      if (allPaymentReceived) {
        // Record remaining as a final payment
        final remaining = contract.totalAmount - contract.totalPaid;
        if (remaining > 0) {
          final payment = Payment()
            ..contractId = contractId
            ..amount = remaining
            ..method = PaymentMethod.cash
            ..notes = 'Final payment (Admin completed)'
            ..paymentDate = DateTime.now();
          await _isar.payments.put(payment);
          contract.totalPaid = contract.totalAmount;
          contract.paymentsMade += 1;

          // === INVESTMENT TRACKING: Record final payment as revenue ===
          if (Get.isRegistered<InvestmentService>()) {
            try {
              final investmentService = Get.find<InvestmentService>();
              final bike = await _isar.bikes.get(contract.bikeId);
              await investmentService.recordInstallmentPaymentRevenue(
                contractId: contractId,
                amount: remaining,
                bikeId: contract.bikeId,
                previousTotalPaid: previousTotalPaid,
                purchasePrice: bike?.purchasePrice ?? 0.0,
                description: bike != null
                    ? 'Final Payment (Admin) \u2014 ${bike.model} ${bike.brand}'
                    : 'Final Payment (Admin) \u2014 Contract #$contractId',
                inTransaction: true,
              );
            } catch (e) {
              debugPrint('InvestmentService admin-complete revenue recording warning: $e');
            }
          }
        }
      } else {
        // Waive remaining → don't add to revenue
        contract.isWaived = true;
      }

      contract.status = ContractStatusEnum.completed;
      contract.months = contract.paymentsMade;
      contract.nextDueDate = null;
      contract.lastPaymentDate = DateTime.now();

      await _isar.installmentContracts.put(contract);
      // Profit is now finalized continuously inside recordInstallmentPaymentRevenue
      
      // Refresh investment KPIs
      _refreshInvestmentKPIs();
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
    debugPrint('Starting Legacy Data Repair...');
    try {
      await _isar.writeTxn(() async {
        // 1. Check ALL contracts to avoid filter issues
        final allContracts = await _isar.installmentContracts.where().findAll();
        debugPrint('Found ${allContracts.length} contracts to check.');

        int fixedCount = 0;

        for (final contract in allContracts) {
          // Check if down payment is 0 or missing (ONLY apply to legacy contracts created before a certain date)
          // 0 down payment is a valid business case for new contracts!
          if (contract.downPayment <= 0 && contract.contractDate.isBefore(DateTime(2025, 3, 1))) {
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
                debugPrint('Fixing Contract #${contract.id}: Found 0 down payment. Using payment #${validPayment.id} of ${validPayment.amount}');
                
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
                  debugPrint('  - Marked Payment #${validPayment.id} as Down Payment');
                }
              } else {
                 debugPrint('Skipping Contract #${contract.id}: No valid (>0) payments found.');
              }
            } else {
               debugPrint('Skipping Contract #${contract.id}: No payments found.');
            }
          }
        }
        // 1.5 Auto-fix accidentally hijacked first payments on 0-down plans
        final accidentalRepairs = await _isar.payments
            .filter()
            .notesEqualTo('Down Payment (Repaired)')
            .findAll();
            
        int restoredCount = 0;
        for (final payment in accidentalRepairs) {
           final contract = await _isar.installmentContracts.get(payment.contractId);
           if (contract != null && contract.contractDate.isAfter(DateTime(2025, 3, 1))) {
              payment.isDownPayment = false;
              payment.notes = 'Restored Payment'; // Clear the buggy note
              contract.downPayment = 0; // Reset it to valid 0 down payment
              await _isar.payments.put(payment);
              await _isar.installmentContracts.put(contract);
              restoredCount++;
           }
        }
        if (restoredCount > 0) debugPrint('Restored $restoredCount accidentally repaired down payments');

        debugPrint('Legacy Repair Complete. Fixed $fixedCount contracts.');
      });
      
      // Run the Rounding & Overpayment Fix
      await fixOverpaymentAndRounding();
      
    } catch (e) {
      debugPrint('Error in legacy repair: $e');
    }
  }

  /// Fixes rounding issues (EMI to nearest 50) and recalculates totals/counts
  Future<void> fixOverpaymentAndRounding() async {
    try {
      debugPrint('Starting Rounding & Overpayment Fix...');
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
            debugPrint('Fixing Contract #${contract.id} EMI: $currentEMI -> $roundedEMI');
            contract.monthlyEMI = roundedEMI;
            
            // Recalculate Grand Total based on new EMI
            // Total = DownPayment + (EMI * Months)
            double newTotal = contract.downPayment + (roundedEMI * contract.months);
            if (newTotal != contract.totalAmount) {
               debugPrint('  - Updated Total Amount: ${contract.totalAmount} -> $newTotal');
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
             debugPrint('Fixing Contract #${contract.id} Counts:');
             debugPrint('  - TotalPaid: ${contract.totalPaid} -> $validTotalPaid');
             debugPrint('  - PaymentsMade: ${contract.paymentsMade} -> $installmentCount');
             
             contract.totalPaid = validTotalPaid;
             contract.paymentsMade = installmentCount;
             changed = true;
          }
          
          // 3. Update Remaining Balance & Status
          double remaining = contract.totalAmount - contract.totalPaid;
          if (remaining < 0) remaining = 0; // Handle overpayment
          

          
          // Check Completion
          if (remaining <= 0) {
             debugPrint('  - marking as COMPLETED (Balance 0)');
             contract.status = ContractStatusEnum.completed;
             contract.months = contract.paymentsMade; // Adjust duration
             contract.nextDueDate = null;
             changed = true;
          }
          
          if (changed) {
            await _isar.installmentContracts.put(contract);
            fixedCount++;
          }
        }
      });
      
      debugPrint('Rounding & Overpayment Fix Complete. Updated $fixedCount contracts.');
      
    } catch (e) {
      debugPrint('Error in Rounding/Overpayment fix: $e');
    }
  }

  /// Refresh investment controller KPIs if registered
  void _refreshInvestmentKPIs() {
    if (Get.isRegistered<InvestmentController>()) {
      try {
        Get.find<InvestmentController>().loadInvestmentData();
      } catch (_) {}
    }
  }
}
