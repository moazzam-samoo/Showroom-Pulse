import 'package:isar/isar.dart';

part 'payment.g.dart';

/// Payment Method Enum
enum PaymentMethod {
  cash,
  bankTransfer,
  jazzCash,
  easyPaisa,
  cheque,
}

/// Payment Collection - Represents a payment on an installment contract
@collection
class Payment {
  Id id = Isar.autoIncrement;

  /// ID of the contract this payment is for
  late int contractId;

  /// Payment amount
  late double amount;

  /// Date of payment
  DateTime paymentDate = DateTime.now();

  /// Due date (if scheduled)
  DateTime? dueDate;

  /// Payment method used
  @enumerated
  PaymentMethod method = PaymentMethod.cash;

  /// Name of the person who collected the payment
  String? collectorName;

  /// Is this payment for down payment?
  bool isDownPayment = false;

  /// Is this a late fee payment?
  bool isLateFee = false;

  /// Notes about the payment
  String? notes;

  /// Receipt number (if any)
  String? receiptNumber;
}

// Authored by: Moazzam Samoo
