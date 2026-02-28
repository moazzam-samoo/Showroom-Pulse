import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';

/// KPI Card Widget
/// 
/// Analyzed from: Dark Theme UI/Dashboard Page.png
/// - Gradient background (blue gradient)
/// - White text for values and labels
/// - Small icon (right-aligned, semi-transparent)
/// - Border radius: 12px
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? subtitleColor;
  final bool showAlert;
  final String? alertText;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.subtitleColor,
    this.showAlert = false,
    this.alertText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightGradientDark, // #1a5276
            AppColors.lightGradientLight, // #2980b9
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGradientDark.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row - Title and Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                icon,
                size: 16,
                color: Colors.white38,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Value
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Subtitle or Alert
          if (showAlert && alertText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.alertTriangle,
                    size: 12,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      alertText!,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ] else if (subtitle != null) ...[
            Text(
              subtitle!,
              style: TextStyle(
                color: subtitleColor ?? Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            const Text(
              ' ',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

/// KPI Section - Row of 4 KPI Cards
/// 
/// Layout from Dashboard: Total Asset Value, Units in Stock, 
/// Monthly Sales Revenue, Critical Arrears
class KpiSection extends StatelessWidget {
  final String totalAssetValue;
  final String totalAssetGrowth;
  final int unitsInStock;
  final int lowStockAlert;
  final String monthlySalesRevenue;
  final String salesTarget;
  final int salesProgress;
  final String criticalArrears;
  final int accountsOverdue;
  final bool hasRecoveryInProgress;

  const KpiSection({
    super.key,
    this.totalAssetValue = 'Rs. 0',
    this.totalAssetGrowth = '+0% MTD Growth',
    this.unitsInStock = 0,
    this.lowStockAlert = 0,
    this.monthlySalesRevenue = 'Rs. 0',
    this.salesTarget = 'Rs. 0',
    this.salesProgress = 0,
    this.criticalArrears = 'Rs. 0',
    this.accountsOverdue = 0,
    this.hasRecoveryInProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Total Asset Value
          Expanded(
            child: KpiCard(
              title: 'TOTAL ASSET VALUE',
              value: totalAssetValue,
              subtitle: totalAssetGrowth,
              subtitleColor: Colors.greenAccent,
              icon: LucideIcons.dollarSign,
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          // Units in Stock
          Expanded(
            child: KpiCard(
              title: 'UNITS IN STOCK',
              value: '$unitsInStock Units',
              icon: LucideIcons.boxes,
              showAlert: lowStockAlert > 0,
              alertText: 'Low Stock Alert: CD70 ($lowStockAlert Left)',
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          // Monthly Sales Revenue
          Expanded(
            child: _buildSalesRevenueCard(),
          ),
          const SizedBox(width: AppSpacing.base),
          // Critical Arrears
          Expanded(
            child: KpiCard(
              title: 'CRITICAL ARREARS',
              value: criticalArrears,
              subtitle: '$accountsOverdue Accounts Overdue',
              icon: LucideIcons.alertCircle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesRevenueCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightGradientDark,
            AppColors.lightGradientLight,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGradientDark.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: const Text(
                  'MONTHLY SALES REVENUE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.dollarSign,
                size: 16,
                color: Colors.white38,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            monthlySalesRevenue,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                'Target: $salesTarget',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$salesProgress%',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Authored by: Moazzam Samoo
