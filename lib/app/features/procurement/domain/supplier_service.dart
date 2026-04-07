import 'dart:io';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/core/services/file_service.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/data/models/purchase_batch.dart';
import 'package:tahir_showroom/app/data/models/supplier.dart';

class SupplierService extends GetxService {
  Isar get _isar => Get.find<IsarService>().isar;
  final FileService _fileService = Get.find<FileService>();

  Future<SupplierService> init() async {
    return this;
  }

  // --- Suppliers ---

  Future<List<Supplier>> getAllSuppliers() async {
    return await _isar.suppliers.where().findAll();
  }

  Future<Supplier> createSupplier(String name, String cnic, String phone, {File? profilePic, File? cnicPic}) async {
    final supplier = Supplier()
      ..name = name
      ..cnic = cnic
      ..phone = phone;

    if (profilePic != null) {
      supplier.profilePicFilename = await _fileService.saveSupplierProfile(profilePic, name);
    }
    
    if (cnicPic != null) {
      supplier.cnicPicFilename = await _fileService.saveSupplierCnic(cnicPic, name);
    }

    await _isar.writeTxn(() async {
      await _isar.suppliers.put(supplier);
    });

    return supplier;
  }

  Future<void> updateSupplier(Supplier supplier, String newName, String newCnic, String newPhone, {File? newProfile, File? newCnicPic}) async {
    final oldName = supplier.name;
    
    // 1. Rename Directory if name changed
    if (oldName != newName) {
      await _fileService.renameSupplierDirectory(oldName, newName);
    }

    // 2. Update Files if provided
    if (newProfile != null) {
      supplier.profilePicFilename = await _fileService.saveSupplierProfile(newProfile, newName);
    }
    if (newCnicPic != null) {
      supplier.cnicPicFilename = await _fileService.saveSupplierCnic(newCnicPic, newName);
    }

    // 3. Update DB
    await _isar.writeTxn(() async {
      supplier
        ..name = newName
        ..cnic = newCnic
        ..phone = newPhone;
      await _isar.suppliers.put(supplier);
    });
  }

  Future<void> deleteSupplier(Supplier supplier) async {
    // 1. Cascading Delete of Batches & Bikes
    // Load all batches
    await supplier.batches.load();
    final batches = supplier.batches.toList();
    
    for (var batch in batches) {
      await deletePurchaseBatch(batch); // Reuse logic (deletes bikes + batch folder + record)
    }

    // 2. Delete Supplier Directory
    await _fileService.deleteSupplierDirectory(supplier.name);

    // 3. Delete Supplier Record
    await _isar.writeTxn(() async {
      await _isar.suppliers.delete(supplier.id);
    });
  }

  /// Deletes only the supplier record and associated batches/files,
  /// but keeps all bikes in inventory with their batch link cleared.
  Future<void> deleteSupplierOnly(Supplier supplier) async {
    // 1. Load all batches
    await supplier.batches.load();
    final batches = supplier.batches.toList();

    for (var batch in batches) {
      // Delete batch folder (invoices, etc.)
      if (batch.supplier.value != null) {
        await _fileService.deleteBatchDirectory(batch.supplier.value!.name, batch.purchaseDate);
      }

      // Unlink bikes from batch (keep bikes in DB)
      await batch.bikes.load();
      final bikes = batch.bikes.toList();
      
      await _isar.writeTxn(() async {
        for (var bike in bikes) {
          bike.batch.value = null;
          await bike.batch.save();
        }
        // Delete batch record
        await _isar.purchaseBatchs.delete(batch.id);
      });
    }

    // 2. Delete Supplier Directory
    await _fileService.deleteSupplierDirectory(supplier.name);

    // 3. Delete Supplier Record
    await _isar.writeTxn(() async {
      await _isar.suppliers.delete(supplier.id);
    });
  }

  // --- Procurement (Batches) ---

  Future<List<PurchaseBatch>> getSupplierBatches(int supplierId) async {
    final supplier = await _isar.suppliers.get(supplierId);
    if (supplier == null) return [];
    await supplier.batches.load();
    return supplier.batches.toList();
  }

  Future<List<Bike>> getBatchBikes(int batchId) async {
    final batch = await _isar.purchaseBatchs.get(batchId);
    if (batch == null) return [];
    await batch.bikes.load();
    return batch.bikes.toList();
  }

