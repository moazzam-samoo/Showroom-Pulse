import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:tahir_showroom/app/data/models/expense.dart';

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
      final pdf = pw.Document();
      final monthYear = _monthYearFormat.format(DateTime(year, month));

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader(context, 'Profit Report', monthYear),
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
      final pdf = pw.Document();
      final monthYear = _monthYearFormat.format(DateTime(year, month));

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader(context, 'Revenue & Expense Statement', monthYear),
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

  pw.Widget _buildHeader(pw.Context context, String title, String monthYear) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'AL-TAHIR SHOWROOM',
                  style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
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
}
