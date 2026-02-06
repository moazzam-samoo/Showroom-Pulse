import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/features/auth/data/auth_service.dart';
import '../controllers/dashboard_controller.dart';

import '../widgets/kpi_section.dart';
import '../widgets/performance_chart.dart';
import '../widgets/stock_allocation_chart.dart';
import '../widgets/transaction_feed.dart';

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
    
    return Scaffold(
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
                  Get.offNamed('/customers');
                  break;
                case 5:
                  Get.offNamed('/reports');
                  break;
                case 6:
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
                _buildHeader(isDark, authService),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        // KPI Section
                        Obx(() => KpiSection(
                          totalAssetValue: 'Rs. ${(controller.totalAssetValue.value / 1000000).toStringAsFixed(1)}M',
                          totalAssetGrowth: '+${controller.totalAssetGrowth.value.toStringAsFixed(1)}% MTD Growth',
                          unitsInStock: controller.unitsInStock.value,
                          lowStockAlert: controller.lowStockAlert.value,
                          monthlySalesRevenue: 'Rs. ${(controller.monthlyRevenue.value / 1000000).toStringAsFixed(1)}M',
                          salesTarget: 'Rs. 10.0M',
                          salesProgress: controller.revenueOnTrack.value ? 82 : 50,
                          criticalArrears: 'Rs. ${(controller.pendingInstallments.value / 1000000).toStringAsFixed(2)}M',
                          accountsOverdue: controller.overdueInstallments.value,
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
                        // Transaction Feed (using Recent Sales data)
                        const SizedBox(
                          height: 350,
                          child: LiveTransactionFeed(
                            transactions: [], // Empty for now - could add getRecentTransactions method
                          ),
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
    );
  }

  Widget _buildHeader(bool isDark, AuthService authService) {
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
              Text(
                'Executive Command Center',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Tahir Showroom • Real-time Performance Metrics',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 12,
                ),
              ),
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
                    const Text(
                      'Live: 4 Active Sales Reps',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                  Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                  );
                },
              ),
              // Notifications
              IconButton(
                icon: Icon(
                  LucideIcons.bell,
                  size: 20,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                onPressed: () {},
              ),
              // User Avatar
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    authService.currentUser.value?.displayName.substring(0, 1).toUpperCase() ?? 'A',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Removed _getSampleTransactions() method - using real data now
}

// Authored by: Moazzam Samoo
