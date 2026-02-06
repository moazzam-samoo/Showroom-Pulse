import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Keep only digits
    final newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // If the resulting text is empty (user typed non-digits), return empty
    if (newText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Parse the value
    final int value = int.tryParse(newText) ?? 0;

    // Format new value
    final formatter = NumberFormat('#,###');
    final String newString = formatter.format(value);

    // Calculate the cursor position
    // We count how many digits were before the cursor in the unformatted string
    int digitsBeforeCursor = 0;
    for (int i = 0; i < newValue.selection.baseOffset; i++) {
      if (i < newValue.text.length && RegExp(r'\d').hasMatch(newValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    // Now find where that maps to in the formatted string
    int newCursorOffset = 0;
    int digitsFound = 0;
    for (int i = 0; i < newString.length; i++) {
      if (RegExp(r'\d').hasMatch(newString[i])) {
        digitsFound++;
      }
      if (digitsFound == digitsBeforeCursor) {
        // If we found the n-th digit, the cursor should be after it? 
        // Or if we are right at the position. 
        // Let's increment one more to be "after" the current char if it's the one we just counted.
        // Actually, if we are at the target digit count, we stop.
        newCursorOffset = i + 1;
        break;
      }
    }
    
    // Handle edge case where we are at the very beginning
    if (digitsBeforeCursor == 0) {
      newCursorOffset = 0;
    }

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }
}
