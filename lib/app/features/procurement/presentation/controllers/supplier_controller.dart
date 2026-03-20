import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/purchase_batch.dart';
import 'package:tahir_showroom/app/data/models/supplier.dart';
import 'package:tahir_showroom/app/features/procurement/domain/supplier_service.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/core/widgets/app_toast.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';

class BikeEntry {
  String engineNumber = '';
  String chassisNumber = '';
  String model = '';
  String brand = 'Honda'; // Default
  BikeConditionEnum condition = BikeConditionEnum.newBike;
  String color = '';
  int modelYear = DateTime.now().year;
  double purchasePrice = 0.0;
  File? imageFile;
  Bike? existingBike; // For Edit Mode

  // Focus Nodes for Keyboard Navigation
  final FocusNode engineFocus = FocusNode();
  final FocusNode chassisFocus = FocusNode();
  final FocusNode brandFocus = FocusNode();
  final FocusNode modelFocus = FocusNode();
  final FocusNode conditionFocus = FocusNode();
  final FocusNode colorFocus = FocusNode();
  final FocusNode yearFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode imageFocus = FocusNode();

  void dispose() {
    engineFocus.dispose();
    chassisFocus.dispose();
    brandFocus.dispose();
    modelFocus.dispose();
    conditionFocus.dispose();
    colorFocus.dispose();
    yearFocus.dispose();
    priceFocus.dispose();
    imageFocus.dispose();
  }
}

class SupplierController extends GetxController {
  final SupplierService _supplierService = Get.put(SupplierService());
  final FileService _fileService = Get.find<FileService>();

  // --- State ---
  final RxList<Supplier> suppliers = <Supplier>[].obs;
  final Rx<Supplier?> selectedSupplier = Rx<Supplier?>(null);
  
  // Search State
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  List<Supplier> get filteredSuppliers {
    if (searchQuery.value.isEmpty) return suppliers;
    final query = searchQuery.value.toLowerCase();
    return suppliers.where((s) => 
      s.name.toLowerCase().contains(query) || 
      s.phone.contains(query) || 
      s.cnic.contains(query)
    ).toList();
  }

  // New Supplier State
  final RxBool isNewSupplier = false.obs;
  final newSupplierName = TextEditingController();
  final newSupplierPhone = TextEditingController();
  final newSupplierCnic = TextEditingController();
  final Rx<File?> newSupplierProfilePic = Rx<File?>(null);
  final Rx<File?> newSupplierCnicPic = Rx<File?>(null);

  // Add/Edit Stock State
  final Rx<PurchaseBatch?> editingBatch = Rx<PurchaseBatch?>(null); // Null = Create Mode
  final Rx<DateTime> purchaseDate = DateTime.now().obs;
  final Rx<File?> billImage = Rx<File?>(null);
  final RxList<BikeEntry> bikeEntries = <BikeEntry>[].obs;
  final RxDouble totalBatchCost = 0.0.obs;

