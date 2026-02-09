import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';

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
}

// Authored by: Moazzam Samoo
