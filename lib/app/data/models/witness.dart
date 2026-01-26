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

  /// Witness phone number
  late String phoneNumber;

  /// Relationship to customer
  String? relationship;

  /// Address
  String? address;

  /// CNIC image filename (stored in customer's Witness folder)
  String? cnicImageFilename;

  /// ID of the contract this witness is associated with
  late int contractId;
}

// Authored by: Moazzam Samoo
