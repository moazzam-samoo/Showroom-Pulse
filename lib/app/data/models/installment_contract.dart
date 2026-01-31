import 'package:isar/isar.dart';

part 'installment_contract.g.dart';

/// Contract Status Enum
enum ContractStatusEnum {
  active,
  completed,
  defaulted,
}

enum MarkupType {
  percentage, // % Logic
  fixed,      // Fixed Amount Logic
}

/// Installment Contract Collection - Represents an installment sale agreement
@collection
class InstallmentContract {
  Id id = Isar.autoIncrement;

  /// ID of the bike being sold
  late int bikeId;

  /// ID of the customer
  late int customerId;

  /// Cash price of the bike
  late double cashPrice;

  /// Type of markup applied
  @enumerated
  MarkupType markupType = MarkupType.percentage;

  /// Value of the markup
  /// If percentage: e.g. 40.0 (40%)
  /// If fixed: e.g. 15000.0 (Rs 15,000)
  double markupValue = 40.0;

  /// The actual calculated markup amount in currency
  late double totalMarkupAmount;

  /// Total amount after markup
  late double totalAmount;

  /// Down payment amount
  late double downPayment;

  /// Number of months for installment
  late int months;

  /// Monthly EMI amount
  late double monthlyEMI;

  /// Contract date
  DateTime contractDate = DateTime.now();

  /// First EMI due date
  late DateTime firstDueDate;

  /// Contract status
  @enumerated
  ContractStatusEnum status = ContractStatusEnum.active;

  /// Total amount paid so far
  double totalPaid = 0;

  /// Is late fee enabled?
  bool lateFeeEnabled = false;

  /// Late fee percentage
  double lateFeePercentage = 0;

  /// Notes
  String? notes;

  /// Calculate remaining balance
  double get remainingBalance => totalAmount - totalPaid;

  /// Calculate payment progress (0.0 to 1.0)
  double get paymentProgress {
    if (totalAmount <= 0) return 0;
    return (totalPaid / totalAmount).clamp(0.0, 1.0);
  }
}

// Authored by: Moazzam Samoo
