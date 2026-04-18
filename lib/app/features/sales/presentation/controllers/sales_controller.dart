import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/sales/domain/sales_service.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sale_card.dart';
import 'package:tahir_showroom/app/core/services/report_pdf_service.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

class SalesController extends GetxController {
  final SalesService _salesService = SalesService();

  // Sales Data
  final RxList<SaleCardData> allSales = <SaleCardData>[].obs;
  final RxBool isLoading = false.obs;

  // Filters
  final selectedDateRange = 'All Time'.obs; // Default: All Time
  final selectedStatus = 'All Status'.obs;
  final selectedCustomerPapers = 'All Papers'.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Options
  final dateRangeOptions = ['This Month', 'Last Month', 'This Year', 'All Time'];
  final statusOptions = ['All Status', 'Cash', 'Installment'];

  bool get hasActiveFilters =>
      searchQuery.value.isNotEmpty ||
      selectedDateRange.value != 'All Time' ||
      selectedStatus.value != 'All Status';

  void clearFilters() {
    selectedDateRange.value = 'All Time';
    selectedStatus.value = 'All Status';
    selectedCustomerPapers.value = 'All Papers';
    searchQuery.value = '';
    searchController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['filterCustomerPapers'] != null) {
        selectedCustomerPapers.value = Get.arguments['filterCustomerPapers'];
      }
    }
    loadSales();
  }

  /// Load all sales from database
  Future<void> loadSales() async {
    try {
      isLoading.value = true;
      final sales = await _salesService.getAllSales();
      allSales.value = sales;
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to load sales: $e',
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
    debugPrint('Date Range Changed: $range');
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    debugPrint('Status Changed: $status');
  }

  void setCustomerPapersFilter(String filter) {
    selectedCustomerPapers.value = filter;
    debugPrint('Customer Papers Changed: $filter');
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
        final queryNoCommas = query.replaceAll(',', '');
        
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
          (sale.sellingPrice?.toInt().toString().contains(queryNoCommas) ?? false) ||
          (sale.bikePrice?.toInt().toString().contains(queryNoCommas) ?? false) ||
          sale.amountPaid.toInt().toString().contains(queryNoCommas);

        if (!matches && query != 'sold' && query != 'installment') return false;
      }

      // 4. Customer Papers Filter
      final papersFilter = selectedCustomerPapers.value;
      if (papersFilter != 'All Papers') {
        if (papersFilter == 'Pending' && sale.isCustomerPapersDelivered) return false;
        if (papersFilter == 'Delivered' && !sale.isCustomerPapersDelivered) return false;
      }

      return true;
    }).toList();
  }



  Future<void> exportReport() async {
    try {
      final sales = filteredSales;
      if (sales.isEmpty) {
        AppToast.showInfo(title: 'No Data', message: 'No sales found for the selected filters.');
        return;
      }

      AppToast.showInfo(title: 'Exporting', message: 'Generating sales report...');
      final pdfService = Get.find<ReportPdfService>();

      final cashSales = sales.where((s) => s.isCash).map((s) => <String, dynamic>{
        'customerName': s.customerName,
        'bikeModel': s.bikeModel,
        'amountPaid': s.amountPaid,
        'saleDate': s.saleDate,
        'sellingPrice': s.sellingPrice ?? s.amountPaid,
      }).toList();

      final installmentSales = sales.where((s) => !s.isCash).map((s) => <String, dynamic>{
        'customerName': s.customerName,
        'bikeModel': s.bikeModel,
        'amountPaid': s.amountPaid,
        'saleDate': s.saleDate,
        'sellingPrice': s.sellingPrice ?? 0,
        'monthlyPayment': s.installmentMonthlyPayment ?? 0,
        'duration': s.installmentDuration ?? 0,
        'amountRemaining': s.amountRemaining ?? 0,
      }).toList();

      final filePath = await pdfService.generateSalesReport(
        cashSales: cashSales,
        installmentSales: installmentSales,
        dateRange: selectedDateRange.value,
      );

      if (filePath != null) {
        AppToast.showSuccess(title: 'Success', message: 'Report saved to $filePath');
      } else {
        AppNotificationDialog.showError(title: 'Error', message: 'Failed to generate report');
      }
    } catch (e) {
      AppNotificationDialog.showError(title: 'Error', message: 'Export failed: $e');
    }
  }

  Future<void> exportSaleInvoice(SaleCardData data) async {
    try {
      AppToast.showInfo(title: 'Exporting', message: 'Generating invoice...');
      final pdfService = Get.find<ReportPdfService>();
      
      final saleMap = {
        'customerName': data.customerName,
        'customerCnic': data.customerCnic,
        'customerContact': data.customerContact,
        'customerAddress': data.customerAddress,
        'bikeModel': data.bikeModel,
        'bikeMaker': data.bikeMaker,
        'bikeYear': data.bikeYear,
        'bikeColor': data.bikeColor,
        'bikeChassisNumber': data.bikeChassisNumber,
        'bikeEngineNumber': data.bikeEngineNumber,
        'bikeCondition': data.bikeCondition?.name, // 'newBike' or 'usedBike'
        'bikeRegistrationNumber': data.bikeRegistrationNumber,
        'isCustomerPapersDelivered': data.isCustomerPapersDelivered,
        'customerPapersPromisedDate': data.customerPapersPromisedDate,
        'isCash': data.isCash,
        'amountPaid': data.amountPaid,
        'sellingPrice': data.sellingPrice,
        'amountRemaining': data.amountRemaining,
        'installmentMonthlyPayment': data.installmentMonthlyPayment,
        'installmentDuration': data.installmentDuration,
        'saleDate': data.saleDate,
        'witnesses': (data.witnesses != null && data.witnesses!.isNotEmpty) 
          ? data.witnesses!.map((w) => {
              'fullName': w.fullName,
              'cnicNumber': w.cnicNumber,
              'phoneNumber': w.phoneNumber,
            }).toList() 
          : (data.witnessName != null ? [{
              'fullName': data.witnessName ?? '',
              'cnicNumber': data.witnessCnic ?? '',
              'phoneNumber': data.witnessPhone ?? '',
            }] : []),
      };

      final filePath = await pdfService.generateSaleInvoice(saleData: saleMap);
      if (filePath != null) {
        AppToast.showSuccess(title: 'Success', message: 'Invoice saved to $filePath');
      } else {
        AppNotificationDialog.showError(title: 'Error', message: 'Failed to generate invoice');
      }
    } catch (e) {
      AppNotificationDialog.showError(title: 'Error', message: 'Failed during export: $e');
    }
  }

  String currencyFormat(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)},000';
    }
    return amount.toStringAsFixed(0);
  }

  /// Delete a sale (cascade delete)
  Future<void> deleteSale(int saleId) async {
    try {
      isLoading.value = true;
      final success = await _salesService.deleteSaleWithCascade(saleId);
      
      if (success) {
        AppToast.showSuccess(
          title: 'Deleted',
          message: 'Sale records deleted successfully',
        );
        await refreshSales();
      } else {
        AppNotificationDialog.showError(
          title: 'Error',
          message: 'Failed to delete sale records',
        );
      }
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Delete failed: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
}

