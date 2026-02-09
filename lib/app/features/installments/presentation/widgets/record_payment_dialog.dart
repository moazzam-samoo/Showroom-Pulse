import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/data/models/payment.dart';

/// Dialog for recording a new payment
class RecordPaymentDialog extends StatefulWidget {
  final Function(double amount, PaymentMethod method, String? collector, String? notes) onSubmit;

  const RecordPaymentDialog({super.key, required this.onSubmit});

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _collectorController = TextEditingController();
  final _notesController = TextEditingController();
  PaymentMethod _selectedMethod = PaymentMethod.cash;

  @override
  void dispose() {
    _amountController.dispose();
    _collectorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Record Payment',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      LucideIcons.x,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Amount Field
              _buildLabel('Amount *', isDark),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                decoration: _inputDecoration('Enter amount', isDark),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required';
                  }
                  if (double.tryParse(value.replaceAll(',', '')) == null) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.base),

              // Payment Method
              _buildLabel('Payment Method', isDark),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<PaymentMethod>(
                value: _selectedMethod,
                dropdownColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                decoration: _inputDecoration(null, isDark),
                items: PaymentMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(_getMethodText(method)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedMethod = value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.base),

              // Collector Name
              _buildLabel('Collector Name (Optional)', isDark),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _collectorController,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                decoration: _inputDecoration('Who collected payment?', isDark),
              ),
              const SizedBox(height: AppSpacing.base),

              // Notes
              _buildLabel('Notes (Optional)', isDark),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                decoration: _inputDecoration('Additional notes', isDark),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text(
                    'Save Payment',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      ),
      filled: true,
      fillColor: isDark ? AppColors.darkCard : AppColors.lightBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  String _getMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.jazzCash:
        return 'JazzCash';
      case PaymentMethod.easyPaisa:
        return 'EasyPaisa';
      case PaymentMethod.cheque:
        return 'Cheque';
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      widget.onSubmit(
        amount,
        _selectedMethod,
        _collectorController.text.isEmpty ? null : _collectorController.text,
        _notesController.text.isEmpty ? null : _notesController.text,
      );
      Get.back();
    }
  }
}

// Authored by: Moazzam Samoo
