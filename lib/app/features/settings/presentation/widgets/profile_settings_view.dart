import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/file_service.dart';
import '../../../../core/widgets/app_notification_dialog.dart';
import '../../../../core/widgets/app_toast.dart';
import '../controllers/settings_controller.dart';

class ProfileSettingsView extends GetView<SettingsController> {
  final GlobalKey? profilePicUploadKey;
  final GlobalKey? ownerNameInputKey;

  const ProfileSettingsView({
    super.key,
    this.profilePicUploadKey,
    this.ownerNameInputKey,
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
            'Profile Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Profile Picture
          Container(
            key: profilePicUploadKey,
            child: _buildSettingRow(
            title: 'Owner Profile Picture',
            subtitle: 'Upload a picture to display on the dashboard',
            isDark: isDark,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (settings.ownerProfilePicPath != null && File(settings.ownerProfilePicPath!).existsSync())
                  Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: FileImage(File(settings.ownerProfilePicPath!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: Icon(
                      LucideIcons.user,
                      size: 24,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton.icon(
                  icon: const Icon(LucideIcons.camera, size: 14),
                  label: const Text('Upload Photo', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                    foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () => _handleProfilePicUpload(settings),
                ),
              ],
            ),
            ),
          ),
          _divider(isDark),

          // Owner Name
          Container(
            key: ownerNameInputKey,
            child: _buildSettingInputRow(
              title: 'Owner Name',
              subtitle: 'Displays on the dashboard greeting',
              initialValue: settings.ownerName ?? '',
              hintText: 'e.g. Tahir',
              isDark: isDark,
              onSubmitted: (value) {
                settings.ownerName = value.isEmpty ? null : value;
                controller.settings.refresh();
                controller.saveSettings();
                AppToast.showSuccess(title: 'Profile Updated', message: 'Owner name saved successfully');
              },
            ),
          ),
          _divider(isDark),

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

  Future<void> _handleProfilePicUpload(settings) async {
    final fileService = Get.find<FileService>();
    final File? pickedFile = await fileService.pickImage();

    if (pickedFile != null) {
      // Re-using saveShowroomLogo logic, or ideally saveProfilePic logic.
      // Assuming saveShowroomLogo saves an image to the documents temp/db directory.
      // We'll use fileService.saveShowroomLogo for now to save the image file safely.
      final savedPath = await fileService.saveShowroomLogo(pickedFile);
      if (savedPath != null) {
        settings.ownerProfilePicPath = savedPath;
        controller.settings.refresh();
        controller.saveSettings();
        AppToast.showSuccess(title: 'Profile Updated', message: 'Profile picture saved successfully');
      } else {
        AppNotificationDialog.showError(title: 'Error', message: 'Failed to save profile picture');
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
