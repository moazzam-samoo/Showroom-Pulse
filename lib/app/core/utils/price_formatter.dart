/// Pakistani Price Formatter
/// Formats amounts in South Asian lakh/crore style: Rs. 25,00,000
class PriceFormatter {
  /// Format a double amount to Pakistani Rupee lakh format.
  /// Example: 2500000.0 → "Rs. 25,00,000"
  static String formatPKR(double amount, {bool showDecimal = false}) {
    if (amount < 0) return '-${formatPKR(-amount, showDecimal: showDecimal)}';
    
    final intPart = amount.truncate();
    final str = intPart.toString();
    
    if (str.length <= 3) {
      return showDecimal
          ? 'Rs. $str.${_decimalPart(amount)}'
          : 'Rs. $str';
    }
    
    // Last 3 digits
    final last3 = str.substring(str.length - 3);
    var remaining = str.substring(0, str.length - 3);
    
    // Group remaining digits in pairs (lakh format)
    final buffer = StringBuffer();
    while (remaining.length > 2) {
      buffer.write('${remaining.substring(remaining.length - 2)},');
      remaining = remaining.substring(0, remaining.length - 2);
    }
    if (remaining.isNotEmpty) {
      buffer.write('$remaining,');
    }
    
    // Reverse the grouped pairs
    final groups = buffer.toString().split(',').where((s) => s.isNotEmpty).toList().reversed;
    final formatted = '${groups.join(',')},$last3';
    
    return showDecimal
        ? 'Rs. $formatted.${_decimalPart(amount)}'
        : 'Rs. $formatted';
  }

  static String _decimalPart(double amount) {
    final decimal = ((amount - amount.truncate()) * 100).round();
    return decimal.toString().padLeft(2, '0');
  }

  /// Format in words for KPI cards: "7 Lac 20k" or "1.5 Cr"
  static String formatLakhWords(double amount) {
    if (amount < 0) return '-${formatLakhWords(-amount)}';
    if (amount == 0) return '0';

    if (amount >= 10000000) {
      // Crores
      final crores = amount / 10000000;
      return '${crores.toStringAsFixed(crores.truncateToDouble() == crores ? 0 : 2)} Cr';
    } else if (amount >= 100000) {
      // Lakhs
      final lakhs = (amount / 100000).truncate();
      final remainder = amount % 100000;
      final thousands = (remainder / 1000).round();
      
      if (thousands > 0) {
        return '$lakhs LAC ${thousands}K';
      } else {
        return '$lakhs LAC';
      }
    } else if (amount >= 1000) {
      // Thousands
      final thousands = (amount / 1000).truncate();
      return '${thousands}K';
    } else {
      // Less than 1000
      return amount.truncate().toString();
    }
  }
}

