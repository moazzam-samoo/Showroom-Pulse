import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/investment/presentation/controllers/investment_controller.dart';
import 'package:tahir_showroom/app/features/investment/domain/investment_service.dart';

class InvestmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestmentService>(() => InvestmentService());
    Get.lazyPut<InvestmentController>(() => InvestmentController());
  }
}

// Authored by: Moazzam Samoo
