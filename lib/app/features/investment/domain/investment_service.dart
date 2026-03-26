import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/data/models/investment.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/purchase_batch.dart';

class InvestmentService extends GetxService {
  late Isar _isar;

  @override
  void onInit() {
    super.onInit();
    _isar = Get.find<IsarService>().isar;
  }

  // ==================== CAPITAL OPERATIONS ====================

  /// Record a new capital injection
  Future<Investment> addCapitalInvestment({
    required double amount,
    required DateTime date,
    InvestmentCategoryEnum category = InvestmentCategoryEnum.personalCapital,
    String? description,
    bool isLocked = false,
  }) async {
    final inv = Investment()
      ..amount = amount
      ..date = date
      ..type = InvestmentTypeEnum.capitalInjection
      ..category = category
      ..description = description
      ..isLocked = isLocked;

    await _isar.writeTxn(() async {
      await _isar.investments.put(inv);
    });
    return inv;
  }

  /// Record money spent on a single specific bike purchase
  Future<Investment> recordBikePurchaseInvestment({
    required double amount,
    required DateTime date,
    required int bikeId,
    String? description,
  }) async {
    final inv = Investment()
      ..amount = amount
      ..date = date
      ..type = InvestmentTypeEnum.bikePurchase
      ..category = InvestmentCategoryEnum.other
      ..bikeId = bikeId
      ..description = description ?? 'Investment allocated to bike ID: $bikeId';

    await _isar.writeTxn(() async {
      await _isar.investments.put(inv);
    });
    return inv;
  }

  /// Remove investment record associated with a specific bike (Refund)
  /// Handles both individual bike purchases and bikes belonging to a dealer batch.
  Future<void> removeBikePurchaseInvestment(Bike bike) async {
    await _isar.writeTxn(() async {
      // 1. Try deleting individual bike record first
      final deletedCount = await _isar.investments
          .filter()
          .typeEqualTo(InvestmentTypeEnum.bikePurchase)
          .bikeIdEqualTo(bike.id)
          .deleteAll();

      // 2. If not found as individual, check if it belongs to a batch
      if (deletedCount == 0) {
        await bike.batch.load();
        if (bike.batch.value != null) {
          final batchId = bike.batch.value!.id;
          // Find the investment record for this batch
          final batchInv = await _isar.investments
              .filter()
              .typeEqualTo(InvestmentTypeEnum.bikePurchase)
              .purchaseBatchIdEqualTo(batchId)
              .findFirst();

          if (batchInv != null) {
            // Subtract this bike's price from the batch investment
            batchInv.amount -= bike.purchasePrice;
            
            if (batchInv.amount <= 0) {
              await _isar.investments.delete(batchInv.id);
            } else {
              // Update the batch investment record with remaining amount
              await _isar.investments.put(batchInv);
            }
          }
        }
      }
    });
  }

  /// Record money spent on a dealer batch purchase
  Future<Investment> recordBatchPurchaseInvestment({
    required double amount,
    required DateTime date,
    required int batchId,
    String? description,
  }) async {
    final inv = Investment()
      ..amount = amount
      ..date = date
      ..type = InvestmentTypeEnum.bikePurchase
      ..category = InvestmentCategoryEnum.other
      ..purchaseBatchId = batchId
      ..description = description ?? 'Investment allocated to batch ID: $batchId';

    await _isar.writeTxn(() async {
      await _isar.investments.put(inv);
    });
    return inv;
  }

  /// Record a withdrawal
  Future<Investment> recordWithdrawal({
    required double amount,
    required DateTime date,
    String? description,
  }) async {
    final inv = Investment()
      ..amount = amount
      ..date = date
      ..type = InvestmentTypeEnum.withdrawal
      ..category = InvestmentCategoryEnum.other
      ..description = description ?? 'Capital withdrawal';

    await _isar.writeTxn(() async {
      await _isar.investments.put(inv);
    });
    return inv;
  }

