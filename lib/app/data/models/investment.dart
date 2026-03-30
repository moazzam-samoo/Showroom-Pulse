import 'package:isar/isar.dart';

part 'investment.g.dart';

/// Type of investment action
enum InvestmentTypeEnum {
  capitalInjection,   // User adding money to the business
  bikePurchase,       // Money spent on purchasing bikes (dealer batch or manual)
  withdrawal,         // User taking money out
  bikeSale,           // Revenue from selling a bike (cash sale)
  installmentPayment, // Monthly/down payment received from installment customer
}

enum InvestmentCategoryEnum {
  personalCapital,
  loan,
  partnership,
  other,
  maintenance,
  personalUse,
  expense,
}

/// Investment Collection - Tracks all capital flowing into and out of the business
@collection
class Investment {
  Id id = Isar.autoIncrement;

  /// Amount of the investment
  late double amount;

  /// Date the investment was made
  late DateTime date;

  /// Type of investment (capital, purchase, withdrawal)
  @enumerated
  late InvestmentTypeEnum type;

  /// Category (where the money came from)
  @enumerated
  InvestmentCategoryEnum category = InvestmentCategoryEnum.personalCapital;

  /// Optional contextual notes
  String? description;

  /// If this investment is "locked", it cannot be spent on bikes
  bool isLocked = false;

  /// For a bikePurchase type, the ID of the specific bike (if manually added)
  int? bikeId;

  /// For a bikePurchase type, the ID of the PurchaseBatch (if dealer batch)
  int? purchaseBatchId;

  /// If this investment resulted in a purchase, track the profit earned
  /// from the sale of those item(s).
  /// For bikeSale: profit = saleAmount - purchasePrice (can be negative for loss)
  /// For installmentPayment: profit set on finalization = totalPaid - purchasePrice
  double profitAmount = 0.0;

  /// For bikeSale type, links to the Sale record
  int? saleId;

  /// For installmentPayment type, links to the InstallmentContract
  int? installmentContractId;

  // -- Return Ratios (V2) --
  /// The exact mathematical amount of Cash Revenue returned to Personal Capital
  double returnPersonal = 0.0;
  
  /// The exact mathematical amount of Cash Revenue returned to Partnership Capital
  double returnPartnership = 0.0;
  
  /// The exact mathematical amount of Cash Revenue returned to Other Capital
  double returnOther = 0.0;
  
  /// The exact mathematical amount of Cash Revenue returned to Loan Capital
  double returnLoan = 0.0;
}

// Authored by: Moazzam Samoo
