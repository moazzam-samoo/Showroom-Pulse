import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'file_service.dart';

// Import all models
import '../../data/models/bike.dart';
import '../../data/models/customer.dart';
import '../../data/models/installment_contract.dart';
import '../../data/models/payment.dart';
import '../../data/models/witness.dart';
import '../../data/models/user.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/supplier.dart';
import '../../data/models/purchase_batch.dart';
import '../../data/models/sale.dart';
import '../../data/models/expense.dart';

/// IsarService - Handles Isar database operations
/// 
/// Database is stored in Documents/TahirShowroom/Database/
class IsarService extends GetxService {
  late Isar _isar;
  
  Isar get isar => _isar;

  /// Allows BackupService to inject a new Isar instance after import
  void setIsar(Isar isar) {
    _isar = isar;
  }

  /// Initialize the Isar database
  Future<IsarService> init() async {
    final fileService = Get.find<FileService>();
    
    _isar = await Isar.open(
      [
        BikeSchema,
        CustomerSchema,
        InstallmentContractSchema,
        PaymentSchema,
        WitnessSchema,
        UserSchema,
        AppSettingsSchema,
        SupplierSchema,
        PurchaseBatchSchema,
        SaleSchema,
        ExpenseSchema,
      ],
      directory: fileService.databasePath,
      name: 'default',
    );
    
    return this;
  }

  /// Close the database
  Future<void> close() async {
    await _isar.close();
  }

  /// Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }
}

// Authored by: Moazzam Samoo
