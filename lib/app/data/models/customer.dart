import 'package:isar/isar.dart';

part 'customer.g.dart';

/// Customer Collection - Represents a customer
/// 
/// Unique identifier: cnicNumber (also used for media folder)
@collection
class Customer {
  Id id = Isar.autoIncrement;

  /// Customer's full name
  late String fullName;

  /// CNIC number (unique - used as folder name for documents)
  @Index(unique: true)
  late String cnicNumber;

  /// Contact phone number
  late String phoneNumber;

  /// Alternative phone number
  String? alternativePhone;

  /// Address
  String? address;

  /// Profile image filename
  String? profileImageFilename;

  /// CNIC front image filename
  String? cnicFrontFilename;

  /// CNIC back image filename
  String? cnicBackFilename;

  /// Date registered
  DateTime dateRegistered = DateTime.now();

  /// Notes about the customer
  String? notes;
}

// Authored by: Moazzam Samoo
