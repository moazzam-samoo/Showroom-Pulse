import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:tahir_showroom/app/features/sales/domain/sales_service.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/app_settings.dart';
import 'package:tahir_showroom/app/data/models/customer.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';
import 'package:tahir_showroom/app/features/dashboard/presentation/widgets/upcoming_installments.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';
import 'package:tahir_showroom/app/features/investment/domain/investment_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:local_notifier/local_notifier.dart';

class DashboardController extends GetxController {
  final SalesService _salesService = SalesService();
  final IsarService _isarService = Get.find<IsarService>();

  // Overdue Papers Dismissal State
  static bool dismissOverduePapers = false;

  // Profile Settings
  final ownerName = RxnString();
  final ownerProfilePicPath = RxnString();
  final showroomName = RxString('Showroom Pulse');
  final showroomAddress = RxnString();
  final showroomPhone = RxnString();

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
  final totalInvestment = 0.0.obs;
  final allocatedInvestment = 0.0.obs;
  final availableInvestment = 0.0.obs;
  final unitsInStock = 0.obs;
  final lowStockAlert = 0.obs;
  final totalInstallmentValue = 0.0.obs;
  final netProfit = 0.0.obs;

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
      
      // Run paper tracking scan after data is loaded
      checkOverduePapers();
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to load dashboard data: $e',
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
      debugPrint('Error loading dashboard stats: $e');
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
      debugPrint('Error loading chart data: $e');
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
      debugPrint('Error loading stock allocation: $e');
    }
  }

  /// Load KPI card data
  Future<void> loadKPIData() async {
    try {
      final assetValue = await _salesService.calculateTotalAssetValue();
      totalAssetValue.value = assetValue;
      
      if (!Get.isRegistered<InvestmentService>()) {
        Get.put(InvestmentService());
      }
      final investmentService = Get.find<InvestmentService>();
      totalInvestment.value = await investmentService.getTotalCapital();
      allocatedInvestment.value = await investmentService.getTotalAllocated();
      availableInvestment.value = await investmentService.getAvailableBalance();
      netProfit.value = await investmentService.getTotalProfit();

      final bikes = await _isarService.isar.bikes.where().findAll();
      unitsInStock.value = bikes.where((b) => 
        b.status == BikeStatusEnum.available
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
      debugPrint('Error loading KPI data: $e');
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
        showroomAddress.value = settingsList.first.showroomAddress;
        showroomPhone.value = settingsList.first.showroomPhone;
      }
    } catch (e) {
      debugPrint('Error loading profile settings: $e');
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
      debugPrint('Error updating owner name: $e');
    }
  }

  /// Upload a new profile picture using file picker
  /// Returns true on success, false if cancelled or on failure.
  Future<bool> uploadProfilePicture() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final sourceFile = File(result.files.single.path!);
        
        final fileService = Get.find<FileService>();
        // Ensure profile media directory exists
        final profileDir = Directory(fileService.profileMediaPath);
        if (!await profileDir.exists()) {
          await profileDir.create(recursive: true);
        }

        // Generate unique filename to avoid caching issues
        final ext = p.extension(sourceFile.path);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final newPath = p.join(profileDir.path, 'profile_$timestamp$ext');

        // Delete old picture if it exists
        if (ownerProfilePicPath.value != null) {
          final oldFile = File(ownerProfilePicPath.value!);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        }

        // Copy new image
        await sourceFile.copy(newPath);

        // Update state and DB
        ownerProfilePicPath.value = newPath;
        final settingsList = await _isarService.isar.appSettings.where().findAll();
        if (settingsList.isNotEmpty) {
          final settings = settingsList.first;
          await _isarService.isar.writeTxn(() async {
            settings.ownerProfilePicPath = newPath;
            await _isarService.isar.appSettings.put(settings);
          });
        }
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload profile picture: $e');
      return false;
    }
  }

  /// Remove current profile picture
  Future<void> removeProfilePicture() async {
    try {
      if (ownerProfilePicPath.value != null) {
        final file = File(ownerProfilePicPath.value!);
        if (await file.exists()) {
          await file.delete();
        }
        ownerProfilePicPath.value = null;

        // Update DB
        final settingsList = await _isarService.isar.appSettings.where().findAll();
        if (settingsList.isNotEmpty) {
          final settings = settingsList.first;
          await _isarService.isar.writeTxn(() async {
            settings.ownerProfilePicPath = null;
            await _isarService.isar.appSettings.put(settings);
          });
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove profile picture: $e');
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
      debugPrint('Error loading upcoming installments: $e');
    }
  }

  /// Refresh all data (called after new sale)
  Future<void> refreshStats() async {
    await loadAllDashboardData();
  }

  /// Check for overdue vehicle papers and notify
  Future<void> checkOverduePapers() async {
    if (dismissOverduePapers) return;

    try {
      final isar = _isarService.isar;
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      
      // Fetch all bikes to check paper statuses
      final bikes = await isar.bikes.where().findAll();
      
      int overdueDealerPapers = 0;
      int overdueCustomerPapers = 0;
      int dueSoonDealerPapers = 0;
      int dueSoonCustomerPapers = 0;

      for (var bike in bikes) {
        // Dealer Papers
        if (!bike.isDealerPapersCollected && bike.dealerPapersPromisedDate != null) {
          if (bike.dealerPapersPromisedDate!.isBefore(now)) {
            overdueDealerPapers++;
          } else if (bike.dealerPapersPromisedDate!.isBefore(tomorrow)) {
            dueSoonDealerPapers++;
          }
        }
        
        // Customer Papers
        if (!bike.isCustomerPapersDelivered && bike.customerPapersPromisedDate != null) {
          if (bike.customerPapersPromisedDate!.isBefore(now)) {
            overdueCustomerPapers++;
          } else if (bike.customerPapersPromisedDate!.isBefore(tomorrow)) {
            dueSoonCustomerPapers++;
          }
        }
      }

      final totalIssues = overdueDealerPapers + overdueCustomerPapers + dueSoonDealerPapers + dueSoonCustomerPapers;
      if (totalIssues > 0) {
        String message = '';
        if (overdueCustomerPapers > 0) message += '• $overdueCustomerPapers Customer Papers Overdue\n';
        if (overdueDealerPapers > 0) message += '• $overdueDealerPapers Dealer Papers Overdue\n';
        if (dueSoonCustomerPapers > 0) message += '• $dueSoonCustomerPapers Customer Papers Due Soon\n';
        if (dueSoonDealerPapers > 0) message += '• $dueSoonDealerPapers Dealer Papers Due Soon';
        
        final title = (overdueDealerPapers + overdueCustomerPapers > 0) ? '⚠️ Vehicle Papers Overdue' : '⏰ Vehicle Papers Due Soon';

        // Try to show OS-level notification
        try {
          if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
            final notification = LocalNotification(
              title: title,
              body: message.trim(),
            );
            notification.show();
          }
        } catch (e) {
          debugPrint('Failed to show OS notification: $e');
        }
        
        // Show as a warning notification after a short delay (so dashboard finishes opening)
        Future.delayed(const Duration(seconds: 2), () {
          if (Get.isSnackbarOpen) return;
          Get.snackbar(
            (overdueDealerPapers + overdueCustomerPapers > 0) ? '⚠️ Vehicle Papers Overdue' : '⏰ Vehicle Papers Due Soon',
            message.trim(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: (overdueDealerPapers + overdueCustomerPapers > 0) ? Colors.redAccent.shade700 : Colors.orange.shade700,
            colorText: Colors.white,
            duration: const Duration(seconds: 15),
            icon: const Icon(LucideIcons.fileWarning, color: Colors.white, size: 28),
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            isDismissible: true,
            forwardAnimationCurve: Curves.easeOutBack,
            mainButton: TextButton(
              onPressed: () {
                dismissOverduePapers = true;
                Get.closeAllSnackbars();
              },
              child: const Text("Don't Show Again", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            onTap: (snack) {
              Get.closeAllSnackbars();
              if (overdueCustomerPapers > 0 || dueSoonCustomerPapers > 0) {
                Get.offNamed('/sales', arguments: {'filterCustomerPapers': 'Pending'});
              } else {
                Get.offNamed('/inventory', arguments: {'filterDealerPapers': 'Pending'});
              }
            },
          );
        });
      }
    } catch (e) {
      debugPrint('Error checking overdue papers: $e');
    }
  }
}

