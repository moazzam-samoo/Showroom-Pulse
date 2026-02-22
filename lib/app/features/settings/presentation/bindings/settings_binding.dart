import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import '../controllers/settings_controller.dart';
import '../../data/repositories/settings_repository.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsRepository(Get.find<IsarService>()));
    Get.lazyPut(() => SettingsController(Get.find<SettingsRepository>()));
  }
}
