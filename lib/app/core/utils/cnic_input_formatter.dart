import 'package:flutter/services.dart';

/// Input formatter for Pakistani CNIC numbers
/// Formats: XXXXX-XXXXXXX-X (5 digits, dash, 7 digits, dash, 1 digit)
/// Example: 4180106609149 → 41801-0660914-9
class CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Keep only digits
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // If no digits, return empty
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Limit to 13 digits (CNIC length)
    final limitedDigits = digitsOnly.length > 13 ? digitsOnly.substring(0, 13) : digitsOnly;

    // Format based on length
    String formatted;
    if (limitedDigits.length <= 5) {
      formatted = limitedDigits;
    } else if (limitedDigits.length <= 12) {
      formatted = '${limitedDigits.substring(0, 5)}-${limitedDigits.substring(5)}';
    } else {
      formatted = '${limitedDigits.substring(0, 5)}-${limitedDigits.substring(5, 12)}-${limitedDigits.substring(12)}';
    }

    // Calculate cursor position
    int digitsBeforeCursor = 0;
    for (int i = 0; i < newValue.selection.baseOffset && i < newValue.text.length; i++) {
      if (RegExp(r'\d').hasMatch(newValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    // Clamp digitsBeforeCursor to available digits in formatted string
    if (digitsBeforeCursor > limitedDigits.length) {
      digitsBeforeCursor = limitedDigits.length;
    }

    // Find cursor position in formatted string
    int newCursorOffset = 0;
    int digitsFound = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (RegExp(r'\d').hasMatch(formatted[i])) {
        digitsFound++;
      }
      if (digitsFound == digitsBeforeCursor) {
        newCursorOffset = i + 1;
        break;
      }
    }

    // Handle edge case: cursor at the beginning
    if (digitsBeforeCursor == 0) {
      newCursorOffset = 0;
    }

    // Ensure cursor is within bounds
    if (newCursorOffset > formatted.length) {
      newCursorOffset = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }
}
