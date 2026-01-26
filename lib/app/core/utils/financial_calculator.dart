/// Financial Calculator - Handles installment calculations
/// 
/// Based on Technical Documentation:
/// - Default Markup: 40%
/// - Formula: Total = CashPrice + (CashPrice × (Markup / 100))
/// - EMI = (Total - DownPayment) / Months
class FinancialCalculator {
  FinancialCalculator._();

  /// Default markup percentage
  static const double defaultMarkupPercentage = 40.0;

  /// Calculate total amount with markup
  /// 
  /// [cashPrice] - The base cash price of the bike
  /// [markupPercentage] - The markup percentage (default: 40%)
  /// 
  /// Returns the total amount including markup
  static double calculateTotalWithMarkup(
    double cashPrice, {
    double markupPercentage = defaultMarkupPercentage,
  }) {
    return cashPrice + (cashPrice * (markupPercentage / 100));
  }

  /// Calculate markup amount only
  static double calculateMarkupAmount(
    double cashPrice, {
    double markupPercentage = defaultMarkupPercentage,
  }) {
    return cashPrice * (markupPercentage / 100);
  }

  /// Calculate monthly EMI (Equal Monthly Installment)
  /// 
  /// [totalAmount] - Total amount after markup
  /// [downPayment] - Initial down payment
  /// [months] - Number of months for installment
  /// 
  /// Returns the monthly EMI amount
  static double calculateMonthlyEMI(
    double totalAmount,
    double downPayment,
    int months,
  ) {
    if (months <= 0) return 0;
    final remainingAmount = totalAmount - downPayment;
    return remainingAmount / months;
  }

  /// Calculate remaining balance after payments
  /// 
  /// [totalAmount] - Total amount to be paid
  /// [totalPaid] - Amount already paid
  /// 
  /// Returns the remaining balance
  static double calculateRemainingBalance(
    double totalAmount,
    double totalPaid,
  ) {
    return totalAmount - totalPaid;
  }

  /// Calculate payment progress percentage
  /// 
  /// [totalAmount] - Total amount to be paid
  /// [totalPaid] - Amount already paid
  /// 
  /// Returns percentage (0.0 to 1.0)
  static double calculatePaymentProgress(
    double totalAmount,
    double totalPaid,
  ) {
    if (totalAmount <= 0) return 0;
    final progress = totalPaid / totalAmount;
    return progress.clamp(0.0, 1.0);
  }

  /// Calculate late fee (if enabled)
  /// 
  /// [amount] - The overdue amount
  /// [percentage] - Late fee percentage
  /// 
  /// Returns the late fee amount
  static double calculateLateFee(
    double amount,
    double percentage,
  ) {
    return amount * (percentage / 100);
  }

  /// Get installment plan summary
  static Map<String, double> getInstallmentSummary({
    required double cashPrice,
    required double downPayment,
    required int months,
    double markupPercentage = defaultMarkupPercentage,
  }) {
    final totalWithMarkup = calculateTotalWithMarkup(
      cashPrice,
      markupPercentage: markupPercentage,
    );
    final markupAmount = calculateMarkupAmount(
      cashPrice,
      markupPercentage: markupPercentage,
    );
    final monthlyEMI = calculateMonthlyEMI(totalWithMarkup, downPayment, months);

    return {
      'cashPrice': cashPrice,
      'markupPercentage': markupPercentage,
      'markupAmount': markupAmount,
      'totalAmount': totalWithMarkup,
      'downPayment': downPayment,
      'financedAmount': totalWithMarkup - downPayment,
      'months': months.toDouble(),
      'monthlyEMI': monthlyEMI,
    };
  }
}

// Authored by: Moazzam Samoo
