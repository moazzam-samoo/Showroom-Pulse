import 'package:isar/isar.dart';

part 'bike.g.dart';

/// Bike Status Enum
enum BikeStatusEnum {
  available,
  sold,
  installment,
}

/// Bike Collection - Represents a motorcycle in inventory
/// 
/// Unique identifiers: engineNumber, chassisNumber
@collection
class Bike {
  Id id = Isar.autoIncrement;

  /// Engine number (unique identifier)
  @Index(unique: true)
  late String engineNumber;

  /// Chassis number (unique identifier)
  @Index(unique: true)
  late String chassisNumber;

  /// Brand name (Honda, Suzuki, Yamaha, etc.)
  late String brand;

  /// Model name (CG125, GS150, YBR125, etc.)
  late String model;

  /// Color of the bike
  late String color;

  /// Year of manufacture
  int? year;

  /// Stock quantity (usually 1)
  int stock = 1;

  /// Purchase price (dealer cost)
  late double purchasePrice;

  /// Selling price (cash price)
  late double sellingPrice;

  /// Current status
  @enumerated
  BikeStatusEnum status = BikeStatusEnum.available;

  /// Image filename (stored in Media/Bikes/)
  String? imageFilename;

  /// Date added to inventory
  DateTime dateAdded = DateTime.now();

  /// Date sold (if applicable)
  DateTime? dateSold;

  /// Additional notes
  String? notes;
}

// Authored by: Moazzam Samoo
