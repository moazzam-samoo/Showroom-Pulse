import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of a separator
    if (oldValue.text.length > newValue.text.length) {
      final int selectionIndex = newValue.selection.end;
      // If the user deleted a comma, we need to delete the digit before it too
      // or just trust the standard behavior if we strip non-digits.
      // But actually, standard behavior is usually just to re-format.
    }

    // 1. Get the pure number
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // If empty or 0, return empty or formatted 0? 
    // Let's stick to returning the formatted string.
    if (newText.isEmpty) {
       return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    
    // Parse
    int value = int.tryParse(newText) ?? 0;
    
    // Format
    final formatter = NumberFormat('#,###');
    String newString = formatter.format(value);

    // 2. Calculate cursor position
    // We want to maintain the cursor's position relative to the DIGITS.
    // Count how many digits are to the left of the cursor in the NEW raw input.
    // BUT 'newValue' already has the user's change applied to the PREVIOUS formatted text.
    
    // Let's count digits before selection in newValue
    int digitsBeforeCursor = 0;
    for (int i = 0; i < newValue.selection.end; i++) {
      if (i < newValue.text.length && RegExp(r'\d').hasMatch(newValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    // Now find the index in 'newString' that follows that many digits
    int newCursorOffset = 0;
    int digitsEncountered = 0;

    for (int i = 0; i < newString.length; i++) {
      if (RegExp(r'\d').hasMatch(newString[i])) {
        digitsEncountered++;
      }
      newCursorOffset = i + 1;
      if (digitsEncountered >= digitsBeforeCursor) {
        break;
      }
    }
    
    // Edge case: if digitsBeforeCursor is 0, we are at start
    if (digitsBeforeCursor == 0) {
        newCursorOffset = 0;
    }
    
    // Safety check
    if (newCursorOffset > newString.length) {
        newCursorOffset = newString.length;
    }

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }
}
