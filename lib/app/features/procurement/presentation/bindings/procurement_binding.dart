import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/procurement/presentation/controllers/supplier_controller.dart';

class ProcurementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierController>(() => SupplierController());
  }
}