  /// Finds and removes investment records linked to bikes or batches
  /// that no longer exist in the database (retroactive cleanup).
  Future<void> cleanupOrphanedInvestments() async {
    await _isar.writeTxn(() async {
      // Get all bike purchase records
      final bikePurchases = await _isar.investments
          .filter()
          .typeEqualTo(InvestmentTypeEnum.bikePurchase)
          .findAll();

      for (final inv in bikePurchases) {
        if (inv.bikeId != null) {
          final bike = await _isar.bikes.get(inv.bikeId!);
          if (bike == null) {
            // Bike was deleted, record is orphaned - CLEANUP
            debugPrint('Cleaning up orphaned investment (Bike ID: ${inv.bikeId}): ${inv.description}');
            await _isar.investments.delete(inv.id);
          }
        } else if (inv.purchaseBatchId != null) {
          final batch = await _isar.purchaseBatchs.get(inv.purchaseBatchId!);
          if (batch == null) {
            // Batch was deleted, record is orphaned - CLEANUP
            debugPrint('Cleaning up orphaned investment (Batch ID: ${inv.purchaseBatchId}): ${inv.description}');
            await _isar.investments.delete(inv.id);
          } else {
            // RECONCILE BATCH AMOUNT with actual inventory truth
            // Load bikes currently in this batch
            await batch.bikes.load();
            final currentBikesPrice = batch.bikes.fold<double>(0.0, (sum, b) => sum + b.purchasePrice);
            
            if (currentBikesPrice == 0) {
              // Batch exists but has 0 bikes in inventory - CLEANUP
              debugPrint('Cleaning up emptied batch investment (Batch ID: ${inv.purchaseBatchId}): ${inv.description}');
              await _isar.investments.delete(inv.id);
            } else if (inv.amount != currentBikesPrice) {
              // Batch amount is out of sync with current bikes (partial deletion) - RECONCILE
              debugPrint('Reconciling Batch ${inv.purchaseBatchId}: ${inv.amount} -> $currentBikesPrice');
              inv.amount = currentBikesPrice;
              await _isar.investments.put(inv);
            }
          }
        } else {
          // Linkless bikePurchase record is invalid - CLEANUP
          debugPrint('Cleaning up linkless bike purchase investment: ${inv.id} - ${inv.description}');
          await _isar.investments.delete(inv.id);
        }
      }
    });
  }

  // ==================== SALE REVENUE OPERATIONS ====================

  /// Record revenue from a cash bike sale
  /// profit = saleAmount - purchasePrice (can be negative for loss)
  Future<Investment> recordBikeSaleRevenue({
    required int bikeId,
    required double saleAmount,
    required double purchasePrice,
    required int saleId,
    String? bikeName,
  }) async {
    final profit = saleAmount - purchasePrice;

    final inv = Investment()
      ..amount = saleAmount
      ..date = DateTime.now()
      ..type = InvestmentTypeEnum.bikeSale
      ..category = InvestmentCategoryEnum.other
      ..bikeId = bikeId
      ..saleId = saleId
      ..profitAmount = profit
      ..description = bikeName != null
          ? 'Cash Sale Revenue — $bikeName'
          : 'Cash Sale Revenue — Bike #$bikeId';

    await _isar.writeTxn(() async {
      await _isar.investments.put(inv);
    });
    return inv;
  }

  /// Record an installment payment received (down payment or monthly EMI)
  Future<Investment> recordInstallmentPaymentRevenue({
    required int contractId,
    required double amount,
    required int bikeId,
    String? description,
  }) async {
    final inv = Investment()
      ..amount = amount
      ..date = DateTime.now()
      ..type = InvestmentTypeEnum.installmentPayment
      ..category = InvestmentCategoryEnum.other
      ..bikeId = bikeId
      ..installmentContractId = contractId
      ..description = description ?? 'Installment Payment — Contract #$contractId';

    await _isar.writeTxn(() async {
      await _isar.investments.put(inv);
    });
    return inv;
  }

