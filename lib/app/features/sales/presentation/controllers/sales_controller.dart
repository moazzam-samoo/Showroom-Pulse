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

  /// Helper to parse date from DD/MM/YYYY
  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), 
          int.parse(parts[1]), 
          int.parse(parts[0])
        );
      }
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Filtered Sales List
  List<SaleCardData> get filteredSales {
    return allSales.where((sale) {
      // 1. Date Range Filter
      final saleDate = _parseDate(sale.saleDate);
      final now = DateTime.now();
      final range = selectedDateRange.value;

      if (range == 'This Month') {
        if (saleDate.month != now.month || saleDate.year != now.year) return false;
      } else if (range == 'Last Month') {
        final lastMonth = DateTime(now.year, now.month - 1);
        if (saleDate.month != lastMonth.month || saleDate.year != lastMonth.year) return false;
      } else if (range == 'This Year') {
         if (saleDate.year != now.year) return false;
      }

      // 2. Status Filter (Dropdown)
      if (selectedStatus.value != 'All Status') {
        if (selectedStatus.value == 'Cash' && !sale.isCash) return false;
        if (selectedStatus.value == 'Installment' && sale.isCash) return false;
      }

      // 3. Search Query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        
        // Status Keywords (Sold, Installment)
        if (query == 'sold' && !sale.isCash) return false;
        if (query == 'installment' && sale.isCash) return false;
        
        // Fields Search
        final matches = 
          sale.customerName.toLowerCase().contains(query) ||
          sale.bikeModel.toLowerCase().contains(query) ||
          sale.bikeColor.toLowerCase().contains(query) ||
          sale.bikeEngineNumber.toLowerCase().contains(query) ||
          sale.bikeChassisNumber.toLowerCase().contains(query) ||
          (sale.bikeBrand?.toLowerCase().contains(query) ?? false) ||
          sale.customerCnic.contains(query) ||
          sale.customerContact.contains(query) ||
          (sale.sellingPrice?.toInt().toString().contains(query) ?? false) ||
          (sale.bikePrice?.toInt().toString().contains(query) ?? false) ||
          sale.amountPaid.toInt().toString().contains(query);

        if (!matches && query != 'sold' && query != 'installment') return false;
      }

      return true;
    }).toList();
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

