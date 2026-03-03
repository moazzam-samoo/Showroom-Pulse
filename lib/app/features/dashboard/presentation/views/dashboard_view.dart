import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/utils/price_formatter.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/features/auth/data/auth_service.dart';
import 'package:tahir_showroom/app/core/services/notification_service.dart';
import 'package:tahir_showroom/app/core/services/theme_service.dart';
import 'package:tahir_showroom/app/data/models/notification_alert.dart';
import '../controllers/dashboard_controller.dart';

import '../widgets/kpi_section.dart';
import '../widgets/performance_chart.dart';
import '../widgets/stock_allocation_chart.dart';
import '../widgets/quick_actions.dart';
import '../widgets/upcoming_installments.dart';
import '../widgets/kpi_detail_dialogs.dart';

/// Dashboard View - Main screen after login
/// 
/// Analyzed from: Dark Theme UI/Dashboard Page.png
/// Layout:
/// - Left: Sidebar Navigation (64px)
/// - Right: Main Content
///   - Header: Title + Status Bar
///   - KPI Section: 4 gradient cards
///   - Charts Row: Performance Velocity + Stock Allocation
///   - Transaction Feed: Live table
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedNavIndex = 0;
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authService = Get.find<AuthService>();
    
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          _showExitDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Row(
        children: [
          // Sidebar
          SidebarNavigation(
            selectedIndex: _selectedNavIndex,
            onItemSelected: (index) {
              setState(() => _selectedNavIndex = index);
              switch (index) {
                case 0:
                  // Already on Dashboard
                  break;
                case 1:
                   Get.offNamed('/procurement');
                   break;
                case 2:
                  Get.offNamed('/inventory');
                  break;
                case 3:
                  Get.offNamed('/sales');
                  break;
                case 4:
                  Get.offNamed('/installments');
                  break;
                case 5:
                  Get.offNamed('/customers');
                  break;
                case 6:
                  Get.offNamed('/reports');
                  break;
                case 7:
                  Get.offNamed('/settings');
                  break;
              }
            },
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                _buildHeader(isDark, authService, controller),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        // Quick Actions Row
                        const QuickActionsRow(),
                        const SizedBox(height: AppSpacing.lg),
                        // KPI Section
                        Obx(() => KpiSection(
                          totalAssetValue: PriceFormatter.formatLakhWords(controller.totalAssetValue.value),
                          totalAssetGrowth: '+${controller.totalAssetGrowth.value.toStringAsFixed(1)}% MTD',
                          unitsInStock: controller.unitsInStock.value,
                          lowStockAlert: controller.lowStockAlert.value,
                          monthlySalesRevenue: PriceFormatter.formatLakhWords(controller.monthlyRevenue.value),
                          salesTarget: '10 Lac',
                          salesProgress: controller.revenueOnTrack.value ? 82 : 50,
                          totalInstallmentValue: PriceFormatter.formatLakhWords(controller.totalInstallmentValue.value),
                          activeContractsCount: controller.activeContracts.value,
                          onAssetValueTap: () => KpiDetailDialogs.showAssetValueDialog(context),
                          onUnitsInStockTap: () => KpiDetailDialogs.showStockDialog(context),
                          onSalesRevenueTap: () => KpiDetailDialogs.showRevenueDialog(context),
                          onCriticalArrearsTap: () => KpiDetailDialogs.showInstallmentDialog(context),
                        )),
                        const SizedBox(height: AppSpacing.lg),
                        // Charts Row
                        SizedBox(
                          height: 280,
                          child: Row(
                            children: [
                              // Performance Chart
                              Expanded(
                                flex: 2,
                                child: Obx(() => PerformanceChart(
                                  weeklyData: controller.weeklySalesData.isNotEmpty 
                                      ? controller.weeklySalesData.toList() 
                                      : [0, 0, 0, 0, 0, 0, 0],
                                  todaySales: controller.todaySalesCount.value,
                                )),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              // Stock Allocation
                              Expanded(
                                flex: 1,
                                child: Obx(() => StockAllocationChart(
                                  newModelsPercent: controller.newModelsPercent.value,
                                  newModelsCount: controller.newModelsCount.value,
                                  preOwnedPercent: controller.preOwnedPercent.value,
                                  preOwnedCount: controller.preOwnedCount.value,
                                )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Upcoming Installments (replaces empty Transaction Feed)
                        SizedBox(
                          height: 350,
                          child: Obx(() => UpcomingInstallmentsWidget(
                            installments: controller.upcomingInstallments.toList(),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, AuthService authService, DashboardController controller) {
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title Section
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final name = controller.ownerName.value;
                return Text(
                  name != null && name.isNotEmpty
                      ? 'Welcome, $name'
                      : 'Executive Command Center',
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
              Obx(() => Text(
                '${controller.showroomName.value} • Real-time Performance Metrics',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 12,
                ),
              )),
            ],
          ),
          // Right Section
          Row(
            children: [
              // Live Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() => Text(
                      'Live: ${controller.activeContracts.value} Active Installments',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Theme Toggle
              IconButton(
                icon: Icon(
                  isDark ? LucideIcons.sun : LucideIcons.moon,
                  size: 20,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                onPressed: () {
                  Get.find<ThemeService>().toggleTheme();
                },
              ),
              // Notifications
              Obx(() {
                final notifService = Get.find<NotificationService>();
                final count = notifService.alertCount;
                
                return PopupMenuButton<NotificationAlert>(
                  tooltip: 'Installment Alerts',
                  offset: const Offset(0, 48),
                  color: isDark ? AppColors.darkCard : Colors.white,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        LucideIcons.bell,
                        size: 20,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      if (count > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  itemBuilder: (context) {
                    if (count == 0) {
                      return [
                        const PopupMenuItem(
                          enabled: false,
                          child: Text('No new alerts', style: TextStyle(color: Colors.grey)),
                        )
                      ];
                    }

                    final items = <PopupMenuEntry<NotificationAlert>>[];
                    
                    items.add(
                      const PopupMenuItem(
                        enabled: false,
                        child: Text(
                          'Installment Alerts',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                    
                    items.add(const PopupMenuDivider());

                    for (var alert in notifService.pendingAlerts) {
                      items.add(
                        PopupMenuItem(
                          value: alert,
                          child: Row(
                            children: [
                              Icon(
                                alert.severity == AlertSeverity.critical ? Icons.warning_rounded : Icons.info_outline,
                                color: alert.color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${alert.severityLabel} — ${alert.customerName}',
                                      style: TextStyle(
                                        color: alert.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Rs ${alert.amountDue.toStringAsFixed(0)} due ${alert.timeText} • ${alert.bikeModel}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'View',
                                style: TextStyle(
                                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    items.add(const PopupMenuDivider());
                    items.add(
                      PopupMenuItem(
                        value: null,
                        child: Center(
                          child: Text(
                            'View All in Installments →',
                            style: TextStyle(color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary, fontSize: 12),
                          ),
                        ),
                      ),
                    );

                    return items;
                  },
                  onSelected: (alert) {
                    Get.toNamed('/installments', arguments: alert?.contractId);
                  },
                );
              }),
              // User Avatar
              const SizedBox(width: 8),
              Obx(() {
                final hasPic = controller.ownerProfilePicPath.value != null &&
                    File(controller.ownerProfilePicPath.value!).existsSync();

                return Tooltip(
                  message: controller.ownerName.value ?? authService.currentUser.value?.displayName ?? 'User',
                  child: InkWell(
                    onTap: () => _showProfileDialog(context, isDark, controller),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                        image: hasPic
                            ? DecorationImage(
                                image: FileImage(File(controller.ownerProfilePicPath.value!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: hasPic
                          ? null
                          : Center(
                              child: Text(
                                (controller.ownerName.value?.isNotEmpty == true
                                        ? controller.ownerName.value!
                                        : (authService.currentUser.value?.displayName ?? 'A'))
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context, bool isDark, DashboardController controller) {
    final TextEditingController nameController = TextEditingController(text: controller.ownerName.value);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Edit Profile',
            style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show profile picture with actions
              Obx(() {
                final hasPic = controller.ownerProfilePicPath.value != null &&
                    File(controller.ownerProfilePicPath.value!).existsSync();
                return Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                        shape: BoxShape.circle,
                        image: hasPic
                            ? DecorationImage(
                                image: FileImage(File(controller.ownerProfilePicPath.value!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: hasPic
                          ? null
                          : Icon(LucideIcons.user, size: 40, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () => controller.uploadProfilePicture(),
                          icon: Icon(LucideIcons.camera, size: 16, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                          label: Text('Upload', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary)),
                        ),
                        if (hasPic)
                          TextButton.icon(
                            onPressed: () => controller.removeProfilePicture(),
                            icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                            label: const Text('Remove', style: TextStyle(fontSize: 12, color: Colors.red)),
                          ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                decoration: InputDecoration(
                  labelText: 'Owner Name',
                  labelStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  filled: true,
                  fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) {
                  controller.updateOwnerName(nameController.text.trim());
                  Get.back();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateOwnerName(nameController.text.trim());
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showExitDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text(
          'Exit Application',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to exit the application?',
          style: TextStyle(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'No',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => exit(0),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Exit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Removed _getSampleTransactions() method - using real data now
}

// Authored by: Moazzam Samoo
