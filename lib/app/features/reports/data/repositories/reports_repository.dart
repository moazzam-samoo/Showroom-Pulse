import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';

/// Repository for revenue calculations
class ReportsRepository {
  final Isar _isar;

  ReportsRepository(this._isar);

  // ─── Revenue Queries ───────────────────────────────────────

  /// Get all sales in a given range (optional month/year)
  Future<List<Sale>> getSalesInPeriod({int? month, int? year}) async {
    if (month == null && year == null) {
      // All time
      return await _isar.sales.where().findAll();
    }
    
    final start = DateTime(year!, month ?? 1, 1);
    final end = month != null 
        ? DateTime(year, month + 1, 0, 23, 59, 59)
        : DateTime(year, 12, 31, 23, 59, 59);

    return await _isar.sales
        .filter()
        .saleDateBetween(start, end)
        .findAll();
  }

  /// Calculate total revenue using proportional recognition
  Future<double> getTotalRevenue({int? month, int? year}) async {
    final sales = await getSalesInPeriod(month: month, year: year);
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

      if (sale.saleType == SaleType.installment) {
        if (sale.installmentContractId == null) continue;
        final contract = await _isar.installmentContracts.get(sale.installmentContractId!);
        if (contract == null || contract.status != ContractStatusEnum.completed) {
          continue; // Skip active installments entirely
        }
        
        // If completed installment, add base profit and markup
        total += baseProfit.isNaN ? 0.0 : baseProfit;
        total += contract.totalMarkupAmount.isNaN ? 0.0 : contract.totalMarkupAmount;
      } else if (sale.saleType == SaleType.cash) {
        total += baseProfit.isNaN ? 0.0 : baseProfit;
      }
    }
    return total;
  }

  /// Revenue grouped by brand — full amounts + earned (proportional recovery)
  Future<Map<String, Map<String, double>>> getProfitByBrand({int? month, int? year}) async {
    final sales = await getSalesInPeriod(month: month, year: year);
    final Map<String, Map<String, double>> result = {};

    for (final sale in sales) {
      final bike = await _isar.bikes.get(sale.bikeId);
      if (bike == null) continue;

      // 1. Early Skip for Incomplete Installments
      if (sale.saleType == SaleType.installment) {
        if (sale.installmentContractId == null) continue;
        final contract = await _isar.installmentContracts.get(sale.installmentContractId!);
        if (contract == null || contract.status != ContractStatusEnum.completed) {
          continue; // Skip active installments entirely
        }
      }

      // 2. Consistent Naming (BRAND MODEL YEAR)
      final brandUpper = bike.brand.trim().toUpperCase();
      final modelUpper = bike.model.trim().toUpperCase();
      final detailName = "$brandUpper $modelUpper MODEL ${bike.modelYear}";

      // If no month is specified, group by Month-Year | Details
      final String groupKey;
      if (month == null) {
        final monthStr = DateFormat('MMM yyyy').format(sale.saleDate);
        groupKey = "$monthStr | $detailName";
      } else {
        groupKey = detailName;
      }

      result.putIfAbsent(groupKey,
          () => {'cash': 0, 'installment': 0, 'total': 0, 'earned': 0, 'assetValue': 0});

      final pPrice = bike.purchasePrice.isNaN ? 0.0 : bike.purchasePrice;
      final sPrice = bike.cashSalePrice.isNaN ? 0.0 : bike.cashSalePrice;
      
      double dAmt = sale.discountAmount.isNaN ? 0.0 : sale.discountAmount;
      if (sale.saleType == SaleType.cash && dAmt == 0.0) {
        final double received = sale.receivedAmount.isNaN ? 0.0 : sale.receivedAmount;
        if (received > 0 && received < sPrice) {
          dAmt = sPrice - received;
        }
      }
      
      final baseProfit = sPrice - pPrice - dAmt;

      if (sale.saleType == SaleType.cash) {
        final profit = baseProfit.isNaN ? 0.0 : baseProfit;
        result[groupKey]!['cash'] = result[groupKey]!['cash']! + profit;
        result[groupKey]!['earned'] = result[groupKey]!['earned']! + profit;
        result[groupKey]!['assetValue'] = result[groupKey]!['assetValue']! + sPrice;
        result[groupKey]!['total'] = result[groupKey]!['total']! + profit;
      } else {
        // Must be completed installment due to early skip
        final contract = (await _isar.installmentContracts.get(sale.installmentContractId!))!;
        final markup = contract.totalMarkupAmount.isNaN ? 0.0 : contract.totalMarkupAmount;
        final profitPart = baseProfit.isNaN ? 0.0 : baseProfit;

        result[groupKey]!['installment'] = result[groupKey]!['installment']! + markup;
        result[groupKey]!['earned'] = result[groupKey]!['earned']! + profitPart + markup;
        result[groupKey]!['assetValue'] = result[groupKey]!['assetValue']! + contract.totalAmount;
        result[groupKey]!['total'] = result[groupKey]!['total']! + profitPart + markup;
      }
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
      final revenue = await getTotalRevenue(month: date.month, year: date.year);
      trend.add(MapEntry(monthNames[date.month - 1], revenue));
    }
    return trend;
  }

  /// Get monthly revenue breakdown for a specific year (for Yearly Report)
  Future<List<MapEntry<String, double>>> getYearlyRevenueBreakdown(int year) async {
    final List<MapEntry<String, double>> trend = [];
    final monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    for (int i = 1; i <= 12; i++) {
      final revenue = await getTotalRevenue(month: i, year: year);
      trend.add(MapEntry(monthNames[i - 1], revenue));
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

      if (sale.saleType == SaleType.installment) {
        if (sale.installmentContractId == null) continue;
        final contract = await _isar.installmentContracts.get(sale.installmentContractId!);
        if (contract == null || contract.status != ContractStatusEnum.completed) {
          continue; // Skip active installments entirely
        }
        
        // Full base profit and markup only if completed
        dailyRevenue[day] = dailyRevenue[day]! + (baseProfit.isNaN ? 0.0 : baseProfit);
        dailyRevenue[day] = dailyRevenue[day]! + (contract.totalMarkupAmount.isNaN ? 0.0 : contract.totalMarkupAmount);
      } else if (sale.saleType == SaleType.cash) {
        final profit = baseProfit.isNaN ? 0.0 : baseProfit;
        dailyRevenue[day] = dailyRevenue[day]! + profit;
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
      final revenue = await getTotalRevenue(month: i, year: year);
      trend.add(MapEntry(monthNames[i - 1], revenue));
    }
    return trend;
  }
}
