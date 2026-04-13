import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';
import 'package:tahir_showroom/app/features/customers/presentation/controllers/customers_controller.dart';
import 'package:tahir_showroom/app/features/procurement/presentation/controllers/supplier_controller.dart';
import 'package:tahir_showroom/app/features/installments/presentation/controllers/installments_controller.dart';
import 'package:tahir_showroom/app/features/dashboard/presentation/controllers/dashboard_controller.dart';

class DataRefresher {
  static void refreshAll() {
    if (Get.isRegistered<InventoryController>()) Get.find<InventoryController>().loadBikes();
    if (Get.isRegistered<SalesController>()) Get.find<SalesController>().loadSales();
    if (Get.isRegistered<CustomersController>()) Get.find<CustomersController>().loadCustomers();
    if (Get.isRegistered<SupplierController>()) Get.find<SupplierController>().loadSuppliers();
    if (Get.isRegistered<InstallmentsController>()) Get.find<InstallmentsController>().loadContracts();
    if (Get.isRegistered<DashboardController>()) Get.find<DashboardController>().loadAllDashboardData();
  }
}