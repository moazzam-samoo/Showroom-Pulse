
import '../../data/models/installment_contract.dart';

class InstallmentCalculationResult {
  final double cashPrice;
  final double totalMarkup;
  final double grandTotal;
  final double monthlyEMI;

  InstallmentCalculationResult({
    required this.cashPrice,
    required this.totalMarkup,
    required this.grandTotal,
    required this.monthlyEMI,
  });

  @override
  String toString() => 'Price: $cashPrice, Markup: $totalMarkup, Total: $grandTotal, EMI: $monthlyEMI';
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

    double rawEMI = loanAmount / months;
    
    // Round EMI to nearest 50 (e.g. 25833 -> 25850)
    double monthlyEMI = (rawEMI / 50).ceil() * 50.0;
    
    // Recalculate totals based on rounded EMI to ensure consistency
    // New Loan Amount = EMI * Months
    double newLoanAmount = monthlyEMI * months;
    
    // New Grand Total = Down Payment + New Loan Amount
    grandTotal = downPayment + newLoanAmount;
    
    // Update markup to reflect the rounded total
    totalMarkup = grandTotal - cashPrice;

    return InstallmentCalculationResult(
      cashPrice: cashPrice,
      totalMarkup: totalMarkup,
      grandTotal: grandTotal,
      monthlyEMI: monthlyEMI,
    );
  }
}
