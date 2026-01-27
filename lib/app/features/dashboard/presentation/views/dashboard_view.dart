import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/features/auth/data/auth_service.dart';

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
                        const KpiSection(
                          totalAssetValue: 'Rs. 54.5M',
                          totalAssetGrowth: '+5.2% MTD Growth',
                          unitsInStock: 145,
                          lowStockAlert: 4,
                          monthlySalesRevenue: 'Rs. 8.2M',
                          salesTarget: 'Rs. 10.0M',
                          salesProgress: 82,
                          criticalArrears: 'Rs. 1.25M',
                          accountsOverdue: 5,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Charts Row
                        SizedBox(
                          height: 280,
                          child: Row(
                            children: [
                              // Performance Chart
                              Expanded(
                                flex: 2,
                                child: PerformanceChart(
                                  weeklyData: [30, 50, 20, 60, 40, 80, 70],
                                  todaySales: 12,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              // Stock Allocation
                              const Expanded(
                                flex: 1,
                                child: StockAllocationChart(
                                  newModelsPercent: 70,
                                  newModelsCount: 82,
                                  preOwnedPercent: 30,
                                  preOwnedCount: 63,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Transaction Feed
                        SizedBox(
                          height: 350,
                          child: LiveTransactionFeed(
                            transactions: _getSampleTransactions(),
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
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
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

  List<Transaction> _getSampleTransactions() {
    return [
      const Transaction(
        id: '1',
        assetModel: 'Honda CD70',
        vin: 'A827',
        stakeholder: 'Ali Khan',
        stakeholderContact: 'Verified Buyer',
        reference: 'INV-2023-1042',
        referenceDate: 'Oct 24, 10:30',
        value: 'Rs. 155,000',
        valueType: 'Full Cash Payment',
        status: 'COMPLETED',
      ),
      const Transaction(
        id: '2',
        assetModel: 'Honda CG125',
        vin: 'A921',
        stakeholder: 'Ahmed Hassan',
        stakeholderContact: 'Verified @ A201+',
        reference: 'INV-2023-1041',
        referenceDate: 'Oct 23, 14:00',
        value: 'Rs. 280,000',
        valueType: 'Full Cash Payment',
        status: 'PENDING',
      ),
      const Transaction(
        id: '3',
        assetModel: 'Suzuki GS150',
        vin: 'A102',
        stakeholder: 'Usman Tariq',
        stakeholderContact: 'New Customer',
        reference: 'INV-2023-1040',
        referenceDate: 'Oct 23, 11:50',
        value: 'Rs. 320,000',
        valueType: 'Installment Plan',
        status: 'COMPLETED',
      ),
    ];
  }
}

// Authored by: Moazzam Samoo
