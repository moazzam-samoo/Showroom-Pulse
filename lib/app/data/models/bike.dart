import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/purchase_batch.dart';

part 'bike.g.dart';

/// Bike Status Enum
enum BikeStatusEnum {
  available,
  sold,
  installment,
}

/// Bike Condition Enum
enum BikeConditionEnum {
  newBike,
  usedBike,
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

  // -- Specs --
  late String model; // Changed from modelName to match UI convention
  late String brand;
  late String color;
  
  /// Manufacturing Year (V2)
  late int modelYear;

  // -- Financials --
  /// Purchase Price per unit (V2) - Source of truth for cost
  late double purchasePrice;

  @Index() 
  late double cashSalePrice;

  // -- Funding Ratios (V2) --
  /// The exact mathematical amount of Personal Capital that paid for this bike
  double fundedByPersonal = 0.0;
  
  /// The exact mathematical amount of Partnership Capital that paid for this bike
  double fundedByPartnership = 0.0;
  
  /// The exact mathematical amount of Other Capital that paid for this bike
  double fundedByOther = 0.0;
  
  /// The exact mathematical amount of Loan Capital that paid for this bike
  double fundedByLoan = 0.0;

  // -- Media --
  String? imageFilename; // Stored as [engineNumber].jpg in Media/Bikes/

  // -- Status --
  @enumerated
  BikeStatusEnum status = BikeStatusEnum.available;

  @enumerated
  BikeConditionEnum condition = BikeConditionEnum.newBike;

  // -- Relationships --
  final batch = IsarLink<PurchaseBatch>(); // Link to source batch (V2)

  /// Date added to inventory
  DateTime dateAdded = DateTime.now();

  /// Date sold (if applicable)
  DateTime? dateSold;

  /// Additional notes
  String? notes;

  /// Investment amount allocated to this bike (from user's capital)
  double investmentAmount = 0.0;

  /// Registration Number (For Used Bikes)
  String? registrationNumber;

  // -- Purchaser Details (V2 - Optional) --
  String? purchaserName;
  String? purchaserPhone;
  String? purchaserCnic;
  String? purchaserCnicFrontFilename;
  String? purchaserCnicBackFilename;

  // -- Document Tracking (Dealer Side) --
  bool isDealerPapersCollected = false;
  DateTime? dealerPapersPromisedDate;

  // -- Document Tracking (Customer Side) --
  bool isCustomerPapersDelivered = false;
  DateTime? customerPapersPromisedDate;
}

// Authored by: Moazzam Samoo
