import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Stats Observables
  final totalDailySales = 450000.0.obs;
  final dailyGrowth = 12.0.obs;
  
  final pendingInstallments = 1200000.0.obs;
  final overdueInstallments = 8.obs;
  
  final activeContracts = 142.obs;
  final newContractsMonth = 5.obs;
  
  final monthlyRevenue = 8400000.0.obs;
  final isRevenueOnTrack = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardStats();
  }

  void loadDashboardStats() {
    // TODO: Connect to Isar Services to get real data
    // For now, using the mock data that matches the design
  }
}
