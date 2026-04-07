import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/utils/price_formatter.dart';
import 'package:tahir_showroom/app/features/dashboard/presentation/controllers/dashboard_controller.dart';

class InvestmentSnapshotWidget extends GetView<DashboardController> {
  const InvestmentSnapshotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.wallet,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Investment Snapshot',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Get.toNamed('/investment'),
                child: Text(
                  'Manage →',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Obx(() => _buildSnapshotItem(
                        context: context,
                        isDark: isDark,
                        icon: Icons.inventory_2,
                        title: 'Cash in Inventory',
                        amount: controller.totalAssetValue.value,
                        color: const Color.fromARGB(255, 221, 236, 12),
                        subtitle: 'Purchase value in showroom',
                      )),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Obx(() {
                    final profit = controller.netProfit.value;
                    final isProfit = profit >= 0;
                    return _buildSnapshotItem(
                      context: context,
                      isDark: isDark,
                      icon: isProfit ? Icons.trending_up : Icons.trending_down,
                      title: 'Net Profit',
                      amount: profit,
                      color: isProfit
                          ? const Color.fromARGB(255, 32, 232, 52)
                          : Colors.red,
                      subtitle:
                          isProfit ? 'Total net earnings' : 'Total net loss',
                    );
                  }),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Obx(() => _buildSnapshotItem(
                        context: context,
                        isDark: isDark,
                        icon: Icons.schedule,
                        title: 'Future Payments',
                        amount: controller.totalInstallmentValue.value,
                        color: Colors.blue,
                        subtitle:
                            '${controller.activeContracts.value} active contracts',
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotItem({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required double amount,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              PriceFormatter.formatPKR(amount),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Authored by: Moazzam Samoo
