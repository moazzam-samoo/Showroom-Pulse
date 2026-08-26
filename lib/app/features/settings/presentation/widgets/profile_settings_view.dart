import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../auth/data/auth_service.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
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
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
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
                  if (settings.ownerProfilePicPath != null &&
                      File(settings.ownerProfilePicPath!).existsSync())
                    Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
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
                        color: isDark
                            ? AppColors.darkCard
                            : AppColors.lightSurface,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                      ),
                      child: Icon(
                        LucideIcons.user,
                        size: 24,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton.icon(
                    icon: const Icon(LucideIcons.camera, size: 14),
                    label: const Text('Upload Photo',
                        style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.darkCard : AppColors.lightSurface,
                      foregroundColor: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      side: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
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
              controller: controller.ownerNameController,
              hintText: 'e.g. Tahir',
              isDark: isDark,
              action: ElevatedButton(
                onPressed: () => controller.updateOwnerName(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Save',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          _divider(isDark),

          // Credential Management Section
          Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.lg, bottom: AppSpacing.sm),
            child: Text(
              'Account Credentials',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),

          // Update Username
          _buildCredentialRow(
            title: 'Login Username',
            subtitle:
                'Current: ${Get.find<AuthService>().currentUser.value?.username ?? "admin"}',
            isDark: isDark,
            buttonLabel: 'Update Username',
            onTap: () => _showUpdateUsernameDialog(context, isDark),
          ),
          _divider(isDark),

          // Update Password
          _buildCredentialRow(
            title: 'Login Password',
            subtitle: 'Choose a strong password for account security',
            isDark: isDark,
            buttonLabel: 'Change Password',
            onTap: () => _showUpdatePasswordDialog(context, isDark),
          ),
          _divider(isDark),

          const SizedBox(height: 40),
        ],
      );
    });
  }

  Widget _buildCredentialRow({
    required String title,
    required String subtitle,
    required bool isDark,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppColors.darkCard : AppColors.lightSurface,
              foregroundColor:
                  isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(buttonLabel,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showUpdateUsernameDialog(BuildContext context, bool isDark) {
    final usernameController = TextEditingController(
        text: Get.find<AuthService>().currentUser.value?.username);

    Get.dialog(
      AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text('Update Username',
            style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: usernameController,
              autofocus: true,
              style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                labelText: 'New Username',
                labelStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (usernameController.text.trim().isEmpty) {
                AppToast.showError(
                    title: 'Error', message: 'Username cannot be empty');
                return;
              }
              final success = await controller.updateCredentials(
                  usernameController.text.trim(), '');
              if (success) {
                Get.back();
                AppToast.showSuccess(
                    title: 'Success', message: 'Username updated successfully');
              } else {
                AppToast.showError(
                    title: 'Error', message: 'Failed to update username');
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showUpdatePasswordDialog(BuildContext context, bool isDark) {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text('Change Password',
            style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: confirmController,
              obscureText: true,
              style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (passwordController.text.isEmpty) {
                AppToast.showError(
                    title: 'Error', message: 'Password cannot be empty');
                return;
              }
              if (passwordController.text != confirmController.text) {
                AppToast.showError(
                    title: 'Error', message: 'Passwords do not match');
                return;
              }
              final success = await controller.updateCredentials(
                  '', passwordController.text);
              if (success) {
                Get.back();
                AppToast.showSuccess(
                    title: 'Success', message: 'Password changed successfully');
              } else {
                AppToast.showError(
                    title: 'Error', message: 'Failed to change password');
              }
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark
          ? AppColors.darkBorder.withValues(alpha: 0.5)
          : AppColors.lightBorderLight,
    );
  }

  Future<void> _handleProfilePicUpload(settings) async {
    final dashboardController = Get.find<DashboardController>();
    final success = await dashboardController.uploadProfilePicture();

    if (success) {
      // Keep SettingsController's copy in sync so this screen's Obx reflects it too
      settings.ownerProfilePicPath = dashboardController.ownerProfilePicPath.value;
      controller.settings.refresh();
      AppToast.showSuccess(
          title: 'Profile Updated',
          message: 'Profile picture saved successfully');
    }
    // uploadProfilePicture() already shows its own error snackbar on failure
  }

  Widget _buildSettingInputRow({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required bool isDark,
    String? hintText,
    Widget? action,
  }) {
    return _buildSettingRow(
      title: title,
      subtitle: subtitle,
      isDark: isDark,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 240,
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.md),
            action,
          ],
        ],
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
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
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
