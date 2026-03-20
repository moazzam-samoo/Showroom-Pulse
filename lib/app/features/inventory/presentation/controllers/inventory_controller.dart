import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/inventory/domain/inventory_service.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

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
  final RxnString selectedCondition = RxnString();
  final RxnString selectedColor = RxnString();
  final RxnString selectedSkin = RxnString();
  final Rxn<double> minPrice = Rxn<double>();
  final Rxn<double> maxPrice = Rxn<double>();

  @override
  void onInit() {
    super.onInit();
    // Listen to search changes for real-time filtering
    searchController.addListener(() {
      bikes.refresh(); 
    });
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
      AppNotificationDialog.showError(title: 'Error', message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a new bike
  Future<bool> addBike(Map<String, dynamic> data) async {
    if (data['engineNumber'].toString().trim().isEmpty ||
        data['chassisNumber'].toString().trim().isEmpty) {
      AppNotificationDialog.showError(
        title: 'Missing Information',
        message: 'Engine Number and Chassis Number are strictly required.',
      );
      return false;
    }

    try {
      final bike = Bike()
        ..model = data['model'] ?? ''
        ..brand = data['brand']?.toString().trim().isNotEmpty == true 
            ? data['brand'] 
            : (data['model']?.toString().split(' ').first ?? '')
        ..condition = data['condition'] == 'Used' ? BikeConditionEnum.usedBike : BikeConditionEnum.newBike
        ..color = data['color'] ?? ''
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
      
      AppToast.showSuccess(
        title: 'Success',
        message: 'Bike added to inventory',
      );
      return true;
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to add bike: $e',
      );
      return false;
    }
  }

  /// Update bike price
  Future<void> updateBikePrice(Bike bike, double newPrice) async {
    try {
      bike.cashSalePrice = newPrice;
      await _inventoryService.updateBike(bike);
      bikes.refresh(); // Trigger UI update
      AppToast.showSuccess(
        title: 'Success',
        message: 'Price updated successfully',
      );
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to update price: $e',
      );
    }
  }

  /// Update complete bike details
  Future<bool> updateBikeDetails(Bike bike, Map<String, dynamic> data) async {
    try {
      // Update bike fields
      bike.model = data['model'] ?? '';
      bike.brand = data['brand']?.toString().trim().isNotEmpty == true 
          ? data['brand'] 
          : (data['model']?.toString().split(' ').first ?? ''); // Update brand
      bike.condition = data['condition'] == 'Used' ? BikeConditionEnum.usedBike : BikeConditionEnum.newBike;
      bike.color = data['color'] ?? '';
      bike.engineNumber = data['engineNumber'] ?? '';
      bike.chassisNumber = data['chassisNumber'] ?? '';
      bike.purchasePrice = data['purchasePrice'] ?? 0.0;
      bike.cashSalePrice = data['sellingPrice'] ?? 0.0;

      // Handle Image update if new file provided
      if (data['imageFile'] != null && data['imageFile'] is File) {
        final File imageFile = data['imageFile'];
        
        // Delete old image if exists
        if (bike.imageFilename != null && bike.imageFilename!.isNotEmpty) {
          try {
            final oldFile = File(bike.imageFilename!);
            if (await oldFile.exists()) {
              await oldFile.delete();
            }
          } catch (e) {
            debugPrint('Could not delete old image: $e');
          }
        }
        
        // Save new image
        final filename = await _fileService.saveBikeImage(
          imageFile,
          bike.engineNumber,
        );
        bike.imageFilename = filename; // Update filename in DB
      }

      await _inventoryService.updateBike(bike);
      
      await loadBikes(); // Refresh list
      
      AppToast.showSuccess(
        title: 'Success',
        message: 'Bike updated successfully',
      );
      return true;
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to update bike: $e',
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
      
      AppToast.showSuccess(
        title: 'Success',
        message: 'Bike deleted successfully',
      );
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to delete bike: $e',
      );
    }
  }

  /// Get filtered bikes based on current filter state
  List<Bike> get filteredBikes {
    return bikes.where((bike) {
      // Enhanced text search: model, engine, chassis
      final searchQuery = searchController.text.toLowerCase();
      if (searchQuery.isNotEmpty) {
        // Check for Status Keywords
        bool isStatusKeyword = false;
        bool statusMatches = false;
        
        // Match exact keywords (case-insensitive done by toLowerCase())
        if (searchQuery == 'available') {
           isStatusKeyword = true;
           if (bike.status == BikeStatusEnum.available) statusMatches = true;
        } else if (searchQuery == 'sold') {
           isStatusKeyword = true;
           if (bike.status == BikeStatusEnum.sold) statusMatches = true;
        } else if (searchQuery == 'installment' || searchQuery == 'reserved') {
           isStatusKeyword = true;
           if (bike.status == BikeStatusEnum.installment) statusMatches = true;
        }

        final matches = bike.model.toLowerCase().contains(searchQuery) ||
            bike.brand.toLowerCase().contains(searchQuery) ||
            bike.color.toLowerCase().contains(searchQuery) ||
            bike.engineNumber.toLowerCase().contains(searchQuery) ||
            bike.chassisNumber.toLowerCase().contains(searchQuery) ||
            bike.purchasePrice.toInt().toString().contains(searchQuery) ||
            bike.cashSalePrice.toInt().toString().contains(searchQuery) ||
            (bike.condition == BikeConditionEnum.newBike ? 'new' : 'used').contains(searchQuery) ||
            statusMatches; // Include status match
            
        if (!matches) return false;
      }

      // Brand filter
      if (selectedBrand.value != null && selectedBrand.value!.isNotEmpty) {
        if (!bike.brand.toLowerCase().contains(selectedBrand.value!.toLowerCase()) && 
            !bike.model.toLowerCase().contains(selectedBrand.value!.toLowerCase())) {
          return false;
        }
      }

      // CC Filter
      if (selectedCC.value != null && selectedCC.value!.isNotEmpty) {
         final cc = selectedCC.value!.toLowerCase().replaceAll('cc', '');
         if (!bike.model.toLowerCase().contains(cc)) {
           return false;
         }
      }

      // Status filter
      if (selectedStatus.value != null && selectedStatus.value!.isNotEmpty) {
        final statusString = bike.status.toString().split('.').last;
        if (statusString.toLowerCase() != selectedStatus.value!.toLowerCase()) {
          if (selectedStatus.value!.toLowerCase() == 'pending' && statusString == 'installment') {
             // allow
          } else {
             return false;
          }
        }
      }

      // Condition filter
      if (selectedCondition.value != null && selectedCondition.value!.isNotEmpty) {
        final conditionString = bike.condition == BikeConditionEnum.newBike ? 'New' : 'Used';
        if (conditionString.toLowerCase() != selectedCondition.value!.toLowerCase()) {
          return false;
        }
      }

      // Color filter
      if (selectedColor.value != null && selectedColor.value!.isNotEmpty) {
        if (bike.color.toLowerCase() != selectedColor.value!.toLowerCase()) {
          return false;
        }
      }

      // Skin filter
      if (selectedSkin.value != null && selectedSkin.value!.isNotEmpty) {
        if (bike.color.toLowerCase() != selectedSkin.value!.toLowerCase()) {
          return false;
        }
      }

      // Price range filter (checks both purchase and sale price)
      if (minPrice.value != null || maxPrice.value != null) {
        final purchasePrice = bike.purchasePrice;
        final salePrice = bike.cashSalePrice;
        
        bool priceMatches = false;
        
        // Check if either price falls within range
        if (minPrice.value != null && maxPrice.value != null) {
          priceMatches = (purchasePrice >= minPrice.value! && purchasePrice <= maxPrice.value!) ||
                        (salePrice >= minPrice.value! && salePrice <= maxPrice.value!);
        } else if (minPrice.value != null) {
          priceMatches = purchasePrice >= minPrice.value! || salePrice >= minPrice.value!;
        } else if (maxPrice.value != null) {
          priceMatches = purchasePrice <= maxPrice.value! || salePrice <= maxPrice.value!;
        }
        
        if (!priceMatches) return false;
      }

      return true;
    }).toList()..sort((a, b) {
      // Define status priority: Available = 0, Installment = 1, Sold = 2
      int getStatusPriority(BikeStatusEnum status) {
        switch (status) {
          case BikeStatusEnum.available:
            return 0;
          case BikeStatusEnum.installment:
            return 1;
          case BikeStatusEnum.sold:
            return 2;
        }
      }
      
      // First, sort by status priority
      final statusComparison = getStatusPriority(a.status).compareTo(getStatusPriority(b.status));
      
      // If status is the same, sort by price descending (highest price first)
      if (statusComparison == 0) {
        return b.cashSalePrice.compareTo(a.cashSalePrice);
      }
      
      return statusComparison;
    });
  }
}
