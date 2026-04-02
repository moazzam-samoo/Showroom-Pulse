import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isar/isar.dart';

import 'isar_service.dart';
import 'file_service.dart';
import '../../data/models/bike.dart';
import '../../data/models/customer.dart';
import '../../data/models/installment_contract.dart';
import '../../data/models/payment.dart';
import '../../data/models/witness.dart';
import '../../data/models/user.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/supplier.dart';
import '../../data/models/purchase_batch.dart';
import '../../data/models/sale.dart';
import '../../data/models/expense.dart';
import '../../data/models/investment.dart';

/// BackupService — Handles database export and import operations
///
/// V2 Format: JSON data + Media folder → single .tahir ZIP (~1-5 MB)
/// V1 Legacy: Isar copyToFile + Media → .tahir ZIP (400+ MB)
///
/// V2 exports only the actual data as compressed JSON, eliminating
/// Isar's pre-allocated empty space that caused 417 MB exports for 5 MB of data.
class BackupService {
  final IsarService _isarService;
  final FileService _fileService;

  BackupService(this._isarService, this._fileService);

  // ═══════════════════════════════════════════════════════════
  //  EXPORT (V2 — JSON-based)
  // ═══════════════════════════════════════════════════════════

  Future<String?> exportBackup({Function(String)? onProgress}) async {
    try {
      onProgress?.call('Preparing backup...');

      // 1. Create temp staging directory
      final tempDir = await getTemporaryDirectory();
      final stagingDir = Directory(p.join(tempDir.path, 'tahir_backup_staging'));
      if (await stagingDir.exists()) {
        await stagingDir.delete(recursive: true);
      }
      await stagingDir.create(recursive: true);

      // 2. Export all data as JSON
      onProgress?.call('Serializing data...');
      final data = await _exportDataAsJson();
      final dataJsonString = const JsonEncoder.withIndent('  ').convert(data);
      final dataFile = File(p.join(stagingDir.path, 'data.json'));
      await dataFile.writeAsString(dataJsonString);

      // 3. Build manifest
      onProgress?.call('Gathering statistics...');
      final manifest = await _buildManifest();
      final manifestFile = File(p.join(stagingDir.path, 'manifest.json'));
      await manifestFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(manifest),
      );

      // 4. Build ZIP archive
      onProgress?.call('Creating backup archive...');
      final archive = Archive();

      // Add manifest
      final manifestBytes = await manifestFile.readAsBytes();
      archive.addFile(
        ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
      );

      // Add data.json
      final dataBytes = await dataFile.readAsBytes();
      archive.addFile(
        ArchiveFile('data.json', dataBytes.length, dataBytes),
      );

      // Add media files (if any exist)
      onProgress?.call('Adding media files...');
      final mediaDir = Directory(_fileService.mediaPath);
      if (await mediaDir.exists()) {
        await _addDirectoryToArchive(archive, mediaDir, 'media');
      }

      // 5. Encode ZIP
      onProgress?.call('Compressing...');
      final zipData = ZipEncoder().encode(archive);
      if (zipData == null) {
        debugPrint('BackupService: ZIP encoding returned null');
        return null;
      }

      // 6. Let user pick save location
      final dateStamp = DateFormat('yyyy-MM-dd_HHmm').format(DateTime.now());
      final defaultFileName = 'TahirShowroom_Backup_$dateStamp.tahir';

      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName: defaultFileName,
        type: FileType.custom,
        allowedExtensions: ['tahir'],
      );

      if (savePath == null) {
        debugPrint('BackupService: User cancelled save dialog');
        return null;
      }

      // 7. Write to chosen location
      onProgress?.call('Saving backup...');
      final outputFile = File(savePath);
      await outputFile.writeAsBytes(zipData);

      // 8. Cleanup staging
      await stagingDir.delete(recursive: true);

      final fileSizeMB = (await outputFile.length()) / (1024 * 1024);
      debugPrint(
        'BackupService: V2 backup saved to $savePath '
        '(${fileSizeMB.toStringAsFixed(2)} MB)',
      );

