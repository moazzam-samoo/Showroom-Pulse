import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/data/models/investment.dart';
import 'package:tahir_showroom/app/features/investment/domain/investment_service.dart';
import 'package:tahir_showroom/app/features/investment/presentation/controllers/investment_controller.dart';
import 'package:tahir_showroom/app/features/investment/presentation/widgets/kpi_detail_dialog.dart';

/// Contains all 9 KPI detail popup builders for the Investment Management screen
class KpiDetailPopups {
  static final _currencyFormat = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs ', decimalDigits: 0);
  static final _dateFormat = DateFormat('dd MMM yyyy');

  // Helper for reactive content with filtering
  static Widget _buildReactiveContent<T>({
    required String title,
    required IconData icon,
    required Color accentColor,
    required Future<T> Function(DateTime? start, DateTime? end) dataFetcher,
    required Widget Function(T data, bool isDark) bodyBuilder,
    Widget Function(T data, bool isDark)? footerBuilder,
  }) {
    return _KpiDetailReactiveWrapper<T>(
      title: title,
      icon: icon,
      accentColor: accentColor,
      dataFetcher: dataFetcher,
      bodyBuilder: bodyBuilder,
      footerBuilder: footerBuilder,
    );
  }

  // ─── 1. Total Invested ─────────────────────────────────────
  static Future<void> showTotalInvested(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);

