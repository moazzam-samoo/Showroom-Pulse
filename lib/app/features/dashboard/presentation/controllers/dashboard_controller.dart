import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/features/sales/domain/sales_service.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/app_settings.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/features/dashboard/presentation/widgets/upcoming_installments.dart';

class DashboardController extends GetxController {
  final SalesService _salesService = SalesService();
  final IsarService _isarService = Get.find<IsarService>();

  // Profile Settings
  final ownerName = RxnString();
  final ownerProfilePicPath = RxnString();
  final showroomName = RxString('AL-TAHIR SHOWROOM');

  // Loading State
  final RxBool isLoading = false.obs;

  // Stats Observables
  final totalDailySales = 0.0.obs;
  final dailyGrowth = 0.0.obs;
  final pendingInstallments = 0.0.obs;
  final overdueInstallments = 0.obs;
  final activeContracts = 0.obs;
  final newContractsMonth = 0.obs;
  final monthlyRevenue = 0.0.obs;
  final revenueOnTrack = false.obs;

  // Chart Data
  final weeklySalesData = <double>[].obs;
  final todaySalesCount = 0.obs;

  // Stock Allocation
  final newModelsPercent = 0.0.obs;
  final newModelsCount = 0.obs;
  final preOwnedPercent = 0.0.obs;
  final preOwnedCount = 0.obs;

  // KPI Data
  final totalAssetValue = 0.0.obs;
  final totalAssetGrowth = 0.0.obs;
  final unitsInStock = 0.obs;
  final lowStockAlert = 0.obs;
  final totalInstallmentValue = 0.0.obs;

  // Upcoming Installments (for bottom widget)
  final upcomingInstallments = <UpcomingInstallment>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllDashboardData();
  }

  /// Load all dashboard data in parallel
  Future<void> loadAllDashboardData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadDashboardStats(),
        loadChartData(),
        loadStockAllocation(),
        loadKPIData(),
        loadProfileSettings(),
        loadUpcomingInstallments(),
      ]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load main dashboard statistics
  Future<void> loadDashboardStats() async {
    try {
      final stats = await _salesService.calculateDashboardStats();
      
      totalDailySales.value = stats['totalDailySales'];
      dailyGrowth.value = stats['dailyGrowth'];
      pendingInstallments.value = stats['pendingInstallments'];
      overdueInstallments.value = stats['overdueInstallments'];
      activeContracts.value = stats['activeContracts'];
      newContractsMonth.value = stats['newContractsMonth'];
      monthlyRevenue.value = stats['monthlyRevenue'];
      revenueOnTrack.value = stats['isRevenueOnTrack'];
    } catch (e) {
      print('Error loading dashboard stats: $e');
    }
  }

  /// Load chart data for performance chart
  Future<void> loadChartData() async {
    try {
      final data = await _salesService.getWeeklySalesData();
      weeklySalesData.value = data;
      
      final today = await _salesService.getTodaySalesCount();
      todaySalesCount.value = today;
    } catch (e) {
      print('Error loading chart data: $e');
    }
  }

  /// Load stock allocation data
  Future<void> loadStockAllocation() async {
    try {
      final allocation = await _salesService.getStockAllocation();
      newModelsPercent.value = allocation['newModelsPercent'];
      newModelsCount.value = allocation['newModelsCount'];
      preOwnedPercent.value = allocation['preOwnedPercent'];
      preOwnedCount.value = allocation['preOwnedCount'];
    } catch (e) {
      print('Error loading stock allocation: $e');
    }
  }

  /// Load KPI card data
  Future<void> loadKPIData() async {
    try {
      final assetValue = await _salesService.calculateTotalAssetValue();
      totalAssetValue.value = assetValue;
      
      final bikes = await _isarService.isar.bikes.where().findAll();
      unitsInStock.value = bikes.where((b) => 
        b.status == BikeStatusEnum.available || 
        b.status == BikeStatusEnum.installment
      ).length;
      
      final lowStock = await _salesService.getLowStockAlert();
      lowStockAlert.value = lowStock;
      
      totalAssetGrowth.value = 5.2; // Placeholder

      // Compute total installment remaining directly
      final contracts = await _isarService.isar.installmentContracts
          .filter()
          .not().statusEqualTo(ContractStatusEnum.completed)
          .and()
          .not().statusEqualTo(ContractStatusEnum.defaulted)
          .findAll();
      totalInstallmentValue.value = contracts.fold<double>(
        0, (sum, c) => sum + c.remainingBalance,
      );
    } catch (e) {
      print('Error loading KPI data: $e');
    }
  }

  /// Load profile settings from AppSettings
  Future<void> loadProfileSettings() async {
    try {
      final settingsList = await _isarService.isar.appSettings.where().findAll();
      if (settingsList.isNotEmpty) {
        ownerName.value = settingsList.first.ownerName;
        ownerProfilePicPath.value = settingsList.first.ownerProfilePicPath;
        showroomName.value = settingsList.first.showroomName;
      }
    } catch (e) {
      print('Error loading profile settings: $e');
    }
  }

  /// Update owner name from dialog
  Future<void> updateOwnerName(String name) async {
    ownerName.value = name.isEmpty ? null : name;
    
    // Save to database
    try {
      final settingsList = await _isarService.isar.appSettings.where().findAll();
      if (settingsList.isNotEmpty) {
        final settings = settingsList.first;
        await _isarService.isar.writeTxn(() async {
          settings.ownerName = name.isEmpty ? null : name;
          await _isarService.isar.appSettings.put(settings);
        });
      }
    } catch (e) {
      print('Error updating owner name: $e');
    }
  }

  /// Load upcoming installments due in the next 7 days
  Future<void> loadUpcomingInstallments() async {
    try {
      final isar = _isarService.isar;
      final now = DateTime.now();
      final sevenDaysLater = now.add(const Duration(days: 7));

      final contracts = await isar.installmentContracts
          .filter()
          .statusEqualTo(ContractStatusEnum.active)
          .findAll();

      final List<UpcomingInstallment> upcoming = [];

      for (var contract in contracts) {
        final dueDate = contract.nextDueDate;
        if (dueDate == null) continue;

        // Include overdue + next 7 days
        if (dueDate.isBefore(sevenDaysLater)) {
          // Resolve customer name
          final customer = await isar.customers
              .filter()
              .idEqualTo(contract.customerId)
              .findFirst();

          // Resolve bike model
          final bike = await isar.bikes
              .filter()
              .idEqualTo(contract.bikeId)
              .findFirst();

          upcoming.add(UpcomingInstallment(
            customerName: customer?.fullName ?? 'Unknown',
            bikeModel: bike?.model ?? 'Unknown',
            amount: contract.monthlyEMI,
            dueDate: dueDate,
            isOverdue: now.isAfter(dueDate),
          ));
        }
      }

      // Sort: overdue first, then by soonest due date
      upcoming.sort((a, b) {
        if (a.isOverdue && !b.isOverdue) return -1;
        if (!a.isOverdue && b.isOverdue) return 1;
        return a.dueDate.compareTo(b.dueDate);
      });

      upcomingInstallments.value = upcoming;
    } catch (e) {
      print('Error loading upcoming installments: $e');
    }
  }

  /// Refresh all data (called after new sale)
  Future<void> refreshStats() async {
    await loadAllDashboardData();
  }
}

