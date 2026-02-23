import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/expense.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';

/// Repository for revenue calculations and expense management
class ReportsRepository {
  final Isar _isar;

  ReportsRepository(this._isar);

  // ─── Revenue Queries ───────────────────────────────────────

  /// Get all sales in a given month/year
  Future<List<Sale>> getSalesByMonth(int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);

    return await _isar.sales
        .filter()
        .saleDateBetween(start, end)
        .findAll();
  }

  /// Calculate total revenue using proportional recognition for installments
  Future<double> getTotalRevenue(int month, int year) async {
    final sales = await getSalesByMonth(month, year);
    double total = 0;

    for (final sale in sales) {
      final bike = await _isar.bikes.get(sale.bikeId);
      if (bike == null) continue;

      final pPrice = bike.purchasePrice.isNaN ? 0.0 : bike.purchasePrice;
      final sPrice = bike.cashSalePrice.isNaN ? 0.0 : bike.cashSalePrice;
      
      double dAmt = sale.discountAmount.isNaN ? 0.0 : sale.discountAmount;
      // Fallback for legacy cash sales where discountAmount was not explicitly saved
      if (sale.saleType == SaleType.cash && dAmt == 0.0) {
        final double received = sale.receivedAmount.isNaN ? 0.0 : sale.receivedAmount;
        if (received > 0 && received < sPrice) {
          dAmt = sPrice - received;
        }
      }
      
      final baseProfit = sPrice - pPrice - dAmt;

      if (sale.saleType == SaleType.cash) {
        total += baseProfit.isNaN ? 0.0 : baseProfit;
      } else if (sale.installmentContractId != null) {
        final contract = await _isar.installmentContracts.get(sale.installmentContractId!);
        if (contract != null) {
          double progress = contract.totalAmount > 0
              ? (contract.totalPaid / contract.totalAmount)
              : 0.0;
          if (progress.isNaN || progress.isInfinite) progress = 0.0;
          progress = progress.clamp(0.0, 1.0);
          
          final profitPart = baseProfit * progress;
          final markupPart = contract.totalMarkupAmount * progress;
          
          total += profitPart.isNaN ? 0.0 : profitPart;
          total += markupPart.isNaN ? 0.0 : markupPart;
        }
      }
    }
    return total;
  }

  /// Revenue grouped by brand — full amounts + earned (proportional recovery)
  Future<Map<String, Map<String, double>>> getProfitByBrand(int month, int year) async {
    final sales = await getSalesByMonth(month, year);
    final Map<String, Map<String, double>> result = {};

    for (final sale in sales) {
      final bike = await _isar.bikes.get(sale.bikeId);
      if (bike == null) continue;

      final brand = bike.brand;
      result.putIfAbsent(brand, () => {'cash': 0, 'installment': 0, 'total': 0, 'earned': 0});

      final pPrice = bike.purchasePrice.isNaN ? 0.0 : bike.purchasePrice;
      final sPrice = bike.cashSalePrice.isNaN ? 0.0 : bike.cashSalePrice;
      
      double dAmt = sale.discountAmount.isNaN ? 0.0 : sale.discountAmount;
      // Fallback for legacy cash sales
      if (sale.saleType == SaleType.cash && dAmt == 0.0) {
        final double received = sale.receivedAmount.isNaN ? 0.0 : sale.receivedAmount;
        if (received > 0 && received < sPrice) {
          dAmt = sPrice - received;
        }
      }
      
      final baseProfit = sPrice - pPrice - dAmt;

      if (sale.saleType == SaleType.cash) {
        final profit = baseProfit.isNaN ? 0.0 : baseProfit;
        result[brand]!['cash'] = result[brand]!['cash']! + profit;
        result[brand]!['earned'] = result[brand]!['earned']! + profit;
      } else if (sale.installmentContractId != null) {
        final contract = await _isar.installmentContracts.get(sale.installmentContractId!);
        if (contract != null) {
          final markup = contract.totalMarkupAmount.isNaN ? 0.0 : contract.totalMarkupAmount;
          final totalProfit = baseProfit + markup;
          
          double progress = contract.totalAmount > 0
              ? (contract.totalPaid / contract.totalAmount)
              : 0.0;
          if (progress.isNaN || progress.isInfinite) progress = 0.0;
          progress = progress.clamp(0.0, 1.0);

          final profitPart = baseProfit.isNaN ? 0.0 : baseProfit;
          
          result[brand]!['cash'] = result[brand]!['cash']! + profitPart;
          result[brand]!['installment'] = result[brand]!['installment']! + markup;
          
          final earnedPart = totalProfit * progress;
          result[brand]!['earned'] = result[brand]!['earned']! + (earnedPart.isNaN ? 0.0 : earnedPart);
        }
      }

      result[brand]!['total'] = result[brand]!['cash']! + result[brand]!['installment']!;
    }
    return result;
  }

  /// Monthly profit for the last N months (for bar chart)
  Future<List<MapEntry<String, double>>> getMonthlyProfitTrend(int months) async {
    final now = DateTime.now();
    final List<MapEntry<String, double>> trend = [];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    for (int i = months - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final revenue = await getTotalRevenue(date.month, date.year);
      trend.add(MapEntry(monthNames[date.month - 1], revenue));
    }
    return trend;
  }

  /// Stock distribution by brand (for donut chart)
  Future<Map<String, int>> getStockDistribution() async {
    final bikes = await _isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.available)
        .findAll();

    final Map<String, int> distribution = {};
    for (final bike in bikes) {
      distribution[bike.brand] = (distribution[bike.brand] ?? 0) + 1;
    }
    return distribution;
  }

  /// Daily revenue trend for the selected month
  Future<List<MapEntry<String, double>>> getDailyRevenueTrend(int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);

    final sales = await _isar.sales
        .filter()
        .saleDateBetween(start, end)
        .findAll();

    final int daysInMonth = end.day;
    final Map<int, double> dailyRevenue = {for (var i = 1; i <= daysInMonth; i++) i: 0.0};

    for (final sale in sales) {
      final bike = await _isar.bikes.get(sale.bikeId);
      if (bike == null) continue;

      final day = sale.saleDate.day;
      final pPrice = bike.purchasePrice.isNaN ? 0.0 : bike.purchasePrice;
      final sPrice = bike.cashSalePrice.isNaN ? 0.0 : bike.cashSalePrice;
      
      double dAmt = sale.discountAmount.isNaN ? 0.0 : sale.discountAmount;
      // Fallback for legacy cash sales
      if (sale.saleType == SaleType.cash && dAmt == 0.0) {
        final double received = sale.receivedAmount.isNaN ? 0.0 : sale.receivedAmount;
        if (received > 0 && received < sPrice) {
          dAmt = sPrice - received;
        }
      }
      
      final baseProfit = sPrice - pPrice - dAmt;

      if (sale.saleType == SaleType.cash) {
        final profit = baseProfit.isNaN ? 0.0 : baseProfit;
        dailyRevenue[day] = dailyRevenue[day]! + profit;
      } else if (sale.installmentContractId != null) {
        final contract = await _isar.installmentContracts.get(sale.installmentContractId!);
        if (contract != null) {
          double progress = contract.totalAmount > 0
              ? (contract.totalPaid / contract.totalAmount)
              : 0.0;
          if (progress.isNaN || progress.isInfinite) progress = 0.0;
          progress = progress.clamp(0.0, 1.0);
              
          final profitPart = baseProfit * progress;
          final markupPart = contract.totalMarkupAmount * progress;
          
          final safeProfit = profitPart.isNaN ? 0.0 : profitPart;
          final safeMarkup = markupPart.isNaN ? 0.0 : markupPart;
          
          dailyRevenue[day] = dailyRevenue[day]! + safeProfit + safeMarkup;
        }
      }
    }

    return dailyRevenue.entries
        .map((e) => MapEntry(e.key.toString(), e.value))
        .toList();
  }

  /// Monthly revenue trend for the selected year
  Future<List<MapEntry<String, double>>> getAnnualRevenueTrend(int year) async {
    final List<MapEntry<String, double>> trend = [];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    for (int i = 1; i <= 12; i++) {
      final revenue = await getTotalRevenue(i, year);
      trend.add(MapEntry(monthNames[i - 1], revenue));
    }
    return trend;
  }

  // ─── Expense CRUD ──────────────────────────────────────────

  /// Get all expenses for a given month/year
  Future<List<Expense>> getExpensesByMonth(int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);

    return await _isar.expenses
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
  }

  /// Get total expenses for a month
  Future<double> getTotalExpenses(int month, int year) async {
    final expenses = await getExpensesByMonth(month, year);
    return expenses.fold<double>(0.0, (double sum, e) => sum + e.amount);
  }

  /// Get all unique category names (for dropdown)
  Future<List<String>> getExpenseCategories() async {
    final expenses = await _isar.expenses.where().findAll();
    final categories = expenses.map((e) => e.category).toSet().toList();
    categories.sort();
    return categories;
  }

  /// Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _isar.writeTxn(() async {
      await _isar.expenses.put(expense);
    });
  }

  /// Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    await _isar.writeTxn(() async {
      await _isar.expenses.put(expense);
    });
  }

  /// Delete an expense by ID
  Future<void> deleteExpense(int id) async {
    await _isar.writeTxn(() async {
      await _isar.expenses.delete(id);
    });
  }
}
