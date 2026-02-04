import 'package:get/get.dart';

class SalesController extends GetxController {
  // Filters
  final selectedDateRange = 'All Time'.obs; // Default: All Time
  final selectedStatus = 'All Status'.obs;
  final searchQuery = ''.obs;

  // Options
  final dateRangeOptions = ['This Month', 'Last Month', 'This Year', 'All Time'];
  final statusOptions = ['All Status', 'Cash', 'Installment'];

  void setDateRange(String range) {
    selectedDateRange.value = range;
    // TODO: Trigger data refresh based on date
    print('Date Range Changed: $range');
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    // TODO: Trigger data refresh based on status
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
