import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:archive/archive.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';
import 'package:tahir_showroom/app/features/installments/presentation/controllers/installments_controller.dart';

/// Statement PDF generation service
class StatementService {
  final _currencyFormat = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs ',
    decimalDigits: 0,
  );
  final _dateFormat = DateFormat('dd/MM/yyyy');

  /// Generate a single customer statement PDF and save to Downloads
  Future<String?> generateSingleStatement(ContractDisplayData data) async {
    try {
      final pdf = pw.Document();
      _addStatementPage(pdf, data);

      final outputPath = await _getDownloadsPath();
      final sanitizedName = data.customer.fullName.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
      final fileName = 'Statement_${sanitizedName}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
      final file = File('$outputPath/$fileName');

      await file.writeAsBytes(await pdf.save());
      return file.path;
    } catch (e) {
      debugPrint('Error generating statement: $e');
      return null;
    }
  }

  /// Generate a combined PDF with all contracts
  Future<String?> generateGlobalStatement(List<ContractDisplayData> allData) async {
    try {
      final pdf = pw.Document();

      for (final data in allData) {
        _addStatementPage(pdf, data);
      }

      final outputPath = await _getDownloadsPath();
      final fileName = 'All_Statements_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
      final file = File('$outputPath/$fileName');

      await file.writeAsBytes(await pdf.save());
      return file.path;
    } catch (e) {
      debugPrint('Error generating global statement: $e');
      return null;
    }
  }

  /// Generate individual PDFs for each contract and bundle into a ZIP
  Future<String?> generateGlobalZip(List<ContractDisplayData> allData) async {
    try {
      final archive = Archive();
      final dateStamp = DateFormat('yyyyMMdd').format(DateTime.now());

      for (final data in allData) {
        final pdf = pw.Document();
        _addStatementPage(pdf, data);

        final sanitizedName = data.customer.fullName.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
        final fileName = 'Statement_$sanitizedName.pdf';
        final pdfBytes = await pdf.save();

        archive.addFile(ArchiveFile(fileName, pdfBytes.length, pdfBytes));
      }

      final outputPath = await _getDownloadsPath();
      final zipFileName = 'All_Statements_$dateStamp.zip';
      final zipFile = File('$outputPath/$zipFileName');

      final zipData = ZipEncoder().encode(archive);
      if (zipData != null) {
        await zipFile.writeAsBytes(zipData);
        return zipFile.path;
      }
      return null;
    } catch (e) {
      debugPrint('Error generating ZIP: $e');
      return null;
    }
  }

  void _addStatementPage(pw.Document pdf, ContractDisplayData data) {
    final contract = data.contract;
    final customer = data.customer;
    final bike = data.bike;
    final payments = data.payments;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(context),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          // Customer & Bike Info
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(child: _buildCustomerSection(customer)),
              pw.SizedBox(width: 20),
              pw.Expanded(child: _buildBikeSection(bike)),
            ],
          ),
          pw.SizedBox(height: 16),

          // Contract Summary
          _buildContractSummary(contract),
          pw.SizedBox(height: 16),

          // Witnesses
          if (data.payments.isNotEmpty) ...[
            _buildWitnessSection(data),
            pw.SizedBox(height: 16),
          ],

          // Payment History Table
          _buildPaymentTable(payments),
        ],
      ),
    );
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Tahir Showroom',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Installment Statement',
              style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
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
              'Generated: ${_dateFormat.format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildCustomerSection(Customer customer) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Customer Details', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          _pdfInfoRow('Name', customer.fullName),
          _pdfInfoRow('CNIC', customer.cnicNumber),
          _pdfInfoRow('Phone', customer.phoneNumber),
          if (customer.address != null) _pdfInfoRow('Address', customer.address!),
        ],
      ),
    );
  }

  pw.Widget _buildBikeSection(Bike bike) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Bike Details', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          _pdfInfoRow('Model', '${bike.brand} ${bike.model}'),
          _pdfInfoRow('Color', bike.color),
          _pdfInfoRow('Engine #', bike.engineNumber),
          _pdfInfoRow('Chassis #', bike.chassisNumber),
        ],
      ),
    );
  }

  pw.Widget _buildContractSummary(InstallmentContract contract) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Contract Summary', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Expanded(child: _pdfInfoRow('Total Amount', _currencyFormat.format(contract.totalAmount))),
              pw.Expanded(child: _pdfInfoRow('Down Payment', _currencyFormat.format(contract.downPayment))),
            ],
          ),
          pw.Row(
            children: [
              pw.Expanded(child: _pdfInfoRow('Monthly EMI', _currencyFormat.format(contract.monthlyEMI))),
              pw.Expanded(child: _pdfInfoRow('Duration', '${contract.months} months')),
            ],
          ),
          pw.Row(
            children: [
              pw.Expanded(child: _pdfInfoRow('Total Paid', _currencyFormat.format(contract.totalPaid))),
              pw.Expanded(child: _pdfInfoRow('Remaining', _currencyFormat.format(contract.remainingBalance))),
            ],
          ),
          pw.Row(
            children: [
              pw.Expanded(child: _pdfInfoRow('Status', contract.status.name.toUpperCase())),
              pw.Expanded(child: _pdfInfoRow('Start Date', _dateFormat.format(contract.contractDate))),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildWitnessSection(ContractDisplayData data) {
    // Fetch witnesses from repository would be ideal, but we work with what ContractDisplayData provides
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Witness Information', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(
            'Witnesses are on file at Tahir Showroom.',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPaymentTable(List<Payment> payments) {
    final allPayments = payments.toList();
    allPayments.sort((a, b) => a.paymentDate.compareTo(b.paymentDate));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Payment History', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        if (allPayments.isEmpty)
          pw.Text('No payments recorded yet.', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600))
        else
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            cellHeight: 28,
            headers: ['#', 'Date', 'Amount', 'Method', 'Collector', 'Notes'],
            data: List.generate(allPayments.length, (i) {
              final p = allPayments[i];
              return [
                '${i + 1}',
                _dateFormat.format(p.paymentDate),
                _currencyFormat.format(p.amount),
                p.method.name,
                p.collectorName ?? '-',
                p.isDownPayment ? 'Down Payment' : (p.notes ?? '-'),
              ];
            }),
          ),
      ],
    );
  }

  pw.Widget _pdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text('$label:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(child: pw.Text(value, style: const pw.TextStyle(fontSize: 10))),
        ],
      ),
    );
  }

  Future<String> _getDownloadsPath() async {
    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile != null) {
        final downloadsDir = Directory('$userProfile\\Downloads');
        if (await downloadsDir.exists()) return downloadsDir.path;
      }
    }
    // Fallback to application documents directory
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
}

// Authored by: Moazzam Samoo
