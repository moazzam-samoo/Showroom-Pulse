import 'package:isar/isar.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/witness.dart';

/// Data class for customer with aggregated transaction data
class CustomerWithTransactions {
  final Customer customer;
  final List<TransactionRecord> transactions;
  final int totalTransactions;
  final double pendingAmount;
  final DateTime? lastPurchaseDate;

  CustomerWithTransactions({
    required this.customer,
    required this.transactions,
    required this.totalTransactions,
    required this.pendingAmount,
    this.lastPurchaseDate,
  });

  /// Get initials for avatar
  String get initials {
    final cleanName = customer.fullName.trim();
    if (cleanName.isEmpty) return '??';
    
    final parts = cleanName.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    
    return cleanName.substring(0, cleanName.length >= 2 ? 2 : 1).toUpperCase();
  }
}

/// Data class for a single transaction record
class TransactionRecord {
  final Sale sale;
  final Bike bike;
  final InstallmentContract? contract;
  final List<Payment> payments;
  final String? witnessName;
  final String? witnessId;
  final String? witnessPhone;
  final String? witnessAddress;

  final List<Witness> witnesses;

  TransactionRecord({
    required this.sale,
    required this.bike,
    this.contract,
    this.payments = const [],
    this.witnessName,
    this.witnessId,
    this.witnessPhone,
    this.witnessAddress,
    this.witnesses = const [],
  });

  bool get isInstallment => sale.saleType == SaleType.installment;
  
  String get statusText {
    if (!isInstallment) return 'Paid';
    if (contract == null) return 'Unknown';
    switch (contract!.status) {
      case ContractStatusEnum.active:
        return 'Active Installment';
      case ContractStatusEnum.partiallyPaid:
        return 'Partially Paid';
      case ContractStatusEnum.overdue:
        return 'Overdue';
      case ContractStatusEnum.completed:
        return 'Completed';
      case ContractStatusEnum.defaulted:
        return 'Defaulted';
    }
  }

  double get pendingAmount {
    if (!isInstallment || contract == null) return 0;
    return contract!.remainingBalance;
  }
}

/// Repository for customer data with aggregations
class CustomerRepository {
  Isar get _isar => Get.find<IsarService>().isar;

  CustomerRepository();

  /// Get all customers with their transaction summaries
  Future<List<CustomerWithTransactions>> getAllCustomersWithTransactions({
    String? searchQuery,
    bool sortByDateDesc = true,
    bool sortByPriceDesc = false,
  }) async {
    // Get all customers
    var customers = await _isar.customers.where().findAll();

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Normalize query: remove non-digit characters for flexible matching
      final normalizedQuery = searchQuery.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '').toLowerCase();
      final query = searchQuery.toLowerCase();
      
