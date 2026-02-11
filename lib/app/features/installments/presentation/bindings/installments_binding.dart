import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/installments/presentation/controllers/installments_controller.dart';

/// Binding for the Installments feature
class InstallmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InstallmentsController>(() => InstallmentsController());
  }
}

// Authored by: Moazzam Samoo
