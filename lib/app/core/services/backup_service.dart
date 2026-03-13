import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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

/// BackupService — Handles database export and import operations
///
/// Export: Isar copyToFile() + Media folder → single .tahir ZIP
/// Import: Extract .tahir ZIP → replace Database/ + Media/ → restart
class BackupService {
  final IsarService _isarService;
  final FileService _fileService;

  BackupService(this._isarService, this._fileService);

  // ═══════════════════════════════════════════════════════════
  //  EXPORT
  // ═══════════════════════════════════════════════════════════

  /// Export database + media to a .tahir backup file
  /// Returns the path to the saved backup file, or null on failure
  Future<String?> exportBackup({Function(String)? onProgress}) async {
    try {
      onProgress?.call('Preparing backup...');

      // 1. Create temp directory for staging
      final tempDir = await getTemporaryDirectory();
      final stagingDir = Directory(p.join(tempDir.path, 'tahir_backup_staging'));
      if (await stagingDir.exists()) {
        await stagingDir.delete(recursive: true);
      }
      await stagingDir.create(recursive: true);

      // 2. Copy Isar database to staging
      onProgress?.call('Copying database...');
      final dbStagingDir = Directory(p.join(stagingDir.path, 'database'));
      await dbStagingDir.create();
      final dbSnapshotPath = p.join(dbStagingDir.path, 'default.isar');
      await _isarService.isar.copyToFile(dbSnapshotPath);

      // 3. Gather record counts for manifest
      onProgress?.call('Gathering statistics...');
      final manifest = await _buildManifest();

      // 4. Write manifest.json
      final manifestFile = File(p.join(stagingDir.path, 'manifest.json'));
      await manifestFile.writeAsString(const JsonEncoder.withIndent('  ').convert(manifest));

      // 5. Build ZIP archive
      onProgress?.call('Creating backup archive...');
      final archive = Archive();

      // Add manifest
      final manifestBytes = await manifestFile.readAsBytes();
      archive.addFile(ArchiveFile('manifest.json', manifestBytes.length, manifestBytes));

      // Add database snapshot
      final dbBytes = await File(dbSnapshotPath).readAsBytes();
      archive.addFile(ArchiveFile('database/default.isar', dbBytes.length, dbBytes));

      // Add media files
      onProgress?.call('Adding media files...');
      final mediaDir = Directory(_fileService.mediaPath);
      if (await mediaDir.exists()) {
        await _addDirectoryToArchive(archive, mediaDir, 'media');
      }

      // 6. Encode ZIP
      onProgress?.call('Compressing...');
      final zipData = ZipEncoder().encode(archive);
      if (zipData == null) {
        debugPrint('BackupService: ZIP encoding returned null');
        return null;
      }

      // 7. Let user pick save location
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

      // 8. Write to chosen location
      onProgress?.call('Saving backup...');
      final outputFile = File(savePath);
      await outputFile.writeAsBytes(zipData);

      // 9. Cleanup staging
      await stagingDir.delete(recursive: true);

      final fileSizeMB = (await outputFile.length()) / (1024 * 1024);
      debugPrint('BackupService: Backup saved to $savePath (${fileSizeMB.toStringAsFixed(1)} MB)');

      return savePath;
    } catch (e) {
      debugPrint('BackupService: Export failed — $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  IMPORT
  // ═══════════════════════════════════════════════════════════

  /// Import a .tahir backup file, replacing all current data
  /// Returns a map with backup info on success, null on failure
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

      // Find manifest
      final manifestFile = archive.findFile('manifest.json');
      if (manifestFile == null) {
        return {'error': 'Invalid backup file — no manifest found'};
      }

      final manifest = json.decode(utf8.decode(manifestFile.content as List<int>)) as Map<String, dynamic>;
      manifest['_filePath'] = file.path;
      manifest['_fileSize'] = (await file.length()) / (1024 * 1024);

      return manifest;
    } catch (e) {
      debugPrint('BackupService: getBackupInfo failed — $e');
      return {'error': 'Failed to read backup: $e'};
    }
  }

  /// Perform the actual import from a previously validated backup file path
  Future<bool> importBackup(String filePath, {Function(String)? onProgress}) async {
    try {
      onProgress?.call('Reading backup file...');
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Validate structure
      final hasDb = archive.findFile('database/default.isar') != null;
      final hasManifest = archive.findFile('manifest.json') != null;

      if (!hasDb || !hasManifest) {
        debugPrint('BackupService: Invalid backup structure');
        return false;
      }

      // 1. Close current Isar instance and delete files
      onProgress?.call('Closing database...');
      await _isarService.isar.close(deleteFromDisk: true);

      // 2. Ensure db directory is cleared properly for Windows
      onProgress?.call('Clearing old data...');
      final dbDir = Directory(_fileService.databasePath);
      if (await dbDir.exists()) {
        try {
          // Attempt to delete directory entirely
          await dbDir.delete(recursive: true);
        } catch (e) {
          debugPrint('BackupService: Could not delete entire dbDir, deleting contents instead - $e');
          // If Windows locks the directory itself, delete files inside instead
          final entities = dbDir.listSync();
          for (var entity in entities) {
            if (entity is File) {
              try {
                await entity.delete();
              } catch (_) {}
            }
          }
        }
      }
      
      if (!await dbDir.exists()) {
        await dbDir.create(recursive: true);
      }

      // 3. Clear existing media files
      final mediaDir = Directory(_fileService.mediaPath);
      if (await mediaDir.exists()) {
        await mediaDir.delete(recursive: true);
        await mediaDir.create(recursive: true);
      }

      // 4. Extract database
      onProgress?.call('Restoring database...');
      for (final file in archive) {
        if (file.isFile && file.name.startsWith('database/')) {
          final relativePath = file.name.substring('database/'.length);
          final outputPath = p.join(_fileService.databasePath, relativePath);
          final outputFile = File(outputPath);
          await outputFile.parent.create(recursive: true);
          await outputFile.writeAsBytes(file.content as List<int>);
        }
      }

      // 5. Extract media files
      onProgress?.call('Restoring media files...');
      for (final file in archive) {
        if (file.isFile && file.name.startsWith('media/')) {
          final relativePath = file.name.substring('media/'.length);
          final outputPath = p.join(_fileService.mediaPath, relativePath);
          final outputFile = File(outputPath);
          await outputFile.parent.create(recursive: true);
          await outputFile.writeAsBytes(file.content as List<int>);
        }
      }

      // 6. Re-open Isar with all schemas
      onProgress?.call('Restarting database...');
      await _reopenIsar();

      debugPrint('BackupService: Import completed successfully');
      return true;
    } catch (e) {
      debugPrint('BackupService: Import failed — $e');
      // Attempt recovery — reopen Isar even on failure
      try {
        await _reopenIsar();
      } catch (_) {}
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════

  /// Build manifest with metadata and record counts
  Future<Map<String, dynamic>> _buildManifest() async {
    final isar = _isarService.isar;

    return {
      'appName': 'Tahir Showroom',
      'appVersion': '1.0.0',
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
        'appSettings': await isar.appSettings.count(),
        'users': await isar.users.count(),
      },
    };
  }

  /// Recursively add all files in a directory to an archive
  Future<void> _addDirectoryToArchive(Archive archive, Directory dir, String archivePrefix) async {
    final entities = dir.listSync(recursive: true);
    for (final entity in entities) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: dir.path).replaceAll('\\', '/');
        final archivePath = '$archivePrefix/$relativePath';
        final bytes = await entity.readAsBytes();
        archive.addFile(ArchiveFile(archivePath, bytes.length, bytes));
      }
    }
  }

  /// Re-open Isar after import with all registered schemas
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
      ],
      directory: _fileService.databasePath,
      name: 'default',
    );

    // Update the IsarService's internal reference
    _isarService.setIsar(isar);
  }
}