    showDialog(
      context: context,
      builder: (_) => _buildReactiveContent<List<Investment>>(
        title: 'Total Invested — Capital Injections',
        icon: Icons.account_balance_wallet,
        accentColor: const Color(0xFF3B82F6),
        dataFetcher: (start, end) async {
          final investments = await service.getInvestmentHistory(start: start, end: end);
          return investments.where((inv) => inv.type == InvestmentTypeEnum.capitalInjection).toList();
        },
        bodyBuilder: (data, isDark) => Table(
          border: TableBorder.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 0.5,
          ),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2.5),
            3: FlexColumnWidth(3),
            4: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: headerBg),
              children: const [
                KpiTableHeaderCell('#'),
                KpiTableHeaderCell('Date'),
                KpiTableHeaderCell('Category'),
                KpiTableHeaderCell('Description'),
                KpiTableHeaderCell('Amount', align: TextAlign.right),
              ],
            ),
            ...data.asMap().entries.map((e) {
              final idx = e.key;
              final inv = e.value;
              String catLabel;
              if (inv.category == InvestmentCategoryEnum.personalCapital) {
                catLabel = 'Personal Investment';
              } else if (inv.category == InvestmentCategoryEnum.loan) {
                catLabel = 'Loan Investment';
              } else if (inv.category == InvestmentCategoryEnum.partnership) {
                catLabel = 'Partnership Investment';
              } else {
                catLabel = 'Others Investment';
              }

              return TableRow(
                decoration: idx.isOdd ? BoxDecoration(color: altRowBg) : null,
                children: [
                  KpiTableCell('${idx + 1}'),
                  KpiTableCell(_dateFormat.format(inv.date)),
                  KpiTableCell(catLabel, color: const Color(0xFF22C55E)),
                  KpiTableCell(inv.description?.replaceAll('\u2014', '-') ?? '-'),
                  KpiTableCell(_currencyFormat.format(inv.amount), bold: true, align: TextAlign.right),
                ],
              );
            }),
          ],
        ),
        footerBuilder: (data, isDark) {
          double total = data.fold(0.0, (sum, inv) => sum + inv.amount);
          return Column(
            children: [
              KpiSummaryRow(label: 'Total Records', value: '${data.length}'),
              KpiSummaryRow(label: 'Grand Total', value: _currencyFormat.format(total), bold: true, valueColor: const Color(0xFF3B82F6)),
            ],
          );
        },
      ),
    );
  }

  // ─── 2. Available Cash ─────────────────────────────────────
  static Future<void> showAvailableCash(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
    final categories = ['Personal Capital', 'Partnership', 'Other', 'Loan'];

    showDialog(
      context: context,
      builder: (_) => _buildReactiveContent<Map<String, dynamic>>(
        title: 'Available Cash — Category Breakdown',
        icon: Icons.savings,
        accentColor: const Color(0xFF22C55E),
        dataFetcher: (start, end) async {
          final financials = await service.getCategoryFinancials(start: start, end: end);
          final activeBikes = await service.getActiveInventoryBikesDetail(); // Core inventory is always current
          
          double bikePersonal = 0, bikePartnership = 0, bikeOther = 0, bikeLoan = 0;
          for (final b in activeBikes) {
            bikePersonal += (b['fundedByPersonal'] as double?) ?? 0;
            bikePartnership += (b['fundedByPartnership'] as double?) ?? 0;
            bikeOther += (b['fundedByOther'] as double?) ?? 0;
            bikeLoan += (b['fundedByLoan'] as double?) ?? 0;
          }
          return {
            'fin': financials,
            'bikeFund': [bikePersonal, bikePartnership, bikeOther, bikeLoan]
          };
        },
        bodyBuilder: (data, isDark) {
          final List<CategoryFinancials> financials = data['fin'];
          final List<double> bikeAmounts = data['bikeFund'];
          
          return Table(
            border: TableBorder.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 0.5,
            ),
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: headerBg),
                children: const [
                  KpiTableHeaderCell('Category'),
                  KpiTableHeaderCell('Available Cash', align: TextAlign.right),
                  KpiTableHeaderCell('Invested on Bikes', align: TextAlign.right),
                  KpiTableHeaderCell('Earned Profit', align: TextAlign.right),
                ],
              ),
              ...financials.asMap().entries.map((e) {
                final idx = e.key;
                final fin = e.value;
                return TableRow(
                  decoration: idx.isOdd ? BoxDecoration(color: altRowBg) : null,
                  children: [
                    KpiTableCell(categories[idx], bold: true),
                    KpiTableCell(_currencyFormat.format(fin.available), align: TextAlign.right, color: const Color(0xFF22C55E)),
                    KpiTableCell(_currencyFormat.format(bikeAmounts[idx]), align: TextAlign.right, color: const Color(0xFFF59E0B)),
                    KpiTableCell(_currencyFormat.format(fin.earnedProfit), align: TextAlign.right, color: const Color(0xFF10B981)),
                  ],
                );
              }),
            ],
          );
        },
        footerBuilder: (data, isDark) {
          final List<CategoryFinancials> financials = data['fin'];
          final List<double> bikeAmounts = data['bikeFund'];
          final totalOnBikes = bikeAmounts.reduce((a, b) => a + b);
          
          return Column(
            children: [
              KpiSummaryRow(
                label: 'Total Available',
                value: _currencyFormat.format(financials.fold(0.0, (sum, c) => sum + c.available)),
                bold: true,
                valueColor: const Color(0xFF22C55E),
              ),
              KpiSummaryRow(
                label: 'Total on Bikes',
                value: _currencyFormat.format(totalOnBikes),
                valueColor: const Color(0xFFF59E0B),
              ),
              KpiSummaryRow(
                label: 'Total Earned Profit',
                value: _currencyFormat.format(financials.fold(0.0, (sum, c) => sum + c.earnedProfit)),
                valueColor: const Color(0xFF10B981),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── 3. Net Profit ─────────────────────────────────────────
  static Future<void> showNetProfit(BuildContext context) async {
    final controller = Get.find<InvestmentController>();
    final service = Get.find<InvestmentService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
    final categories = ['Personal Capital', 'Partnership', 'Other', 'Loan'];

    showDialog(
      context: context,
      builder: (_) => _buildReactiveContent<List<CategoryFinancials>>(
        title: 'Net Profit — Category Breakdown',
        icon: Icons.trending_up, // Static icon for consistency, can be dynamic
        accentColor: const Color(0xFF10B981),
        dataFetcher: (start, end) => service.getCategoryFinancials(start: start, end: end),
        bodyBuilder: (data, isDark) {
          final totalProfit = data.fold(0.0, (sum, c) => sum + c.earnedProfit);
          return Table(
            border: TableBorder.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 0.5,
            ),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: headerBg),
                children: const [
                  KpiTableHeaderCell('Category'),
                  KpiTableHeaderCell('Net Profit', align: TextAlign.right),
                  KpiTableHeaderCell('Share %', align: TextAlign.right),
                ],
              ),
              ...data.asMap().entries.map((e) {
                final idx = e.key;
                final fin = e.value;
                final share = totalProfit != 0 ? (fin.earnedProfit / totalProfit * 100) : 0.0;
                final profitColor = fin.earnedProfit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                return TableRow(
                  decoration: idx.isOdd ? BoxDecoration(color: altRowBg) : null,
                  children: [
                    KpiTableCell(categories[idx], bold: true),
                    KpiTableCell(_currencyFormat.format(fin.earnedProfit), bold: true, align: TextAlign.right, color: profitColor),
                    KpiTableCell('${share.toStringAsFixed(1)}%', align: TextAlign.right),
                  ],
                );
              }),
            ],
          );
        },
        footerBuilder: (data, isDark) {
          final totalProfit = data.fold(0.0, (sum, c) => sum + c.earnedProfit);
          return Column(
            children: [
              KpiSummaryRow(
                label: 'Total Net Profit',
                value: _currencyFormat.format(totalProfit),
                bold: true,
                valueColor: totalProfit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
              KpiSummaryRow(
                label: 'ROI',
                value: '${controller.roiPercentage.value.toStringAsFixed(1)}%',
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── 4. Sold & Completed Bikes ─────────────────────────────
  static Future<void> showSoldAndCompleted(BuildContext context) async {
    final service = Get.find<InvestmentService>();

    showDialog(
      context: context,
      builder: (_) => _buildReactiveContent<List<Map<String, dynamic>>>(
        title: 'Sold & Completed Bikes',
        icon: Icons.assignment_turned_in,
        accentColor: const Color(0xFF10B981),
        dataFetcher: (start, end) => service.getSoldAndCompletedBikesDetail(start: start, end: end),
        bodyBuilder: (data, isDark) {
          final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
          final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: data.asMap().entries.map((e) {
              final idx = e.key;
              final b = e.value;
              final profit = (b['profit'] as double?) ?? 0;
              final profitColor = profit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: idx.isOdd ? altRowBg : null,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${idx + 1}. ${b['bikeName']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: profitColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Profit: ${_currencyFormat.format(profit)}',
                            style: TextStyle(color: profitColor, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${b['color']} (${b['modelYear']}) • ${b['saleType']} • ${_dateFormat.format(b['saleDate'])}',
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('Purchase: ${_currencyFormat.format(b['purchasePrice'])}', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87)),
                        const SizedBox(width: 16),
                        Text('Sale: ${_currencyFormat.format(b['saleAmount'])}', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    FundingBreakdownRow(
                      personal: (b['fundedByPersonal'] as double?) ?? 0,
                      partnership: (b['fundedByPartnership'] as double?) ?? 0,
                      other: (b['fundedByOther'] as double?) ?? 0,
                      loan: (b['fundedByLoan'] as double?) ?? 0,
                      currencyFormat: _currencyFormat,
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
        footerBuilder: (data, isDark) {
          double totalPurchase = 0, totalProfit = 0;
          for (final b in data) {
            totalPurchase += (b['purchasePrice'] as double?) ?? 0;
            totalProfit += (b['profit'] as double?) ?? 0;
          }
          return Column(
            children: [
              KpiSummaryRow(label: 'Total Bikes Sold', value: '${data.length}'),
              KpiSummaryRow(label: 'Total Purchase Value', value: _currencyFormat.format(totalPurchase), bold: true),
              KpiSummaryRow(label: 'Total Profit', value: _currencyFormat.format(totalProfit), bold: true, valueColor: totalProfit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
            ],
          );
        },
      ),
    );
  }

  // ─── 5. Active Inventory Bikes ─────────────────────────────
  static Future<void> showActiveInventory(BuildContext context) async {
    final service = Get.find<InvestmentService>();

    showDialog(
      context: context,
      builder: (_) => _buildReactiveContent<List<Map<String, dynamic>>>(
        title: 'Active Inventory Bikes',
        icon: Icons.inventory_2,
        accentColor: const Color(0xFF6366F1),
        dataFetcher: (start, end) => service.getActiveInventoryBikesDetail(start: start, end: end),
        bodyBuilder: (data, isDark) {
          final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
          final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: data.asMap().entries.map((e) {
              final idx = e.key;
              final b = e.value;
              final statusColor = b['status'] == 'Available' ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: idx.isOdd ? altRowBg : null,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${idx + 1}. ${b['bikeName']}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(b['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${b['color']} (${b['modelYear']}) • Purchased: ${_dateFormat.format(b['purchaseDate'])}',
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text('Purchase Price: ${_currencyFormat.format(b['purchasePrice'])}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
                    const SizedBox(height: 4),
                    FundingBreakdownRow(
                      personal: (b['fundedByPersonal'] as double?) ?? 0,
                      partnership: (b['fundedByPartnership'] as double?) ?? 0,
                      other: (b['fundedByOther'] as double?) ?? 0,
                      loan: (b['fundedByLoan'] as double?) ?? 0,
                      currencyFormat: _currencyFormat,
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
        footerBuilder: (data, isDark) {
          double totalValue = data.fold(0.0, (sum, b) => sum + ((b['purchasePrice'] as double?) ?? 0));
          return Column(
            children: [
              KpiSummaryRow(label: 'Total Bikes', value: '${data.length}'),
              KpiSummaryRow(label: 'Total Purchase Value', value: _currencyFormat.format(totalValue), bold: true, valueColor: const Color(0xFF6366F1)),
            ],
          );
        },
      ),
    );
  }

  // ─── 6. Maintenance ────────────────────────────────────────
  static Future<void> showMaintenance(BuildContext context) async {
    final service = Get.find<InvestmentService>();

    showDialog(
      context: context,
      builder: (_) => _buildReactiveContent<List<Map<String, dynamic>>>(
        title: 'Maintenance Expenses',
        icon: Icons.build,
        accentColor: const Color(0xFFEAB308),
        dataFetcher: (start, end) => service.getMaintenanceDetail(start: start, end: end),
        bodyBuilder: (data, isDark) {
          final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
          final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
          
          return Table(
            border: TableBorder.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 0.5),
            columnWidths: const {
              0: FixedColumnWidth(40),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(3),
              3: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: headerBg),
                children: const [
                  KpiTableHeaderCell('#'),
                  KpiTableHeaderCell('Date'),
                  KpiTableHeaderCell('Description'),
                  KpiTableHeaderCell('Amount', align: TextAlign.right),
                ],
              ),
              ...data.asMap().entries.map((e) {
                final idx = e.key;
                final r = e.value;
                return TableRow(
                  decoration: idx.isOdd ? BoxDecoration(color: altRowBg) : null,
                  children: [
                    KpiTableCell('${idx + 1}'),
                    KpiTableCell(_dateFormat.format(r['date'])),
                    KpiTableCell(r['description'] ?? '-'),
                    KpiTableCell(_currencyFormat.format(r['amount']), bold: true, align: TextAlign.right),
                  ],
                );
              }),
            ],
          );
        },
        footerBuilder: (data, isDark) {
          double total = data.fold(0.0, (sum, r) => sum + ((r['amount'] as double?) ?? 0));
          return Column(
            children: [
              KpiSummaryRow(label: 'Total Records', value: '${data.length}'),
              KpiSummaryRow(label: 'Grand Total', value: _currencyFormat.format(total), bold: true, valueColor: const Color(0xFFEAB308)),
            ],
          );
        },
      ),
    );
  }


  // ─── 7. Total Expenses ─────────────────────────────────────
  static Future<void> showTotalExpenses(BuildContext context) async {
    final service = Get.find<InvestmentService>();

    showDialog(
      context: context,
      builder: (_) => _buildReactiveContent<List<Map<String, dynamic>>>(
        title: 'Total Expenses Breakdown',
        icon: Icons.receipt_long,
        accentColor: const Color(0xFFF97316),
        dataFetcher: (start, end) => service.getExpensesDetail(start: start, end: end),
        bodyBuilder: (data, isDark) {
          final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
          final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
          
          return Table(
            border: TableBorder.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 0.5),
            columnWidths: const {
              0: FixedColumnWidth(40),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(3),
              4: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: headerBg),
                children: const [
                  KpiTableHeaderCell('#'),
                  KpiTableHeaderCell('Date'),
                  KpiTableHeaderCell('Type'),
                  KpiTableHeaderCell('Description'),
                  KpiTableHeaderCell('Amount', align: TextAlign.right),
                ],
              ),
              ...data.asMap().entries.map((e) {
                final idx = e.key;
                final r = e.value;
                return TableRow(
                  decoration: idx.isOdd ? BoxDecoration(color: altRowBg) : null,
                  children: [
                    KpiTableCell('${idx + 1}'),
                    KpiTableCell(_dateFormat.format(r['date'])),
                    KpiTableCell(r['type'] ?? '-', color: const Color(0xFFF97316)),
                    KpiTableCell(r['description'] ?? '-'),
                    KpiTableCell(_currencyFormat.format(r['amount']), bold: true, align: TextAlign.right),
                  ],
                );
              }),
            ],
          );
        },
        footerBuilder: (data, isDark) {
          double total = data.fold(0.0, (sum, r) => sum + ((r['amount'] as double?) ?? 0));
          return Column(
            children: [
              KpiSummaryRow(label: 'Total Records', value: '${data.length}'),
              KpiSummaryRow(label: 'Grand Total', value: _currencyFormat.format(total), bold: true, valueColor: const Color(0xFFF97316)),
            ],
          );
        },
      ),
    );
  }

  // ─── 8. Future Payments ────────────────────────────────────
  static Future<void> showFuturePayments(BuildContext context) async {
    final service = Get.find<InvestmentService>();

    showDialog(
      context: context,
      builder: (_) => _buildReactiveContent<List<Map<String, dynamic>>>(
        title: 'Future Payments — Active Contracts',
        icon: Icons.update,
        accentColor: const Color(0xFFF59E0B),
        dataFetcher: (start, end) => service.getFuturePaymentsDetail(start: start, end: end),
        bodyBuilder: (data, isDark) {
          final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
          final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: data.asMap().entries.map((e) {
              final idx = e.key;
              final c = e.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: idx.isOdd ? altRowBg : null,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${idx + 1}. ${c['bikeName']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                        Text(_currencyFormat.format(c['remainingBalance']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFF59E0B))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'EMI: ${_currencyFormat.format(c['monthlyEMI'])} • ${c['paymentsRemaining']} payments left',
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    FundingBreakdownRow(
                      personal: (c['sharePersonal'] as double?) ?? 0,
                      partnership: (c['sharePartnership'] as double?) ?? 0,
                      other: (c['shareOther'] as double?) ?? 0,
                      loan: (c['shareLoan'] as double?) ?? 0,
                      currencyFormat: _currencyFormat,
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
        footerBuilder: (data, isDark) {
          double totalRemaining = 0;
          double totalPersonal = 0, totalPartnership = 0, totalOther = 0, totalLoan = 0;
          for (final c in data) {
            totalRemaining += (c['remainingBalance'] as double?) ?? 0;
            totalPersonal += (c['sharePersonal'] as double?) ?? 0;
            totalPartnership += (c['sharePartnership'] as double?) ?? 0;
            totalOther += (c['shareOther'] as double?) ?? 0;
            totalLoan += (c['shareLoan'] as double?) ?? 0;
          }
          return Column(
            children: [
              KpiSummaryRow(label: 'Active Contracts', value: '${data.length}'),
              KpiSummaryRow(label: 'Total Future Payment', value: _currencyFormat.format(totalRemaining), bold: true, valueColor: const Color(0xFFF59E0B)),
              const SizedBox(height: 4),
              KpiSummaryRow(label: 'Personal will get', value: _currencyFormat.format(totalPersonal)),
              KpiSummaryRow(label: 'Partnership will get', value: _currencyFormat.format(totalPartnership)),
              KpiSummaryRow(label: 'Other will get', value: _currencyFormat.format(totalOther)),
              KpiSummaryRow(label: 'Loan will get', value: _currencyFormat.format(totalLoan)),
            ],
          );
        },
      ),
    );
  }

  // ─── 9. Future Profit ──────────────────────────────────────
  static Future<void> showFutureProfit(BuildContext context) async {
    final service = Get.find<InvestmentService>();

    showDialog(
      context: context,
      builder: (_) => _buildReactiveContent<List<Map<String, dynamic>>>(
        title: 'Future Profit — Active Contracts',
        icon: Icons.auto_graph,
        accentColor: const Color(0xFF8B5CF6),
        dataFetcher: (start, end) => service.getFutureProfitDetail(start: start, end: end),
        bodyBuilder: (data, isDark) {
          final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
          final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: data.asMap().entries.map((e) {
              final idx = e.key;
              final c = e.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: idx.isOdd ? altRowBg : null,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${idx + 1}. ${c['bikeName']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                        Text(_currencyFormat.format(c['futureProfit']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF8B5CF6))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Total Profit Potential: ${_currencyFormat.format(c['totalProfitPotential'])}',
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    FundingBreakdownRow(
                      personal: (c['sharePersonal'] as double?) ?? 0,
                      partnership: (c['sharePartnership'] as double?) ?? 0,
                      other: (c['shareOther'] as double?) ?? 0,
                      loan: (c['shareLoan'] as double?) ?? 0,
                      currencyFormat: _currencyFormat,
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
        footerBuilder: (data, isDark) {
          double totalFutureProfit = 0;
          double totalPersonal = 0, totalPartnership = 0, totalOther = 0, totalLoan = 0;
          for (final c in data) {
            totalFutureProfit += (c['futureProfit'] as double?) ?? 0;
            totalPersonal += (c['sharePersonal'] as double?) ?? 0;
            totalPartnership += (c['sharePartnership'] as double?) ?? 0;
            totalOther += (c['shareOther'] as double?) ?? 0;
            totalLoan += (c['shareLoan'] as double?) ?? 0;
          }
          return Column(
            children: [
              KpiSummaryRow(label: 'Active Contracts', value: '${data.length}'),
              KpiSummaryRow(label: 'Total Future Profit', value: _currencyFormat.format(totalFutureProfit), bold: true, valueColor: const Color(0xFF8B5CF6)),
              const SizedBox(height: 4),
              KpiSummaryRow(label: 'Personal will get', value: _currencyFormat.format(totalPersonal)),
              KpiSummaryRow(label: 'Partnership will get', value: _currencyFormat.format(totalPartnership)),
              KpiSummaryRow(label: 'Other will get', value: _currencyFormat.format(totalOther)),
              KpiSummaryRow(label: 'Loan will get', value: _currencyFormat.format(totalLoan)),
            ],
          );
        },
      ),
    );
  }

}

// ─────────────────────────────────────────────────────────────
// REACTIVE WRAPPER COMPONENTS
// ─────────────────────────────────────────────────────────────

class _KpiDetailReactiveWrapper<T> extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final Future<T> Function(DateTime? start, DateTime? end) dataFetcher;
  final Widget Function(T data, bool isDark) bodyBuilder;
  final Widget Function(T data, bool isDark)? footerBuilder;

  const _KpiDetailReactiveWrapper({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.dataFetcher,
    required this.bodyBuilder,
    this.footerBuilder,
  });

  @override
  State<_KpiDetailReactiveWrapper<T>> createState() => _KpiDetailReactiveWrapperState<T>();
}

class _KpiDetailReactiveWrapperState<T> extends State<_KpiDetailReactiveWrapper<T>> {
  final Rx<InvestmentFilter> _currentFilter = InvestmentFilter.all.obs;
  final RxInt _selectedMonth = DateTime.now().month.obs;
  final RxInt _selectedYear = DateTime.now().year.obs;
  final RxBool _isLoading = true.obs;
  T? _data;
  final List<Worker> _workers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    // Re-load when filter changes
    _workers.add(ever(_currentFilter, (_) => _loadData()));
    _workers.add(ever(_selectedMonth, (_) => _loadData()));
    _workers.add(ever(_selectedYear, (_) => _loadData()));
  }

  @override
  void dispose() {
    for (var w in _workers) {
      w.dispose();
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    _isLoading.value = true;
    final range = _getDateRange(_currentFilter.value);
    _data = await widget.dataFetcher(range.start, range.end);
    _isLoading.value = false;
  }

  ({DateTime? start, DateTime? end}) _getDateRange(InvestmentFilter filter) {
    final now = DateTime.now();
    switch (filter) {
      case InvestmentFilter.weekly:
        return (start: now.subtract(const Duration(days: 7)), end: now);
      case InvestmentFilter.monthly:
        return (start: DateTime(now.year, now.month, 1), end: now);
      case InvestmentFilter.yearly:
        return (start: DateTime(now.year, 1, 1), end: now);
      case InvestmentFilter.all:
        return (start: null, end: null);
      case InvestmentFilter.custom:
        final start = DateTime(_selectedYear.value, _selectedMonth.value, 1);
        final end = DateTime(_selectedYear.value, _selectedMonth.value + 1, 0, 23, 59, 59);
        return (start: start, end: end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);

    return Obx(() {
      return KpiDetailDialog(
        title: widget.title,
        icon: widget.icon,
        accentColor: widget.accentColor,
        topFilter: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text("Time: ", style: TextStyle(color: textCol.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              _buildDateChip('All Time', InvestmentFilter.all),
              const SizedBox(width: 4),
              _buildDateChip('Week', InvestmentFilter.weekly),
              const SizedBox(width: 4),
              _buildDateChip('Month', InvestmentFilter.monthly),
              const SizedBox(width: 4),
              _buildDateChip('Year', InvestmentFilter.yearly),
              const SizedBox(width: 12),
              Container(height: 20, width: 1, color: isDark ? Colors.white24 : Colors.black12),
              const SizedBox(width: 12),
              _buildDropdownFilters(isDark),
            ],
          ),
        ),
        body: _isLoading.value
            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
            : widget.bodyBuilder(_data as T, isDark),
        footer: (_isLoading.value || _data == null || widget.footerBuilder == null)
            ? null
            : widget.footerBuilder!(_data as T, isDark),
      );
    });
  }

  Widget _buildDropdownFilters(bool isDark) {
    final textStyle = TextStyle(fontSize: 11, color: isDark ? Colors.white : Colors.black87);
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    // Years from 2024 to current
    final currentYear = DateTime.now().year;
    final years = List.generate(currentYear - 2024 + 1, (i) => 2024 + i).reversed.toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month Dropdown
        _buildDropdown<int>(
          value: _selectedMonth.value,
          items: List.generate(12, (i) => DropdownMenuItem(
            value: i + 1,
            child: Text(months[i], style: textStyle),
          )),
          onChanged: (val) {
            if (val != null) {
              _selectedMonth.value = val;
              _currentFilter.value = InvestmentFilter.custom;
            }
          },
          isDark: isDark,
          hint: 'Month',
        ),
        const SizedBox(width: 8),
        // Year Dropdown
        _buildDropdown<int>(
          value: _selectedYear.value,
          items: years.map((y) => DropdownMenuItem(
            value: y,
            child: Text('$y', style: textStyle),
          )).toList(),
          onChanged: (val) {
            if (val != null) {
              _selectedYear.value = val;
              _currentFilter.value = InvestmentFilter.custom;
            }
          },
          isDark: isDark,
          hint: 'Year',
        ),
      ],
    );
  }

  Widget _buildDropdown<V>({
    required V value,
    required List<DropdownMenuItem<V>> items,
    required ValueChanged<V?> onChanged,
    required bool isDark,
    required String hint,
  }) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<V>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.arrow_drop_down, size: 18, color: isDark ? Colors.white54 : Colors.black54),
          style: TextStyle(fontSize: 11, color: isDark ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildDateChip(String label, InvestmentFilter filter) {
    final isSelected = _currentFilter.value == filter;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ChoiceChip(
      label: Text(label, style: TextStyle(
          fontSize: 11, 
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      )),
      selected: isSelected,
      onSelected: (val) {
        if (val) _currentFilter.value = filter;
      },
      selectedColor: widget.accentColor,
      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
