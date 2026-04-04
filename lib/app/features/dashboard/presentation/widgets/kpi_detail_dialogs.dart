import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/utils/price_formatter.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/sale.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';

class KpiDetailDialogs {
  static final _isar = Get.find<IsarService>().isar;

  // --- 1. Total Asset Value Dialog ---
  static Future<void> showAssetValueDialog(BuildContext context) async {
    final bikes = await _isar.bikes.filter().statusEqualTo(BikeStatusEnum.available).findAll();
    
    // Group by model
    final Map<String, List<Bike>> groupedBikes = {};
    for (var bike in bikes) {
      if (!groupedBikes.containsKey(bike.model)) groupedBikes[bike.model] = [];
      groupedBikes[bike.model]!.add(bike);
    }

    final totalAssetValue = bikes.fold<double>(0, (sum, b) => sum + b.purchasePrice);

    _showDialog(
      context: context,
      title: 'Asset Value Breakdown',
      content: groupedBikes.isEmpty 
        ? _buildEmptyState('No available bikes in inventory.')
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTableHeader(['Horse Power', 'Count', 'Unit Price', 'Total Value']),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: groupedBikes.entries.map((entry) {
                      final model = entry.key;
                      final count = entry.value.length;
                      // Assume all bikes of same model have similar purchase price for simplicity
                      final unitPrice = entry.value.first.purchasePrice; 
                      final totalValue = count * unitPrice;
                      
                      return _buildTableRow([
                        model,
                        '$count',
                        PriceFormatter.formatPKR(unitPrice),
                        PriceFormatter.formatPKR(totalValue),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              const Divider(),
              _buildTableFooter('Grand Total', PriceFormatter.formatPKR(totalAssetValue)),
            ],
          ),
    );
  }

  // --- 2. Units In Stock Dialog ---
  static Future<void> showStockDialog(BuildContext context) async {
    final bikes = await _isar.bikes.filter().statusEqualTo(BikeStatusEnum.available).findAll();
    
    // Group by model
    final Map<String, List<Bike>> groupedBikes = {};
    for (var bike in bikes) {
      if (!groupedBikes.containsKey(bike.model)) groupedBikes[bike.model] = [];
      groupedBikes[bike.model]!.add(bike);
    }

    final totalValue = bikes.fold<double>(0, (sum, b) => sum + b.purchasePrice);

    _showDialog(
      context: context,
      title: 'Available Stock Breakdown',
      content: bikes.isEmpty
        ? _buildEmptyState('No available bikes in stock.')
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTableHeader(['Horse Power', 'Units', 'Unit Price', 'Total Value']),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: groupedBikes.entries.map((entry) {
                      final model = entry.key;
                      final count = entry.value.length;
                      final unitPrice = entry.value.first.purchasePrice;
                      final totalModelValue = count * unitPrice;

                      return _buildTableRow([
                        model,
                        '$count',
                        PriceFormatter.formatPKR(unitPrice),
                        PriceFormatter.formatPKR(totalModelValue),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              const Divider(),
              _buildTableFooter('Grand Total', PriceFormatter.formatPKR(totalValue)),
            ],
          ),
    );
  }

  // --- 3. Monthly Sales Revenue Dialog ---
  static Future<void> showRevenueDialog(BuildContext context) async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    
    final sales = await _isar.sales
        .filter()
        .saleDateBetween(firstDayOfMonth, now)
        .sortBySaleDateDesc()
        .findAll();

    final totalRev = sales.fold<double>(0, (sum, s) => sum + s.receivedAmount);

    _showDialog(
      context: context,
      title: 'This Month\'s Sales',
      content: sales.isEmpty
        ? _buildEmptyState('No sales recorded this month.')
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTableHeader(['Date', 'Customer', 'Type', 'Amount']),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: sales.map((sale) {
                      final customer = _isar.customers.getSync(sale.customerId);
                      return _buildTableRow([
                        DateFormat('dd MMM').format(sale.saleDate),
                        customer?.fullName ?? 'Unknown',
                        sale.saleType == SaleType.cash ? 'Cash' : 'Inst.',
                        PriceFormatter.formatPKR(sale.receivedAmount),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              const Divider(),
              _buildTableFooter('${sales.length} Sales', PriceFormatter.formatPKR(totalRev)),
            ],
          ),
    );
  }

  // --- 4. Total Installment Value Dialog ---
  static Future<void> showInstallmentDialog(BuildContext context) async {
    final contracts = await _isar.installmentContracts
        .filter()
        .not().statusEqualTo(ContractStatusEnum.completed)
        .and()
        .not().statusEqualTo(ContractStatusEnum.defaulted)
        .findAll();

    final totalRemaining = contracts.fold<double>(0, (sum, c) => sum + c.remainingBalance);

    _showDialog(
      context: context,
      title: 'Active Installment Contracts',
      width: 700, // wider for more columns
      content: contracts.isEmpty
        ? _buildEmptyState('No active installment contracts.')
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTableHeader(['Customer', 'Total', 'Paid', 'Remaining']),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: contracts.map((c) {
                      final customer = _isar.customers.getSync(c.customerId);
                      return _buildTableRow([
                        customer?.fullName ?? 'Unknown',
                        PriceFormatter.formatPKR(c.totalAmount),
                        PriceFormatter.formatPKR(c.totalAmount - c.remainingBalance),
                        PriceFormatter.formatPKR(c.remainingBalance),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              const Divider(),
              _buildTableFooter('Total Receivable', PriceFormatter.formatPKR(totalRemaining)),
            ],
          ),
    );
  }

  // --- Helper Methods ---

  static void _showDialog({
    required BuildContext context, 
    required String title, 
    required Widget content,
    double width = 500,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
            IconButton(
              icon: Icon(Icons.close, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        content: SizedBox(
          width: width,
          height: 400, // Fixed height for scrolling
          child: content,
        ),
      ),
    );
  }

  static Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }


  static Widget _buildTableHeader(List<String> headers) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: Colors.grey.withOpacity(0.1),
      child: Row(
        children: headers.map((h) => Expanded(
          child: Text(h, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
        )).toList(),
      ),
    );
  }

  static Widget _buildTableRow(List<String> cells) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: cells.map((c) => Expanded(
          child: Text(c, style: const TextStyle(fontSize: 13)),
        )).toList(),
      ),
    );
  }

  static Widget _buildTableFooter(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
        ],
      ),
    );
  }
}
