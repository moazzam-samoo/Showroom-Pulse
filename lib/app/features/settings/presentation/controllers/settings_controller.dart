import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/settings_repository.dart';
import '../../../../data/models/app_settings.dart';
import '../../../../core/services/backup_service.dart';
import '../../../../core/services/isar_service.dart';
import '../../../../core/services/file_service.dart';
import '../../../../core/services/checkpoint_service.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart' as tahir_showroom_walkthrough_service;

class SettingsController extends GetxController {
  final SettingsRepository _repository;
  
  SettingsController(this._repository);

  final isLoading = true.obs;
  final settings = Rxn<AppSettings>();
  final selectedCategory = 'Financials'.obs;
  final isExporting = false.obs;
  final isImporting = false.obs;
  final exportProgress = ''.obs;
  final importProgress = ''.obs;

  late final BackupService _backupService;

  @override
  void onInit() {
    super.onInit();
    _backupService = BackupService(
      Get.find<IsarService>(),
      Get.find<FileService>(),
    );
    loadSettings();
  }

  Future<void> loadSettings() async {
    isLoading.value = true;
    settings.value = await _repository.getSettings();
    isLoading.value = false;
  }

  Future<void> saveSettings() async {
    if (settings.value != null) {
      await _repository.updateSettings(settings.value!);
      
      // Notify DashboardController to reload profile and showroom data
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().loadProfileSettings();
      }
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  // ═══════════════════════════════════════════════════════════
  //  BIKE BRANDS & MODELS MANAGEMENT
  // ═══════════════════════════════════════════════════════════

  List<String> getBikeBrandsList() {
    return settings.value?.bikeBrands
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList() ?? [];
  }

  void addBikeBrand(String brand) {
    if (settings.value == null || brand.trim().isEmpty) return;
    final b = brand.trim();
    final current = getBikeBrandsList();
    if (!current.any((m) => m.toLowerCase() == b.toLowerCase())) {
      current.add(b);
      settings.value!.bikeBrands = current.join(',');
      settings.refresh();
      saveSettings();
    }
  }

  void removeBikeBrand(String brand) {
    if (settings.value == null) return;
    final current = getBikeBrandsList();
    current.removeWhere((m) => m == brand);
    settings.value!.bikeBrands = current.join(',');
    settings.refresh();
    saveSettings();
  }

  List<String> getBikeModelsList() {
    return settings.value?.bikeModels
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList() ?? [];
  }

  void addBikeModel(String model) {
    if (settings.value == null || model.trim().isEmpty) return;
    final m = model.trim();
    final current = getBikeModelsList();
    if (!current.any((x) => x.toLowerCase() == m.toLowerCase())) {
      current.add(m);
      settings.value!.bikeModels = current.join(',');
      settings.refresh();
      saveSettings();
    }
  }

  void removeBikeModel(String model) {
    if (settings.value == null) return;
    final current = getBikeModelsList();
    current.removeWhere((x) => x == model);
    settings.value!.bikeModels = current.join(',');
    settings.refresh();
    saveSettings();
  }

  Future<void> replayWalkthrough() async {
    final walkthroughService = Get.find<tahir_showroom_walkthrough_service.WalkthroughService>();
    await walkthroughService.resetAllTabs();
    Get.offAllNamed('/walkthrough');
  }

  // ═══════════════════════════════════════════════════════════
  //  BACKUP / RESTORE
  // ═══════════════════════════════════════════════════════════

  Future<void> exportDatabase() async {
    if (isExporting.value) return;
    isExporting.value = true;
    exportProgress.value = 'Starting export...';

    try {
      final path = await _backupService.exportBackup(
        onProgress: (msg) => exportProgress.value = msg,
      );

      if (path != null) {
        AppToast.showSuccess(
          title: 'Backup Saved',
          message: 'Backup file saved successfully.',
        );
      } else {
        AppNotificationDialog.showWarning(
          title: 'Export Cancelled',
          message: 'No backup file was created.',
        );
      }
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Export Failed',
        message: 'Could not create backup: $e',
      );
    } finally {
      isExporting.value = false;
      exportProgress.value = '';
    }
  }

