import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/customers/presentation/controllers/customers_controller.dart';

/// Binding for the Customers feature
class CustomersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomersController>(() => CustomersController());
  }
}

// Authored by: Moazzam Samoo
