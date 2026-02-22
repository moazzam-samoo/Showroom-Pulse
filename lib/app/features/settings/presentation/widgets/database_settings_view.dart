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

    return ListView(
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
          subtitle: 'Save a copy of your entire system to Downloads',
          buttonLabel: 'Export Data',
          icon: LucideIcons.download,
          isDark: isDark,
          isDanger: false,
          onPressed: () {
            Get.snackbar(
              'Coming Soon',
              'Export feature will be available in the next release.',
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
              colorText: Colors.blue,
            );
          },
        ),
        _divider(isDark),

        // Import
        _buildActionRow(
          title: 'Import Database Backup',
          subtitle: 'Restore from a previously exported backup file',
          buttonLabel: 'Import Data',
          icon: LucideIcons.upload,
          isDark: isDark,
          isDanger: false,
          onPressed: () {
            Get.snackbar(
              'Coming Soon',
              'Import feature will be available in the next release.',
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
              colorText: Colors.blue,
            );
          },
        ),
        _divider(isDark),

        // Factory Reset
        _buildActionRow(
          title: 'Factory Data Reset',
          subtitle: 'Permanently delete all Bikes, Sales, Installments, and Customers',
          buttonLabel: 'Clear All Data',
          icon: LucideIcons.trash2,
          isDark: isDark,
          isDanger: true,
          onPressed: () => _handleClearData(context),
        ),

        const SizedBox(height: 40),
      ],
    );
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

  void _handleClearData(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      AlertDialog(
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
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkError : AppColors.lightError,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () async {
              Get.back();
              final isarService = Get.find<IsarService>();
              await isarService.clearAllData();
              Get.snackbar(
                'Data Cleared',
                'All application data has been permanently deleted.',
                backgroundColor: (isDark ? AppColors.darkError : AppColors.lightError).withValues(alpha: 0.1),
                colorText: isDark ? AppColors.darkError : AppColors.lightError,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Delete All Data', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
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
    required VoidCallback onPressed,
  }) {
    final dangerColor = isDark ? AppColors.darkError : AppColors.lightError;

    return _buildInfoRow(
      title: title,
      subtitle: subtitle,
      icon: icon,
      isDark: isDark,
      trailing: ElevatedButton.icon(
        icon: Icon(icon, size: 14),
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
