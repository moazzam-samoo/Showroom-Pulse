import 'dart:io';
import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/core/services/isar_service.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:get/get.dart';

class InventoryService {
  final IsarService _isarService = Get.find<IsarService>();

  /// Get all bikes from the database
  Future<List<Bike>> getAllBikes() async {
    final isar = _isarService.isar;
    return await isar.bikes.where().findAll();
  }

  /// Get available bikes only
  Future<List<Bike>> getAvailableBikes() async {
    final isar = _isarService.isar;
    return await isar.bikes
        .filter()
        .statusEqualTo(BikeStatusEnum.available)
        .findAll();
  }

  /// Add a new bike to inventory
  Future<void> addBike(Bike bike) async {
    final isar = _isarService.isar;
    
    // Check if engine or chassis number already exists
    final existingEngine = await isar.bikes
        .filter()
        .engineNumberEqualTo(bike.engineNumber)
        .findFirst();
        
    if (existingEngine != null) {
      throw Exception('Bike with Engine No. ${bike.engineNumber} already exists');
    }

    final existingChassis = await isar.bikes
        .filter()
        .chassisNumberEqualTo(bike.chassisNumber)
        .findFirst();

    if (existingChassis != null) {
      throw Exception('Bike with Chassis No. ${bike.chassisNumber} already exists');
    }

    await isar.writeTxn(() async {
      await isar.bikes.put(bike);
    });
  }

  /// Update an existing bike
  Future<void> updateBike(Bike bike) async {
    final isar = _isarService.isar;
    await isar.writeTxn(() async {
      await isar.bikes.put(bike);
    });
  }

  /// Delete a bike
  Future<void> deleteBike(Id id) async {
    final isar = _isarService.isar;
    await isar.writeTxn(() async {
      await isar.bikes.delete(id);
    });
  }
}
