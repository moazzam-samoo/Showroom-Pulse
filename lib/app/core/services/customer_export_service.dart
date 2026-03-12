import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/core/services/report_pdf_service.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/features/customers/data/repositories/customer_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class CustomerExportService extends GetxService {
  late final FileService _fileService;
  late final ReportPdfService _pdfService;

  @override
  void onInit() {
    super.onInit();
    _fileService = Get.find<FileService>();
    _pdfService = Get.find<ReportPdfService>();
  }

  Future<String> _getDownloadsPath() async {
    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile != null) {
        final dir = Directory(p.join(userProfile, 'Downloads'));
        if (await dir.exists()) return dir.path;
      }
    }
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  /// Use PowerShell Compress-Archive to create ZIP (no external packages needed)
  Future<bool> _createZip(String sourceDir, String zipFilePath) async {
    try {
      // Delete existing zip if present
      final existingZip = File(zipFilePath);
      if (await existingZip.exists()) await existingZip.delete();

      final result = await Process.run(
        'powershell',
        [
          '-NoProfile',
          '-Command',
          'Compress-Archive -Path "${sourceDir.replaceAll('/', '\\')}\\*" -DestinationPath "${zipFilePath.replaceAll('/', '\\')}" -Force',
        ],
      );

      if (result.exitCode != 0) {
        debugPrint('PowerShell ZIP error: ${result.stderr}');
        return false;
      }
      return await File(zipFilePath).exists();
    } catch (e) {
      debugPrint('Error creating ZIP: $e');
      return false;
    }
  }

  /// Stage customer media files into organized folders
  Future<void> _stageCustomerMedia(Customer customer, Directory customerDir) async {
    // Use the same sanitization logic as FileService
    final sanitizedCnic = customer.cnicNumber.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    final mediaDir = Directory(p.join(_fileService.customersMediaPath, sanitizedCnic));

    debugPrint('Looking for media at: ${mediaDir.path}');
    debugPrint('Media dir exists: ${await mediaDir.exists()}');

    if (!await mediaDir.exists()) {
      debugPrint('No media directory found for customer ${customer.fullName}');
      return;
    }

    // List all files to debug
    final allFiles = await mediaDir.list(recursive: true).toList();
    debugPrint('Files in media dir: ${allFiles.map((f) => f.path).toList()}');

    // Profile picture
    if (customer.profileImageFilename != null && customer.profileImageFilename!.isNotEmpty) {
      final profileSource = File(p.join(mediaDir.path, customer.profileImageFilename!));
      debugPrint('Profile source: ${profileSource.path}, exists: ${await profileSource.exists()}');
      if (await profileSource.exists()) {
        final profileDir = Directory(p.join(customerDir.path, 'Profile'));
        await profileDir.create(recursive: true);
        await profileSource.copy(p.join(profileDir.path, customer.profileImageFilename!));
      }
    }

    // NIC Front
    if (customer.cnicFrontFilename != null && customer.cnicFrontFilename!.isNotEmpty) {
      final frontSource = File(p.join(mediaDir.path, customer.cnicFrontFilename!));
      debugPrint('NIC Front source: ${frontSource.path}, exists: ${await frontSource.exists()}');
      if (await frontSource.exists()) {
        final nicDir = Directory(p.join(customerDir.path, 'NIC'));
        await nicDir.create(recursive: true);
        await frontSource.copy(p.join(nicDir.path, customer.cnicFrontFilename!));
      }
    }

    // NIC Back
    if (customer.cnicBackFilename != null && customer.cnicBackFilename!.isNotEmpty) {
      final backSource = File(p.join(mediaDir.path, customer.cnicBackFilename!));
      debugPrint('NIC Back source: ${backSource.path}, exists: ${await backSource.exists()}');
      if (await backSource.exists()) {
        final nicDir = Directory(p.join(customerDir.path, 'NIC'));
        await nicDir.create(recursive: true);
        await backSource.copy(p.join(nicDir.path, customer.cnicBackFilename!));
      }
    }
  }

  /// Download single customer as ZIP
  Future<String?> downloadSingleCustomer(CustomerWithTransactions customerData) async {
    try {
      final customer = customerData.customer;
      final tempDir = await Directory.systemTemp.createTemp('tahir_export_');
      final exportFolderName = '${customer.fullName.replaceAll(' ', '_')}_${customer.cnicNumber.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '')}';
      final stagingDir = Directory(p.join(tempDir.path, exportFolderName));
      await stagingDir.create(recursive: true);

      // 1. Generate Statement PDF
      final pdfPath = await _generateStatementForCustomer(customerData);
      if (pdfPath != null) {
        final pdfFile = File(pdfPath);
        if (await pdfFile.exists()) {
          await pdfFile.copy(p.join(stagingDir.path, '${customer.fullName}_Statement.pdf'));
          await pdfFile.delete();
        }
      }

      // 2. Stage Images
      await _stageCustomerMedia(customer, stagingDir);

      // 3. Create ZIP using PowerShell
      final downloadsPath = await _getDownloadsPath();
      final zipFilename = 'Customer_${customer.fullName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.zip';
      final zipFilePath = p.join(downloadsPath, zipFilename);

      final success = await _createZip(stagingDir.path, zipFilePath);

      // 4. Cleanup temp files
      await tempDir.delete(recursive: true);

      return success ? zipFilePath : null;
    } catch (e) {
      debugPrint('Error downloading single customer: $e');
      return null;
    }
  }

  /// Download all customers as a single ZIP
  Future<String?> downloadAllCustomers(List<CustomerWithTransactions> customers) async {
    try {
      if (customers.isEmpty) return null;

      final tempDir = await Directory.systemTemp.createTemp('tahir_export_bulk_');
      final exportFolderName = 'All_Customers_${DateTime.now().millisecondsSinceEpoch}';
      final stagingDir = Directory(p.join(tempDir.path, exportFolderName));
      await stagingDir.create(recursive: true);

      // 1. Generate Global PDF Summary (Directory of all customers)
      final pdfPath = await _pdfService.generateCustomerProfilePdf(customers: customers);
      if (pdfPath != null) {
        final pdfFile = File(pdfPath);
        if (await pdfFile.exists()) {
          await pdfFile.copy(p.join(stagingDir.path, 'Customer_Summary_List.pdf'));
          await pdfFile.delete();
        }
      }

      // 2. Stage Images & Individual Statements for each customer
      for (final customerData in customers) {
        final customer = customerData.customer;
        final safeName = '${customer.fullName.replaceAll(' ', '_')}_${customer.cnicNumber.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '')}';
        final customerDir = Directory(p.join(stagingDir.path, safeName));
        await customerDir.create(recursive: true);
        
        // Add Statement PDF for this customer
        final cPdfPath = await _generateStatementForCustomer(customerData);
        if (cPdfPath != null) {
          final cPdfFile = File(cPdfPath);
          if (await cPdfFile.exists()) {
             await cPdfFile.copy(p.join(customerDir.path, '${customer.fullName}_Statement.pdf'));
             await cPdfFile.delete();
          }
        }

        // Add Media (Profile, NIC)
        await _stageCustomerMedia(customer, customerDir);
      }

      // 3. Create ZIP using PowerShell
      final downloadsPath = await _getDownloadsPath();
      final zipFilePath = p.join(downloadsPath, '$exportFolderName.zip');

      final success = await _createZip(stagingDir.path, zipFilePath);

      // 4. Cleanup temp files
      await tempDir.delete(recursive: true);

      return success ? zipFilePath : null;
    } catch (e) {
      debugPrint('Error downloading all customers: $e');
      return null;
    }
  }

  Future<String?> _generateStatementForCustomer(CustomerWithTransactions customerData) async {
    final customer = customerData.customer;
    final customerMap = {
      'fullName': customer.fullName,
      'phoneNumber': customer.phoneNumber,
      'cnicNumber': customer.cnicNumber,
      'address': customer.address,
    };

    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final txList = customerData.transactions.map((tx) {
      final date = dateFormat.format(tx.sale.saleDate);
      final vehicle = tx.bike.model;
      final type = tx.isInstallment ? 'Installment' : 'Cash';
      final total = tx.isInstallment ? (tx.contract?.totalAmount ?? tx.sale.totalAmount) : tx.sale.totalAmount;
      final paid = tx.sale.receivedAmount;
      final bal = total - paid;
      
      return {
        'date': date,
        'vehicle': vehicle,
        'type': type,
        'totalPrice': total,
        'amountPaid': paid,
        'amountRemaining': bal,
      };
    }).toList();

    return await _pdfService.generateCustomerStatement(
      customerData: customerMap,
      transactions: txList,
    );
  }
}
