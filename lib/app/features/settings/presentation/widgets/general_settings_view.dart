import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/file_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/widgets/app_notification_dialog.dart';
import '../../../../core/widgets/app_toast.dart';
import '../controllers/settings_controller.dart';

class GeneralSettingsView extends GetView<SettingsController> {
  final GlobalKey? replayTourKey;

  const GeneralSettingsView({
    super.key,
    this.replayTourKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final settings = controller.settings.value;
      if (settings == null) return const SizedBox.shrink();

      return ListView(
        primary: false,
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'General Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Showroom Name
          _buildSettingInputRow(
            title: 'Showroom Name',
            subtitle: 'Used in PDF headers, reports, and statements',
            initialValue: settings.showroomName,
            isDark: isDark,
            onSubmitted: (value) {
              settings.showroomName = value;
              controller.settings.refresh();
              controller.saveSettings();
              AppToast.showSuccess(title: 'Settings Saved', message: 'Showroom name updated');
            },
          ),
          _divider(isDark),

          // Showroom Logo
          _buildSettingRow(
            title: 'Showroom Logo',
            subtitle: 'Upload a custom logo for printed reports',
            isDark: isDark,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (settings.showroomLogoPath != null && File(settings.showroomLogoPath!).existsSync())
                  Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      image: DecorationImage(
                        image: FileImage(File(settings.showroomLogoPath!)),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ElevatedButton.icon(
                  icon: const Icon(LucideIcons.image, size: 14),
                  label: const Text('Upload Logo', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () => _handleLogoUpload(settings),
                ),
              ],
            ),
          ),
          _divider(isDark),

          // Showroom Address
          _buildSettingInputRow(
            title: 'Showroom Address',
            subtitle: 'Optional — for PDF footers and printed statements',
            initialValue: settings.showroomAddress ?? '',
            isDark: isDark,
            hintText: '123 Main Street, City',
            onSubmitted: (value) {
              settings.showroomAddress = value.isEmpty ? null : value;
              controller.settings.refresh();
              controller.saveSettings();
              AppToast.showSuccess(title: 'Settings Saved', message: 'Showroom address updated');
            },
          ),
          _divider(isDark),

          // Showroom Phone
          _buildSettingInputRow(
            title: 'Showroom Phone',
            subtitle: 'Optional — appears on PDF header/footer',
            initialValue: settings.showroomPhone ?? '',
            isDark: isDark,
            hintText: '0300-1234567',
            onSubmitted: (value) {
              settings.showroomPhone = value.isEmpty ? null : value;
              controller.settings.refresh();
              controller.saveSettings();
              AppToast.showSuccess(title: 'Settings Saved', message: 'Showroom phone updated');
            },
          ),
          _divider(isDark),

          // Currency Symbol
          _buildSettingRow(
            title: 'Currency Symbol',
            subtitle: 'Local currency prefix displayed across the app',
            isDark: isDark,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder, width: 0.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: ['Rs', 'PKR', '\$', '€', '£'].contains(settings.currencySymbol) ? settings.currencySymbol : 'Rs',
                  dropdownColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                  isDense: true,
                  style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  items: ['Rs', 'PKR', '\$', '€', '£']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settings.currencySymbol = value;
                      controller.settings.refresh();
                      controller.saveSettings();
                      AppToast.showSuccess(title: 'Settings Saved', message: 'Currency changed to $value');
                    }
                  },
                ),
              ),
            ),
          ),
          _divider(isDark),

          // Theme Toggle
          _buildSettingRow(
            title: 'Dark Theme (Executive Mode)',
            subtitle: 'Switch between dark executive theme and light theme',
            isDark: isDark,
            trailing: Switch(
              value: settings.isDarkTheme,
              activeColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              onChanged: (value) {
                settings.isDarkTheme = value;
                controller.settings.refresh();
                controller.saveSettings();
                Get.find<ThemeService>().setThemeMode(value);
              },
            ),
          ),
          _divider(isDark),

          // Walkthrough Replay
          Container(
            key: replayTourKey,
            child: _buildSettingRow(
            title: 'App Walkthrough',
            subtitle: 'Restart the guided tour of AL-AL-TAHIR Showroom',
            isDark: isDark,
            trailing: ElevatedButton.icon(
              icon: const Icon(LucideIcons.playCircle, size: 14),
              label: const Text('Replay Tour', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: () {
                AppNotificationDialog.showConfirmation(
                  title: 'Replay Walkthrough?',
                  message: 'This will take you back to the intro screens and reset the dashboard tour.',
                  onConfirm: () => controller.replayWalkthrough(),
                  confirmText: 'Replay',
                );
              },
            ),
          ),
          ),

          const SizedBox(height: 40),
        ],
      );
    });
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.lightBorderLight,
    );
  }

  Future<void> _handleLogoUpload(settings) async {
    final fileService = Get.find<FileService>();
    final File? pickedFile = await fileService.pickImage();

    if (pickedFile != null) {
      final savedPath = await fileService.saveShowroomLogo(pickedFile);
      if (savedPath != null) {
        settings.showroomLogoPath = savedPath;
        controller.settings.refresh();
        controller.saveSettings();
        AppToast.showSuccess(title: 'Settings Saved', message: 'Showroom logo updated');
      } else {
        AppNotificationDialog.showError(title: 'Error', message: 'Failed to save logo image');
      }
    }
  }

  Widget _buildSettingInputRow({
    required String title,
    required String subtitle,
    required String initialValue,
    required bool isDark,
    required Function(String) onSubmitted,
    String? hintText,
  }) {
    return _buildSettingRow(
      title: title,
      subtitle: subtitle,
      isDark: isDark,
      trailing: SizedBox(
        width: 240,
        child: TextFormField(
          initialValue: initialValue,
          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            filled: true,
            fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onFieldSubmitted: onSubmitted,
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required String title,
    required String subtitle,
    required bool isDark,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
      child: Row(
        children: [
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
}
