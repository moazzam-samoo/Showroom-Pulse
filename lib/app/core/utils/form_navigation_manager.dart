import 'package:flutter/material.dart';

class FormFieldInfo {
  final FocusNode focusNode;
  final bool Function() isFilled;
  final int order;

  FormFieldInfo({
    required this.focusNode,
    required this.isFilled,
    required this.order,
  });
}

class FormNavigationManager {
  final List<FormFieldInfo> _fields = [];
  bool _isDisposed = false;

  void registerField({
    required FocusNode focusNode,
    required bool Function() isFilled,
    int? order,
  }) {
    if (_isDisposed) return;

    // Automatically assign order if not provided, based on registration sequence
    final fieldOrder = order ?? _fields.length;

    _fields.add(FormFieldInfo(
      focusNode: focusNode,
      isFilled: isFilled,
      order: fieldOrder,
    ));

    // Keep sorted by logical order
    _fields.sort((a, b) => a.order.compareTo(b.order));
  }

  void unregisterField(FocusNode node) {
    if (_isDisposed) return;
    _fields.removeWhere((f) => f.focusNode == node);
  }

  void handleEnter(FocusNode currentFocus) {
    if (_isDisposed) return;

    final currentIndex = _fields.indexWhere((f) => f.focusNode == currentFocus);
    if (currentIndex == -1) {
      // If the current field isn't registered, fallback to default behavior
      currentFocus.nextFocus();
      return;
    }

    final currentField = _fields[currentIndex];

    // Find all unfilled fields
    final unfilledFields = _fields.where((f) => !f.isFilled()).toList();

    if (unfilledFields.isEmpty) {
      // If everything is filled, go to the next logical field (or submit if at the end)
      if (currentIndex < _fields.length - 1) {
        _fields[currentIndex + 1].focusNode.requestFocus();
      } else {
        // Optionally trigger submission here if we had a callback
        currentFocus.nextFocus();
      }
      return;
    }

    // Prioritize the nearest unfilled field that comes AFTER the current field
    FormFieldInfo? bestCandidate;

    for (final field in unfilledFields) {
      if (field.order > currentField.order) {
        bestCandidate = field;
        break; // Found the first unfilled field AFTER current
      }
    }

    // If no unfilled field after the current one, wrap around to the first unfilled field
    bestCandidate ??= unfilledFields.first;

    // Request focus on the best candidate
    bestCandidate.focusNode.requestFocus();
  }

  void dispose() {
    _isDisposed = true;
    _fields.clear();
  }
}