      return savePath;
    } catch (e) {
      debugPrint('BackupService: Export failed — $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  IMPORT (V1 + V2 auto-detect)
  // ═══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>?> getBackupInfo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select Backup File',
        type: FileType.custom,
        allowedExtensions: ['tahir', 'zip'],
      );

      if (result == null || result.files.single.path == null) return null;

      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final manifestFile = archive.findFile('manifest.json');
      if (manifestFile == null) {
        return {'error': 'Invalid backup file — no manifest found'};
      }

      final manifest = json.decode(
        utf8.decode(manifestFile.content as List<int>),
      ) as Map<String, dynamic>;

      manifest['_filePath'] = file.path;
      manifest['_fileSize'] = (await file.length()) / (1024 * 1024);

      // Detect format version
      final hasDataJson = archive.findFile('data.json') != null;
      manifest['_formatVersion'] = hasDataJson ? 2 : 1;

      return manifest;
    } catch (e) {
      debugPrint('BackupService: getBackupInfo failed — $e');
      return {'error': 'Failed to read backup: $e'};
    }
  }

  Future<bool> importBackup(
    String filePath, {
    Function(String)? onProgress,
  }) async {
    try {
      onProgress?.call('Reading backup file...');
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final hasManifest = archive.findFile('manifest.json') != null;
      if (!hasManifest) {
        debugPrint('BackupService: Invalid backup — no manifest');
        return false;
      }

      // Auto-detect format
      final hasDataJson = archive.findFile('data.json') != null;
      final hasIsarDb = archive.findFile('database/default.isar') != null;

      if (hasDataJson) {
        return await _importV2(archive, onProgress: onProgress);
      } else if (hasIsarDb) {
        return await _importV1Legacy(archive, onProgress: onProgress);
      } else {
        debugPrint('BackupService: No data.json or database found');
        return false;
      }
    } catch (e) {
      debugPrint('BackupService: Import failed — $e');
      try {
        await _reopenIsar();
      } catch (_) {}
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  V2 IMPORT — JSON-based (new format)
  // ═══════════════════════════════════════════════════════════

  Future<bool> _importV2(
    Archive archive, {
    Function(String)? onProgress,
  }) async {
    try {
      // 1. Parse data.json
      onProgress?.call('Parsing data...');
      final dataFile = archive.findFile('data.json')!;
      final dataJson = json.decode(
        utf8.decode(dataFile.content as List<int>),
      ) as Map<String, dynamic>;

      // 2. Close Isar and clear database
      onProgress?.call('Closing database...');
      await _isarService.isar.close(deleteFromDisk: true);

      await _clearDirectory(_fileService.databasePath);

      // 3. Clear and restore media
      onProgress?.call('Restoring media files...');
      await _clearDirectory(_fileService.mediaPath);
      await _extractMedia(archive);

      // 4. Open fresh Isar
      onProgress?.call('Opening fresh database...');
      await _reopenIsar();

      // 5. Deserialize all data into Isar
      onProgress?.call('Restoring records...');
      await _deserializeAllData(dataJson);

      debugPrint('BackupService: V2 import completed successfully');
      return true;
    } catch (e) {
      debugPrint('BackupService: V2 import failed — $e');
      try {
        await _reopenIsar();
      } catch (_) {}
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  V1 IMPORT — Legacy Isar file (backward compatibility)
  // ═══════════════════════════════════════════════════════════

  Future<bool> _importV1Legacy(
    Archive archive, {
    Function(String)? onProgress,
  }) async {
    try {
      // 1. Close current Isar
      onProgress?.call('Closing database...');
      await _isarService.isar.close(deleteFromDisk: true);

      // 2. Clear database directory
      onProgress?.call('Clearing old data...');
      await _clearDirectory(_fileService.databasePath);

      // 3. Clear and restore media
      onProgress?.call('Restoring media files...');
      await _clearDirectory(_fileService.mediaPath);
      await _extractMedia(archive);

      // 4. Extract database file
      onProgress?.call('Restoring database...');
      for (final file in archive) {
        if (file.isFile && file.name.startsWith('database/')) {
          final relativePath = file.name.substring('database/'.length);
          final outputPath =
              p.join(_fileService.databasePath, relativePath);
          final outputFile = File(outputPath);
          await outputFile.parent.create(recursive: true);
          await outputFile.writeAsBytes(file.content as List<int>);
        }
      }

      // 5. Re-open Isar
      onProgress?.call('Restarting database...');
      await _reopenIsar();

      debugPrint('BackupService: V1 legacy import completed');
      return true;
    } catch (e) {
      debugPrint('BackupService: V1 import failed — $e');
      try {
        await _reopenIsar();
      } catch (_) {}
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  DATA SERIALIZATION (Export)
  // ═══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> _exportDataAsJson() async {
    final isar = _isarService.isar;

    // Fetch all records
    final bikes = await isar.bikes.where().findAll();
    final customers = await isar.customers.where().findAll();
    final contracts = await isar.installmentContracts.where().findAll();
    final payments = await isar.payments.where().findAll();
    final witnesses = await isar.witness.where().findAll();
    final sales = await isar.sales.where().findAll();
    final suppliers = await isar.suppliers.where().findAll();
    final batches = await isar.purchaseBatchs.where().findAll();
    final expenses = await isar.expenses.where().findAll();
    final investments = await isar.investments.where().findAll();
    final settingsList = await isar.appSettings.where().findAll();
    final users = await isar.users.where().findAll();

    // Load IsarLinks before serialization
    for (final bike in bikes) {
      await bike.batch.load();
    }
    for (final batch in batches) {
      await batch.supplier.load();
    }

    return {
      'bikes': bikes.map(_bikeToMap).toList(),
      'customers': customers.map(_customerToMap).toList(),
      'installmentContracts': contracts.map(_contractToMap).toList(),
      'payments': payments.map(_paymentToMap).toList(),
      'witnesses': witnesses.map(_witnessToMap).toList(),
      'sales': sales.map(_saleToMap).toList(),
      'suppliers': suppliers.map(_supplierToMap).toList(),
      'purchaseBatches': batches.map(_batchToMap).toList(),
      'expenses': expenses.map(_expenseToMap).toList(),
      'investments': investments.map(_investmentToMap).toList(),
      'appSettings': settingsList.map(_settingsToMap).toList(),
      'users': users.map(_userToMap).toList(),
    };
  }

  // --- Individual model serializers ---

  Map<String, dynamic> _bikeToMap(Bike b) => {
        'id': b.id,
        'engineNumber': b.engineNumber,
        'chassisNumber': b.chassisNumber,
        'model': b.model,
        'brand': b.brand,
        'color': b.color,
        'modelYear': b.modelYear,
        'purchasePrice': b.purchasePrice,
        'cashSalePrice': b.cashSalePrice,
        'fundedByPersonal': b.fundedByPersonal,
        'fundedByPartnership': b.fundedByPartnership,
        'fundedByOther': b.fundedByOther,
        'fundedByLoan': b.fundedByLoan,
        'imageFilename': b.imageFilename,
        'status': b.status.index,
        'condition': b.condition.index,
        'batchId': b.batch.value?.id,
        'dateAdded': b.dateAdded.toIso8601String(),
        'dateSold': b.dateSold?.toIso8601String(),
        'notes': b.notes,
        'investmentAmount': b.investmentAmount,
        'registrationNumber': b.registrationNumber,
        'purchaserName': b.purchaserName,
        'purchaserPhone': b.purchaserPhone,
        'purchaserCnic': b.purchaserCnic,
        'purchaserCnicFrontFilename': b.purchaserCnicFrontFilename,
        'purchaserCnicBackFilename': b.purchaserCnicBackFilename,
      };

  Map<String, dynamic> _customerToMap(Customer c) => {
        'id': c.id,
        'fullName': c.fullName,
        'fatherName': c.fatherName,
        'cnicNumber': c.cnicNumber,
        'phoneNumber': c.phoneNumber,
        'alternativePhone': c.alternativePhone,
        'address': c.address,
        'profileImageFilename': c.profileImageFilename,
        'cnicFrontFilename': c.cnicFrontFilename,
        'cnicBackFilename': c.cnicBackFilename,
        'dateRegistered': c.dateRegistered.toIso8601String(),
        'notes': c.notes,
      };

  Map<String, dynamic> _contractToMap(InstallmentContract c) => {
        'id': c.id,
        'bikeId': c.bikeId,
        'customerId': c.customerId,
        'cashPrice': c.cashPrice,
        'markupType': c.markupType.index,
        'markupValue': c.markupValue,
        'totalMarkupAmount': c.totalMarkupAmount,
        'totalAmount': c.totalAmount,
        'downPayment': c.downPayment,
        'months': c.months,
        'monthlyEMI': c.monthlyEMI,
        'contractDate': c.contractDate.toIso8601String(),
        'firstDueDate': c.firstDueDate.toIso8601String(),
        'dayOfMonth': c.dayOfMonth,
        'nextDueDate': c.nextDueDate?.toIso8601String(),
        'lastPaymentDate': c.lastPaymentDate?.toIso8601String(),
        'status': c.status.index,
        'totalPaid': c.totalPaid,
        'paymentsMade': c.paymentsMade,
        'lateFeeEnabled': c.lateFeeEnabled,
        'lateFeePercentage': c.lateFeePercentage,
        'notes': c.notes,
        'discountAmount': c.discountAmount,
        'discountPercentage': c.discountPercentage,
        'isWaived': c.isWaived,
      };

  Map<String, dynamic> _paymentToMap(Payment p) => {
        'id': p.id,
        'contractId': p.contractId,
        'amount': p.amount,
        'paymentDate': p.paymentDate.toIso8601String(),
        'dueDate': p.dueDate?.toIso8601String(),
        'method': p.method.index,
        'collectorName': p.collectorName,
        'isDownPayment': p.isDownPayment,
        'isLateFee': p.isLateFee,
        'notes': p.notes,
        'receiptNumber': p.receiptNumber,
      };

  Map<String, dynamic> _witnessToMap(Witness w) => {
        'id': w.id,
        'fullName': w.fullName,
        'cnicNumber': w.cnicNumber,
        'phoneNumber': w.phoneNumber,
        'relationship': w.relationship,
        'address': w.address,
        'cnicFrontFilename': w.cnicFrontFilename,
        'cnicBackFilename': w.cnicBackFilename,
        'contractId': w.contractId,
        'isPrimary': w.isPrimary,
      };

  Map<String, dynamic> _saleToMap(Sale s) => {
        'id': s.id,
        'saleDate': s.saleDate.toIso8601String(),
        'saleType': s.saleType.index,
        'bikeId': s.bikeId,
        'customerId': s.customerId,
        'totalAmount': s.totalAmount,
        'receivedAmount': s.receivedAmount,
        'installmentContractId': s.installmentContractId,
        'notes': s.notes,
        'discountAmount': s.discountAmount,
        'discountPercentage': s.discountPercentage,
      };

  Map<String, dynamic> _supplierToMap(Supplier s) => {
        'id': s.id,
        'name': s.name,
        'cnic': s.cnic,
        'phone': s.phone,
        'profilePicFilename': s.profilePicFilename,
        'cnicPicFilename': s.cnicPicFilename,
      };

  Map<String, dynamic> _batchToMap(PurchaseBatch b) => {
        'id': b.id,
        'purchaseDate': b.purchaseDate.toIso8601String(),
        'totalAmount': b.totalAmount,
        'totalUnits': b.totalUnits,
        'billImageFilename': b.billImageFilename,
        'supplierId': b.supplier.value?.id,
      };

  Map<String, dynamic> _expenseToMap(Expense e) => {
        'id': e.id,
        'category': e.category,
        'amount': e.amount,
        'date': e.date.toIso8601String(),
        'description': e.description,
      };

  Map<String, dynamic> _investmentToMap(Investment i) => {
        'id': i.id,
        'amount': i.amount,
        'date': i.date.toIso8601String(),
        'type': i.type.index,
        'category': i.category.index,
        'description': i.description,
        'bikeId': i.bikeId,
        'purchaseBatchId': i.purchaseBatchId,
        'profitAmount': i.profitAmount,
        'saleId': i.saleId,
        'installmentContractId': i.installmentContractId,
        'returnPersonal': i.returnPersonal,
        'returnPartnership': i.returnPartnership,
        'returnOther': i.returnOther,
        'returnLoan': i.returnLoan,
      };

  Map<String, dynamic> _settingsToMap(AppSettings s) => {
        'id': s.id,
        'defaultMarkupPercentage': s.defaultMarkupPercentage,
        'automaticLateFeeEnabled': s.automaticLateFeeEnabled,
        'lateFeePercentage': s.lateFeePercentage,
        'cloudSyncEnabled': s.cloudSyncEnabled,
        'isDarkTheme': s.isDarkTheme,
        'showroomName': s.showroomName,
        'showroomLogoPath': s.showroomLogoPath,
        'showroomAddress': s.showroomAddress,
        'showroomPhone': s.showroomPhone,
        'currencySymbol': s.currencySymbol,
        'dateFormat': s.dateFormat,
        'pdfDownloadLocation': s.pdfDownloadLocation,
        'emiRounding': s.emiRounding,
        'defaultExpenseCategories': s.defaultExpenseCategories,
        'lastBackupDate': s.lastBackupDate?.toIso8601String(),
        'ownerName': s.ownerName,
        'ownerProfilePicPath': s.ownerProfilePicPath,
        'bikeBrands': s.bikeBrands,
        'bikeModels': s.bikeModels,
        'bikeYears': s.bikeYears,
      };

  Map<String, dynamic> _userToMap(User u) => {
        'id': u.id,
        'username': u.username,
        'passwordHash': u.passwordHash,
        'displayName': u.displayName,
        'isActive': u.isActive,
        'dateCreated': u.dateCreated.toIso8601String(),
        'lastLogin': u.lastLogin?.toIso8601String(),
      };

  // ═══════════════════════════════════════════════════════════
  //  DATA DESERIALIZATION (Import V2)
  // ═══════════════════════════════════════════════════════════

  Future<void> _deserializeAllData(Map<String, dynamic> data) async {
    final isar = _isarService.isar;

    // --- Phase A: Import independent collections first ---

    // Suppliers (no dependencies)
    final suppliers = _deserializeSuppliers(data['suppliers']);
    await isar.writeTxn(() => isar.suppliers.putAll(suppliers));

    // Customers (no dependencies)
    final customers = _deserializeCustomers(data['customers']);
    await isar.writeTxn(() => isar.customers.putAll(customers));

    // Users (no dependencies)
    final users = _deserializeUsers(data['users']);
    await isar.writeTxn(() => isar.users.putAll(users));

    // AppSettings (no dependencies)
    final settings = _deserializeSettings(data['appSettings']);
    await isar.writeTxn(() => isar.appSettings.putAll(settings));

    // --- Phase B: Collections with links ---

    // PurchaseBatches (links to Supplier)
    final batchMaps = (data['purchaseBatches'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final batches = <PurchaseBatch>[];
    final batchSupplierIds = <int, int?>{}; // batchId → supplierId

    for (final m in batchMaps) {
      final batch = _mapToPurchaseBatch(m);
      batches.add(batch);
      batchSupplierIds[batch.id] = m['supplierId'] as int?;
    }
    await isar.writeTxn(() => isar.purchaseBatchs.putAll(batches));

    // Save PurchaseBatch → Supplier links
    await isar.writeTxn(() async {
      for (final batch in batches) {
        final supplierId = batchSupplierIds[batch.id];
        if (supplierId != null) {
          final supplier = await isar.suppliers.get(supplierId);
          if (supplier != null) {
            batch.supplier.value = supplier;
            await batch.supplier.save();
          }
        }
      }
    });

    // Bikes (links to PurchaseBatch)
    final bikeMaps = (data['bikes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final bikes = <Bike>[];
    final bikeBatchIds = <int, int?>{}; // bikeId → batchId

    for (final m in bikeMaps) {
      final bike = _mapToBike(m);
      bikes.add(bike);
      bikeBatchIds[bike.id] = m['batchId'] as int?;
    }
    await isar.writeTxn(() => isar.bikes.putAll(bikes));

    // Save Bike → PurchaseBatch links
    await isar.writeTxn(() async {
      for (final bike in bikes) {
        final batchId = bikeBatchIds[bike.id];
        if (batchId != null) {
          final batch = await isar.purchaseBatchs.get(batchId);
          if (batch != null) {
            bike.batch.value = batch;
            await bike.batch.save();
          }
        }
      }
    });

    // --- Phase C: Remaining collections (reference by ID, no IsarLinks) ---

    final contracts = _deserializeContracts(data['installmentContracts']);
    await isar.writeTxn(() => isar.installmentContracts.putAll(contracts));

    final payments = _deserializePayments(data['payments']);
    await isar.writeTxn(() => isar.payments.putAll(payments));

    final witnesses = _deserializeWitnesses(data['witnesses']);
    await isar.writeTxn(() => isar.witness.putAll(witnesses));

    final sales = _deserializeSales(data['sales']);
    await isar.writeTxn(() => isar.sales.putAll(sales));

    final expenses = _deserializeExpenses(data['expenses']);
    await isar.writeTxn(() => isar.expenses.putAll(expenses));

    final investments = _deserializeInvestments(data['investments']);
    await isar.writeTxn(() => isar.investments.putAll(investments));

    debugPrint(
      'BackupService: Deserialized — '
      '${bikes.length} bikes, ${customers.length} customers, '
      '${contracts.length} contracts, ${payments.length} payments, '
      '${investments.length} investments',
    );
  }

  // --- Individual model deserializers ---

  Bike _mapToBike(Map<String, dynamic> m) {
    final b = Bike()
      ..id = m['id'] as int
      ..engineNumber = m['engineNumber'] as String
      ..chassisNumber = m['chassisNumber'] as String
      ..model = m['model'] as String
      ..brand = m['brand'] as String
      ..color = m['color'] as String
      ..modelYear = m['modelYear'] as int
      ..purchasePrice = (m['purchasePrice'] as num).toDouble()
      ..cashSalePrice = (m['cashSalePrice'] as num).toDouble()
      ..fundedByPersonal = (m['fundedByPersonal'] as num?)?.toDouble() ?? 0.0
      ..fundedByPartnership = (m['fundedByPartnership'] as num?)?.toDouble() ?? 0.0
      ..fundedByOther = (m['fundedByOther'] as num?)?.toDouble() ?? 0.0
      ..fundedByLoan = (m['fundedByLoan'] as num?)?.toDouble() ?? 0.0
      ..imageFilename = m['imageFilename'] as String?
      ..status = BikeStatusEnum.values[m['status'] as int]
      ..condition = BikeConditionEnum.values[m['condition'] as int]
      ..dateAdded = DateTime.parse(m['dateAdded'] as String)
      ..dateSold = m['dateSold'] != null ? DateTime.parse(m['dateSold'] as String) : null
      ..notes = m['notes'] as String?
      ..investmentAmount = (m['investmentAmount'] as num?)?.toDouble() ?? 0.0
      ..registrationNumber = m['registrationNumber'] as String?
      ..purchaserName = m['purchaserName'] as String?
      ..purchaserPhone = m['purchaserPhone'] as String?
      ..purchaserCnic = m['purchaserCnic'] as String?
      ..purchaserCnicFrontFilename = m['purchaserCnicFrontFilename'] as String?
      ..purchaserCnicBackFilename = m['purchaserCnicBackFilename'] as String?;
    return b;
  }

  List<Customer> _deserializeCustomers(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return Customer()
        ..id = m['id'] as int
        ..fullName = m['fullName'] as String
        ..fatherName = m['fatherName'] as String?
        ..cnicNumber = m['cnicNumber'] as String
        ..phoneNumber = m['phoneNumber'] as String
        ..alternativePhone = m['alternativePhone'] as String?
        ..address = m['address'] as String?
        ..profileImageFilename = m['profileImageFilename'] as String?
        ..cnicFrontFilename = m['cnicFrontFilename'] as String?
        ..cnicBackFilename = m['cnicBackFilename'] as String?
        ..dateRegistered = DateTime.parse(m['dateRegistered'] as String)
        ..notes = m['notes'] as String?;
    }).toList();
  }

  List<Supplier> _deserializeSuppliers(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return Supplier()
        ..id = m['id'] as int
        ..name = m['name'] as String
        ..cnic = m['cnic'] as String
        ..phone = m['phone'] as String
        ..profilePicFilename = m['profilePicFilename'] as String?
        ..cnicPicFilename = m['cnicPicFilename'] as String?;
    }).toList();
  }

  PurchaseBatch _mapToPurchaseBatch(Map<String, dynamic> m) {
    return PurchaseBatch()
      ..id = m['id'] as int
      ..purchaseDate = DateTime.parse(m['purchaseDate'] as String)
      ..totalAmount = (m['totalAmount'] as num).toDouble()
      ..totalUnits = m['totalUnits'] as int
      ..billImageFilename = m['billImageFilename'] as String?;
  }

  List<InstallmentContract> _deserializeContracts(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return InstallmentContract()
        ..id = m['id'] as int
        ..bikeId = m['bikeId'] as int
        ..customerId = m['customerId'] as int
        ..cashPrice = (m['cashPrice'] as num).toDouble()
        ..markupType = MarkupType.values[m['markupType'] as int]
        ..markupValue = (m['markupValue'] as num).toDouble()
        ..totalMarkupAmount = (m['totalMarkupAmount'] as num).toDouble()
        ..totalAmount = (m['totalAmount'] as num).toDouble()
        ..downPayment = (m['downPayment'] as num).toDouble()
        ..months = m['months'] as int
        ..monthlyEMI = (m['monthlyEMI'] as num).toDouble()
        ..contractDate = DateTime.parse(m['contractDate'] as String)
        ..firstDueDate = DateTime.parse(m['firstDueDate'] as String)
        ..dayOfMonth = m['dayOfMonth'] as int? ?? 1
        ..nextDueDate = m['nextDueDate'] != null
            ? DateTime.parse(m['nextDueDate'] as String)
            : null
        ..lastPaymentDate = m['lastPaymentDate'] != null
            ? DateTime.parse(m['lastPaymentDate'] as String)
            : null
        ..status = ContractStatusEnum.values[m['status'] as int]
        ..totalPaid = (m['totalPaid'] as num).toDouble()
        ..paymentsMade = m['paymentsMade'] as int
        ..lateFeeEnabled = m['lateFeeEnabled'] as bool? ?? false
        ..lateFeePercentage = (m['lateFeePercentage'] as num?)?.toDouble() ?? 0
        ..notes = m['notes'] as String?
        ..discountAmount = (m['discountAmount'] as num?)?.toDouble() ?? 0.0
        ..discountPercentage = (m['discountPercentage'] as num?)?.toDouble() ?? 0.0
        ..isWaived = m['isWaived'] as bool? ?? false;
    }).toList();
  }

  List<Payment> _deserializePayments(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return Payment()
        ..id = m['id'] as int
        ..contractId = m['contractId'] as int
        ..amount = (m['amount'] as num).toDouble()
        ..paymentDate = DateTime.parse(m['paymentDate'] as String)
        ..dueDate = m['dueDate'] != null
            ? DateTime.parse(m['dueDate'] as String)
            : null
        ..method = PaymentMethod.values[m['method'] as int]
        ..collectorName = m['collectorName'] as String?
        ..isDownPayment = m['isDownPayment'] as bool? ?? false
        ..isLateFee = m['isLateFee'] as bool? ?? false
        ..notes = m['notes'] as String?
        ..receiptNumber = m['receiptNumber'] as String?;
    }).toList();
  }

  List<Witness> _deserializeWitnesses(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return Witness()
        ..id = m['id'] as int
        ..fullName = m['fullName'] as String
        ..cnicNumber = m['cnicNumber'] as String
        ..phoneNumber = m['phoneNumber'] as String
        ..relationship = m['relationship'] as String?
        ..address = m['address'] as String?
        ..cnicFrontFilename = m['cnicFrontFilename'] as String?
        ..cnicBackFilename = m['cnicBackFilename'] as String?
        ..contractId = m['contractId'] as int
        ..isPrimary = m['isPrimary'] as bool? ?? true;
    }).toList();
  }

  List<Sale> _deserializeSales(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return Sale()
        ..id = m['id'] as int
        ..saleDate = DateTime.parse(m['saleDate'] as String)
        ..saleType = SaleType.values[m['saleType'] as int]
        ..bikeId = m['bikeId'] as int
        ..customerId = m['customerId'] as int
        ..totalAmount = (m['totalAmount'] as num).toDouble()
        ..receivedAmount = (m['receivedAmount'] as num).toDouble()
        ..installmentContractId = m['installmentContractId'] as int?
        ..notes = m['notes'] as String?
        ..discountAmount = (m['discountAmount'] as num?)?.toDouble() ?? 0.0
        ..discountPercentage = (m['discountPercentage'] as num?)?.toDouble() ?? 0.0;
    }).toList();
  }

  List<Expense> _deserializeExpenses(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return Expense()
        ..id = m['id'] as int
        ..category = m['category'] as String
        ..amount = (m['amount'] as num).toDouble()
        ..date = DateTime.parse(m['date'] as String)
        ..description = m['description'] as String?;
    }).toList();
  }

  List<Investment> _deserializeInvestments(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return Investment()
        ..id = m['id'] as int
        ..amount = (m['amount'] as num).toDouble()
        ..date = DateTime.parse(m['date'] as String)
        ..type = InvestmentTypeEnum.values[m['type'] as int]
        ..category = InvestmentCategoryEnum.values[m['category'] as int]
        ..description = m['description'] as String?
        ..bikeId = m['bikeId'] as int?
        ..purchaseBatchId = m['purchaseBatchId'] as int?
        ..profitAmount = (m['profitAmount'] as num?)?.toDouble() ?? 0.0
        ..saleId = m['saleId'] as int?
        ..installmentContractId = m['installmentContractId'] as int?
        ..returnPersonal = (m['returnPersonal'] as num?)?.toDouble() ?? 0.0
        ..returnPartnership = (m['returnPartnership'] as num?)?.toDouble() ?? 0.0
        ..returnOther = (m['returnOther'] as num?)?.toDouble() ?? 0.0
        ..returnLoan = (m['returnLoan'] as num?)?.toDouble() ?? 0.0;
    }).toList();
  }

  List<AppSettings> _deserializeSettings(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return AppSettings()
        ..id = m['id'] as int
        ..defaultMarkupPercentage = (m['defaultMarkupPercentage'] as num?)?.toDouble() ?? 40.0
        ..automaticLateFeeEnabled = m['automaticLateFeeEnabled'] as bool? ?? true
        ..lateFeePercentage = (m['lateFeePercentage'] as num?)?.toDouble() ?? 5.0
        ..cloudSyncEnabled = m['cloudSyncEnabled'] as bool? ?? false
        ..isDarkTheme = m['isDarkTheme'] as bool? ?? true
        ..showroomName = m['showroomName'] as String? ?? 'AL-TAHIR Showroom'
        ..showroomLogoPath = m['showroomLogoPath'] as String?
        ..showroomAddress = m['showroomAddress'] as String?
        ..showroomPhone = m['showroomPhone'] as String?
        ..currencySymbol = m['currencySymbol'] as String? ?? 'Rs'
        ..dateFormat = m['dateFormat'] as String? ?? 'dd/MM/yyyy'
        ..pdfDownloadLocation = m['pdfDownloadLocation'] as String?
        ..emiRounding = m['emiRounding'] as String? ?? 'Nearest 50'
        ..defaultExpenseCategories = m['defaultExpenseCategories'] as String? ??
            'Building Rent,Electricity,Snacks/Tea,Salaries,Maintenance'
        ..lastBackupDate = m['lastBackupDate'] != null
            ? DateTime.parse(m['lastBackupDate'] as String)
            : null
        ..ownerName = m['ownerName'] as String?
        ..ownerProfilePicPath = m['ownerProfilePicPath'] as String?
        ..bikeBrands = m['bikeBrands'] as String? ??
            'Honda,Suzuki,Yamaha,United,Road Prince,Super Power,Hi Speed,Unique,Crown,Pak Hero'
        ..bikeModels = m['bikeModels'] as String? ??
            'CG125,CD70,GS150,CB150F,Pridor,CG125S,CB150F-SE,YBR125,GD110,GR150'
        ..bikeYears = m['bikeYears'] as String? ?? '2024,2025,2026';
    }).toList();
  }

  List<User> _deserializeUsers(dynamic raw) {
    final list = (raw as List?)?.cast<Map<String, dynamic>>() ?? [];
    return list.map((m) {
      return User()
        ..id = m['id'] as int
        ..username = m['username'] as String
        ..passwordHash = m['passwordHash'] as String
        ..displayName = m['displayName'] as String
        ..isActive = m['isActive'] as bool? ?? true
        ..dateCreated = DateTime.parse(m['dateCreated'] as String)
        ..lastLogin = m['lastLogin'] != null
            ? DateTime.parse(m['lastLogin'] as String)
            : null;
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> _buildManifest() async {
    final isar = _isarService.isar;

    return {
      'appName': 'AL-TAHIR Showroom',
      'appVersion': '1.0.0',
      'formatVersion': 2,
      'backupDate': DateTime.now().toIso8601String(),
      'isarVersion': '3.1.0+1',
      'collections': {
        'bikes': await isar.bikes.count(),
        'customers': await isar.customers.count(),
        'installmentContracts': await isar.installmentContracts.count(),
        'payments': await isar.payments.count(),
        'witnesses': await isar.witness.count(),
        'sales': await isar.sales.count(),
        'suppliers': await isar.suppliers.count(),
        'purchaseBatches': await isar.purchaseBatchs.count(),
        'expenses': await isar.expenses.count(),
        'investments': await isar.investments.count(),
        'appSettings': await isar.appSettings.count(),
        'users': await isar.users.count(),
      },
    };
  }

  Future<void> _addDirectoryToArchive(
    Archive archive,
    Directory dir,
    String archivePrefix,
  ) async {
    final entities = dir.listSync(recursive: true);
    for (final entity in entities) {
      if (entity is File) {
        final relativePath =
            p.relative(entity.path, from: dir.path).replaceAll('\\', '/');
        final archivePath = '$archivePrefix/$relativePath';
        final bytes = await entity.readAsBytes();
        archive.addFile(ArchiveFile(archivePath, bytes.length, bytes));
      }
    }
  }

  Future<void> _extractMedia(Archive archive) async {
    for (final file in archive) {
      if (file.isFile && file.name.startsWith('media/')) {
        final relativePath = file.name.substring('media/'.length);
        if (relativePath.isEmpty) continue;
        final outputPath = p.join(_fileService.mediaPath, relativePath);
        final outputFile = File(outputPath);
        await outputFile.parent.create(recursive: true);
        await outputFile.writeAsBytes(file.content as List<int>);
      }
    }
  }

  Future<void> _clearDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      try {
        await dir.delete(recursive: true);
      } catch (e) {
        debugPrint('BackupService: Could not delete $dirPath — $e');
        final entities = dir.listSync();
        for (var entity in entities) {
          if (entity is File) {
            try {
              await entity.delete();
            } catch (_) {}
          }
        }
      }
    }
    await Directory(dirPath).create(recursive: true);
  }

  Future<void> _reopenIsar() async {
    final isar = await Isar.open(
      [
        BikeSchema,
        CustomerSchema,
        InstallmentContractSchema,
        PaymentSchema,
        WitnessSchema,
        UserSchema,
        AppSettingsSchema,
        SupplierSchema,
        PurchaseBatchSchema,
        SaleSchema,
        ExpenseSchema,
        InvestmentSchema,
      ],
      directory: _fileService.databasePath,
      name: 'default',
    );

    _isarService.setIsar(isar);
  }
}
