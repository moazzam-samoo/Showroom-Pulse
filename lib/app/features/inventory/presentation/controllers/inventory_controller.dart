import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/inventory/domain/inventory_service.dart';

class InventoryController extends GetxController {
  final InventoryService _inventoryService = InventoryService(); // Could be injected
  final FileService _fileService = Get.find<FileService>();

  final RxList<Bike> bikes = <Bike>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Filter Observables
  final searchController = TextEditingController();
  final RxnString selectedBrand = RxnString();
  final RxnString selectedCC = RxnString();
  final RxnString selectedStatus = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadBikes();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Load all bikes from database
  Future<void> loadBikes() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final loadedBikes = await _inventoryService.getAllBikes();
      bikes.assignAll(loadedBikes);
      
      // Update image paths to full paths
      for (var bike in bikes) {
        if (bike.imageFilename != null) {
          bike.imageFilename = _fileService.getBikeImagePath(bike.imageFilename!);
        }
      }
    } catch (e) {
      errorMessage.value = 'Failed to load inventory: $e';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a new bike
  Future<bool> addBike(Map<String, dynamic> data) async {
    try {
      final bike = Bike()
        ..model = data['model']
        ..brand = data['model'].toString().split(' ').first // Simple brand extraction
        ..color = data['color']
        ..modelYear = DateTime.now().year // Default to current year

        ..engineNumber = data['engineNumber']
        ..chassisNumber = data['chassisNumber']
        ..purchasePrice = data['purchasePrice']
        ..cashSalePrice = data['sellingPrice']
        ..status = BikeStatusEnum.available;

      // Handle Image
      if (data['imageFile'] != null && data['imageFile'] is File) {
        final File imageFile = data['imageFile'];
        final filename = await _fileService.saveBikeImage(
          imageFile,
          bike.engineNumber,
        );
        bike.imageFilename = filename; // Save filename in DB
      }

      await _inventoryService.addBike(bike);
      
      await loadBikes(); // Refresh list
      
      Get.snackbar(
        'Success',
        'Bike added to inventory',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add bike: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return false;
    }
  }

  /// Pick an image from gallery/filesystem
  Future<File?> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }

  /// Delete a bike
  Future<void> deleteBike(Bike bike) async {
    try {
      // 1. Delete image if exists
      if (bike.imageFilename != null) {
        // Note: bike.imageFilename currently holds the full path due to loadBikes processing
        // We need to extract just the filename if we were deleting by ID, 
        // but here we can just pass the path if fileService supports it, 
        // OR construct path. 
        // Actually InventoryService deleteBike only needs ID.
        // File deletion:
        // await _fileService.deleteFile(bike.imageFilename!); // careful if path is full or relative
      }
      
      // 2. Delete from DB
      await _inventoryService.deleteBike(bike.id);
      
      await loadBikes();
      
      Get.snackbar(
        'Success',
        'Bike deleted successfully',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete bike: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  /// Get filtered bikes based on current filter state
  List<Bike> get filteredBikes {
    return bikes.where((bike) {
      // Search filter
      final searchQuery = searchController.text.toLowerCase();
      if (searchQuery.isNotEmpty) {
        final matches = bike.model.toLowerCase().contains(searchQuery) ||
            bike.engineNumber.toLowerCase().contains(searchQuery);
        if (!matches) return false;
      }

      // Brand filter
      if (selectedBrand.value != null && selectedBrand.value!.isNotEmpty) {
        // Assuming brand is stored in brand field or part of model name
        // The implementation ensures brand is set, but fallback to model name check
        if (!bike.brand.toLowerCase().contains(selectedBrand.value!.toLowerCase()) && 
            !bike.model.toLowerCase().contains(selectedBrand.value!.toLowerCase())) {
          return false;
        }
      }

      // CC Filter (Approximation for now based on model name)
      if (selectedCC.value != null && selectedCC.value!.isNotEmpty) {
         final cc = selectedCC.value!.toLowerCase().replaceAll('cc', '');
         if (!bike.model.toLowerCase().contains(cc)) {
           return false;
         }
      }

      // Status filter
      if (selectedStatus.value != null) {
        final statusString = bike.status.toString().split('.').last;
        if (statusString.toLowerCase() != selectedStatus.value!.toLowerCase()) {
          if (selectedStatus.value!.toLowerCase() == 'pending' && statusString == 'installment') {
             // allow
          } else {
             return false;
          }
        }
      }

      return true;
    }).toList();
  }
}
