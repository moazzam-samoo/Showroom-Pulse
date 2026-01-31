import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';

class SalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesController>(
      () => SalesController(),
    );
  }
}
