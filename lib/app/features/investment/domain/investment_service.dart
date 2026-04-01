import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/data/models/investment.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/expense.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/data/models/purchase_batch.dart';

class CategoryFinancials {
  final InvestmentCategoryEnum category;
  final double injected;
  final double available;
  final double earnedProfit;

  CategoryFinancials({
    required this.category,
    required this.injected,
    required this.available,
    this.earnedProfit = 0.0,
  });
}

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

  /// Record a withdrawal or expense
  Future<Investment> recordWithdrawal({
    required double amount,
    required DateTime date,
    required InvestmentCategoryEnum category,
    double deductPersonal = 0.0,
    double deductPartnership = 0.0,
    double deductOther = 0.0,
    double deductLoan = 0.0,
    String? description,
    bool isLocked = false,
  }) async {
    final inv = Investment()
      ..amount = amount
      ..date = date
      ..type = InvestmentTypeEnum.withdrawal
      ..category = category
      ..description = description ?? 'Capital outflow'
      ..isLocked = isLocked
      ..returnPersonal = deductPersonal
      ..returnPartnership = deductPartnership
      ..returnOther = deductOther
      ..returnLoan = deductLoan;

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
    
    final distribution = await _calculateReturnDistribution(bikeId, saleAmount);

    final inv = Investment()
      ..amount = saleAmount
      ..date = DateTime.now()
      ..type = InvestmentTypeEnum.bikeSale
      ..category = InvestmentCategoryEnum.other
      ..bikeId = bikeId
      ..saleId = saleId
      ..profitAmount = profit
      ..returnPersonal = distribution.personal
      ..returnPartnership = distribution.partnership
      ..returnOther = distribution.other
      ..returnLoan = distribution.loan
      ..description = bikeName != null
          ? 'Cash Sale Revenue — $bikeName'
          : 'Cash Sale Revenue — Bike #$bikeId';

    await _isar.writeTxn(() async {
      await _isar.investments.put(inv);
    });
    return inv;
  }

  /// Record an installment payment received (down payment or monthly EMI)
  /// Calculates profit dynamically using Cost-Recovery logic.
  Future<Investment> recordInstallmentPaymentRevenue({
    required int contractId,
    required double amount,
    required int bikeId,
    required double previousTotalPaid,
    required double purchasePrice,
    String? description,
    bool inTransaction = false,
  }) async {
    final currentTotalPaid = previousTotalPaid + amount;
    double profitRealizedNow = 0.0;

    // Cost-Recovery logic: Profit is realized only when TotalPaid exceeds PurchasePrice.
    if (currentTotalPaid > purchasePrice) {
      if (previousTotalPaid >= purchasePrice) {
        // Unrecovered cost is already 0. The entire payment is profit.
        profitRealizedNow = amount;
      } else {
        // We just crossed the threshold!
        profitRealizedNow = currentTotalPaid - purchasePrice;
      }
    }

    final distribution = await _calculateReturnDistribution(bikeId, amount);

    final inv = Investment()
      ..amount = amount
      ..date = DateTime.now()
      ..type = InvestmentTypeEnum.installmentPayment
      ..category = InvestmentCategoryEnum.other
      ..bikeId = bikeId
      ..installmentContractId = contractId
      ..profitAmount = profitRealizedNow
      ..returnPersonal = distribution.personal
      ..returnPartnership = distribution.partnership
      ..returnOther = distribution.other
      ..returnLoan = distribution.loan
      ..description = description ?? 'Installment Payment — Contract #$contractId';

    if (inTransaction) {
      await _isar.investments.put(inv);
    } else {
      await _isar.writeTxn(() async {
        await _isar.investments.put(inv);
      });
    }
    return inv;
  }

  /// Helper to calculate mathematically perfect return distribution
  Future<({double personal, double partnership, double other, double loan})> _calculateReturnDistribution(int bikeId, double incomingAmount) async {
    final bike = await _isar.bikes.get(bikeId);
    
    if (bike == null) {
      return (personal: incomingAmount, partnership: 0.0, other: 0.0, loan: 0.0);
    }
    
    final double totalFunded = bike.fundedByPersonal + bike.fundedByPartnership + bike.fundedByOther + bike.fundedByLoan;
    
    if (totalFunded <= 0) {
      // Fallback for legacy bikes or bikes bought with zero capital layout
      return (personal: incomingAmount, partnership: 0.0, other: 0.0, loan: 0.0);
    }
    
    return (
      personal: (bike.fundedByPersonal / totalFunded) * incomingAmount,
      partnership: (bike.fundedByPartnership / totalFunded) * incomingAmount,
      other: (bike.fundedByOther / totalFunded) * incomingAmount,
      loan: (bike.fundedByLoan / totalFunded) * incomingAmount,
    );
  }

  /// Finalize profit on a completed installment contract
  /// [OBSOLETE] Profit is now realized continuously per-payment via Cost-Recovery matching in recordInstallmentPaymentRevenue.
  Future<void> finalizeInstallmentProfit({
    required int contractId,
    required double totalPaid,
    required double purchasePrice,
  }) async {
    // Kept empty to avoid breaking older codebase calls before they are removed, 
    // but we no longer need to finalize profit at the end.
    debugPrint('finalizeInstallmentProfit called for $contractId. Ignored because logic is now continuous.');
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
    final List<CategoryFinancials> breakdown = await getCategoryFinancials();
    final unlockedAvailable = breakdown.fold<double>(0.0, (sum, c) => sum + c.available);
    
    // Total Available now natively includes exactly distributed profit from the category breakdown
    return unlockedAvailable;
  }

  /// Returns current TOTAL balance (including locked capital and profit)
  Future<double> getTotalRemainingBalance() async {
    final totalCapital = await getTotalCapital();
    final allocated = await getTotalAllocated();
    final salesRevenue = await getCashFromSales();
    final installmentRevenue = await getCashFromInstallments();
    return totalCapital - allocated + salesRevenue + installmentRevenue;
  }

  /// Calculates the breakdown of capital across categories based on priority spending.
  /// Priority: Personal > Partnership > Other > Loan
  Future<List<CategoryFinancials>> getCategoryFinancials() async {
    final allInvestments = await _isar.investments.where().findAll();
    final allBikes = await _isar.bikes.where().findAll();

    final categories = [
      InvestmentCategoryEnum.personalCapital,
      InvestmentCategoryEnum.partnership,
      InvestmentCategoryEnum.other,
      InvestmentCategoryEnum.loan,
    ];

    List<CategoryFinancials> result = [];

    for (final cat in categories) {
      double injected = 0.0;
      double withdrawn = 0.0;
      double bikePurchases = 0.0;
      double returns = 0.0;
      double earnedProfit = 0.0;

      // 1. Injected & Withdrawn
      for (final inv in allInvestments) {
        if (!inv.isLocked) {
          if (inv.type == InvestmentTypeEnum.capitalInjection && inv.category == cat) {
            injected += inv.amount;
          } else if (inv.type == InvestmentTypeEnum.withdrawal) {
            double exactDeducted = 0.0;
            switch (cat) {
              case InvestmentCategoryEnum.personalCapital: exactDeducted = inv.returnPersonal; break;
              case InvestmentCategoryEnum.partnership: exactDeducted = inv.returnPartnership; break;
              case InvestmentCategoryEnum.other: exactDeducted = inv.returnOther; break;
              case InvestmentCategoryEnum.loan: exactDeducted = inv.returnLoan; break;
              default: break;
            }
            // Add precisely deducted value across multiple pools
            if (exactDeducted > 0) {
              withdrawn += exactDeducted;
            } else if (inv.category == cat && inv.returnPersonal == 0 && inv.returnPartnership == 0 && inv.returnOther == 0 && inv.returnLoan == 0) {
              // Legacy fallback if perfectly mapped V2 withdrawals did not exist
              withdrawn += inv.amount;
            }
          }
        }

        // 2. Returns & Profit (Sales & Installment Revenues)
        if (inv.type == InvestmentTypeEnum.bikeSale || inv.type == InvestmentTypeEnum.installmentPayment) {
          // Add raw Cash Return
          switch (cat) {
            case InvestmentCategoryEnum.personalCapital: returns += inv.returnPersonal; break;
            case InvestmentCategoryEnum.partnership: returns += inv.returnPartnership; break;
            case InvestmentCategoryEnum.other: returns += inv.returnOther; break;
            case InvestmentCategoryEnum.loan: returns += inv.returnLoan; break;
            default: break;
          }
          
          // Add strict mathematical Earned Profit (Amount proportion x ProfitAmount)
          if (inv.amount > 0 && inv.profitAmount > 0) {
            double categoryReturnedAmt = 0;
            switch (cat) {
              case InvestmentCategoryEnum.personalCapital: categoryReturnedAmt = inv.returnPersonal; break;
              case InvestmentCategoryEnum.partnership: categoryReturnedAmt = inv.returnPartnership; break;
              case InvestmentCategoryEnum.other: categoryReturnedAmt = inv.returnOther; break;
              case InvestmentCategoryEnum.loan: categoryReturnedAmt = inv.returnLoan; break;
              default: break;
            }
            final ratio = categoryReturnedAmt / inv.amount;
            earnedProfit += (inv.profitAmount * ratio);
          } else if (inv.amount > 0 && inv.profitAmount < 0) {
            // Handle explicitly negative profit (Loss mapping to categories inversely)
            double categoryReturnedAmt = 0;
            switch (cat) {
              case InvestmentCategoryEnum.personalCapital: categoryReturnedAmt = inv.returnPersonal; break;
              case InvestmentCategoryEnum.partnership: categoryReturnedAmt = inv.returnPartnership; break;
              case InvestmentCategoryEnum.other: categoryReturnedAmt = inv.returnOther; break;
              case InvestmentCategoryEnum.loan: categoryReturnedAmt = inv.returnLoan; break;
              default: break;
            }
            final ratio = categoryReturnedAmt / inv.amount;
            earnedProfit += (inv.profitAmount * ratio); // Adds a negative
          }
        }
      }

      // 3. Bike Purchases (Outflows derived from exact snapshots)
      for (final bike in allBikes) {
        switch (cat) {
          case InvestmentCategoryEnum.personalCapital: bikePurchases += bike.fundedByPersonal; break;
          case InvestmentCategoryEnum.partnership: bikePurchases += bike.fundedByPartnership; break;
          case InvestmentCategoryEnum.other: bikePurchases += bike.fundedByOther; break;
          case InvestmentCategoryEnum.loan: bikePurchases += bike.fundedByLoan; break;
          default: break;
        }
      }

      final available = injected - withdrawn - bikePurchases + returns;

      result.add(CategoryFinancials(
        category: cat,
        injected: injected, // Represents raw cash initially put into business
        available: available, // Represents perfectly tracked balance at this exact second
        earnedProfit: earnedProfit,
      ));
    }

    return result;
  }

  /// Returns breakdown of locked capital
  Future<Map<InvestmentCategoryEnum, double>> getLockedBreakdown() async {
    final allInvestments = await _isar.investments.where().findAll();
    final Map<InvestmentCategoryEnum, double> locked = {
      InvestmentCategoryEnum.personalCapital: 0,
      InvestmentCategoryEnum.partnership: 0,
      InvestmentCategoryEnum.other: 0,
      InvestmentCategoryEnum.loan: 0,
    };

    for (final inv in allInvestments) {
      if (inv.isLocked) {
        if (inv.type == InvestmentTypeEnum.capitalInjection) {
          locked[inv.category] = (locked[inv.category] ?? 0) + inv.amount;
        } else if (inv.type == InvestmentTypeEnum.withdrawal) {
          // Precisely deduct from locked capital if we ever support multi-pool locked withdrawals
          // Currently, locked is a pool per-category, but the feature is minimally used
          locked[inv.category] = (locked[inv.category] ?? 0) - inv.amount;
        }
      }
    }
    return locked;
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

    // Profit from installments (continuous cost-recovery logic)
    final installmentRecords = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.installmentPayment)
        .findAll();
    final installmentProfit = 
        installmentRecords.fold<double>(0.0, (sum, i) => sum + i.profitAmount);

    return saleProfit + installmentProfit;
  }

  /// Returns total expenses 
  Future<double> getTotalExpenses() async {
    final expenses = await _isar.expenses.where().findAll();
    return expenses.fold<double>(0.0, (sum, exp) => sum + exp.amount);
  }

  /// Returns total withdrawals 
  Future<double> getTotalWithdrawals() async {
    final records = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.withdrawal)
        .findAll();
    return records.fold<double>(0.0, (sum, i) => sum + i.amount);
  }

  /// Returns total cash spent specifically on maintenance
  Future<double> getMaintenanceCash() async {
    final records = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.withdrawal)
        .and()
        .categoryEqualTo(InvestmentCategoryEnum.maintenance)
        .findAll();
    return records.fold<double>(0.0, (sum, i) => sum + i.amount);
  }

  /// Returns total cash spent on Expenses, Maintenance, and Personal Use
  Future<double> getExpensesCash() async {
    final records = await _isar.investments
        .filter()
        .typeEqualTo(InvestmentTypeEnum.withdrawal)
        .and()
        .group((q) => q
            .categoryEqualTo(InvestmentCategoryEnum.maintenance)
            .or()
            .categoryEqualTo(InvestmentCategoryEnum.expense)
            .or()
            .categoryEqualTo(InvestmentCategoryEnum.personalUse))
        .findAll();
    return records.fold<double>(0.0, (sum, i) => sum + i.amount);
  }

  /// Returns total asset value (Unsold bikes purchase price + Future expected installments)
  Future<double> getAssetsValue() async {
    // 1. Unsold Bikes Value
    final unsoldBikes = await _isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.available)
        .or()
        .statusEqualTo(BikeStatusEnum.installment)
        .findAll();
    final unsoldValue = unsoldBikes.fold<double>(0.0, (sum, b) => sum + b.purchasePrice);

    // 2. Future Installment Receivables
    final futurePayments = await getFutureInstallmentPayments();

    return unsoldValue + futurePayments;
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

  /// Predicted profit from active installments (Remaining profit to be realized)
  /// For each active contract: (Remaining Balance - Remaining Cost to cover)
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
        final totalAmount = contract.totalAmount;
        final totalPaid = contract.totalPaid;
        final purchasePrice = bike.purchasePrice;
        
        // Total Profit the contract COULD ever make
        final totalProfitPotential = (totalAmount - purchasePrice).clamp(0.0, double.infinity);
        
        // Remaining Balance (What we will receive in future)
        final futurePayment = (totalAmount - totalPaid).clamp(0.0, double.infinity);
        
        // Future Profit is the portion of the futurePayment that is profit.
        // If futurePayment is 100k and totalProfitPotential is 50k, 
        // it means we still have 50k of cost to recover before we touch the profit.
        // So Future Profit stays at 50k.
        // If futurePayment drops to 30k, then everything left is profit, so Future Profit = 30k.
        final futureProfit = (futurePayment < totalProfitPotential) 
            ? futurePayment 
            : totalProfitPotential;
        
        totalFutureProfit += futureProfit;
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

  /// Returns total historical purchase price of ALL bikes ever bought
  Future<double> getCashOnBikes() async {
    final bikes = await _isar.bikes.where().findAll();
    return bikes.fold<double>(0.0, (sum, b) => sum + b.purchasePrice);
  }

  /// Returns purchase price of bikes that are either Sold (Cash) or Completed (Installment)
  Future<double> getSoldAndCompletedBikesValue() async {
    // 1. Sold (Cash) bikes
    final soldBikes = await _isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.sold)
        .findAll();
    final soldValue = soldBikes.fold<double>(0.0, (sum, b) => sum + b.purchasePrice);

    // 2. Completed Installment bikes
    final installmentBikes = await _isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.installment)
        .findAll();
    
    double completedValue = 0.0;
    for (final bike in installmentBikes) {
      final contract = await _isar.installmentContracts
          .filter()
          .bikeIdEqualTo(bike.id)
          .findFirst();
      if (contract?.status == ContractStatusEnum.completed) {
        completedValue += bike.purchasePrice;
      }
    }

    return soldValue + completedValue;
  }

  /// Returns purchase price of bikes that are either Available or Pending Installment
  Future<double> getActiveInventoryValue() async {
    // 1. Available bikes
    final availableBikes = await _isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.available)
        .findAll();
    final availableValue = availableBikes.fold<double>(0.0, (sum, b) => sum + b.purchasePrice);

    // 2. Pending Installment bikes
    final installmentBikes = await _isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.installment)
        .findAll();
    
    double pendingValue = 0.0;
    for (final bike in installmentBikes) {
      final contract = await _isar.installmentContracts
          .filter()
          .bikeIdEqualTo(bike.id)
          .findFirst();
      if (contract != null && contract.status != ContractStatusEnum.completed) {
        pendingValue += bike.purchasePrice;
      }
    }

    return availableValue + pendingValue;
  }

  /// Count of all bikes ever bought
  Future<int> getTotalBikesPurchasedCount() async {
    return await _isar.bikes.where().count();
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
      
      // Run repair once for everyone
      final repairDone = prefs.getBool('investment_repair_v1_done') ?? false;
      if (!repairDone) {
        await repairMismatchedInstallmentRecords();
        await prefs.setBool('investment_repair_v1_done', true);
      }

      // Run new profit recalculation
      final profitRecalcDone = prefs.getBool('investment_profit_recalc_v1_done') ?? false;
      if (!profitRecalcDone) {
        await recalculateHistoricalInstallmentProfits();
        await prefs.setBool('investment_profit_recalc_v1_done', true);
      }

      final migrationDone = prefs.getBool('investment_migration_v2_done') ?? false;
      if (!migrationDone) {
        debugPrint('Starting Investment Migration v2 (Sales & Installments)...');
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
      }
      
      // Migrate Expenses to Investment Outflows
      final expenseMigrationDone = prefs.getBool('expense_to_investment_migration_v1_done') ?? false;
      if (!expenseMigrationDone) {
        debugPrint('Starting Expense Migration to Unified Ledger...');
        int expenseRecordsMigrated = 0;
        await _isar.writeTxn(() async {
          final oldExpenses = await _isar.expenses.where().findAll();
          for (final exp in oldExpenses) {
             final inv = Investment()
               ..amount = exp.amount
               ..date = exp.date
               ..type = InvestmentTypeEnum.withdrawal
               ..category = InvestmentCategoryEnum.expense
               ..description = 'Expense — ${exp.category}'
               ..isLocked = false
               ..returnOther = exp.amount; // Safest fallback: deduct from 'Other' dynamically
             await _isar.investments.put(inv);
             expenseRecordsMigrated++;
          }
        });
        await prefs.setBool('expense_to_investment_migration_v1_done', true);
        debugPrint('Expense Migration Complete: $expenseRecordsMigrated records unified.');
      }
    } catch (e) {
      debugPrint('Investment Migration Error: $e');
    }
  }

  /// Repairs records where installmentContractId was incorrectly set to 0.
  /// Uses bikeId to find the corresponding InstallmentContract.
  Future<void> repairMismatchedInstallmentRecords() async {
    debugPrint('Starting Investment Record Repair (Contract ID 0)...');
    try {
      await _isar.writeTxn(() async {
        final recordsToFix = await _isar.investments
            .filter()
            .typeEqualTo(InvestmentTypeEnum.installmentPayment)
            .installmentContractIdEqualTo(0)
            .findAll();

        if (recordsToFix.isEmpty) {
          debugPrint('No records with Contract ID 0 found.');
          return;
        }

        debugPrint('Found ${recordsToFix.length} investment records to repair.');
        int fixedCount = 0;

        for (final record in recordsToFix) {
          if (record.bikeId == null) continue;

          // Find the contract for this bike
          final contract = await _isar.installmentContracts
              .filter()
              .bikeIdEqualTo(record.bikeId!)
              .findFirst();

          if (contract != null) {
            record.installmentContractId = contract.id;
            await _isar.investments.put(record);
            fixedCount++;
            
            // If the contract is completed, also check if profit needs re-calculation
            if (contract.status == ContractStatusEnum.completed) {
              final profit = contract.totalPaid - (await _isar.bikes.get(contract.bikeId))!.purchasePrice;
              // Re-run finalize profit just in case it was missed due to ID 0
              final contractRecords = await _isar.investments
                  .filter()
                  .typeEqualTo(InvestmentTypeEnum.installmentPayment)
                  .installmentContractIdEqualTo(contract.id)
                  .sortByDate()
                  .findAll();
              
              if (contractRecords.isNotEmpty && contractRecords.first.profitAmount == 0) {
                 contractRecords.first.profitAmount = profit;
                 await _isar.investments.put(contractRecords.first);
                 debugPrint('  - Also finalized profit for Contract #${contract.id}');
              }
            }
          }
        }
        debugPrint('Repair Complete. Linked $fixedCount records to correct contracts.');
      });
    } catch (e) {
      debugPrint('Error repairing investment records: $e');
    }
  }

  /// Recalculates historical profits for all installment contracts 
  /// based on the new Cost-Recovery (Threshold) realization logic.
  Future<void> recalculateHistoricalInstallmentProfits() async {
    debugPrint('Starting Historical Profit Recalculation (Cost-Recovery)...');
    try {
      int updatedCount = 0;
      await _isar.writeTxn(() async {
        final contracts = await _isar.installmentContracts.where().findAll();
        for (final contract in contracts) {
          final bike = await _isar.bikes.get(contract.bikeId);
          if (bike == null) continue;

          final purchasePrice = bike.purchasePrice;
          
          final payments = await _isar.investments
              .filter()
              .installmentContractIdEqualTo(contract.id)
              .typeEqualTo(InvestmentTypeEnum.installmentPayment)
              .sortByDate()
              .findAll();
              
          double runningTotal = 0.0;
          
          for (final payment in payments) {
             final amount = payment.amount;
             final currentTotal = runningTotal + amount;
             double profit = 0.0;
             
             if (currentTotal > purchasePrice) {
                if (runningTotal >= purchasePrice) {
                   profit = amount;
                } else {
                   profit = currentTotal - purchasePrice;
                }
             }
             
             if (payment.profitAmount != profit) {
                payment.profitAmount = profit;
                // Remove any old "Completed" text if present
                if (payment.description != null && payment.description!.contains(' [Completed')) {
                  payment.description = payment.description!.split(' [Completed')[0];
                }
                await _isar.investments.put(payment);
                updatedCount++;
             }
             
             runningTotal = currentTotal;
          }
        }
      });
      debugPrint('Historical Profit Recalculation complete. Updated $updatedCount records.');
    } catch (e) {
      debugPrint('Error recalculating historical profits: $e');
    }
  }
}

// Authored by: Moazzam Samoo
