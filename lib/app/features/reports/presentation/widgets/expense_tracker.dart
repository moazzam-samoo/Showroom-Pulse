import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/data/models/expense.dart';

class ExpenseTracker extends StatelessWidget {
  final List<Expense> expenses;
  final List<String> categories;
  final Function(Expense) onAdd;
  final Function(Expense) onUpdate;
  final Function(int) onDelete;
  final double totalExpenses;
  final double totalRevenue;
  final double netProfit;

  const ExpenseTracker({
    super.key,
    required this.expenses,
    required this.categories,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
    required this.totalExpenses,
    required this.totalRevenue,
    required this.netProfit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat('#,##0', 'en_PK');
    final dateFormat = DateFormat('dd MMM yyyy');

    return Column(
      children: [
        // Expense Table
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
            ),
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expense Tracker',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _showAddExpenseDialog(context, isDark),
                    icon: const Icon(LucideIcons.plus, size: 16),
                    label: const Text('Add Expense'),
                    style: FilledButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Table
              expenses.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          Icon(
                            LucideIcons.receipt,
                            size: 48,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No expenses recorded this month',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1),
                      },
                      children: [
                        // Header
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
                              ),
                            ),
                          ),
                          children: [
                            _headerCell('Category', isDark),
                            _headerCell('Amount', isDark),
                            _headerCell('Date', isDark),
                            _headerCell('Actions', isDark),
                          ],
                        ),
                        // Rows
                        ...expenses.map((expense) => TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDark
                                    ? AppColors.darkBorder.withOpacity(0.5)
                                    : AppColors.lightBorderLight,
                              ),
                            ),
                          ),
                          children: [
                            // Category with colored dot
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(expense.category),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      expense.category,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Amount
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              child: Text(
                                'Rs ${currencyFormat.format(expense.amount)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.darkWarning : AppColors.lightWarning,
                                ),
                              ),
                            ),
                            // Date
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              child: Text(
                                dateFormat.format(expense.date),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                            // Actions
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(LucideIcons.edit3, size: 16,
                                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                                    ),
                                    onPressed: () => _showEditExpenseDialog(context, isDark, expense),
                                    tooltip: 'Edit',
                                    constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
                                    padding: EdgeInsets.zero,
                                  ),
                                  IconButton(
                                    icon: Icon(LucideIcons.trash2, size: 16,
                                      color: isDark ? AppColors.darkError : AppColors.lightError,
                                    ),
                                    onPressed: () => _confirmDelete(context, isDark, expense),
                                    tooltip: 'Delete',
                                    constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Summary Bar
        _buildSummaryBar(isDark, currencyFormat),
      ],
    );
  }

  Widget _buildSummaryBar(bool isDark, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem(
            'Total Expenses',
            'Rs ${currencyFormat.format(totalExpenses)}',
            isDark ? AppColors.darkWarning : AppColors.lightWarning,
            isDark,
          ),
          Container(width: 1, height: 40, color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight),
          _summaryItem(
            'Revenue',
            'Rs ${currencyFormat.format(totalRevenue)}',
            isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            isDark,
          ),
          Container(width: 1, height: 40, color: isDark ? AppColors.darkBorder : AppColors.lightBorderLight),
          _summaryItem(
            'Hands-On Amount',
            'Rs ${currencyFormat.format(netProfit)}',
            isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    const colors = {
      'Salaries': Color(0xFF3b82f6),
      'Electricity': Color(0xFFf59e0b),
      'Rent': Color(0xFF8b5cf6),
      'Utilities': Color(0xFF10b981),
    };
    return colors[category] ?? const Color(0xFF64748b);
  }

  // ─── Dialogs ─────────────────────────────────────────────────

  void _showAddExpenseDialog(BuildContext context, bool isDark) {
    final categoryController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String? selectedCategory;
    bool isNewCategory = false;

    void saveExpense() {
      final category = isNewCategory ? categoryController.text.trim() : selectedCategory;
      final amount = double.tryParse(amountController.text.replaceAll(',', ''));
      if (category == null || category.isEmpty || amount == null || amount <= 0) return;

      final expense = Expense()
        ..category = category
        ..amount = amount
        ..date = selectedDate
        ..description = descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim();

      onAdd(expense);
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text(
                'Add New Expense',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Category dropdown
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      dropdownColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      items: [
                        ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                        const DropdownMenuItem(value: '__new__', child: Text('+ Create New Category')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          if (value == '__new__') {
                            isNewCategory = true;
                            selectedCategory = null;
                          } else {
                            isNewCategory = false;
                            selectedCategory = value;
                          }
                        });
                      },
                    ),
                    if (isNewCategory) ...[
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: categoryController,
                        onSubmitted: (_) => saveExpense(),
                        decoration: InputDecoration(
                          labelText: 'New Category Name',
                          labelStyle: TextStyle(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    // Amount
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => saveExpense(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) return newValue;
                          final value = int.tryParse(newValue.text.replaceAll(',', '')) ?? 0;
                          final formatted = NumberFormat('#,##0').format(value);
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Amount (Rs)',
                        labelStyle: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Date picker
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(LucideIcons.calendar, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                      title: Text(
                        DateFormat('dd MMM yyyy').format(selectedDate),
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => selectedDate = date);
                      },
                    ),
                    // Description
                    TextField(
                      controller: descriptionController,
                      onSubmitted: (_) => saveExpense(),
                      decoration: InputDecoration(
                        labelText: 'Note (optional)',
                        labelStyle: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                  )),
                ),
                FilledButton(
                  onPressed: saveExpense,
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditExpenseDialog(BuildContext context, bool isDark, Expense expense) {
    final amountController = TextEditingController(
      text: NumberFormat('#,##0').format(expense.amount),
    );
    final descriptionController = TextEditingController(text: expense.description ?? '');
    DateTime selectedDate = expense.date;

    void saveEdit() {
      final amount = double.tryParse(amountController.text.replaceAll(',', ''));
      if (amount == null || amount <= 0) return;

      expense.amount = amount;
      expense.date = selectedDate;
      expense.description = descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim();

      onUpdate(expense);
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text(
                'Edit: ${expense.category}',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => saveEdit(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) return newValue;
                          final value = int.tryParse(newValue.text.replaceAll(',', '')) ?? 0;
                          final formatted = NumberFormat('#,##0').format(value);
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Amount (Rs)',
                        labelStyle: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(LucideIcons.calendar, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                      title: Text(
                        DateFormat('dd MMM yyyy').format(selectedDate),
                        style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => selectedDate = date);
                      },
                    ),
                    TextField(
                      controller: descriptionController,
                      onSubmitted: (_) => saveEdit(),
                      decoration: InputDecoration(
                        labelText: 'Note (optional)',
                        labelStyle: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDark ? AppColors.darkBorderInput : AppColors.lightBorder,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                  )),
                ),
                FilledButton(
                  onPressed: saveEdit,
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, bool isDark, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Delete Expense',
          style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
        content: Text(
          'Delete "${expense.category}" (Rs ${NumberFormat('#,##0').format(expense.amount)})?',
          style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
            )),
          ),
          FilledButton(
            onPressed: () {
              onDelete(expense.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.darkError),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
