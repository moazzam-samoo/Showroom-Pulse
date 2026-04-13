import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/utils/data_refresher.dart';
import 'package:file_picker/file_picker.dart';

import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/investment.dart';
import 'package:tahir_showroom/app/features/inventory/domain/inventory_service.dart';
import 'package:tahir_showroom/app/features/investment/domain/investment_service.dart';
import 'package:tahir_showroom/app/features/investment/presentation/controllers/investment_controller.dart';
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

  InvestmentService _getInvestmentService() {
    if (!Get.isRegistered<InvestmentService>()) {
      Get.put(InvestmentService());
    }
    return Get.find<InvestmentService>();
  }

  /// Load all bikes from database
  Future<void> loadBikes() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final loadedBikes = await _inventoryService.getAllBikes();
      
      // MIGRATION SCRIPT to fix reversed brand/model fields globally
      bool changed = false;
      final makers = ['honda', 'yamaha', 'suzuki', 'united', 'road prince', 'super power', 'unique', 'ravi', 'hi-speed', 'zxmco', 'metro', 'crown', 'other'];
      for (var bike in loadedBikes) {
        String brandLower = bike.brand.toLowerCase();
        bool hasReversed = false;
        
        for (var maker in makers) {
          if (brandLower.contains(maker)) {
            hasReversed = true;
            break;
          }
        }
        
        if (!hasReversed) {
          String modelLower = bike.model.toLowerCase();
          if ((modelLower.contains('125') || modelLower.contains('70') || modelLower.contains('110') || modelLower.contains('150')) &&
              !(brandLower.contains('125') || brandLower.contains('70') || brandLower.contains('110') || brandLower.contains('150'))) {
            hasReversed = true;
          }
        }
        
        if (hasReversed) {
          String temp = bike.model;
          bike.model = bike.brand;
          bike.brand = temp;
          await _inventoryService.updateBike(bike);
          changed = true;
        }
      }

      if (changed) {
        final fixedBikes = await _inventoryService.getAllBikes();
        bikes.assignAll(fixedBikes);
      } else {
        bikes.assignAll(loadedBikes);
      }
      
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
        ..registrationNumber = data['registrationNumber']
        ..purchasePrice = data['purchasePrice']
        ..cashSalePrice = data['sellingPrice']
        ..status = BikeStatusEnum.available
        ..isDealerPapersCollected = data['isDealerPapersCollected'] ?? false
        ..dealerPapersPromisedDate = data['dealerPapersPromisedDate'];

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

      // Assign investment amount if provided
      final investmentAmount = double.tryParse(data['investmentAmount']?.toString() ?? '0') ?? 0.0;
      bike.investmentAmount = investmentAmount;

      if (investmentAmount > 0) {
        final invService = _getInvestmentService();
        final availableBalance = await invService.getAvailableBalance();
        if (investmentAmount > availableBalance) {
          final format = NumberFormat('#,##0', 'en_US');
          AppNotificationDialog.showError(
            title: 'Not Enough Capital',
            message: 'You cannot use Rs ${format.format(investmentAmount)} because your available balance is only Rs ${format.format(availableBalance)}.\n\nPlease go to the Investment screen and invest more cash first.',
          );
          return false;
        }

        // --- Priority Distribution (Funding Snapshot) ---
        final financials = await invService.getCategoryFinancials();
        double remainingToFund = investmentAmount;

        final priorityOrder = [
          InvestmentCategoryEnum.personalCapital,
          InvestmentCategoryEnum.partnership,
          InvestmentCategoryEnum.other,
          InvestmentCategoryEnum.loan,
        ];

        for (final cat in priorityOrder) {
          if (remainingToFund <= 0) break;
          
          final catData = financials.firstWhere(
            (e) => e.category == cat, 
            orElse: () => CategoryFinancials(category: cat, injected: 0, available: 0)
          );
          
          final availableForCat = catData.available;
          if (availableForCat > 0) {
            double assigned = 0.0;
            if (availableForCat >= remainingToFund) {
              assigned = remainingToFund;
              remainingToFund = 0;
            } else {
              assigned = availableForCat;
              remainingToFund -= availableForCat;
            }

            switch(cat) {
               case InvestmentCategoryEnum.personalCapital: bike.fundedByPersonal = assigned; break;
               case InvestmentCategoryEnum.partnership: bike.fundedByPartnership = assigned; break;
               case InvestmentCategoryEnum.other: bike.fundedByOther = assigned; break;
               case InvestmentCategoryEnum.loan: bike.fundedByLoan = assigned; break;
               default: break;
            }
          }
        }
      }



      final addedId = await _inventoryService.addBike(bike);
      
      // Record investment if capital was injected
      if (investmentAmount > 0) {
        try {
          final invService = _getInvestmentService();
          await invService.recordBikePurchaseInvestment(
            amount: investmentAmount,
            date: DateTime.now(),
            bikeId: addedId,
          );
        } catch (e) {
          debugPrint('Failed to record investment: $e');
        }
      }
      
      await loadBikes();
      DataRefresher.refreshAll();
      
      // Trigger Investment UI Refresh
      if (Get.isRegistered<InvestmentController>()) {
        Get.find<InvestmentController>().loadInvestmentData();
      }

      if (investmentAmount > 0) {
        final invService = _getInvestmentService();
        final remainingBalance = await invService.getAvailableBalance();
        final deficitWarning = remainingBalance < 0 ? ' (⚠️ Deficit)' : '';
        AppToast.showFinancial(
          title: 'Success',
          line1: '🏍️ ${bike.model} ${bike.brand} added to Inventory',
          line2: 'Capital Used: Rs ${investmentAmount.toStringAsFixed(0)} | Remaining: Rs ${remainingBalance.toStringAsFixed(0)}$deficitWarning',
        );
      } else {
        AppToast.showSuccess(
          title: 'Success',
          message: 'Bike added to inventory',
        );
      }
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
      bike.registrationNumber = data['registrationNumber'];
      bike.purchasePrice = data['purchasePrice'] ?? 0.0;
      bike.cashSalePrice = data['sellingPrice'] ?? 0.0;
      bike.purchaserName = data['purchaserName'];
      bike.purchaserPhone = data['purchaserPhone'];
      bike.purchaserCnic = data['purchaserCnic'];
      bike.isDealerPapersCollected = data['isDealerPapersCollected'] ?? false;
      bike.dealerPapersPromisedDate = data['dealerPapersPromisedDate'];

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
      
      await loadBikes();
      DataRefresher.refreshAll();
      
      // Trigger Investment UI Refresh
      if (Get.isRegistered<InvestmentController>()) {
        Get.find<InvestmentController>().loadInvestmentData();
      }
      
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

  /// Quick update just for Dealer Papers
  Future<void> markDealerPapersCollected(Bike bike) async {
    try {
      bike.isDealerPapersCollected = true;
      bike.dealerPapersPromisedDate = null;
      await _inventoryService.updateBike(bike);
      bikes.refresh();
      AppToast.showSuccess(
        title: 'Success',
        message: 'Dealer papers marked as collected.',
      );
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to update papers status: $e',
      );
    }
  }

  /// Quick update just for Customer Papers
  Future<void> markCustomerPapersDelivered(Bike bike) async {
    try {
      bike.isCustomerPapersDelivered = true;
      bike.customerPapersPromisedDate = null;
      await _inventoryService.updateBike(bike);
      bikes.refresh();
      AppToast.showSuccess(
        title: 'Success',
        message: 'Customer papers marked as delivered.',
      );
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to update papers status: $e',
      );
    }
  }

  /// Update paper status fields without forcing "collected/delivered = true"
  /// Used when user updates the promised date or unchecks the checkbox.
  Future<void> updateBikePaperStatus(Bike bike) async {
    try {
      await _inventoryService.updateBike(bike);
      bikes.refresh();
    } catch (e) {
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to save paper status: $e',
      );
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
      // 1. Handle Investment Refund
      double refundedAmount = 0;
      final invService = _getInvestmentService();
      
      // We always try to remove investment - the service handles 
      // check for existence (individual or batch)
      await invService.removeBikePurchaseInvestment(bike);
      
      // If the bike had a stored investment amount, we use it for the toast
      if (bike.investmentAmount > 0) {
        refundedAmount = bike.investmentAmount;
      } else {
        // Fallback to purchase price if investment field was't synced yet
        refundedAmount = bike.purchasePrice;
      }

      // 2. Trigger Investment UI Refresh (Direct GetX signal)
      if (Get.isRegistered<InvestmentController>()) {
        Get.find<InvestmentController>().loadInvestmentData();
      }

      // 2. Delete from DB
      await _inventoryService.deleteBike(bike.id);
      
      await loadBikes();
      
      if (refundedAmount > 0) {
        AppToast.showFinancial(
          title: 'Deleted Successfully',
          line1: '🏍️ ${bike.model} removed from inventory',
          line2: 'Capital Refunded: Rs ${refundedAmount.toStringAsFixed(0)} back to Available Cash',
        );
      } else {
        AppToast.showSuccess(
          title: 'Success',
          message: 'Bike deleted successfully',
        );
      }
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
