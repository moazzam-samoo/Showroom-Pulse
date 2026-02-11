import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';

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
    final parts = customer.fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return customer.fullName.substring(0, 2).toUpperCase();
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

  TransactionRecord({
    required this.sale,
    required this.bike,
    this.contract,
    this.payments = const [],
    this.witnessName,
    this.witnessId,
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
  final Isar _isar;

  CustomerRepository(this._isar);

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
      final query = searchQuery.toLowerCase();
      customers = customers.where((c) =>
          c.fullName.toLowerCase().contains(query) ||
          c.cnicNumber.contains(query) ||
          c.phoneNumber.contains(query)).toList();
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
          }
        }

        transactions.add(TransactionRecord(
          sale: sale,
          bike: bike,
          contract: contract,
          payments: payments,
          witnessName: 'N/A', // TODO: Add witness model
          witnessId: null,
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
}

// Authored by: Moazzam Samoo
