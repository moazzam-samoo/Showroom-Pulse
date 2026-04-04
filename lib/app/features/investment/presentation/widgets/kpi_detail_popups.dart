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

  // ─── 1. Total Invested ─────────────────────────────────────
  static Future<void> showTotalInvested(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final investments = await service.getInvestmentHistory();
    final capitalInvestments = investments
        .where((inv) => inv.type == InvestmentTypeEnum.capitalInjection)
        .toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);

    double total = capitalInvestments.fold(0.0, (sum, inv) => sum + inv.amount);

    showDialog(
      context: context,
      builder: (_) => KpiDetailDialog(
        title: 'Total Invested — Capital Injections',
        icon: Icons.account_balance_wallet,
        accentColor: const Color(0xFF3B82F6),
        body: Table(
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
            ...capitalInvestments.asMap().entries.map((e) {
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
        footer: Column(
          children: [
            KpiSummaryRow(label: 'Total Records', value: '${capitalInvestments.length}'),
            KpiSummaryRow(label: 'Grand Total', value: _currencyFormat.format(total), bold: true, valueColor: const Color(0xFF3B82F6)),
          ],
        ),
      ),
    );
  }

  // ─── 2. Available Cash ─────────────────────────────────────
  static Future<void> showAvailableCash(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final financials = await service.getCategoryFinancials();
    
    // Get bike funding per category for active bikes
    final activeBikes = await service.getActiveInventoryBikesDetail();
    double bikePersonal = 0, bikePartnership = 0, bikeOther = 0, bikeLoan = 0;
    for (final b in activeBikes) {
      bikePersonal += (b['fundedByPersonal'] as double?) ?? 0;
      bikePartnership += (b['fundedByPartnership'] as double?) ?? 0;
      bikeOther += (b['fundedByOther'] as double?) ?? 0;
      bikeLoan += (b['fundedByLoan'] as double?) ?? 0;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
    final categories = ['Personal Capital', 'Partnership', 'Other', 'Loan'];
    final bikeAmounts = [bikePersonal, bikePartnership, bikeOther, bikeLoan];

    showDialog(
      context: context,
      builder: (_) => KpiDetailDialog(
        title: 'Available Cash — Category Breakdown',
        icon: Icons.savings,
        accentColor: const Color(0xFF22C55E),
        body: Table(
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
        ),
        footer: Column(
          children: [
            KpiSummaryRow(
              label: 'Total Available',
              value: _currencyFormat.format(financials.fold(0.0, (sum, c) => sum + c.available)),
              bold: true,
              valueColor: const Color(0xFF22C55E),
            ),
            KpiSummaryRow(
              label: 'Total on Bikes',
              value: _currencyFormat.format(bikePersonal + bikePartnership + bikeOther + bikeLoan),
              valueColor: const Color(0xFFF59E0B),
            ),
            KpiSummaryRow(
              label: 'Total Earned Profit',
              value: _currencyFormat.format(financials.fold(0.0, (sum, c) => sum + c.earnedProfit)),
              valueColor: const Color(0xFF10B981),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 3. Net Profit ─────────────────────────────────────────
  static Future<void> showNetProfit(BuildContext context) async {
    final controller = Get.find<InvestmentController>();
    final service = Get.find<InvestmentService>();
    final financials = await service.getCategoryFinancials();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
    final categories = ['Personal Capital', 'Partnership', 'Other', 'Loan'];
    final totalProfit = financials.fold(0.0, (sum, c) => sum + c.earnedProfit);

    showDialog(
      context: context,
      builder: (_) => KpiDetailDialog(
        title: 'Net Profit — Category Breakdown',
        icon: totalProfit >= 0 ? Icons.trending_up : Icons.trending_down,
        accentColor: totalProfit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
        body: Table(
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
            ...financials.asMap().entries.map((e) {
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
        ),
        footer: Column(
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
        ),
      ),
    );
  }

  // ─── 4. Sold & Completed Bikes ─────────────────────────────
  static Future<void> showSoldAndCompleted(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final bikes = await service.getSoldAndCompletedBikesDetail();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    double totalPurchase = 0, totalProfit = 0;
    for (final b in bikes) {
      totalPurchase += (b['purchasePrice'] as double?) ?? 0;
      totalProfit += (b['profit'] as double?) ?? 0;
    }

    showDialog(
      context: context,
      builder: (_) => KpiDetailDialog(
        title: 'Sold & Completed Bikes',
        icon: Icons.assignment_turned_in,
        accentColor: const Color(0xFF10B981),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: bikes.asMap().entries.map((e) {
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
        ),
        footer: Column(
          children: [
            KpiSummaryRow(label: 'Total Bikes Sold', value: '${bikes.length}'),
            KpiSummaryRow(label: 'Total Purchase Value', value: _currencyFormat.format(totalPurchase), bold: true),
            KpiSummaryRow(label: 'Total Profit', value: _currencyFormat.format(totalProfit), bold: true, valueColor: totalProfit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
          ],
        ),
      ),
    );
  }

  // ─── 5. Active Inventory Bikes ─────────────────────────────
  static Future<void> showActiveInventory(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final bikes = await service.getActiveInventoryBikesDetail();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    double totalValue = bikes.fold(0.0, (sum, b) => sum + ((b['purchasePrice'] as double?) ?? 0));

    showDialog(
      context: context,
      builder: (_) => KpiDetailDialog(
        title: 'Active Inventory Bikes',
        icon: Icons.inventory_2,
        accentColor: const Color(0xFF6366F1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: bikes.asMap().entries.map((e) {
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
        ),
        footer: Column(
          children: [
            KpiSummaryRow(label: 'Total Bikes', value: '${bikes.length}'),
            KpiSummaryRow(label: 'Total Purchase Value', value: _currencyFormat.format(totalValue), bold: true, valueColor: const Color(0xFF6366F1)),
          ],
        ),
      ),
    );
  }

  // ─── 6. Maintenance ────────────────────────────────────────
  static Future<void> showMaintenance(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final records = await service.getMaintenanceDetail();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);

    double total = records.fold(0.0, (sum, r) => sum + ((r['amount'] as double?) ?? 0));

    showDialog(
      context: context,
      builder: (_) => KpiDetailDialog(
        title: 'Maintenance Expenses',
        icon: Icons.build,
        accentColor: const Color(0xFFEAB308),
        body: Table(
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
            ...records.asMap().entries.map((e) {
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
        ),
        footer: Column(
          children: [
            KpiSummaryRow(label: 'Total Records', value: '${records.length}'),
            KpiSummaryRow(label: 'Grand Total', value: _currencyFormat.format(total), bold: true, valueColor: const Color(0xFFEAB308)),
          ],
        ),
      ),
    );
  }

  // ─── 7. Total Expenses ─────────────────────────────────────
  static Future<void> showTotalExpenses(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final records = await service.getExpensesDetail();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);

    double total = records.fold(0.0, (sum, r) => sum + ((r['amount'] as double?) ?? 0));

    showDialog(
      context: context,
      builder: (_) => KpiDetailDialog(
        title: 'Total Expenses Breakdown',
        icon: Icons.receipt_long,
        accentColor: const Color(0xFFF97316),
        body: Table(
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
            ...records.asMap().entries.map((e) {
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
        ),
        footer: Column(
          children: [
            KpiSummaryRow(label: 'Total Records', value: '${records.length}'),
            KpiSummaryRow(label: 'Grand Total', value: _currencyFormat.format(total), bold: true, valueColor: const Color(0xFFF97316)),
          ],
        ),
      ),
    );
  }

  // ─── 8. Future Payments ────────────────────────────────────
  static Future<void> showFuturePayments(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final contracts = await service.getFuturePaymentsDetail();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    double totalRemaining = 0;
    double totalPersonal = 0, totalPartnership = 0, totalOther = 0, totalLoan = 0;
    for (final c in contracts) {
      totalRemaining += (c['remainingBalance'] as double?) ?? 0;
      totalPersonal += (c['sharePersonal'] as double?) ?? 0;
      totalPartnership += (c['sharePartnership'] as double?) ?? 0;
      totalOther += (c['shareOther'] as double?) ?? 0;
      totalLoan += (c['shareLoan'] as double?) ?? 0;
    }

    showDialog(
      context: context,
      builder: (_) => KpiDetailDialog(
        title: 'Future Payments — Active Contracts',
        icon: Icons.update,
        accentColor: const Color(0xFFF59E0B),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: contracts.asMap().entries.map((e) {
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
        ),
        footer: Column(
          children: [
            KpiSummaryRow(label: 'Active Contracts', value: '${contracts.length}'),
            KpiSummaryRow(label: 'Total Future Payment', value: _currencyFormat.format(totalRemaining), bold: true, valueColor: const Color(0xFFF59E0B)),
            const SizedBox(height: 4),
            KpiSummaryRow(label: 'Personal will get', value: _currencyFormat.format(totalPersonal)),
            KpiSummaryRow(label: 'Partnership will get', value: _currencyFormat.format(totalPartnership)),
            KpiSummaryRow(label: 'Other will get', value: _currencyFormat.format(totalOther)),
            KpiSummaryRow(label: 'Loan will get', value: _currencyFormat.format(totalLoan)),
          ],
        ),
      ),
    );
  }

  // ─── 9. Future Profit ──────────────────────────────────────
  static Future<void> showFutureProfit(BuildContext context) async {
    final service = Get.find<InvestmentService>();
    final contracts = await service.getFutureProfitDetail();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final altRowBg = isDark ? const Color(0xFF162032) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    double totalFutureProfit = 0;
    double totalPersonal = 0, totalPartnership = 0, totalOther = 0, totalLoan = 0;
    for (final c in contracts) {
      totalFutureProfit += (c['futureProfit'] as double?) ?? 0;
      totalPersonal += (c['sharePersonal'] as double?) ?? 0;
      totalPartnership += (c['sharePartnership'] as double?) ?? 0;
      totalOther += (c['shareOther'] as double?) ?? 0;
      totalLoan += (c['shareLoan'] as double?) ?? 0;
    }

    showDialog(
      context: context,
      builder: (_) => KpiDetailDialog(
        title: 'Future Profit — Active Contracts',
        icon: Icons.auto_graph,
        accentColor: const Color(0xFF8B5CF6),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: contracts.asMap().entries.map((e) {
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
        ),
        footer: Column(
          children: [
            KpiSummaryRow(label: 'Active Contracts', value: '${contracts.length}'),
            KpiSummaryRow(label: 'Total Future Profit', value: _currencyFormat.format(totalFutureProfit), bold: true, valueColor: const Color(0xFF8B5CF6)),
            const SizedBox(height: 4),
            KpiSummaryRow(label: 'Personal will get', value: _currencyFormat.format(totalPersonal)),
            KpiSummaryRow(label: 'Partnership will get', value: _currencyFormat.format(totalPartnership)),
            KpiSummaryRow(label: 'Other will get', value: _currencyFormat.format(totalOther)),
            KpiSummaryRow(label: 'Loan will get', value: _currencyFormat.format(totalLoan)),
          ],
        ),
      ),
    );
  }
}