  // Focus Nodes for Keyboard Navigation
  final FocusNode newSupplierNameFocus = FocusNode();
  final FocusNode newSupplierPhoneFocus = FocusNode();
  final FocusNode newSupplierCnicFocus = FocusNode();
  final FocusNode newSupplierProfilePicFocus = FocusNode();
  final FocusNode newSupplierCnicPicFocus = FocusNode();
  final FocusNode existingSupplierDropdownFocus = FocusNode();
  final FocusNode purchaseDateFocus = FocusNode();
  final FocusNode billImageFocus = FocusNode();
  final FocusNode addRowFocus = FocusNode();
  final FocusNode saveBatchFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();
    _supplierService.init().then((_) => loadSuppliers());
  }
  
  @override
  void onClose() {
    newSupplierName.dispose();
    newSupplierPhone.dispose();
    newSupplierCnic.dispose();

    newSupplierNameFocus.dispose();
    newSupplierPhoneFocus.dispose();
    newSupplierCnicFocus.dispose();
    newSupplierProfilePicFocus.dispose();
    newSupplierCnicPicFocus.dispose();
    existingSupplierDropdownFocus.dispose();
    purchaseDateFocus.dispose();
    billImageFocus.dispose();
    addRowFocus.dispose();
    saveBatchFocus.dispose();

    for (var entry in bikeEntries) {
      entry.dispose();
    }

    super.onClose();
  }

  Future<void> loadSuppliers() async {
    final list = await _supplierService.getAllSuppliers();
    suppliers.assignAll(list);
  }

  /// Initialize AddStockView in Edit Mode
  void initEditBatch(PurchaseBatch batch) async {
    clearBatchForm();
    editingBatch.value = batch;
    
    // 1. Supplier
    // Find the supplier instance from the list that matches the batch's supplier ID
    final batchSupplier = batch.supplier.value;
    if (batchSupplier != null) {
      final matchingSupplier = suppliers.firstWhereOrNull((s) => s.id == batchSupplier.id);
      selectedSupplier.value = matchingSupplier;
    }
    isNewSupplier.value = false;

    // 2. Date
    purchaseDate.value = batch.purchaseDate;
    
    // 3. Bill Image (Handled by UI checking editingBatch.billImageFilename)
    billImage.value = null; 

    // 4. Bikes
    // Need to load bikes first? They should be linked.
    final bikes = await batch.bikes.filter().findAll();
    bikeEntries.clear();
    for (var bike in bikes) {
      final entry = BikeEntry()
        ..engineNumber = bike.engineNumber
        ..chassisNumber = bike.chassisNumber
        ..model = bike.model
        ..brand = bike.brand
        ..condition = bike.condition
        ..color = bike.color
        ..modelYear = bike.modelYear
        ..purchasePrice = bike.purchasePrice
        ..existingBike = bike; 
        
      bikeEntries.add(entry);
    }
    calculateTotal();
  }

  Future<void> createSupplier(String name, String cnic, String phone, File? profilePic, {File? cnicPic}) async {
    await _supplierService.createSupplier(name, cnic, phone, profilePic: profilePic, cnicPic: cnicPic);
    await loadSuppliers();
  }

  Future<void> updateSupplier(Supplier supplier, String name, String cnic, String phone, {File? profilePic, File? cnicPic}) async {
    await _supplierService.updateSupplier(supplier, name, cnic, phone, newProfile: profilePic, newCnicPic: cnicPic);
    await loadSuppliers();
    _refreshSelectedSupplier(); // Ensure UI reflects name change
  }

  Future<void> deleteSupplier(Supplier supplier) async {
    await _supplierService.deleteSupplier(supplier);
    selectedSupplier.value = null; // Clear selection
    await loadSuppliers();
  }

  Future<void> deleteSupplierOnly(Supplier supplier) async {
    await _supplierService.deleteSupplierOnly(supplier);
    selectedSupplier.value = null;
    await loadSuppliers();
  }
  
  Future<void> updateBatchDate(PurchaseBatch batch, DateTime newDate) async {
    await _supplierService.updatePurchaseBatch(batch, newDate);
    await loadSuppliers();
    _refreshSelectedSupplier();
  }

  Future<void> deleteBatch(PurchaseBatch batch) async {
    await _supplierService.deletePurchaseBatch(batch);
    await loadSuppliers();
    _refreshSelectedSupplier();
  }
  
  // --- Image Pickers for New Supplier ---
  
  Future<void> pickSupplierProfilePic() async {
    final file = await _fileService.pickImage();
    if (file != null) {
      newSupplierProfilePic.value = file;
    }
  }

  Future<void> pickSupplierCnicPic() async {
    final file = await _fileService.pickImage();
    if (file != null) {
      newSupplierCnicPic.value = file;
    }
  }

  // --- Batch Entry Logic ---

  Future<void> pickBatchImage() async {
    final file = await _fileService.pickImage();
    if (file != null) {
      billImage.value = file;
    }
  }

  Future<void> pickEntryImage(int index) async {
    final file = await _fileService.pickImage();
    if (file != null) {
      final entry = bikeEntries[index];
      entry.imageFile = file;
      bikeEntries[index] = entry; 
      bikeEntries.refresh();
    }
  }

  void addBikeEntry() {
    bikeEntries.add(BikeEntry());
    calculateTotal();
  }

  void removeBikeEntry(int index) {
    bikeEntries[index].dispose(); // Dispose focus nodes
    bikeEntries.removeAt(index);
    calculateTotal();
  }

  void updateBikeEntry(int index, BikeEntry entry) {
    bikeEntries[index] = entry;
    calculateTotal();
  }
  
  void calculateTotal() {
    double sum = 0;
    for (var entry in bikeEntries) {
      sum += entry.purchasePrice;
    }
    totalBatchCost.value = sum;
  }

  Future<void> saveBatch() async {
    // 1. Check strict requirements first: Engine, Chassis, and having at least 1 row.
    if (bikeEntries.isEmpty) {
      AppNotificationDialog.showError(title: 'Error', message: 'Please add at least one bike');
      return;
    }

    for (int i = 0; i < bikeEntries.length; i++) {
      var e = bikeEntries[i];
      if (e.engineNumber.trim().isEmpty || e.chassisNumber.trim().isEmpty) {
        AppNotificationDialog.showError(
          title: 'Missing Required Details',
          message: 'Row ${i + 1} is missing Engine Number or Chassis Number. These are strictly required.',
        );
        return;
      }
    }

    if (!isNewSupplier.value && selectedSupplier.value == null) {
      AppNotificationDialog.showError(title: 'Error', message: 'Please select a supplier');
      return;
    }

    // 2. Compile missing optional fields
    final List<String> missingFields = [];

    if (isNewSupplier.value) {
      if (newSupplierName.text.trim().isEmpty) missingFields.add('Supplier Name');
      if (newSupplierPhone.text.trim().isEmpty) missingFields.add('Supplier Phone');
      if (newSupplierCnic.text.trim().isEmpty) missingFields.add('Supplier CNIC');
      if (newSupplierProfilePic.value == null) missingFields.add('Supplier Profile Picture');
      if (newSupplierCnicPic.value == null) missingFields.add('Supplier CNIC Image');
    }

    if (billImage.value == null && (editingBatch.value == null || editingBatch.value?.billImageFilename == null)) {
      missingFields.add('Batch Invoice / Bill Image');
    }

    for (int i = 0; i < bikeEntries.length; i++) {
      var e = bikeEntries[i];
      if (e.brand.trim().isEmpty) missingFields.add('Row ${i + 1}: Brand');
      if (e.model.trim().isEmpty) missingFields.add('Row ${i + 1}: Model');
      if (e.color.trim().isEmpty) missingFields.add('Row ${i + 1}: Color');
      if (e.purchasePrice <= 0) missingFields.add('Row ${i + 1}: Purchase Price');
      if (e.imageFile == null && e.existingBike == null) missingFields.add('Row ${i + 1}: Image');
    }

    // 3. Define execution logic
    Future<void> executeSave() async {
      Supplier? finalSupplier;
      try {
        if (isNewSupplier.value) {
          final newSupplier = await _supplierService.createSupplier(
            newSupplierName.text,
            newSupplierCnic.text, 
            newSupplierPhone.text,
            profilePic: newSupplierProfilePic.value,
            cnicPic: newSupplierCnicPic.value,
          );
          await loadSuppliers();
          finalSupplier = newSupplier;
        } else {
          finalSupplier = selectedSupplier.value;
        }

        if (finalSupplier == null) return;

        if (editingBatch.value != null) {
          await _handleUpdateBatch(editingBatch.value!, finalSupplier);
        } else {
          await _handleCreateBatch(finalSupplier);
        }

        clearBatchForm();
        await loadSuppliers();
        _refreshSelectedSupplier();

        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Success!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The batch has been successfully saved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // close dialog
                        Get.back(); // navigate back
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
        
      } catch (e) {
        final errorMessage = e.toString().toLowerCase();
        if (errorMessage.contains('unique index violated') || errorMessage.contains('unique')) {
          AppNotificationDialog.showError(
            title: 'Duplicate Entry', 
            message: 'A bike with this Engine Number or Chassis Number already exists in the system. Please change them and try again.',
          );
        } else {
          AppNotificationDialog.showError(title: 'Error', message: e.toString());
        }
      }
    }

    if (missingFields.isNotEmpty) {
      AppNotificationDialog.showOptionalFieldsWarning(
        missingFields: missingFields,
        onProceed: executeSave,
      );
    } else {
      executeSave();
    }
  }

  Future<void> _handleCreateBatch(Supplier supplier) async {
      List<Bike> bikes = [];
      for (var entry in bikeEntries) {
        if (entry.engineNumber.isEmpty || entry.chassisNumber.isEmpty) {
          throw 'Engine and Chassis numbers are required for all bikes';
        }

        final bike = Bike()
          ..engineNumber = entry.engineNumber
          ..chassisNumber = entry.chassisNumber
          ..model = entry.model
          ..brand = entry.brand
          ..condition = entry.condition
          ..color = entry.color
          ..modelYear = entry.modelYear
          ..purchasePrice = entry.purchasePrice
          ..cashSalePrice = 0 
          ..status = BikeStatusEnum.available;

        if (entry.imageFile != null) {
          bike.imageFilename = await _fileService.saveBikeImage(entry.imageFile!, entry.engineNumber);
        }
        bikes.add(bike);
      }

      await _supplierService.savePurchaseBatch(
        supplier: supplier,
        date: purchaseDate.value,
        billImage: billImage.value,
        bikes: bikes,
      );
  }

  Future<void> _handleUpdateBatch(PurchaseBatch batch, Supplier supplier) async {
      // 1. Identify Bikes to Delete (In Batch but not in Entries)
      // Note: This requires filtering the *original* bikes list.
      // Ideally we should have cached the original IDs or we fetch them again.
      // But we can just see which IDs are missing from the entries.
      
      final currentEntriesIds = bikeEntries.where((e) => e.existingBike != null).map((e) => e.existingBike!.id).toSet();
      final originalBikes = await batch.bikes.filter().findAll();
      final bikesToDeleteIds = originalBikes.where((b) => !currentEntriesIds.contains(b.id)).map((b) => b.id).toList();

      // 2. Prepare Bikes to Save (Update existing or Create new)
      List<Bike> bikesToSave = [];
      
      for (var entry in bikeEntries) {
         if (entry.engineNumber.isEmpty || entry.chassisNumber.isEmpty) {
          throw 'Engine and Chassis numbers are required for all bikes';
        }
        
        Bike bike;
        if (entry.existingBike != null) {
          bike = entry.existingBike!;
        } else {
          bike = Bike()..status = BikeStatusEnum.available..cashSalePrice = 0;
        }

        // Update Fields
        bike
          ..engineNumber = entry.engineNumber
          ..chassisNumber = entry.chassisNumber
          ..model = entry.model
          ..brand = entry.brand
          ..condition = entry.condition
          ..color = entry.color
          ..modelYear = entry.modelYear
          ..purchasePrice = entry.purchasePrice;
          
        // Handle Image Update
        if (entry.imageFile != null) {
           bike.imageFilename = await _fileService.saveBikeImage(entry.imageFile!, entry.engineNumber);
        }
        
        bikesToSave.add(bike);
      }

      await _supplierService.updateFullPurchaseBatch(
        batch: batch,
        newSupplier: supplier,
        newDate: purchaseDate.value,
        newBillImage: billImage.value,
        bikesToSave: bikesToSave,
        deletedBikeIds: bikesToDeleteIds,
      );
  }

  void clearBatchForm() {
    editingBatch.value = null; // Reset edit mode
    purchaseDate.value = DateTime.now();
    billImage.value = null;
    for (var entry in bikeEntries) {
      entry.dispose();
    }
    bikeEntries.clear();
    totalBatchCost.value = 0.0;
    
    // Clear Supplier Form
    isNewSupplier.value = false;
    newSupplierName.clear();
    newSupplierPhone.clear();
    newSupplierCnic.clear();
    newSupplierProfilePic.value = null;
    newSupplierCnicPic.value = null;
    
    selectedSupplier.value = null;
  }

  void _refreshSelectedSupplier() {
    if (selectedSupplier.value != null) {
      final fresh = suppliers.firstWhereOrNull((s) => s.id == selectedSupplier.value!.id);
      selectedSupplier.value = fresh; 
    }
  }
}
