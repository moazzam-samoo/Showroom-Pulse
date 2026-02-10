import 'package:isar/isar.dart';

part 'witness.g.dart';

/// Witness Collection - Represents a witness for installment contracts
@collection
class Witness {
  Id id = Isar.autoIncrement;

  /// Witness full name
  late String fullName;

  /// Witness CNIC number
  late String cnicNumber;

  /// Witness phone number (Pakistani format: 03XX-XXXXXXX)
  late String phoneNumber;

  /// Relationship to customer
  String? relationship;

  /// Full address
  String? address;

  /// CNIC Front image filename (required)
  String? cnicFrontFilename;

  /// CNIC Back image filename (optional)
  String? cnicBackFilename;

  /// ID of the contract this witness is associated with
  late int contractId;

  /// Is this the primary witness (Witness 1)?
  bool isPrimary = true;
}

// Authored by: Moazzam Samoo
