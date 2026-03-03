import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/isar_service.dart';
import '../controllers/settings_controller.dart';

class DatabaseSettingsView extends GetView<SettingsController> {
  const DatabaseSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => ListView(
      primary: false,
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          'Database Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Storage Path
        _buildInfoRow(
          title: 'Storage Path',
          subtitle: 'Where data is safely stored locally on this machine',
          icon: LucideIcons.hardDrive,
          isDark: isDark,
          trailing: FutureBuilder<String>(
            future: _getDatabasePath(),
            builder: (context, snapshot) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 240),
                child: Text(
                  snapshot.data ?? 'Loading...',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontFamily: 'Consolas',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              );
            },
          ),
        ),
        _divider(isDark),

        // Export
        _buildActionRow(
          title: 'Export Database Backup',
          subtitle: 'Save a copy of your entire system (database + images)',
          buttonLabel: controller.isExporting.value ? 'Exporting...' : 'Export Data',
          icon: LucideIcons.download,
          isDark: isDark,
          isDanger: false,
          isLoading: controller.isExporting.value,
          onPressed: controller.isExporting.value ? null : () => controller.exportDatabase(),
        ),

        // Export progress indicator
        if (controller.isExporting.value && controller.exportProgress.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 4, bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 14, height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  controller.exportProgress.value,
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ],
            ),
          ),

        _divider(isDark),

        // Import
        _buildActionRow(
          title: 'Import Database Backup',
          subtitle: 'Restore from a previously exported .tahir backup file',
          buttonLabel: controller.isImporting.value ? 'Importing...' : 'Import Data',
          icon: LucideIcons.upload,
          isDark: isDark,
          isDanger: false,
          isLoading: controller.isImporting.value,
          onPressed: controller.isImporting.value ? null : () => controller.importDatabase(),
        ),

        // Import progress indicator
        if (controller.isImporting.value && controller.importProgress.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 4, bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 14, height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  controller.importProgress.value,
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ],
            ),
          ),

        _divider(isDark),

        // Reset App
        _buildActionRow(
          title: 'Reset App',
          subtitle: 'Roll back to a checkpoint or factory reset',
          buttonLabel: 'Reset Options',
          icon: LucideIcons.rotateCcw,
          isDark: isDark,
          isDanger: true,
          onPressed: () => _handleResetApp(context),
        ),

        const SizedBox(height: 40),
      ],
    ));
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.lightBorderLight,
    );
  }

  Future<String> _getDatabasePath() async {
    final isarService = Get.find<IsarService>();
    return isarService.isar.directory ?? 'Unknown Location';
  }

  void _handleResetApp(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: isDark ? AppColors.darkError : AppColors.lightError, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text('Reset Options', style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black)),
          ],
        ),
        content: Text(
          'How would you like to reset the application?',
          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
              foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            onPressed: () {
              Get.back();
              _showCheckpointChooser(context);
            },
            child: const Text('Restore from Checkpoint'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkError : AppColors.lightError,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              _handleClearData(context);
            },
            child: const Text('Complete Factory Reset'),
          ),
        ],
      ),
    );
  }

  void _showCheckpointChooser(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final checkpoints = await controller.getCheckpoints();

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text('Select Checkpoint', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: SizedBox(
          width: 400,
          child: checkpoints.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No checkpoints available yet. Checkpoints are created automatically every 7 days.',
                    style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: checkpoints.length,
                  itemBuilder: (context, index) {
                    final cp = checkpoints[index];
                    return ListTile(
                      title: Text(cp.formattedDate, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text(cp.formattedSize, style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
                      trailing: const Icon(LucideIcons.history),
                      onTap: () {
                        Get.back(); // close chooser
                        controller.restoreFromCheckpoint(cp.filePath);
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          ),
        ],
      ),
    );
  }

  void _handleClearData(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isClearing = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            title: Row(
              children: [
                Icon(LucideIcons.alertTriangle, color: isDark ? AppColors.darkError : AppColors.lightError, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text('Factory Reset', style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black)),
              ],
            ),
            content: Text(
              'Are you absolutely sure you want to delete all application data? This action cannot be undone.',
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            actions: [
              TextButton(
                onPressed: isClearing ? null : () => Get.back(),
                child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkError : AppColors.lightError,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: isClearing ? null : () async {
                  setState(() => isClearing = true);
                  
                  // Use a small delay to let the UI render the loading spinner
                  await Future.delayed(const Duration(milliseconds: 100));
                  
                  try {
                    final isarService = Get.find<IsarService>();
                    await isarService.clearAllData();
                    
                    if (Get.isDialogOpen ?? false) {
                      Get.back(); // Only close the dialog after completion
                    }
                    
                    Get.snackbar(
                      'Data Cleared',
                      'All application data has been permanently deleted.',
                      backgroundColor: (isDark ? AppColors.darkError : AppColors.lightError).withValues(alpha: 0.1),
                      colorText: isDark ? AppColors.darkError : AppColors.lightError,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } catch (e) {
                    if (Get.isDialogOpen ?? false) {
                      Get.back(); 
                    }
                    Get.snackbar(
                      'Error',
                      'Failed to clear data.',
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      colorText: Colors.red,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: isClearing
                    ? const SizedBox(
                        width: 14, 
                        height: 14, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      )
                    : const Text('Delete All Data', style: TextStyle(fontSize: 13)),
              ),
            ],
          );
        }
      ),
      barrierDismissible: false, // Prevent accidental dismissal during operation
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          trailing,
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData icon,
    required bool isDark,
    required bool isDanger,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    final dangerColor = isDark ? AppColors.darkError : AppColors.lightError;
    final accentColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return _buildInfoRow(
      title: title,
      subtitle: subtitle,
      icon: icon,
      isDark: isDark,
      trailing: ElevatedButton.icon(
        icon: isLoading
            ? SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: isDanger ? dangerColor : accentColor))
            : Icon(icon, size: 14),
        label: Text(buttonLabel, style: const TextStyle(fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDanger ? dangerColor.withValues(alpha: 0.1) : (isDark ? AppColors.darkCard : AppColors.lightSurface),
          foregroundColor: isDanger ? dangerColor : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          side: BorderSide(
            color: isDanger ? dangerColor.withValues(alpha: 0.3) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