      customers = customers.where((c) {
        final matchesName = c.fullName.toLowerCase().contains(query);
        
        // Normalize stored CNIC and Phone for comparison if query looks like number
        final normalizedCnic = c.cnicNumber.replaceAll(RegExp(r'[^0-9]'), '');
        final matchesCnic = c.cnicNumber.contains(query) || normalizedCnic.contains(normalizedQuery);
        
        final normalizedPhone = c.phoneNumber.replaceAll(RegExp(r'[^0-9]'), ''); 
        final matchesPhone = c.phoneNumber.contains(query) || normalizedPhone.contains(normalizedQuery);
        
        return matchesName || matchesCnic || matchesPhone;
      }).toList();
    }

    // Build customer data with transactions
    final result = <CustomerWithTransactions>[];
    
    for (final customer in customers) {
      final sales = await _isar.sales
          .filter()
          .customerIdEqualTo(customer.id)
          .sortBySaleDateDesc()
          .findAll();

      double pendingAmount = 0;
      DateTime? lastPurchaseDate;
      final transactions = <TransactionRecord>[];

      for (final sale in sales) {
        // Get the bike
        final bike = await _isar.bikes.get(sale.bikeId);
        if (bike == null) continue;

        // Update last purchase date
        if (lastPurchaseDate == null || sale.saleDate.isAfter(lastPurchaseDate)) {
          lastPurchaseDate = sale.saleDate;
        }

        // Get contract and payments for installments
        InstallmentContract? contract;
        List<Payment> payments = [];

        if (sale.saleType == SaleType.installment && sale.installmentContractId != null) {
          contract = await _isar.installmentContracts.get(sale.installmentContractId!);
          if (contract != null) {
            pendingAmount += contract.remainingBalance;
            payments = await _isar.payments
                .filter()
                .contractIdEqualTo(contract.id)
                .sortByPaymentDateDesc()
                .findAll();
            
            // Fetch all witnesses
            final witnesses = await _isar.witness
                .filter()
                .contractIdEqualTo(contract.id)
                .findAll();
                
            final primaryWitness = witnesses.isNotEmpty 
                ? (witnesses.firstWhereOrNull((w) => w.isPrimary) ?? witnesses.first)
                : null;

             transactions.add(TransactionRecord(
              sale: sale,
              bike: bike,
              contract: contract,
              payments: payments,
              witnesses: witnesses,
              witnessName: primaryWitness?.fullName ?? 'N/A',
              witnessId: primaryWitness?.cnicNumber,
              witnessPhone: primaryWitness?.phoneNumber,
              witnessAddress: primaryWitness?.address,
            ));
            continue; // Skip the default add below
          }
        }

        // For cash sales, fetch witnesses too
        final witnesses = await _isar.witness
            .filter()
            .contractIdEqualTo(-sale.id) // Negative ID for cash sales
            .findAll();

        final primaryWitness = witnesses.isNotEmpty 
            ? (witnesses.firstWhereOrNull((w) => w.isPrimary) ?? witnesses.first)
            : null;

        transactions.add(TransactionRecord(
          sale: sale,
          bike: bike,
          contract: contract,
          payments: payments,
          witnesses: witnesses,
          witnessName: primaryWitness?.fullName ?? 'N/A',
          witnessId: primaryWitness?.cnicNumber,
          witnessPhone: primaryWitness?.phoneNumber,
          witnessAddress: primaryWitness?.address,
        ));
      }

      result.add(CustomerWithTransactions(
        customer: customer,
        transactions: transactions,
        totalTransactions: sales.length,
        pendingAmount: pendingAmount,
        lastPurchaseDate: lastPurchaseDate,
      ));
    }

    // Sort by last purchase date (primary) and pending amount (secondary)
    result.sort((a, b) {
      if (sortByDateDesc) {
        final dateCompare = (b.lastPurchaseDate ?? DateTime(1970))
            .compareTo(a.lastPurchaseDate ?? DateTime(1970));
        if (dateCompare != 0) return dateCompare;
      }
      if (sortByPriceDesc) {
        return b.pendingAmount.compareTo(a.pendingAmount);
      }
      return 0;
    });

    return result;
  }

  /// Get total customer count
  Future<int> getTotalCustomerCount() async {
    return await _isar.customers.count();
  }

  /// Get active installments count and total value
  Future<Map<String, dynamic>> getActiveInstallmentsStats() async {
    final contracts = await _isar.installmentContracts
        .filter()
        .statusEqualTo(ContractStatusEnum.active)
        .or()
        .statusEqualTo(ContractStatusEnum.partiallyPaid)
        .findAll();

    double totalValue = 0;
    for (final contract in contracts) {
      totalValue += contract.totalAmount;
    }

    return {
      'count': contracts.length,
      'totalValue': totalValue,
    };
  }

  /// Get pending payments stats
  Future<Map<String, dynamic>> getPendingPaymentsStats() async {
    final contracts = await _isar.installmentContracts
        .filter()
        .statusEqualTo(ContractStatusEnum.active)
        .or()
        .statusEqualTo(ContractStatusEnum.partiallyPaid)
        .or()
        .statusEqualTo(ContractStatusEnum.overdue)
        .findAll();

    double dueSoon = 0;
    int pendingCount = 0;
    final now = DateTime.now();
    final weekLater = now.add(const Duration(days: 7));

    for (final contract in contracts) {
      if (contract.nextDueDate != null) {
        if (contract.nextDueDate!.isBefore(weekLater)) {
          dueSoon += contract.monthlyEMI;
          pendingCount++;
        }
      }
    }

    return {
      'count': pendingCount,
      'dueSoon': dueSoon,
    };
  }

  /// Get customer growth percentage (compared to last month)
  Future<double> getCustomerGrowthPercentage() async {
    final now = DateTime.now();
    final startOfThisMonth = DateTime(now.year, now.month, 1);
    final startOfLastMonth = DateTime(now.year, now.month - 1, 1);

    final thisMonthCount = await _isar.customers
        .filter()
        .dateRegisteredGreaterThan(startOfThisMonth)
        .count();

    final lastMonthCount = await _isar.customers
        .filter()
        .dateRegisteredBetween(startOfLastMonth, startOfThisMonth)
        .count();

    if (lastMonthCount == 0) return thisMonthCount > 0 ? 100.0 : 0.0;
    return ((thisMonthCount - lastMonthCount) / lastMonthCount * 100);
  }
  /// Add a new customer
  Future<int> addCustomer({
    required String fullName,
    required String cnicNumber,
    required String phoneNumber,
    String? fatherName,
    String? address,
    String? profileImageFilename,
    String? cnicFrontFilename,
    String? cnicBackFilename,
  }) async {
    final customer = Customer()
      ..fullName = fullName
      ..cnicNumber = cnicNumber
      ..phoneNumber = phoneNumber
      ..fatherName = fatherName
      ..address = address
      ..profileImageFilename = profileImageFilename
      ..cnicFrontFilename = cnicFrontFilename
      ..cnicBackFilename = cnicBackFilename
      ..dateRegistered = DateTime.now();

    // Check if customer with same CNIC exists
    final existing = await _isar.customers.filter().cnicNumberEqualTo(cnicNumber).findFirst();
    if (existing != null) {
      throw Exception('Customer with CNIC $cnicNumber already exists');
    }

    return await _isar.writeTxn(() async {
      return await _isar.customers.put(customer);
    });
  }

  /// Update an existing customer
  Future<void> updateCustomer(Customer customer) async {
    // Check if another customer with same CNIC exists (excluding self)
    final existingList = await _isar.customers
        .filter()
        .cnicNumberEqualTo(customer.cnicNumber)
        .findAll();
        
    final existing = existingList.firstWhereOrNull((c) => c.id != customer.id);
        
    if (existing != null) {
      throw Exception('Another customer with CNIC ${customer.cnicNumber} already exists');
    }

    await _isar.writeTxn(() async {
      await _isar.customers.put(customer);
    });
  }

  /// Check if customer can be deleted (no sales/installments)
  Future<bool> canDeleteCustomer(int id) async {
    final saleCount = await _isar.sales.filter().customerIdEqualTo(id).count();
    return saleCount == 0;
  }

  /// Delete a customer
  Future<void> deleteCustomer(int id) async {
    if (!await canDeleteCustomer(id)) {
      throw Exception('Cannot delete customer with existing sales history');
    }

    await _isar.writeTxn(() async {
      await _isar.customers.delete(id);
    });
  }

  /// Delete customer and ALL associated transaction history
  Future<void> deleteCustomerWithHistory(int customerId) async {
    await _isar.writeTxn(() async {
      // 1. Get all sales for this customer
      final sales = await _isar.sales.filter().customerIdEqualTo(customerId).findAll();
      
      for (final sale in sales) {
        // 2. Handle installments data
        if (sale.saleType == SaleType.installment && sale.installmentContractId != null) {
          // Delete all payments for this contract
          await _isar.payments.filter()
              .contractIdEqualTo(sale.installmentContractId!)
              .deleteAll();
          
          // Delete the contract itself
          await _isar.installmentContracts.delete(sale.installmentContractId!);
          
          // Delete witnesses linked to contract
          await _isar.witness.filter()
              .contractIdEqualTo(sale.installmentContractId!)
              .deleteAll();
        } else {
          // 3. Handle cash sale witnesses (negated IDs)
          await _isar.witness.filter()
              .contractIdEqualTo(-sale.id)
              .deleteAll();
        }
      }

      // 4. Delete all sales records
      await _isar.sales.filter().customerIdEqualTo(customerId).deleteAll();

      // 5. Delete the customer record
      await _isar.customers.delete(customerId);
    });
  }
}

// Authored by: Moazzam Samoo
