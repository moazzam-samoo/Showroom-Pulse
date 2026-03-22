import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';

class NewSaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewSaleController());
  }
}
