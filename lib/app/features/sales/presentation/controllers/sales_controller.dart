import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/sales/domain/sales_service.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sale_card.dart';

class SalesController extends GetxController {
  final SalesService _salesService = SalesService();

  // Sales Data
  final RxList<SaleCardData> allSales = <SaleCardData>[].obs;
  final RxBool isLoading = false.obs;

  // Filters
  final selectedDateRange = 'All Time'.obs; // Default: All Time
  final selectedStatus = 'All Status'.obs;
  final searchQuery = ''.obs;

  // Options
  final dateRangeOptions = ['This Month', 'Last Month', 'This Year', 'All Time'];
  final statusOptions = ['All Status', 'Cash', 'Installment'];

  @override
  void onInit() {
    super.onInit();
    loadSales();
  }

  /// Load all sales from database
  Future<void> loadSales() async {
    try {
      isLoading.value = true;
      final sales = await _salesService.getAllSales();
      allSales.value = sales;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load sales: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh sales data (call after adding new sale)
  Future<void> refreshSales() async {
    await loadSales();
  }

  void setDateRange(String range) {
    selectedDateRange.value = range;
    print('Date Range Changed: $range');
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    print('Status Changed: $status');
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void exportReport() {
    // Placeholder for export logic
    Get.snackbar('Export', 'Generating report for ${selectedDateRange.value}...');
  }

  String currencyFormat(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)},000';
    }
    return amount.toStringAsFixed(0);
  }
}

