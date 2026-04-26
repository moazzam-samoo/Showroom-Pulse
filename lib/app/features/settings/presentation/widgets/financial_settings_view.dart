import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_toast.dart';
import '../controllers/settings_controller.dart';

class FinancialSettingsView extends GetView<SettingsController> {
  final GlobalKey? markupSliderKey;
  final GlobalKey? lateFeeToggleKey;

  const FinancialSettingsView({
    super.key,
    this.markupSliderKey,
    this.lateFeeToggleKey,
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
            'Financial Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Installment Markup
          Container(
            key: markupSliderKey,
            child: _buildSettingRow(
              title: 'Default Installment Markup (%)',
              subtitle: 'Pre-fills markup when creating new installment sales',
              isDark: isDark,
              trailing: SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${settings.defaultMarkupPercentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                          activeTrackColor: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          inactiveTrackColor: (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.2),
                          thumbColor: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 14),
                        ),
                        child: Slider(
                          value: settings.defaultMarkupPercentage,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          onChanged: (value) {
                            settings.defaultMarkupPercentage = value;
                            controller.settings.refresh();
                            controller.saveSettings();
                          },
                          onChangeEnd: (value) {
                            AppToast.showSuccess(
                                title: 'Financial Settings',
                                message:
                                    'Default markup set to ${value.toInt()}%');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _divider(isDark),

          // EMI Rounding
          _buildSettingRow(
            title: 'EMI Rounding Function',
            subtitle: 'How monthly installment amounts are rounded',
            isDark: isDark,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isDark
                        ? AppColors.darkBorderInput
                        : AppColors.lightBorder,
                    width: 0.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: ['Off', 'Nearest 10', 'Nearest 50', 'Nearest 100']
                          .contains(settings.emiRounding)
                      ? settings.emiRounding
                      : 'Off',
                  dropdownColor:
                      isDark ? AppColors.darkCard : AppColors.lightSurface,
                  isDense: true,
                  style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
                  items: ['Off', 'Nearest 10', 'Nearest 50', 'Nearest 100']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settings.emiRounding = value;
                      controller.settings.refresh();
                      controller.saveSettings();
                      AppToast.showSuccess(
                          title: 'Financial Settings',
                          message: 'EMI rounding set to $value');
                    }
                  },
                ),
              ),
            ),
          ),
          _divider(isDark),

          // Late Fee Toggle
          Container(
            key: lateFeeToggleKey,
            child: _buildSettingRow(
              title: 'Automatic Late Fee',
              subtitle: 'Apply penalty for overdue installments',
              isDark: isDark,
              trailing: Switch(
                value: settings.automaticLateFeeEnabled,
                activeThumbColor:
                    isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                onChanged: (value) {
                  settings.automaticLateFeeEnabled = value;
                  controller.settings.refresh();
                  controller.saveSettings();
                },
              ),
            ),
          ),

          // Late Fee percentage slider (only visible if enabled)
          if (settings.automaticLateFeeEnabled) ...[
            _divider(isDark),
            _buildSettingRow(
              title: 'Late Fee Percentage (%)',
              subtitle: 'Percentage of EMI applied as penalty',
              isDark: isDark,
              trailing: SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${settings.lateFeePercentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7),
                          activeTrackColor: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          inactiveTrackColor: (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.2),
                          thumbColor: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 14),
                        ),
                        child: Slider(
                          value: settings.lateFeePercentage,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          onChanged: (value) {
                            settings.lateFeePercentage = value;
                            controller.settings.refresh();
                            controller.saveSettings();
                          },
                          onChangeEnd: (value) {
                            AppToast.showSuccess(
                                title: 'Financial Settings',
                                message: 'Late fee set to ${value.toInt()}%');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          _divider(isDark),

          // Expense Categories
          _buildSettingRow(
            title: 'Default Expense Categories',
            subtitle: 'Pre-defined categories for Tracker (comma separated)',
            isDark: isDark,
            trailing: SizedBox(
              width: 240,
              child: TextFormField(
                initialValue: settings.defaultExpenseCategories,
                style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary),
                decoration: InputDecoration(
                  hintText: 'Rent, Salary, Bills...',
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
                onFieldSubmitted: (value) {
                  settings.defaultExpenseCategories = value;
                  controller.settings.refresh();
                  controller.saveSettings();
                  AppToast.showSuccess(
                      title: 'Financial Settings',
                      message: 'Expense categories updated');
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
      color: isDark
          ? AppColors.darkBorder.withValues(alpha: 0.5)
          : AppColors.lightBorderLight,
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
