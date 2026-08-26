import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';
import 'package:tahir_showroom/app/core/utils/thousands_separator_input_formatter.dart';

/// Dialog for applying discount to the remaining balance
class ApplyDiscountDialog extends StatefulWidget {
  final double currentRemaining;
  final double purchasePrice;
  final double currentTotalAmount;
  final int remainingMonths;
  final Function(double newRemainingAmount) onSubmit;

  const ApplyDiscountDialog({
    super.key,
    required this.currentRemaining,
    required this.purchasePrice,
    required this.currentTotalAmount,
    required this.remainingMonths,
    required this.onSubmit,
  });

  @override
  State<ApplyDiscountDialog> createState() => _ApplyDiscountDialogState();
}

class _ApplyDiscountDialogState extends State<ApplyDiscountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _submitFocus = FocusNode();
  final FocusNode _keyboardFocus = FocusNode();

  double _discountAmount = 0.0;
  bool _isLoss = false;
  double _newMonthlyEMI = 0.0;

  @override
  void initState() {
    super.initState();
    final formatter = NumberFormat('#,###', 'en_US');
    _amountController.text = formatter.format(widget.currentRemaining);
    _amountController.addListener(_calculateFinancials);
    _calculateFinancials();
  }

  void _calculateFinancials() {
    final rawValue = _amountController.text.replaceAll(',', '');
    final newRemaining = double.tryParse(rawValue) ?? widget.currentRemaining;

    setState(() {
      _discountAmount = widget.currentRemaining - newRemaining;
      
      final newTotalAmount = widget.currentTotalAmount - _discountAmount;
      _isLoss = newTotalAmount < widget.purchasePrice;

      final months = widget.remainingMonths > 0 ? widget.remainingMonths : 1;
      _newMonthlyEMI = newRemaining / months;
    });
  }

  @override
  void dispose() {
    _amountController.removeListener(_calculateFinancials);
    _amountController.dispose();
    _amountFocus.dispose();
    _submitFocus.dispose();
    _keyboardFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final currencyFormat = NumberFormat.currency(
      locale: 'en_PK',
      symbol: 'Rs ',
      decimalDigits: 0,
    );

    return KeyboardListener(
      focusNode: _keyboardFocus,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            Get.back();
          } else if (event.logicalKey == LogicalKeyboardKey.enter && _amountFocus.hasFocus) {
             _submitFocus.requestFocus();
          }
        }
      },
      child: Dialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Container(
          width: 450,
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
                      'Apply Discount',
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
                const SizedBox(height: AppSpacing.md),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Remaining Balance:',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      Text(
                        currencyFormat.format(widget.currentRemaining),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Amount Field
                _buildLabel('Agreed New Remaining Balance *', isDark),
                const SizedBox(height: AppSpacing.xs),
                BlinkingFocusBuilder(
                  focusNode: _amountFocus,
                  child: TextFormField(
                    controller: _amountController,
                    focusNode: _amountFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandsSeparatorInputFormatter()
                    ],
                    autofocus: true,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    decoration: _inputDecoration('Enter agreed balance', isDark),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      final val = double.tryParse(value.replaceAll(',', ''));
                      if (val == null) {
                        return 'Enter a valid amount';
                      }
                      if (val > widget.currentRemaining) {
                        return 'New remaining cannot be greater than current remaining';
                      }
                      if (val < 0) {
                        return 'Cannot be negative';
                      }
                      return null;
                    },
                  ),
                ),
                
                const SizedBox(height: AppSpacing.lg),

                if (_discountAmount > 0) ...[
                  // Dynamic Financial Feedback
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Discount Applied:'),
                            Text(
                              currencyFormat.format(_discountAmount),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('New Monthly EMI:'),
                            Text(
                              currencyFormat.format(_newMonthlyEMI),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                if (_isLoss) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkError : AppColors.lightError).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isDark ? AppColors.darkError : AppColors.lightError,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.alertTriangle, 
                          color: isDark ? AppColors.darkError : AppColors.lightError, 
                          size: 20
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Warning: Proceeding with this discount will result in a net loss on this sales contract relative to the bike\'s purchase price.',
                            style: TextStyle(
                              color: isDark ? AppColors.darkError : AppColors.lightError,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Submit Button
                BlinkingFocusBuilder(
                  focusNode: _submitFocus,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      focusNode: _submitFocus,
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoss ? (isDark ? AppColors.darkError : AppColors.lightError) : primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        _isLoss ? 'Confirm Discount (Taking Loss)' : 'Apply Discount',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newRemaining = double.parse(_amountController.text.replaceAll(',', ''));
      widget.onSubmit(newRemaining);
      Get.back();
    }
  }
}

// Authored by: Moazzam Samoo
