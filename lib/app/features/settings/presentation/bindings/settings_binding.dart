import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // SettingsController and SettingsRepository are now initialized globally
    // in initial_binding.dart so they can be accessed anywhere (e.g. for dropdown lists).
  }
}
