import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tahir_showroom/app/features/investment/presentation/controllers/investment_controller.dart';

class InvestmentFilterBar extends GetView<InvestmentController> {
  const InvestmentFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.black.withOpacity(0.05);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Time Filters + Month Dropdown
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
                    children: [
                      _buildFilterChip(
                        label: 'All Time',
                        isSelected: controller.selectedTimeRange.value == InvestmentFilter.all,
                        onSelected: () => controller.setTimeFilter(InvestmentFilter.all),
                        accentColor: const Color(0xFF06B6D4),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'This Week',
                        isSelected: controller.selectedTimeRange.value == InvestmentFilter.weekly,
                        onSelected: () => controller.setTimeFilter(InvestmentFilter.weekly),
                        accentColor: const Color(0xFF06B6D4),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'This Month',
                        isSelected: controller.selectedTimeRange.value == InvestmentFilter.monthly,
                        onSelected: () => controller.setTimeFilter(InvestmentFilter.monthly),
                        accentColor: const Color(0xFF06B6D4),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Last Month',
                        isSelected: controller.selectedTimeRange.value == InvestmentFilter.lastMonth,
                        onSelected: () => controller.setTimeFilter(InvestmentFilter.lastMonth),
                        accentColor: const Color(0xFF06B6D4),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: controller.selectedTimeRange.value == InvestmentFilter.custom
                            ? DateFormat('MMM yyyy').format(controller.selectedSpecificMonth.value)
                            : 'Select Month',
                        isSelected: controller.selectedTimeRange.value == InvestmentFilter.custom,
                        onSelected: () => _showMonthPicker(context),
                        accentColor: const Color(0xFF06B6D4),
                      ),
                    ],
                  )),
                ),
              ),
              const SizedBox(width: 12),
              _buildMonthDropdown(isDark),
              const SizedBox(width: 8),
              Obx(() {
                final hasActiveFilters = controller.selectedTimeRange.value != InvestmentFilter.all ||
                    controller.selectedTransactionType.value != InvestmentTransactionType.all;
                return AnimatedOpacity(
                  opacity: hasActiveFilters ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: hasActiveFilters ? controller.resetFilters : null,
                    icon: Icon(Icons.filter_alt_off, size: 20, color: Colors.red.shade400),
                    tooltip: 'Clear Filters',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                );
              }),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1, thickness: 0.5),
          ),
          // Row 2: Transaction Type Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() => Row(
              children: [
                _buildFilterChip(
                  label: 'All Types',
                  isSelected: controller.selectedTransactionType.value == InvestmentTransactionType.all,
                  onSelected: () => controller.setTransactionType(InvestmentTransactionType.all),
                  accentColor: const Color(0xFF8B5CF6),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Installments',
                  isSelected: controller.selectedTransactionType.value == InvestmentTransactionType.installment,
                  onSelected: () => controller.setTransactionType(InvestmentTransactionType.installment),
                  accentColor: const Color(0xFF22C55E),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Investments',
                  isSelected: controller.selectedTransactionType.value == InvestmentTransactionType.investment,
                  onSelected: () => controller.setTransactionType(InvestmentTransactionType.investment),
                  accentColor: const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Purchases',
                  isSelected: controller.selectedTransactionType.value == InvestmentTransactionType.purchase,
                  onSelected: () => controller.setTransactionType(InvestmentTransactionType.purchase),
                  accentColor: const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Withdrawals',
                  isSelected: controller.selectedTransactionType.value == InvestmentTransactionType.withdrawal,
                  onSelected: () => controller.setTransactionType(InvestmentTransactionType.withdrawal),
                  accentColor: const Color(0xFFEF4444),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Sales',
                  isSelected: controller.selectedTransactionType.value == InvestmentTransactionType.sale,
                  onSelected: () => controller.setTransactionType(InvestmentTransactionType.sale),
                  accentColor: const Color(0xFF10B981),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    required Color accentColor,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : null,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: accentColor,
      pressElevation: 0,
      side: isSelected ? BorderSide.none : BorderSide(color: accentColor.withOpacity(0.3)),
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildMonthDropdown(bool isDark) {
    final now = DateTime.now();
    // Generate last 24 months for the dropdown
    final List<DateTime> months = List.generate(24, (i) {
      return DateTime(now.year, now.month - i, 1);
    });

    return Obx(() {
      final selectedDate = controller.selectedSpecificMonth.value;
      final isSpecific = controller.selectedTimeRange.value == InvestmentFilter.specificMonth;

      return Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSpecific ? const Color(0xFF06B6D4) : (isDark ? Colors.white10 : Colors.black12),
          ),
          color: isSpecific ? const Color(0xFF06B6D4).withOpacity(0.1) : Colors.transparent,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<DateTime>(
            value: isSpecific ? DateTime(selectedDate.year, selectedDate.month, 1) : null,
            hint: Text(
              'Jump to...',
              style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, size: 16),
            items: months.map((date) {
              return DropdownMenuItem(
                value: date,
                child: Text(
                  DateFormat('MMM yyyy').format(date),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }).toList(),
            onChanged: (DateTime? newValue) {
              if (newValue != null) {
                controller.setSpecificMonth(newValue, isFromDropdown: true);
              }
            },
            dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    });
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    DateTime tempDate = controller.selectedSpecificMonth.value;

    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          title: const Text('Select Month'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: isDark
                    ? const ColorScheme.dark(primary: Color(0xFF06B6D4))
                    : const ColorScheme.light(primary: Color(0xFF06B6D4)),
              ),
              child: CalendarDatePicker(
                initialDate: tempDate,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
                onDateChanged: (date) {
                  tempDate = date;
                },
                initialCalendarMode: DatePickerMode.year, // Start with year selection
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, tempDate),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      controller.setSpecificMonth(result);
    }
  }
}
