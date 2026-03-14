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
import 'package:tahir_showroom/app/data/models/notification_alert.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_overlay.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_target.dart';
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

  // Coach Mark Keys
  final _sidebarKey = GlobalKey();
  final _kpiKey = GlobalKey();
  final _quickActionsKey = GlobalKey();
  final _performanceChartKey = GlobalKey();
  bool _showCoachMarks = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments['show_coach_marks'] == true) {
        setState(() {
          _showCoachMarks = true;
        });
      }
    });
  }

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
        body: Stack(
          children: [
            Row(
              children: [
                // Sidebar
                SidebarNavigation(
                  key: _sidebarKey,
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
                        QuickActionsRow(key: _quickActionsKey),
                        const SizedBox(height: AppSpacing.lg),
                        // KPI Section
                        Obx(() => KpiSection(
                          key: _kpiKey,
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
                                  key: _performanceChartKey,
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
            
            // Coach Marks Overlay
            if (_showCoachMarks)
              CoachMarkOverlay(
                targets: [
                  CoachMarkTarget(
                    targetKey: _sidebarKey,
                    title: 'Navigation Menu',
                    description: 'Access all modules of AL-TAHIR Showroom from here. Switch between sales, inventory, and customers seamlessly.',
                    position: CoachMarkPosition.right,
                  ),
                  CoachMarkTarget(
                    targetKey: _quickActionsKey,
                    title: 'Quick Actions',
                    description: 'Perform common tasks instantly with these shortcuts for the most frequent dealership operations.',
                    position: CoachMarkPosition.bottom,
                  ),
                  CoachMarkTarget(
                    targetKey: _kpiKey,
                    title: 'Key Performance Indicators',
                    description: 'Monitor your critical business metrics—assets, stock, revenue, and active installments—at a glance.',
                    position: CoachMarkPosition.bottom,
                  ),
                  CoachMarkTarget(
                    targetKey: _performanceChartKey,
                    title: 'Performance Chart',
                    description: 'Track your daily and weekly sales velocity and trends visually.',
                    position: CoachMarkPosition.right,
                  ),
                ],
                onComplete: () {
                  setState(() => _showCoachMarks = false);
                },
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
                    onTap: () => _showProfileCard(context, isDark, controller),
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

  void _showProfileCard(BuildContext context, bool isDark, DashboardController controller) {
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final showroomAddress = controller.showroomAddress.value;
    final showroomPhone = controller.showroomPhone.value;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 320,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 28, bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(0.15),
                        primaryColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      Obx(() {
                        final hasPic = controller.ownerProfilePicPath.value != null &&
                            File(controller.ownerProfilePicPath.value!).existsSync();
                        return Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryColor, width: 2.5),
                            color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                            image: hasPic
                                ? DecorationImage(
                                    image: FileImage(File(controller.ownerProfilePicPath.value!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: hasPic
                              ? null
                              : Icon(LucideIcons.user, size: 32,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        );
                      }),
                      const SizedBox(height: 12),
                      // Owner Name
                      Obx(() => Text(
                        controller.ownerName.value ?? 'Owner',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      )),
                      const SizedBox(height: 4),
                      // Showroom Name
                      Obx(() => Text(
                        controller.showroomName.value,
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ],
                  ),
                ),
                // Details section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    children: [
                      if (showroomAddress != null && showroomAddress.isNotEmpty)
                        _profileDetailRow(
                          icon: LucideIcons.mapPin,
                          label: 'Address',
                          value: showroomAddress,
                          isDark: isDark,
                          primaryColor: primaryColor,
                        ),
                      if (showroomPhone != null && showroomPhone.isNotEmpty)
                        _profileDetailRow(
                          icon: LucideIcons.phone,
                          label: 'Phone',
                          value: showroomPhone,
                          isDark: isDark,
                          primaryColor: primaryColor,
                        ),
                      if ((showroomAddress == null || showroomAddress.isEmpty) &&
                          (showroomPhone == null || showroomPhone.isEmpty))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Add your address and phone in Settings',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Bottom Action
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Icon(LucideIcons.settings, size: 16, color: primaryColor),
                      label: Text('Edit in Settings', style: TextStyle(color: primaryColor, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        Get.back();
                        Get.offNamed('/settings');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profileDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
