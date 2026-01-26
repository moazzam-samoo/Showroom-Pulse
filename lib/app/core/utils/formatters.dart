import 'package:intl/intl.dart';

/// Formatters - Handles all formatting for display
class Formatters {
  Formatters._();

  // ═══════════════════════════════════════════════════════════════════════════
  // CURRENCY FORMATTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Format amount as Pakistani Rupees
  /// Example: 250000 → "Rs 250,000"
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_PK');
    return 'Rs ${formatter.format(amount.round())}';
  }

  /// Format amount as Pakistani Rupees with decimal
  /// Example: 250000.50 → "Rs 250,000.50"
  static String formatCurrencyWithDecimal(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_PK');
    return 'Rs ${formatter.format(amount)}';
  }

  /// Format amount as compact currency
  /// Example: 1250000 → "Rs 1.25M"
  static String formatCompactCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Rs ${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return 'Rs ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return formatCurrency(amount);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CNIC FORMATTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Format CNIC with dashes
  /// Example: 3520112345678 → "35201-1234567-8"
  static String formatCNIC(String cnic) {
    // Remove any existing dashes
    cnic = cnic.replaceAll('-', '');
    
    if (cnic.length != 13) return cnic;
    
    return '${cnic.substring(0, 5)}-${cnic.substring(5, 12)}-${cnic.substring(12)}';
  }

  /// Remove formatting from CNIC
  static String unformatCNIC(String cnic) {
    return cnic.replaceAll('-', '');
  }

  /// Validate CNIC format
  static bool isValidCNIC(String cnic) {
    final unformatted = unformatCNIC(cnic);
    return unformatted.length == 13 && RegExp(r'^\d+$').hasMatch(unformatted);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHONE FORMATTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Format phone number for display
  /// Example: 03001234567 → "+92 300 1234567"
  static String formatPhone(String phone) {
    if (phone.startsWith('0')) {
      phone = '+92 ${phone.substring(1)}';
    } else if (!phone.startsWith('+')) {
      phone = '+92 $phone';
    }
    return phone;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DATE FORMATTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Format date as DD/MM/YYYY
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format date as Month DD, YYYY
  static String formatDateLong(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  /// Format date as DD MMM YYYY
  static String formatDateMedium(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format date and time
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// Format time only
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Format relative date (e.g., "2 days ago", "Yesterday")
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDateMedium(date);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NUMBER FORMATTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Format percentage
  /// Example: 0.75 → "75%"
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }

  /// Format percentage with decimal
  static String formatPercentageWithDecimal(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  /// Format number with commas
  static String formatNumber(int number) {
    return NumberFormat('#,##0', 'en_PK').format(number);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ENGINE/CHASSIS FORMATTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Format engine number for display (uppercase)
  static String formatEngineNumber(String engineNumber) {
    return engineNumber.toUpperCase();
  }

  /// Format chassis number for display (uppercase)
  static String formatChassisNumber(String chassisNumber) {
    return chassisNumber.toUpperCase();
  }
}

// Authored by: Moazzam Samoo