  /// Saves a complete purchase batch with multiple bikes in a single transaction
  Future<PurchaseBatch> savePurchaseBatch({
    required Supplier supplier,
    required DateTime date,
    required File? billImage,
    required List<Bike> bikes,
  }) async {
    final batch = PurchaseBatch()
      ..purchaseDate = date
      ..totalUnits = bikes.length
      ..totalAmount = bikes.fold(0.0, (sum, bike) => sum + bike.purchasePrice);

    // Save bill image if present
    if (billImage != null) {
      // Use date/time for unique invoice name
      final batchId = '${date.year}${date.month}${date.day}_${DateTime.now().millisecondsSinceEpoch}';
      batch.billImageFilename = await _fileService.saveInvoiceImage(billImage, supplier.name, batchId);
    }

    await _isar.writeTxn(() async {
      // 1. Save Batch
      await _isar.purchaseBatchs.put(batch);
      
      // 2. Link Batch to Supplier
      batch.supplier.value = supplier;
      await batch.supplier.save();
      
      // 3. Save Bikes and Link to Batch
      for (var bike in bikes) {
        // Link to batch
        bike.batch.value = batch;
        await _isar.bikes.put(bike);
        await bike.batch.save();
      }
    });

    return batch;
  }

  Future<void> updatePurchaseBatch(PurchaseBatch batch, DateTime newDate) async {
    final oldDate = batch.purchaseDate;
    
    // 1. Rename folder if date changed
    if (oldDate.year != newDate.year || oldDate.month != newDate.month || oldDate.day != newDate.day) {
      if (batch.supplier.value != null) {
         await _fileService.renameBatchDirectory(batch.supplier.value!.name, oldDate, newDate);
      }
    }

    // 2. Update Record
    await _isar.writeTxn(() async {
      batch.purchaseDate = newDate;
      await _isar.purchaseBatchs.put(batch);
    });
  }

  Future<void> deletePurchaseBatch(PurchaseBatch batch) async {
    // 1. Delete Folder
    if (batch.supplier.value != null) {
      await _fileService.deleteBatchDirectory(batch.supplier.value!.name, batch.purchaseDate);
    }

    // 2. Delete Record & Linked Bikes ??
    // Strategy: If we delete a batch, what happens to the bikes?
    // Option A: Delete bikes too (Cascading delete).
    // Option B: Unlink bikes (Set status to unknown? or just keep them without batch?).
    // Given the requirement is "delete the transaction", usually implies potentially removing the stock entry if it was erroneous?
    // Use Case: User made a mistake.
    // Let's delete the bikes too for now to keep it clean, assuming "Delete Transaction" means "Undo this entire entry".
    
    // 2. Pre-load bikes to delete
    // Accessing IsarLinks inside writeTxn can be problematic if not loaded.
    // Load them explicitly first.
    await batch.bikes.load();
    final bikesToDelete = batch.bikes.toList();
    final bikeIdsToDelete = bikesToDelete.map((b) => b.id).toList();

    await _isar.writeTxn(() async {
      // Delete linked bikes
      for (var id in bikeIdsToDelete) {
        await _isar.bikes.delete(id);
      }
      // Delete batch
      await _isar.purchaseBatchs.delete(batch.id);
    });
  }

  Future<void> updateFullPurchaseBatch({
    required PurchaseBatch batch,
    required Supplier newSupplier,
    required DateTime newDate,
    File? newBillImage,
    required List<Bike> bikesToSave,
    required List<int> deletedBikeIds,
  }) async {
    final oldDate = batch.purchaseDate;
    final oldSupplierName = batch.supplier.value!.name;
    final newSupplierName = newSupplier.name;

    // 1. Handle File System Changes (Date or Supplier Change)
    bool needsMove = (oldSupplierName != newSupplierName) || 
                     (oldDate.year != newDate.year || oldDate.month != newDate.month || oldDate.day != newDate.day);

    if (needsMove) {
       if (oldSupplierName == newSupplierName) {
         await _fileService.renameBatchDirectory(oldSupplierName, oldDate, newDate);
       } else {
         // If supplier changed, we currently just rename date folder if name matches (which it won't).
         // Future: Implement move across suppliers. For now, we assume user manages files manually if supplier changes significantly,
         // or we just leave old files there. Critical path is Date rename.
       }
    }

    // 2. Handle Invoice Image Update
    if (newBillImage != null) {
      final batchId = '${newDate.year}${newDate.month}${newDate.day}_${DateTime.now().millisecondsSinceEpoch}';
      batch.billImageFilename = await _fileService.saveInvoiceImage(newBillImage, newSupplierName, batchId);
    }

    // 3. Database Updates
    await _isar.writeTxn(() async {
      batch.purchaseDate = newDate;
      batch.supplier.value = newSupplier;
      batch.totalUnits = bikesToSave.length;
      batch.totalAmount = bikesToSave.fold(0.0, (sum, bike) => sum + bike.purchasePrice);
      
      await _isar.purchaseBatchs.put(batch);
      await batch.supplier.save(); 

      for (var id in deletedBikeIds) {
        await _isar.bikes.delete(id);
      }

      for (var bike in bikesToSave) {
        bike.batch.value = batch;
        await _isar.bikes.put(bike);
        await bike.batch.save();
      }
    });
  }
}
