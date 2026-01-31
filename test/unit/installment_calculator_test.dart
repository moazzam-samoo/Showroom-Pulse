
import 'package:flutter_test/flutter_test.dart';
import 'package:tahir_showroom/app/core/utils/installment_calculator.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';

void main() {
  group('InstallmentCalculator', () {
    test('Calculates Percentage Markup Correctly (40%)', () {
      // Cash Price = 100,000
      // Markup = 40%
      // Total should be 140,000
      // Down Payment = 20,000
      // Loan Amount = 120,000
      // Months = 12
      // EMI = 10,000
      final result = InstallmentCalculator.calculate(
        cashPrice: 100000,
        markupType: MarkupType.percentage,
        markupValue: 40.0,
        downPayment: 20000,
        months: 12,
      );

      expect(result.totalMarkup, 40000);
      expect(result.grandTotal, 140000);
      expect(result.monthlyEMI, 10000);
    });

    test('Calculates Fixed Markup Correctly (Rs 15,000)', () {
      // Cash Price = 100,000
      // Markup = 15,000 (Fixed)
      // Total should be 115,000
      // Down Payment = 15,000
      // Loan Amount = 100,000
      // Months = 10
      // EMI = 10,000
      final result = InstallmentCalculator.calculate(
        cashPrice: 100000,
        markupType: MarkupType.fixed,
        markupValue: 15000,
        downPayment: 15000,
        months: 10,
      );

      expect(result.totalMarkup, 15000);
      expect(result.grandTotal, 115000);
      expect(result.monthlyEMI, 10000);
    });

    test('Handles Zero Down Payment', () {
      // Total 140,000
      // Down Payment 0
      // Loan 140,000
      // Months 10
      // EMI 14,000
      final result = InstallmentCalculator.calculate(
        cashPrice: 100000,
        markupType: MarkupType.percentage,
        markupValue: 40.0,
        downPayment: 0,
        months: 10,
      );

      expect(result.monthlyEMI, 14000);
    });

    test('Throws Error on Zero Months', () {
      expect(
        () => InstallmentCalculator.calculate(
          cashPrice: 10000,
          markupType: MarkupType.percentage,
          markupValue: 10,
          downPayment: 0,
          months: 0,
        ),
        throwsArgumentError,
      );
    });
  });
}
