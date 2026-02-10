import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';

/// Bike Filter Bar Widget
/// 
/// Analyzed from: Dark Theme UI/Inventory Page.png
/// - Search input on left
/// - "+ Add Bike" button (cyan)
/// - Filter dropdowns: Brand, Engine CC, Status
class BikeFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedBrand;
  final String? selectedCC;
  final String? selectedStatus;
  final String? selectedColor;
  final double? minPrice;
  final double? maxPrice;
  final ValueChanged<String?>? onBrandChanged;
  final ValueChanged<String?>? onCCChanged;
  final ValueChanged<String?>? onStatusChanged;
  final ValueChanged<String?>? onColorChanged;
  final ValueChanged<double?>? onMinPriceChanged;
  final ValueChanged<double?>? onMaxPriceChanged;
  final VoidCallback? onClearFilters;
  final VoidCallback? onAddBike;

  const BikeFilterBar({
    super.key,
    required this.searchController,
    this.selectedBrand,
    this.selectedCC,
    this.selectedStatus,
    this.selectedColor,
    this.minPrice,
    this.maxPrice,
    this.onBrandChanged,
    this.onCCChanged,
    this.onStatusChanged,
    this.onColorChanged,
    this.onMinPriceChanged,
    this.onMaxPriceChanged,
    this.onClearFilters,
    this.onAddBike,
  });

  // Sample data
  static const List<String> brands = ['Honda', 'Suzuki', 'Yamaha', 'Road Prince', 'United'];
  static const List<String> engineCCs = ['70cc', '100cc', '110cc', '125cc', '150cc'];
  static const List<String> statuses = ['Available', 'Sold', 'Pending'];
  static const List<String> colors = [
    'Red', 'Black', 'Blue', 'Silver', 'White', 'Grey', 'Green',
    'Yellow', 'Orange', 'Purple', 'Maroon',
    'Lion Skin', 'Zebra Skin', 'Cheetah Skin',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Row(
      children: [
        // Search Bar
        Expanded(
          flex: 2,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.search,
                  size: 18,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by model, engine, chassis...',
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Brand Filter
        _buildDropdown(
          value: selectedBrand,
          hint: 'Brand',
          items: brands,
          onChanged: onBrandChanged,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        // Engine CC Filter
        _buildDropdown(
          value: selectedCC,
          hint: 'Engine CC',
          items: engineCCs,
          onChanged: onCCChanged,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        // Status Filter
        _buildDropdown(
          value: selectedStatus,
          hint: 'Status',
          items: statuses,
          onChanged: onStatusChanged,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        // Color Filter
        _buildDropdown(
          value: selectedColor,
          hint: 'Color',
          items: colors,
          onChanged: onColorChanged,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        // Price Range
        _buildPriceInput(
          value: minPrice,
          hint: 'Min Price',
          onChanged: onMinPriceChanged,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildPriceInput(
          value: maxPrice,
          hint: 'Max Price',
          onChanged: onMaxPriceChanged,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.sm),
        // Clear Filters Button
        IconButton(
          onPressed: onClearFilters,
          icon: const Icon(LucideIcons.x),
          tooltip: 'Clear Filters',
          style: IconButton.styleFrom(
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            side: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        // Add Bike Button
        ElevatedButton.icon(
          onPressed: onAddBike,
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Add Bike'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    required bool isDark,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontSize: 13,
            ),
          ),
          icon: Icon(
            LucideIcons.chevronDown,
            size: 16,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'All $hint',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            ...items.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 13,
                ),
              ),
            )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPriceInput({
    required double? value,
    required String hint,
    required ValueChanged<double?>? onChanged,
    required bool isDark,
  }) {
    return Container(
      width: 110,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _ThousandsSeparatorInputFormatter(),
        ],
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            fontSize: 13,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (text) {
          if (text.isEmpty) {
            onChanged?.call(null);
          } else {
            // Remove commas before parsing
            final cleanText = text.replaceAll(',', '');
            final parsed = double.tryParse(cleanText);
            if (parsed != null) {
              onChanged?.call(parsed);
            }
          }
        },
      ),
    );
  }
}

/// Custom formatter to add commas for thousands separator
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any existing commas
    final String cleanText = newValue.text.replaceAll(',', '');
    
    // Format with commas
    final formatter = NumberFormat('#,###');
    final String formatted = formatter.format(int.tryParse(cleanText) ?? 0);

    // Calculate new cursor position
    int cursorPosition = newValue.selection.end;
    final int oldCommaCount = oldValue.text.substring(0, oldValue.selection.end).split(',').length - 1;
    final int newCommaCount = formatted.substring(0, cursorPosition + (formatted.length - cleanText.length)).split(',').length - 1;
    cursorPosition += newCommaCount - oldCommaCount;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: cursorPosition.clamp(0, formatted.length),
      ),
    );
  }
}


// Authored by: Moazzam Samoo