  /// Finalize profit on a completed installment contract
  /// Sets profitAmount on the FIRST installmentPayment record for this contract
  Future<void> finalizeInstallmentProfit({
    required int contractId,
    required double totalPaid,
    required double purchasePrice,
  }) async {
    final profit = totalPaid - purchasePrice;

    await _isar.writeTxn(() async {
      // Find the first installmentPayment record for this contract
      final records = await _isar.investments
          .filter()
          .typeEqualTo(InvestmentTypeEnum.installmentPayment)
          .installmentContractIdEqualTo(contractId)
          .sortByDate()
          .findAll();

      if (records.isNotEmpty) {
        // Set profit on the first record (typically the down payment)
        records.first.profitAmount = profit;
        records.first.description =
            '${records.first.description} [Completed — Profit: Rs ${profit.toStringAsFixed(0)}]';
        await _isar.investments.put(records.first);
      }
    });
  }

  /// Add profit to an existing investment (legacy method, kept for compatibility)
  Future<void> addProfitToInvestment(int investmentId, double profit) async {
    await _isar.writeTxn(() async {
      final inv = await _isar.investments.get(investmentId);
      if (inv != null) {
        inv.profitAmount += profit;
        await _isar.investments.put(inv);
      }
    });
  }

  // ==================== BALANCE CALCULATIONS ====================

