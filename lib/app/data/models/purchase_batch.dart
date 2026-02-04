import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/supplier.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';

part 'purchase_batch.g.dart';

@collection
class PurchaseBatch {
  Id id = Isar.autoIncrement;

  late DateTime purchaseDate;

  /// Total cost of the batch (Calculated: sum of linked bikes' purchasePrice)
  /// This is a derived field for caching/display, but source of truth is the Bike.purchasePrice
  late double totalAmount;

  /// Total units in this batch
  late int totalUnits;

  String? billImageFilename; // Stored in Media/Suppliers/{Name}/Invoices/

  final supplier = IsarLink<Supplier>();
  
  @Backlink(to: 'batch')
  final bikes = IsarLinks<Bike>();
}
