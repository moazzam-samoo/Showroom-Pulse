
import '../../data/models/installment_contract.dart';

class InstallmentCalculationResult {
  final double totalMarkup;
  final double grandTotal;
  final double monthlyEMI;

  InstallmentCalculationResult({
    required this.totalMarkup,
    required this.grandTotal,
    required this.monthlyEMI,
  });

  @override
  String toString() => 'Markup: $totalMarkup, Total: $grandTotal, EMI: $monthlyEMI';
}

class InstallmentCalculator {
  /// Calculate installment plan details
  /// [cashPrice]: The base price of the bike
  /// [markupType]: Percentage or Fixed
  /// [markupValue]: The value (e.g. 40.0 for 40%, or 5000.0 for Rs 5k)
  /// [downPayment]: Amount paid upfront
  /// [months]: Duration in months
  static InstallmentCalculationResult calculate({
    required double cashPrice,
    required MarkupType markupType,
    required double markupValue,
    required double downPayment,
    required int months,
  }) {
    if (months <= 0) {
      throw ArgumentError('Months must be greater than 0');
    }

    double totalMarkup = 0;

    if (markupType == MarkupType.percentage) {
      // Formula: CashPrice + (CashPrice * %)
      totalMarkup = cashPrice * (markupValue / 100);
    } else {
      // Formula: CashPrice + FixedAmount
      totalMarkup = markupValue;
    }

    double grandTotal = cashPrice + totalMarkup;
    double loanAmount = grandTotal - downPayment;
    
    // Ensure loan amount isn't negative (edge case where down payment > total)
    if (loanAmount < 0) loanAmount = 0;

    double monthlyEMI = loanAmount / months;

    return InstallmentCalculationResult(
      totalMarkup: totalMarkup,
      grandTotal: grandTotal,
      monthlyEMI: monthlyEMI,
    );
  }
}
