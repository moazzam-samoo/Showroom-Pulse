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

  /// Calculate revenue per sold bike: cashSalePrice - purchasePrice
  Future<double> getTotalRevenue(int month, int year) async {
    final sales = await getSalesByMonth(month, year);
    double total = 0;

    for (final sale in sales) {
      final bike = await _isar.bikes.get(sale.bikeId);
      if (bike != null) {
        total += bike.cashSalePrice - bike.purchasePrice;
      }
    }
    return total;
  }

  /// Revenue grouped by brand for a given month
  Future<Map<String, Map<String, double>>> getProfitByBrand(int month, int year) async {
    final sales = await getSalesByMonth(month, year);
    final Map<String, Map<String, double>> result = {};

    for (final sale in sales) {
      final bike = await _isar.bikes.get(sale.bikeId);
      if (bike == null) continue;

      final brand = bike.brand;
      result.putIfAbsent(brand, () => {'cash': 0, 'installment': 0, 'total': 0});

      final profit = bike.cashSalePrice - bike.purchasePrice;

      if (sale.saleType == SaleType.cash) {
        result[brand]!['cash'] = result[brand]!['cash']! + profit;
      } else {
        // For installment, markup = contract.totalAmount - cashSalePrice
        final contract = sale.installmentContractId != null
            ? await _isar.installmentContracts.get(sale.installmentContractId!)
            : null;
        final installmentMarkup = contract != null
            ? contract.totalAmount - bike.cashSalePrice
            : profit;
        result[brand]!['installment'] = result[brand]!['installment']! + installmentMarkup;
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

  /// Monthly revenue trend for line chart (last N months)
  Future<List<MapEntry<String, double>>> getRevenueTrend(int months) async {
    return getMonthlyProfitTrend(months);
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
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
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
