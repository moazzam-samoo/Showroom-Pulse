import 'package:isar/isar.dart';

part 'sale.g.dart';

enum SaleType {
  cash,
  installment,
}

@collection
class Sale {
  Id id = Isar.autoIncrement;

  /// Date of the sale
  DateTime saleDate = DateTime.now();

  /// Type of sale: Cash or Installment
  @enumerated
  late SaleType saleType;

  /// Link to the Bike sold
  late int bikeId;

  /// Link to the Customer
  late int customerId;

  /// Total transaction amount
  /// For Cash: The final sale price
  /// For Installment: The Grand Total (Price + Markup)
  late double totalAmount;

  /// Amount received upfront
  /// For Cash: Usually equals totalAmount
  /// For Installment: The Down Payment
  late double receivedAmount;

  /// Link to Installment Contract (if saleType == installment)
  int? installmentContractId;

  /// Notes or formatting
  String? notes;

  /// Discount given on this sale (Amount in Currency)
  double discountAmount = 0.0;

  /// Discount given on this sale (Percentage)
  double discountPercentage = 0.0;
}
