import 'package:get/get.dart';

class SalesController extends GetxController {
  // Filters
  final selectedDateRange = 'This Month'.obs;
  final selectedStatus = 'All Status'.obs;

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

  void exportReport() {
    // Placeholder for export logic
    Get.snackbar('Export', 'Generating report for ${selectedDateRange.value}...');
  }
}
