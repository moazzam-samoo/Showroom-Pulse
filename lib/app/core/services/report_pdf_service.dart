import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/data/models/app_settings.dart';
import 'package:tahir_showroom/app/data/models/expense.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';

/// PDF generation service for Reports & Revenue tabs
class ReportPdfService {
  final _currencyFormat = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs ',
    decimalDigits: 0,
  );
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _monthYearFormat = DateFormat('MMMM yyyy');

  // ─── Colors ──────────────────────────────────────────────
  static const _primaryColor = PdfColor.fromInt(0xFF00BCD4);    // Cyan
  static const _successColor = PdfColor.fromInt(0xFF10B981);    // Green
  static const _warningColor = PdfColor.fromInt(0xFFF59E0B);    // Orange
  static const _headerBg = PdfColor.fromInt(0xFF0A0E17);        // Dark navy
  static const _rowAltBg = PdfColor.fromInt(0xFFF8FAFC);        // Light alt row

  // ═══════════════════════════════════════════════════════════
  //  REPORTS TAB — Monthly Profit Report
  // ═══════════════════════════════════════════════════════════

  Future<String?> generateProfitReport({
    required int month,
    required int year,
    required double totalRevenue,
    required double totalExpenses,
    required double netProfit,
    required Map<String, Map<String, double>> profitByBrand,
    required Map<String, int> stockDistribution,
  }) async {
    try {
      final isar = Get.find<IsarService>().isar;
      final settings = await isar.appSettings.where().findFirst() ?? AppSettings();

      final pdf = pw.Document();
      final monthYear = _monthYearFormat.format(DateTime(year, month));

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader(context, 'Profit Report', monthYear, settings),
          footer: _buildFooter,
          build: (context) => [
            _buildKpiSummary(totalRevenue, totalExpenses, netProfit),
            pw.SizedBox(height: 20),
            _buildProfitTable(profitByBrand),
            pw.SizedBox(height: 20),
            _buildStockList(stockDistribution),
          ],
        ),
      );

      return await _savePdf(pdf, 'Profit_Report');
    } catch (e) {
      debugPrint('Error generating profit report: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  REVENUE TAB — Revenue & Expense Statement
  // ═══════════════════════════════════════════════════════════

  Future<String?> generateRevenueStatement({
    required int month,
    required int year,
    required double totalRevenue,
    required double totalExpenses,
    required double netProfit,
    required List<Expense> expenses,
  }) async {
    try {
      final isar = Get.find<IsarService>().isar;
      final settings = await isar.appSettings.where().findFirst() ?? AppSettings();

      final pdf = pw.Document();
      final monthYear = _monthYearFormat.format(DateTime(year, month));

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader(context, 'Revenue & Expense Statement', monthYear, settings),
          footer: _buildFooter,
          build: (context) => [
            _buildKpiSummary(totalRevenue, totalExpenses, netProfit, isRevenue: true),
            pw.SizedBox(height: 20),
            _buildExpenseCategoryBreakdown(expenses),
            pw.SizedBox(height: 20),
            _buildExpenseDetailsTable(expenses),
            pw.SizedBox(height: 24),
            _buildBottomLine(totalRevenue, totalExpenses, netProfit),
          ],
        ),
      );

      return await _savePdf(pdf, 'Revenue_Statement');
    } catch (e) {
      debugPrint('Error generating revenue statement: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  SHARED COMPONENTS
  // ═══════════════════════════════════════════════════════════

  pw.Widget _buildHeader(pw.Context context, String title, String monthYear, AppSettings settings) {
    pw.Widget? logoWidget;
    if (settings.showroomLogoPath != null) {
      final file = File(settings.showroomLogoPath!);
      if (file.existsSync()) {
        final image = pw.MemoryImage(file.readAsBytesSync());
        logoWidget = pw.Image(image, width: 40, height: 40);
      }
    }

    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logoWidget != null) ...[
                      logoWidget,
                      pw.SizedBox(width: 8),
                    ],
                    pw.Text(
                      settings.showroomName.isNotEmpty ? settings.showroomName : 'AL-TAHIR SHOWROOM',
                      style: pw.TextStyle(fontSize: settings.showroomName.length > 20 ? 16 : 22, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  title,
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  monthYear,
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Generated: ${_dateFormat.format(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
                ),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 1.5),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(thickness: 0.5, color: PdfColors.grey400),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'AL-TAHIR SHOWROOM - Confidential',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
            ),
          ],
        ),
      ],
    );
  }

  // ─── KPI Summary (3 boxes) ───────────────────────────────

  pw.Widget _buildKpiSummary(
    double revenue, double expenses, double net, {bool isRevenue = false}
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _kpiBox('Total Revenue', _currencyFormat.format(revenue), _primaryColor),
          _kpiDivider(),
          _kpiBox('Total Expenses', _currencyFormat.format(expenses), _warningColor),
          _kpiDivider(),
          _kpiBox(
            isRevenue ? 'Hands-On Amount' : 'Net Profit',
            _currencyFormat.format(net),
            _successColor,
          ),
        ],
      ),
    );
  }

  pw.Widget _kpiBox(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  pw.Widget _kpiDivider() {
    return pw.Container(width: 1, height: 36, color: PdfColors.grey300);
  }

  // ─── Profit By Brand Table (5 columns) ───────────────────

  pw.Widget _buildProfitTable(Map<String, Map<String, double>> data) {
    double totalCash = 0, totalInstallment = 0, totalProfit = 0, totalEarned = 0;
    for (final v in data.values) {
      totalCash += v['cash'] ?? 0;
      totalInstallment += v['installment'] ?? 0;
      totalProfit += v['total'] ?? 0;
      totalEarned += v['earned'] ?? 0;
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('Profit By Brand'),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(2),
            4: const pw.FlexColumnWidth(2),
          },
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: _headerBg),
              children: [
                _tableHeader('Category'),
                _tableHeader('Base Profit'),
                _tableHeader('Inst. Markup'),
                _tableHeader('Total Profit'),
                _tableHeader('Earned'),
              ],
            ),
            // Data rows
            ...data.entries.toList().asMap().entries.map((e) {
              final brand = e.value;
              final isAlt = e.key.isOdd;
              final installment = brand.value['installment'] ?? 0;

              return pw.TableRow(
                decoration: isAlt ? const pw.BoxDecoration(color: _rowAltBg) : null,
                children: [
                  _tableCell(brand.key, bold: true),
                  _tableCell(_currencyFormat.format(brand.value['cash'] ?? 0)),
                  _tableCell(installment == 0 ? 'Sold on Cash' : _currencyFormat.format(installment)),
                  _tableCell(_currencyFormat.format(brand.value['total'] ?? 0), color: _successColor, bold: true),
                  _tableCell(_currencyFormat.format(brand.value['earned'] ?? 0), color: _primaryColor, bold: true),
                ],
              );
            }),
            // Total row
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400, width: 1)),
              ),
              children: [
                _tableCell('TOTAL', bold: true),
                _tableCell(_currencyFormat.format(totalCash), bold: true),
                _tableCell(_currencyFormat.format(totalInstallment), bold: true),
                _tableCell(_currencyFormat.format(totalProfit), color: _successColor, bold: true),
                _tableCell(_currencyFormat.format(totalEarned), color: _primaryColor, bold: true),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ─── Stock Distribution ──────────────────────────────────

  pw.Widget _buildStockList(Map<String, int> data) {
    if (data.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('Stock Distribution'),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Wrap(
            spacing: 20,
            runSpacing: 8,
            children: data.entries.map((e) => pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Container(width: 8, height: 8, decoration: pw.BoxDecoration(
                  color: _brandColor(e.key),
                  shape: pw.BoxShape.circle,
                )),
                pw.SizedBox(width: 6),
                pw.Text('${e.key}: ', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text('${e.value} bikes', style: const pw.TextStyle(fontSize: 11)),
              ],
            )).toList(),
          ),
        ),
      ],
    );
  }

  // ─── Expense Category Breakdown ──────────────────────────

  pw.Widget _buildExpenseCategoryBreakdown(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle('Expense Breakdown by Category'),
          pw.SizedBox(height: 8),
          pw.Text('No expenses recorded this month.',
            style: pw.TextStyle(fontSize: 11, color: PdfColors.grey500)),
        ],
      );
    }

    // Group by category
    final Map<String, double> categoryTotals = {};
    for (final e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }
    final totalExpenses = categoryTotals.values.fold(0.0, (a, b) => a + b);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('Expense Breakdown by Category'),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: _headerBg),
              children: [
                _tableHeader('Category'),
                _tableHeader('Amount'),
              ],
            ),
            ...categoryTotals.entries.toList().asMap().entries.map((e) {
              final isAlt = e.key.isOdd;
              return pw.TableRow(
                decoration: isAlt ? const pw.BoxDecoration(color: _rowAltBg) : null,
                children: [
                  _tableCell(e.value.key),
                  _tableCell(_currencyFormat.format(e.value.value), color: _warningColor),
                ],
              );
            }),
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _tableCell('TOTAL EXPENSES', bold: true),
                _tableCell(_currencyFormat.format(totalExpenses), bold: true, color: _warningColor),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ─── Expense Details Table ───────────────────────────────

  pw.Widget _buildExpenseDetailsTable(List<Expense> expenses) {
    if (expenses.isEmpty) return pw.SizedBox();

    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('Expense Details'),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FixedColumnWidth(30),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(2),
            4: const pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: _headerBg),
              children: [
                _tableHeader('#'),
                _tableHeader('Category'),
                _tableHeader('Amount'),
                _tableHeader('Date'),
                _tableHeader('Note'),
              ],
            ),
            ...expenses.asMap().entries.map((e) {
              final idx = e.key;
              final expense = e.value;
              final isAlt = idx.isOdd;
              return pw.TableRow(
                decoration: isAlt ? const pw.BoxDecoration(color: _rowAltBg) : null,
                children: [
                  _tableCell('${idx + 1}'),
                  _tableCell(expense.category),
                  _tableCell(_currencyFormat.format(expense.amount), color: _warningColor),
                  _tableCell(_dateFormat.format(expense.date)),
                  _tableCell(expense.description ?? '—', color: PdfColors.grey500),
                ],
              );
            }),
            // Total row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _tableCell(''),
                _tableCell(''),
                _tableCell(_currencyFormat.format(total), bold: true, color: _warningColor),
                _tableCell(''),
                _tableCell(''),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ─── Bottom Line ─────────────────────────────────────────

  pw.Widget _buildBottomLine(double revenue, double expenses, double net) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Bottom Line', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.Divider(thickness: 0.5, color: PdfColors.grey400),
          pw.SizedBox(height: 8),
          _bottomLineRow('Revenue', _currencyFormat.format(revenue), _primaryColor),
          pw.SizedBox(height: 4),
          _bottomLineRow('Expenses', '- ${_currencyFormat.format(expenses)}', _warningColor),
          pw.SizedBox(height: 4),
          pw.Divider(thickness: 1, color: PdfColors.grey600),
          pw.SizedBox(height: 6),
          _bottomLineRow('Hands-On Amount', _currencyFormat.format(net), _successColor, bold: true, fontSize: 16),
        ],
      ),
    );
  }

  pw.Widget _bottomLineRow(String label, String value, PdfColor color, {bool bold = false, double fontSize = 12}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: fontSize, fontWeight: bold ? pw.FontWeight.bold : null)),
        pw.Text(value, style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════

  pw.Widget _sectionTitle(String text) {
    return pw.Text(text, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold));
  }

  pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: pw.Text(text, style: pw.TextStyle(
        fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white,
      )),
    );
  }

  pw.Widget _tableCell(String text, {bool bold = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: pw.Text(text, style: pw.TextStyle(
        fontSize: 10,
        fontWeight: bold ? pw.FontWeight.bold : null,
        color: color,
      )),
    );
  }

  PdfColor _brandColor(String brand) {
    final colors = {
      'HONDA': const PdfColor.fromInt(0xFFef4444),
      'ROYAL ELITE': const PdfColor.fromInt(0xFF3b82f6),
      'UNITED': const PdfColor.fromInt(0xFF10b981),
      'SUPER POWER': const PdfColor.fromInt(0xFFf59e0b),
    };
    return colors[brand.toUpperCase()] ?? const PdfColor.fromInt(0xFF64748b);
  }

  Future<String?> _savePdf(pw.Document pdf, String name) async {
    final outputPath = await _getDownloadsPath();
    final now = DateTime.now();
    final date = '${now.day}_${now.month}_${now.year}';
    final fileName = '${name}_$date.pdf';
    final file = File('$outputPath/$fileName');

    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<String> _getDownloadsPath() async {
    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile != null) {
        final downloadsDir = Directory('$userProfile\\Downloads');
        if (await downloadsDir.exists()) return downloadsDir.path;
      }
    }
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  // ═══════════════════════════════════════════════════════════
  //  SALE INVOICE (INDIVIDUAL SALE)
  // ═══════════════════════════════════════════════════════════

  Future<String?> generateSaleInvoice({
    required Map<String, dynamic> saleData,
  }) async {
    try {
      final isar = Get.find<IsarService>().isar;
      final settings = await isar.appSettings.where().findFirst() ?? AppSettings();

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildInvoiceHeader(context, saleData, settings),
          footer: _buildFooter,
          build: (context) => [
             _buildCustomerAndBikeInfo(saleData),
             pw.SizedBox(height: 20),
             if (saleData['witnesses'] != null && (saleData['witnesses'] as List).isNotEmpty) ...[
               _buildWitnessesInfo(saleData['witnesses']),
               pw.SizedBox(height: 20),
             ],
             _buildInvoiceFinancials(saleData),
             pw.Spacer(),
             _buildSignatures(),
          ],
        ),
      );

      final customerName = (saleData['customerName'] as String).replaceAll(' ', '_');
      final invoiceType = saleData['isCash'] == true ? 'Cash' : 'Installment';
      final fileName = 'Invoice_${invoiceType}_$customerName';
      
      return await _savePdf(pdf, fileName);
    } catch (e) {
      debugPrint('Error generating sale invoice pdf: $e');
      return null;
    }
  }

  /// Generate a global sales report PDF with separate Cash and Installment sections
  Future<String?> generateSalesReport({
    required List<Map<String, dynamic>> cashSales,
    required List<Map<String, dynamic>> installmentSales,
    required String dateRange,
  }) async {
    try {
      final isar = Get.find<IsarService>().isar;
      final settings = await isar.appSettings.where().findFirst() ?? AppSettings();
      final monthYear = dateRange;
      final totalSales = cashSales.length + installmentSales.length;
      final totalCashRevenue = cashSales.fold<double>(0, (sum, s) => sum + ((s['amountPaid'] as num?)?.toDouble() ?? 0));
      final totalInstRevenue = installmentSales.fold<double>(0, (sum, s) => sum + ((s['sellingPrice'] as num?)?.toDouble() ?? 0));
      final totalRevenue = totalCashRevenue + totalInstRevenue;

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader(context, 'SALES REPORT', monthYear, settings),
          footer: _buildFooter,
          build: (context) => [
            // Summary KPIs
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _kpiBox('Total Sales', '$totalSales', PdfColors.blue800),
                  _kpiDivider(),
                  _kpiBox('Cash Sales', '${cashSales.length}', PdfColors.green800),
                  _kpiDivider(),
                  _kpiBox('Installment Sales', '${installmentSales.length}', PdfColors.orange800),
                  _kpiDivider(),
                  _kpiBox('Total Revenue', 'Rs ${NumberFormat('#,###').format(totalRevenue)}', PdfColors.teal800),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Cash Sales Section
            if (cashSales.isNotEmpty) ...[
              _sectionTitle('CASH SALES'),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headerAlignment: pw.Alignment.centerLeft,
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: pw.BoxDecoration(color: PdfColors.green50),
                headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.green900),
                cellStyle: const pw.TextStyle(fontSize: 10),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                headers: ['#', 'Customer', 'Bike', 'Amount', 'Date'],
                data: cashSales.asMap().entries.map((e) {
                  final s = e.value;
                  return [
                    '${e.key + 1}',
                    s['customerName'] ?? '',
                    s['bikeModel'] ?? '',
                    'Rs ${NumberFormat('#,###').format((s['amountPaid'] as num?)?.toDouble() ?? 0)}',
                    s['saleDate'] ?? '',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 8),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Cash Total: Rs ${NumberFormat('#,###').format(totalCashRevenue)}',
                  style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.green800),
                ),
              ),
              pw.SizedBox(height: 24),
            ],

            // Installment Sales Section
            if (installmentSales.isNotEmpty) ...[
              _sectionTitle('INSTALLMENT SALES'),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headerAlignment: pw.Alignment.centerLeft,
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: pw.BoxDecoration(color: PdfColors.orange50),
                headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.orange900),
                cellStyle: const pw.TextStyle(fontSize: 10),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                headers: ['#', 'Customer', 'Bike', 'Paid', 'Monthly', 'Months', 'Remaining', 'Date'],
                data: installmentSales.asMap().entries.map((e) {
                  final s = e.value;
                  return [
                    '${e.key + 1}',
                    s['customerName'] ?? '',
                    s['bikeModel'] ?? '',
                    'Rs ${NumberFormat('#,###').format((s['amountPaid'] as num?)?.toDouble() ?? 0)}',
                    'Rs ${NumberFormat('#,###').format((s['monthlyPayment'] as num?)?.toDouble() ?? 0)}',
                    '${s['duration'] ?? 0}',
                    'Rs ${NumberFormat('#,###').format((s['amountRemaining'] as num?)?.toDouble() ?? 0)}',
                    s['saleDate'] ?? '',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 8),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Installment Total: Rs ${NumberFormat('#,###').format(totalInstRevenue)}',
                  style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.orange800),
                ),
              ),
            ],

            // Grand Total
            pw.SizedBox(height: 24),
            pw.Divider(),
            pw.SizedBox(height: 8),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Grand Total Revenue: Rs ${NumberFormat('#,###').format(totalRevenue)}',
                style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
              ),
            ),
          ],
        ),
      );

      final fileName = 'Sales_Report_${dateRange.replaceAll(' ', '_')}';
      return await _savePdf(pdf, fileName);
    } catch (e) {
      debugPrint('Error generating sales report pdf: $e');
      return null;
    }
  }

  pw.Widget _buildInvoiceHeader(pw.Context context, Map<String, dynamic> saleData, AppSettings settings) {
    pw.Widget? logoWidget;
    if (settings.showroomLogoPath != null) {
      final file = File(settings.showroomLogoPath!);
      if (file.existsSync()) {
        final image = pw.MemoryImage(file.readAsBytesSync());
        logoWidget = pw.Image(image, width: 50, height: 50);
      }
    }

    final isCash = saleData['isCash'] == true;
    final invoiceType = isCash ? 'CASH SALE INVOICE' : 'INSTALLMENT INVOICE';
    final date = saleData['saleDate'] as String;

    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              children: [
                if (logoWidget != null) ...[
                  logoWidget,
                  pw.SizedBox(width: 12),
                ],
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      settings.showroomName.isNotEmpty ? settings.showroomName.toUpperCase() : 'AL-TAHIR SHOWROOM',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: _primaryColor),
                    ),
                    pw.Text('Motors & Installment Center', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                  ],
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  invoiceType,
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: isCash ? _successColor : _warningColor),
                ),
                pw.SizedBox(height: 4),
                pw.Text('Date: $date', style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 2, color: _primaryColor),
        pw.SizedBox(height: 15),
      ],
    );
  }

  pw.Widget _buildCustomerAndBikeInfo(Map<String, dynamic> saleData) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Purchaser Detail
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionTitle('PURCHASER DETAILS'),
                pw.SizedBox(height: 8),
                _infoRow('Name:', saleData['customerName']),
                _infoRow('CNIC:', saleData['customerCnic']),
                _infoRow('Contact:', saleData['customerContact']),
                _infoRow('Address:', saleData['customerAddress']),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 15),
        // Bike Detail
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _sectionTitle('VEHICLE DETAILS'),
                pw.SizedBox(height: 8),
                _infoRow('Model:', saleData['bikeModel']),
                _infoRow('Color:', saleData['bikeColor'] ?? 'N/A'),
                _infoRow('Chassis No:', saleData['bikeChassisNumber']),
                _infoRow('Engine No:', saleData['bikeEngineNumber']),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildWitnessesInfo(List<dynamic> witnesses) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle('WITNESS DETAILS'),
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: witnesses.map((w) => pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(right: 8.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Witness', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _primaryColor)),
                    _infoRow('Name:', w['fullName']),
                    _infoRow('CNIC:', w['cnicNumber']),
                    _infoRow('Contact:', w['phoneNumber']),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceFinancials(Map<String, dynamic> saleData) {
    final isCash = saleData['isCash'] == true;
    final totalAmount = saleData['amountPaid'] as double;
    final sellingPrice = saleData['sellingPrice'] as double?;
    final remaining = saleData['amountRemaining'] as double?;
    final monthly = saleData['installmentMonthlyPayment'] as double?;
    final duration = saleData['installmentDuration'] as int?;

    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: _rowAltBg,
        border: pw.Border.all(color: _primaryColor),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('FINANCIAL SUMMARY', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: _primaryColor)),
              pw.Text(isCash ? 'Settled in Full' : 'Installment Plan', style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700)),
            ],
          ),
          pw.SizedBox(height: 15),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 10),
          
          if (isCash) ...[
            _financialRow('Total Sale Price', _currencyFormat.format(totalAmount), isBold: true, size: 16),
            pw.SizedBox(height: 8),
            _financialRow('Amount Paid', _currencyFormat.format(totalAmount)),
            _financialRow('Balance Due', 'Rs 0'),
          ] else ...[
            _financialRow('Total Selling Price', _currencyFormat.format(sellingPrice ?? 0), isBold: true, size: 14),
            pw.SizedBox(height: 8),
            _financialRow('Advance / Down Payment', _currencyFormat.format(totalAmount)),
            _financialRow('Remaining Balance', _currencyFormat.format(remaining ?? 0)),
            pw.SizedBox(height: 8),
            pw.Divider(color: PdfColors.grey300, borderStyle: pw.BorderStyle.dashed),
            pw.SizedBox(height: 8),
            _financialRow('Duration', '$duration Months'),
            _financialRow('Monthly Installment', _currencyFormat.format(monthly ?? 0), isBold: true, color: _primaryColor),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildSignatures() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _signatureLine('Purchaser Signature'),
        _signatureLine('Authorized Signatory'),
      ],
    );
  }

  pw.Widget _signatureLine(String role) {
    return pw.Column(
      children: [
        pw.Container(width: 150, height: 1, color: PdfColors.black),
        pw.SizedBox(height: 5),
        pw.Text(role, style: const pw.TextStyle(fontSize: 11)),
      ],
    );
  }

  pw.Widget _infoRow(String label, String? value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 60, child: pw.Text(label, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700))),
          pw.Expanded(child: pw.Text(value ?? '—', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
        ],
      ),
    );
  }

  pw.Widget _financialRow(String label, String value, {bool isBold = false, double size = 12, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: size, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(value, style: pw.TextStyle(fontSize: size, fontWeight: pw.FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  CUSTOMER STATEMENT EXPORT
  // ═══════════════════════════════════════════════════════════

  Future<String?> generateCustomerStatement({
    required Map<String, dynamic> customerData,
    required List<Map<String, dynamic>> transactions,
  }) async {
    try {
      final isar = Get.find<IsarService>().isar;
      final settings = await isar.appSettings.where().findFirst() ?? AppSettings();

      final pdf = pw.Document();

      // Calculate totals
      double totalPurchased = 0;
      double totalPaid = 0;
      double totalRemaining = 0;

      for (var tx in transactions) {
        totalPurchased += tx['totalPrice'] ?? 0;
        totalPaid += tx['amountPaid'] ?? 0;
        totalRemaining += tx['amountRemaining'] ?? 0;
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader(context, 'CUSTOMER STATEMENT OF ACCOUNT', _dateFormat.format(DateTime.now()), settings),
          footer: _buildFooter,
          build: (context) => [
            _buildCustomerBlock(customerData),
            pw.SizedBox(height: 20),
            _buildKpiSummary(totalPurchased, totalPaid, totalRemaining, isRevenue: false), // Resusing KPI layout
            pw.SizedBox(height: 20),
            _buildCustomerTransactionsTable(transactions),
            pw.SizedBox(height: 30),
            pw.Center(child: pw.Text('*** End of Statement ***', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600))),
          ],
        ),
      );

      final customerName = (customerData['fullName'] as String).replaceAll(' ', '_');
      final fileName = 'Statement_$customerName';
      
      return await _savePdf(pdf, fileName);
    } catch (e) {
      debugPrint('Error generating customer statement pdf: $e');
      return null;
    }
  }

  pw.Widget _buildCustomerBlock(Map<String, dynamic> customer) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: _rowAltBg,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(customer['fullName'].toString().toUpperCase(), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: _primaryColor)),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Contact: ${customer['phoneNumber']}', style: const pw.TextStyle(fontSize: 11)),
                  pw.Text('CNIC: ${customer['cnicNumber']}', style: const pw.TextStyle(fontSize: 11)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Address:', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                  pw.Text(customer['address'] ?? '', style: const pw.TextStyle(fontSize: 11)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCustomerTransactionsTable(List<Map<String, dynamic>> transactions) {
     return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('TRANSACTION HISTORY'),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),   // Date
            1: const pw.FlexColumnWidth(2),   // Vehicle
            2: const pw.FlexColumnWidth(1), // Type
            3: const pw.FlexColumnWidth(1.5), // Total
            4: const pw.FlexColumnWidth(1.5), // Paid
            5: const pw.FlexColumnWidth(1.5), // Bal
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: _headerBg),
              children: [
                _tableHeader('Date'),
                _tableHeader('Vehicle'),
                _tableHeader('Type'),
                _tableHeader('Total'),
                _tableHeader('Paid'),
                _tableHeader('Balance'),
              ],
            ),
            ...transactions.asMap().entries.map((e) {
              final tx = e.value;
              final isAlt = e.key.isOdd;
              return pw.TableRow(
                decoration: isAlt ? const pw.BoxDecoration(color: _rowAltBg) : null,
                children: [
                  _tableCell(tx['date']),
                  _tableCell(tx['vehicle']),
                  _tableCell(tx['type'], color: tx['type'] == 'Cash' ? _successColor : _warningColor, bold: true),
                  _tableCell(_currencyFormat.format(tx['totalPrice'])),
                  _tableCell(_currencyFormat.format(tx['amountPaid']), color: _successColor),
                  _tableCell(_currencyFormat.format(tx['amountRemaining']), color: tx['amountRemaining'] > 0 ? _warningColor : PdfColors.grey600),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  /// Generate a PDF document containing a list of customer details including financial summary
  Future<String?> generateCustomerProfilePdf({
    required List<CustomerWithTransactions> customers,
    String? customTitle, 
  }) async {
    try {
      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.interRegular(),
          bold: await PdfGoogleFonts.interBold(),
        ),
      );

      final isar = Get.find<IsarService>().isar;
      final settings = await isar.appSettings.where().findFirst();
      if (settings == null) throw Exception('App settings not found');
      
      final title = customTitle ?? (customers.length == 1 ? 'Customer Profile' : 'Customers Profile List');

      // Pagination setup
      const int itemsPerPage = 10;
      
      for (var i = 0; i < customers.length; i += itemsPerPage) {
        final end = (i + itemsPerPage < customers.length) ? i + itemsPerPage : customers.length;
        final pageCustomers = customers.sublist(i, end);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4.landscape, // Switching to landscape to fit more data
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                   _buildHeader(context, title, DateFormat('dd MMM yyyy').format(DateTime.now()), settings),
                  pw.SizedBox(height: 20),
                  
                  // Table Header
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      color: _headerBg, // Fixed: Using dark background for white text
                      borderRadius: const pw.BorderRadius.vertical(top: pw.Radius.circular(4)),
                    ),
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Row(
                      children: [
                        pw.Expanded(flex: 20, child: _tableHeader('Name & Father Name')),
                        pw.Expanded(flex: 20, child: _tableHeader('CNIC Number')),
                        pw.Expanded(flex: 15, child: _tableHeader('Phone')),
                        pw.Expanded(flex: 20, child: _tableHeader('Address')),
                        pw.Expanded(flex: 12, child: _tableHeader('Total Purchase')),
                        pw.Expanded(flex: 12, child: _tableHeader('Total Paid')),
                        pw.Expanded(flex: 12, child: _tableHeader('Balance')),
                      ],
                    ),
                  ),
                  
                  // Table Content
                  ...pageCustomers.map((customerData) {
                    final customer = customerData.customer;
                    final isEven = pageCustomers.indexOf(customerData) % 2 == 0;
                    
                    double totalPurchased = 0;
                    double totalPaid = 0;
                    for (var tx in customerData.transactions) {
                      totalPurchased += tx.isInstallment ? (tx.contract?.totalAmount ?? tx.sale.totalAmount) : tx.sale.totalAmount;
                      totalPaid += tx.sale.receivedAmount;
                    }
                    final balance = totalPurchased - totalPaid;

                    return pw.Container(
                      decoration: pw.BoxDecoration(
                        color: isEven ? PdfColors.white : PdfColors.grey50,
                        border: pw.Border.all(color: PdfColors.grey200),
                      ),
                      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Expanded(
                            flex: 20, 
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _tableCell(customer.fullName, bold: true),
                                if (customer.fatherName != null && customer.fatherName!.isNotEmpty)
                                  pw.Text('S/O: ${customer.fatherName}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                              ]
                            )
                          ),
                          pw.Expanded(flex: 20, child: _tableCell(customer.cnicNumber)),
                          pw.Expanded(flex: 15, child: _tableCell(customer.phoneNumber)),
                          pw.Expanded(flex: 20, child: _tableCell(customer.address ?? 'N/A')),
                          pw.Expanded(flex: 12, child: _tableCell(_currencyFormat.format(totalPurchased))),
                          pw.Expanded(flex: 12, child: _tableCell(_currencyFormat.format(totalPaid), color: _successColor)),
                          pw.Expanded(flex: 12, child: _tableCell(_currencyFormat.format(balance), color: balance > 0 ? _warningColor : null, bold: true)),
                        ],
                      ),
                    );
                  }).toList(),

                  pw.Spacer(),
                  _buildFooter(context),
                ],
              );
            },
          ),
        );
      }

      final fileName = customers.length == 1 
          ? 'Profile_${customers.first.customer.cnicNumber}.pdf'
          : 'All_Customers_Profile_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';

      return await _savePdf(pdf, fileName);
    } catch (e) {
      debugPrint('Error generating customer profile PDF: $e');
      return null;
    }
  }
}