  /// Returns sum of all capital injections
  Future<double> getTotalCapital() async {
    final capitalRecords = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.capitalInjection)
        .findAll();
    return capitalRecords.fold<double>(0.0, (sum, i) => sum + i.amount);
  }

  /// Returns sum of all allocations (bike purchases) + withdrawals
  Future<double> getTotalAllocated() async {
    final allocatedRecords = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.bikePurchase)
        .or()
        .typeEqualTo(InvestmentTypeEnum.withdrawal)
        .findAll();
    return allocatedRecords.fold<double>(0.0, (sum, i) => sum + i.amount);
  }

  /// Returns total locked capital
  Future<double> getLockedCapital() async {
    final lockedRecords = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.capitalInjection)
        .and()
        .isLockedEqualTo(true)
        .findAll();
    return lockedRecords.fold<double>(0.0, (sum, i) => sum + i.amount);
  }

  /// Sum of all revenue from cash bike sales
  Future<double> getCashFromSales() async {
    final saleRecords = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.bikeSale)
        .findAll();
    return saleRecords.fold<double>(0.0, (sum, i) => sum + i.amount);
  }

  /// Sum of all revenue from installment payments
  Future<double> getCashFromInstallments() async {
    final installmentRecords = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.installmentPayment)
        .findAll();
    return installmentRecords.fold<double>(0.0, (sum, i) => sum + i.amount);
  }

  /// Returns current available balance (capital - allocated + sales + installments - locked)
  Future<double> getAvailableBalance() async {
    final totalCapital = await getTotalCapital();
    final allocated = await getTotalAllocated();
    final locked = await getLockedCapital();
    final salesRevenue = await getCashFromSales();
    final installmentRevenue = await getCashFromInstallments();
    return totalCapital - allocated - locked + salesRevenue + installmentRevenue;
  }

  /// Returns current TOTAL balance (including locked capital)
  Future<double> getTotalRemainingBalance() async {
    final totalCapital = await getTotalCapital();
    final allocated = await getTotalAllocated();
    final salesRevenue = await getCashFromSales();
    final installmentRevenue = await getCashFromInstallments();
    return totalCapital - allocated + salesRevenue + installmentRevenue;
  }

  // ==================== PROFIT CALCULATIONS ====================

  /// Returns total realized profit (cash sale profits + completed installment profits)
  Future<double> getTotalProfit() async {
    // Profit from cash sales (including losses as negative)
    final saleRecords = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.bikeSale)
        .findAll();
    final saleProfit =
        saleRecords.fold<double>(0.0, (sum, i) => sum + i.profitAmount);

    // Profit from completed installments
    final installmentRecords = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.installmentPayment)
        .profitAmountGreaterThan(0)
        .findAll();
    // Only count unique contracts (first record per contract has the profit)
    final seenContracts = <int>{};
    double installmentProfit = 0.0;
    for (final record in installmentRecords) {
      if (record.installmentContractId != null &&
          !seenContracts.contains(record.installmentContractId)) {
        seenContracts.add(record.installmentContractId!);
        installmentProfit += record.profitAmount;
      }
    }

    return saleProfit + installmentProfit;
  }

  /// Returns total accumulated losses (negative profits from sales below purchase price)
  Future<double> getAccumulatedLoss() async {
    final saleRecords = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.bikeSale)
        .profitAmountLessThan(0)
        .findAll();
    // Return as positive number (absolute value of losses)
    return saleRecords.fold<double>(
        0.0, (sum, i) => sum + i.profitAmount.abs());
  }

  /// Calculates ROI percentage
  Future<double> calculateROI() async {
    final totalCapital = await getTotalCapital();
    if (totalCapital <= 0) return 0.0;
    final totalProfit = await getTotalProfit();
    return (totalProfit / totalCapital) * 100;
  }

  // ==================== FUTURE INSTALLMENT PREDICTIONS ====================

  /// Sum of remaining EMI payments from ALL active installment contracts
  Future<double> getFutureInstallmentPayments() async {
    final activeContracts = await _isar.installmentContracts
        .filter()
        .statusEqualTo(ContractStatusEnum.active)
        .or()
        .statusEqualTo(ContractStatusEnum.partiallyPaid)
        .or()
        .statusEqualTo(ContractStatusEnum.overdue)
        .findAll();

    return activeContracts.fold<double>(
        0.0, (sum, c) => sum + c.remainingBalance);
  }

  /// Predicted profit from active installments
  /// For each active contract: totalAmount - purchasePrice of bike
  Future<double> getFutureInstallmentProfit() async {
    final activeContracts = await _isar.installmentContracts
        .filter()
        .statusEqualTo(ContractStatusEnum.active)
        .or()
        .statusEqualTo(ContractStatusEnum.partiallyPaid)
        .or()
        .statusEqualTo(ContractStatusEnum.overdue)
        .findAll();

    double totalFutureProfit = 0.0;
    for (final contract in activeContracts) {
      final bike = await _isar.bikes.get(contract.bikeId);
      if (bike != null) {
        final predictedProfit = contract.totalAmount - bike.purchasePrice;
        totalFutureProfit += predictedProfit;
      }
    }
    return totalFutureProfit;
  }

  /// Count of active installment contracts
  Future<int> getActiveContractsCount() async {
    return await _isar.installmentContracts
        .filter()
        .statusEqualTo(ContractStatusEnum.active)
        .or()
        .statusEqualTo(ContractStatusEnum.partiallyPaid)
        .or()
        .statusEqualTo(ContractStatusEnum.overdue)
        .count();
  }

  // ==================== BIKE INVENTORY VALUE ====================

  /// Total purchase price of all unsold bikes (available + installment status)
  Future<double> getCashOnBikes() async {
    final bikes = await _isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.available)
        .or()
        .statusEqualTo(BikeStatusEnum.installment)
        .findAll();
    return bikes.fold<double>(0.0, (sum, b) => sum + b.purchasePrice);
  }

  /// Count of unsold bikes
  Future<int> getUnsoldBikesCount() async {
    return await _isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.available)
        .count();
  }

  // ==================== HISTORY ====================

  /// Returns investment history sorted by date descending
  Future<List<Investment>> getInvestmentHistory() async {
    return await _isar.investments.where().sortByDateDesc().findAll();
  }

  // ==================== DATA MIGRATION ====================

  /// One-time migration: create missing bikeSale/installmentPayment records
  /// for historical data
  Future<void> migrateExistingSalesData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final migrationDone = prefs.getBool('investment_migration_v2_done') ?? false;
      if (migrationDone) return;

      debugPrint('Starting Investment Migration v2...');
      int saleRecordsCreated = 0;
      int paymentRecordsCreated = 0;

      await _isar.writeTxn(() async {
        // 1. Migrate cash sales — create bikeSale records for sold bikes
        final soldBikes = await _isar.bikes
            .filter()
            .statusEqualTo(BikeStatusEnum.sold)
            .findAll();

        for (final bike in soldBikes) {
          // Check if a bikeSale record already exists for this bike
          final existing = await _isar.investments
              .filter()
              .typeEqualTo(InvestmentTypeEnum.bikeSale)
              .bikeIdEqualTo(bike.id)
              .findFirst();
          if (existing != null) continue;

          // Find the sale record for this bike
          final sale = await _isar.sales
              .filter()
              .bikeIdEqualTo(bike.id)
              .findFirst();
          if (sale == null) continue;

          final saleAmount = sale.saleType == SaleType.cash
              ? sale.totalAmount
              : sale.receivedAmount; // For old installment sales, use received
          final profit = saleAmount - bike.purchasePrice;

          final inv = Investment()
            ..amount = saleAmount
            ..date = sale.saleDate
            ..type = InvestmentTypeEnum.bikeSale
            ..category = InvestmentCategoryEnum.other
            ..bikeId = bike.id
            ..saleId = sale.id
            ..profitAmount = profit
            ..description = 'Cash Sale Revenue — ${bike.model} ${bike.brand} [Migrated]';

          await _isar.investments.put(inv);
          saleRecordsCreated++;
        }

        // 2. Migrate installment payments
        final allContracts = await _isar.installmentContracts.where().findAll();

        for (final contract in allContracts) {
          // Check if installmentPayment records exist for this contract
          final existing = await _isar.investments
              .filter()
              .typeEqualTo(InvestmentTypeEnum.installmentPayment)
              .installmentContractIdEqualTo(contract.id)
              .findFirst();
          if (existing != null) continue;

          final bike = await _isar.bikes.get(contract.bikeId);
          if (bike == null) continue;

          // Get all payments for this contract
          final payments = await _isar.payments
              .filter()
              .contractIdEqualTo(contract.id)
              .sortByPaymentDate()
              .findAll();

          for (final payment in payments) {
            final inv = Investment()
              ..amount = payment.amount
              ..date = payment.paymentDate
              ..type = InvestmentTypeEnum.installmentPayment
              ..category = InvestmentCategoryEnum.other
              ..bikeId = bike.id
              ..installmentContractId = contract.id
              ..description = payment.isDownPayment
                  ? 'Down Payment — ${bike.model} ${bike.brand} [Migrated]'
                  : 'Installment Payment — ${bike.model} ${bike.brand} [Migrated]';

            await _isar.investments.put(inv);
            paymentRecordsCreated++;
          }

          // If contract is completed, finalize profit on first record
          if (contract.status == ContractStatusEnum.completed) {
            final firstRecord = await _isar.investments
                .filter()
                .typeEqualTo(InvestmentTypeEnum.installmentPayment)
                .installmentContractIdEqualTo(contract.id)
                .sortByDate()
                .findFirst();

            if (firstRecord != null) {
              final profit = contract.totalPaid - bike.purchasePrice;
              firstRecord.profitAmount = profit;
              await _isar.investments.put(firstRecord);
            }
          }
        }
      });

      await prefs.setBool('investment_migration_v2_done', true);
      debugPrint(
          'Migration Complete: $saleRecordsCreated sale records, $paymentRecordsCreated payment records created.');
    } catch (e) {
      debugPrint('Investment Migration Error: $e');
    }
  }
}

// Authored by: Moazzam Samoo
