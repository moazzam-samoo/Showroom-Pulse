import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/features/investment/presentation/controllers/investment_controller.dart';
import 'package:tahir_showroom/app/core/utils/thousands_separator_input_formatter.dart';
import 'package:tahir_showroom/app/data/models/investment.dart';
import 'package:intl/intl.dart';

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String newValueText = newValue.text.replaceAll(',', '');
    int? value = int.tryParse(newValueText);
    if (value == null) {
      return oldValue;
    }

    final formatter = NumberFormat('#,###', 'en_US');
    String newText = formatter.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class AddInvestmentDialog extends GetView<InvestmentController> {
  final bool isWithdrawal;
  const AddInvestmentDialog({super.key, this.isWithdrawal = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgCol = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final inputBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    // Initialize date if empty
    controller.selectedDate.value = DateTime.now();

    return Dialog(
      backgroundColor: bgCol,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.85, // Safety for small screens
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(isWithdrawal ? 'Withdraw Capital' : 'Add Capital Investment',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textCol)),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: textCol),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Amount
              Text('Amount (Rs)',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textCol.withOpacity(0.8))),
              const SizedBox(height: 8),
              TextField(
                controller: controller.amountController,
                style: TextStyle(color: textCol),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  ThousandsSeparatorInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: 'e.g. 500000',
                  hintStyle: TextStyle(color: textCol.withOpacity(0.4)),
                  filled: true,
                  fillColor: inputBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderCol),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderCol),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date & Category Row
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isNarrow = constraints.maxWidth < 350;
                  return Flex(
                    direction: isNarrow ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: isNarrow ? 0 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textCol.withOpacity(0.8))),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: controller.selectedDate.value,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  controller.selectedDate.value = date;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: inputBg,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderCol),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => Text(
                                          '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
                                          style: TextStyle(color: textCol),
                                        )),
                                    Icon(Icons.calendar_today,
                                        size: 16, color: textCol.withOpacity(0.6)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isNarrow && !isWithdrawal) const SizedBox(width: 16),
                      if (isNarrow && !isWithdrawal) const SizedBox(height: 16),
                      if (!isWithdrawal) Expanded(
                        flex: isNarrow ? 0 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textCol.withOpacity(0.8))),
                            const SizedBox(height: 8),
                            Obx(() => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: borderCol),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<InvestmentCategoryEnum>(
                                      value: controller.selectedCategory.value,
                                      isExpanded: true,
                                      dropdownColor: bgCol,
                                      style: TextStyle(color: textCol),
                                      onChanged: (val) {
                                        if (val != null) {
                                          controller.selectedCategory.value = val;
                                        }
                                      },
                                      items: InvestmentCategoryEnum.values
                                          .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(_formatEnumName(e.name)),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              ),
              const SizedBox(height: 16),

              // Notes
              Text('Notes (Optional)',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textCol.withOpacity(0.8))),
              const SizedBox(height: 8),
              TextField(
                controller: controller.notesController,
                style: TextStyle(color: textCol),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: isWithdrawal ? 'Why are you withdrawing?' : 'Why was this money invested?',
                  hintStyle: TextStyle(color: textCol.withOpacity(0.4)),
                  filled: true,
                  fillColor: inputBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderCol),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderCol),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lock Toggle (Only for Add Capital)
              if (!isWithdrawal) ...[
                Obx(() => CheckboxListTile(
                      value: controller.isLockedToggle.value,
                      onChanged: (val) => controller.isLockedToggle.value = val ?? false,
                      title: Text('Lock this investment', style: TextStyle(color: textCol, fontSize: 14)),
                      subtitle: Text('Prevent this capital from being spent on bikes',
                          style: TextStyle(color: textCol.withOpacity(0.6), fontSize: 12)),
                      activeColor: Colors.blue,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    )),
                const SizedBox(height: 24),
              ],

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isWithdrawal ? controller.saveWithdrawal : controller.saveCapitalInvestment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWithdrawal ? Colors.orange : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(isWithdrawal ? 'Confirm Withdrawal' : 'Save Investment',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatEnumName(String name) {
    if (name.isEmpty) return name;
    // Basic camelCase to Title Case
    final RegExp exp = RegExp(r'(?<=[a-z])(?=[A-Z])');
    final formatted = name.replaceAllMapped(exp, (m) => ' ').capitalizeFirst ?? name;
    return formatted;
  }
}

// Authored by: Moazzam Samoo
