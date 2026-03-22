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
  final RxnString selectedStatus = RxnString('Available'); // Explicitly set to 'Available' as per request
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
        if (bike.imageFilename != null && !bike.imageFilename!.contains('\\') && !bike.imageFilename!.contains('/')) {
          bike.imageFilename = _fileService.getBikeImagePath(bike.imageFilename!);
        }
        if (bike.purchaserCnicFrontFilename != null && !bike.purchaserCnicFrontFilename!.contains('\\') && !bike.purchaserCnicFrontFilename!.contains('/')) {
          bike.purchaserCnicFrontFilename = _fileService.getBikeImagePath(bike.purchaserCnicFrontFilename!);
        }
        if (bike.purchaserCnicBackFilename != null && !bike.purchaserCnicBackFilename!.contains('\\') && !bike.purchaserCnicBackFilename!.contains('/')) {
          bike.purchaserCnicBackFilename = _fileService.getBikeImagePath(bike.purchaserCnicBackFilename!);
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
        ..model = data['maker'] ?? ''
        ..brand = data['horsePower'] ?? ''
        ..modelYear = data['modelYear'] ?? DateTime.now().year
        ..condition = data['condition'] == 'Used' ? BikeConditionEnum.usedBike : BikeConditionEnum.newBike
        ..color = data['color'] ?? ''
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

      // Handle Purchaser CNIC Images
      if (data['purchaserCnicFront'] != null && data['purchaserCnicFront'] is File) {
        bike.purchaserCnicFrontFilename = await _fileService.saveBikePurchaserCnic(
          data['purchaserCnicFront'],
          bike.engineNumber,
          'front',
        );
      }
      if (data['purchaserCnicBack'] != null && data['purchaserCnicBack'] is File) {
        bike.purchaserCnicBackFilename = await _fileService.saveBikePurchaserCnic(
          data['purchaserCnicBack'],
          bike.engineNumber,
          'back',
        );
      }

      bike.purchaserName = data['purchaserName'];
      bike.purchaserPhone = data['purchaserPhone'];
      bike.purchaserCnic = data['purchaserCnic'];

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
      bike.model = data['maker'] ?? '';
      bike.brand = data['horsePower'] ?? '';
      bike.modelYear = data['modelYear'] ?? DateTime.now().year;
      bike.condition = data['condition'] == 'Used' ? BikeConditionEnum.usedBike : BikeConditionEnum.newBike;
      bike.color = data['color'] ?? '';
      bike.engineNumber = data['engineNumber'] ?? '';
      bike.chassisNumber = data['chassisNumber'] ?? '';
      bike.purchasePrice = data['purchasePrice'] ?? 0.0;
      bike.cashSalePrice = data['sellingPrice'] ?? 0.0;
      bike.purchaserName = data['purchaserName'];
      bike.purchaserPhone = data['purchaserPhone'];
      bike.purchaserCnic = data['purchaserCnic'];

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

      // Handle Purchaser CNIC updates
      if (data['purchaserCnicFront'] != null && data['purchaserCnicFront'] is File) {
        bike.purchaserCnicFrontFilename = await _fileService.saveBikePurchaserCnic(
          data['purchaserCnicFront'],
          bike.engineNumber,
          'front',
        );
      }
      if (data['purchaserCnicBack'] != null && data['purchaserCnicBack'] is File) {
        bike.purchaserCnicBackFilename = await _fileService.saveBikePurchaserCnic(
          data['purchaserCnicBack'],
          bike.engineNumber,
          'back',
        );
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
    // Access all reactive dependencies first to ensure reactivity
    final searchQuery = searchController.text.trim().toLowerCase();
    final brandFilter = selectedBrand.value?.toLowerCase();
    final ccFilter = selectedCC.value?.toLowerCase().replaceAll('cc', '');
    final statusFilter = selectedStatus.value?.toLowerCase();
    final conditionFilter = selectedCondition.value?.toLowerCase();
    final colorFilter = selectedColor.value?.toLowerCase();
    final skinFilter = selectedSkin.value?.toLowerCase();
    final minP = minPrice.value;
    final maxP = maxPrice.value;

    return bikes.where((bike) {
      // 1. Search Query Filter
      if (searchQuery.isNotEmpty) {
        bool statusMatches = false;
        if (searchQuery == 'available' && bike.status == BikeStatusEnum.available) statusMatches = true;
        if (searchQuery == 'sold' && bike.status == BikeStatusEnum.sold) statusMatches = true;
        if ((searchQuery == 'installment' || searchQuery == 'reserved') && bike.status == BikeStatusEnum.installment) statusMatches = true;

        final matchesText = bike.model.toLowerCase().contains(searchQuery) ||
            bike.brand.toLowerCase().contains(searchQuery) ||
            bike.color.toLowerCase().contains(searchQuery) ||
            bike.engineNumber.toLowerCase().contains(searchQuery) ||
            bike.chassisNumber.toLowerCase().contains(searchQuery) ||
            bike.purchasePrice.toInt().toString().contains(searchQuery) ||
            bike.cashSalePrice.toInt().toString().contains(searchQuery) ||
            (bike.condition == BikeConditionEnum.newBike ? 'new' : 'used').contains(searchQuery);
            
        if (!matchesText && !statusMatches) return false;
      }

      // 2. Maker (Brand) Filter
      if (brandFilter != null && brandFilter.isNotEmpty) {
        if (!bike.model.toLowerCase().contains(brandFilter) && 
            !bike.brand.toLowerCase().contains(brandFilter)) {
          return false;
        }
      }

      // 3. Horse Power (CC) Filter
      if (ccFilter != null && ccFilter.isNotEmpty) {
        if (!bike.brand.toLowerCase().contains(ccFilter) && 
            !bike.model.toLowerCase().contains(ccFilter)) {
          return false;
        }
      }

      // 4. Status Filter
      if (statusFilter != null && statusFilter.isNotEmpty && statusFilter != 'all') {
        final status = bike.status;
        if (statusFilter == 'available') {
          if (status != BikeStatusEnum.available) return false;
        } else if (statusFilter == 'installment sold') {
          if (status != BikeStatusEnum.installment) return false;
        } else if (statusFilter == 'cash sold') {
          if (status != BikeStatusEnum.sold) return false;
        } else if (statusFilter == 'both sold') {
          if (status == BikeStatusEnum.available) return false;
        }
      }

      // 5. Condition Filter
      if (conditionFilter != null && conditionFilter.isNotEmpty) {
        final conditionString = bike.condition == BikeConditionEnum.newBike ? 'new' : 'used';
        if (conditionString != conditionFilter) return false;
      }

      // 6. Color Filter
      if (colorFilter != null && colorFilter.isNotEmpty) {
        if (bike.color.toLowerCase() != colorFilter) return false;
      }

      // 7. Skin Filter
      if (skinFilter != null && skinFilter.isNotEmpty) {
        // Skin info is often kept in notes or suffix of color, but for now exact match on color
        if (!bike.color.toLowerCase().contains(skinFilter)) return false;
      }

      // 8. Price Range Filter
      if (minP != null || maxP != null) {
        final salePrice = bike.cashSalePrice;
        if (minP != null && salePrice < minP) return false;
        if (maxP != null && salePrice > maxP) return false;
      }

      return true;
    }).toList()..sort((a, b) {
      // Sort priority: Available (0) > Installment (1) > Sold (2)
      int getStatusPriority(BikeStatusEnum status) {
        switch (status) {
          case BikeStatusEnum.available: return 0;
          case BikeStatusEnum.installment: return 1;
          case BikeStatusEnum.sold: return 2;
        }
      }
      final statusComparison = getStatusPriority(a.status).compareTo(getStatusPriority(b.status));
      if (statusComparison == 0) {
        return b.dateAdded.compareTo(a.dateAdded); // Newest first for same status
      }
      return statusComparison;
    });
  }

  /// Helper to get Sale record for a bike
  Future<dynamic> getSaleForBike(int bikeId) async {
    return await _inventoryService.getSaleByBikeId(bikeId);
  }

  /// Helper to get Customer record for a sale
  Future<dynamic> getCustomerBySale(dynamic sale) async {
    if (sale == null) return null;
    return await _inventoryService.getCustomerById(sale.customerId);
  }

  /// Helper to get Supplier/Dealer for a bike
  Future<dynamic> getSupplierForBike(Bike bike) async {
    await bike.batch.load();
    if (bike.batch.value != null) {
      await bike.batch.value!.supplier.load();
      return bike.batch.value!.supplier.value;
    }
    return null;
  }
}