  Future<void> importDatabase() async {
    if (isImporting.value) return;

    // Step 1: Let user pick file and show info
    importProgress.value = 'Reading backup file...';
    final info = await _backupService.getBackupInfo();

    if (info == null) return;

    if (info.containsKey('error')) {
      AppNotificationDialog.showError(
        title: 'Invalid Backup',
        message: info['error'] as String,
      );
      return;
    }

    // Step 2: Show confirmation dialog
    final filePath = info['_filePath'] as String;
    final backupDate = info['backupDate'] as String? ?? 'Unknown';
    final collections = info['collections'] as Map<String, dynamic>? ?? {};
    final totalRecords = collections.values.fold<int>(0, (sum, v) => sum + (v as int));
    final fileSizeMB = (info['_fileSize'] as double?)?.toStringAsFixed(1) ?? '?';

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Get.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Row(
          children: [
            Icon(Icons.restore, color: Get.isDarkMode ? Colors.cyanAccent : Colors.blue, size: 22),
            const SizedBox(width: 8),
            Text('Restore Backup?', style: TextStyle(fontSize: 16, color: Get.isDarkMode ? Colors.white : Colors.black)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will REPLACE all current data with the backup.',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.red[400]),
            ),
            const SizedBox(height: 12),
            _infoLine('Backup Date', backupDate.substring(0, 10)),
            _infoLine('Total Records', '$totalRecords'),
            _infoLine('File Size', '$fileSizeMB MB'),
            const SizedBox(height: 8),
            if (collections.isNotEmpty)
              ...collections.entries.map((e) =>
                _infoLine('  ${_formatCollectionName(e.key)}', '${e.value}'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: Get.isDarkMode ? Colors.white70 : Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Restore', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Step 3: Perform import
    isImporting.value = true;
    importProgress.value = 'Starting restore...';

    try {
      final success = await _backupService.importBackup(
        filePath,
        onProgress: (msg) => importProgress.value = msg,
      );

      if (success) {
        // Reload settings from new DB
        await loadSettings();

        AppToast.showSuccess(
          title: 'Restore Complete',
          message: 'All data has been restored from backup. Please restart the app for full effect.',
        );
      } else {
        AppNotificationDialog.showError(
          title: 'Restore Failed',
          message: 'Could not restore from backup. Your data may be incomplete — please try again.',
        );
      }
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Import Error',
        message: 'Unexpected error: $e',
      );
    } finally {
      isImporting.value = false;
      importProgress.value = '';
    }
  }

  Widget _infoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Get.isDarkMode ? Colors.white60 : Colors.black54)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Get.isDarkMode ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }

  String _formatCollectionName(String key) {
    final spaced = key.replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}').trim();
    if (spaced.isEmpty) return spaced;
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  // --- Checkpoint / Reset logic ---
  Future<List<CheckpointInfo>> getCheckpoints() async {
    final checkpointService = Get.find<CheckpointService>();
    return await checkpointService.getCheckpoints();
  }

  Future<void> restoreFromCheckpoint(String checkpointPath) async {
    isImporting.value = true;
    importProgress.value = 'Preparing checkpoint restore...';
    try {
      final checkpointService = Get.find<CheckpointService>();
      final success = await checkpointService.restoreFromCheckpoint(checkpointPath);
      
      if (success) {
        await Get.dialog(
          barrierDismissible: false,
          AlertDialog(
            title: const Text('Checkpoint Restored'),
            content: const Text('The checkpoint has been staged. The app will now restart to apply the rollback.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Process.start(Platform.resolvedExecutable, []);
                  exit(0);
                },
                child: const Text('Restart App'),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar('Error', 'Failed to restore checkpoint.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred restoring checkpoint: $e');
    } finally {
      isImporting.value = false;
      importProgress.value = '';
    }
  }
}
