import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/settings_repository.dart';
import '../../../../data/models/app_settings.dart';

class SettingsController extends GetxController {
  final SettingsRepository _repository;
  
  SettingsController(this._repository);

  final isLoading = true.obs;
  final settings = Rxn<AppSettings>();
  final selectedCategory = 'Financials'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    isLoading.value = true;
    settings.value = await _repository.getSettings();
    isLoading.value = false;
  }

  Future<void> saveSettings() async {
    if (settings.value != null) {
      await _repository.updateSettings(settings.value!);
      
      // We can also trigger notifications/snackbars here
      Get.snackbar(
        'Success', 
        'Settings updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }
}
