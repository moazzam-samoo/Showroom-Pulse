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
  final String? selectedCondition;
  final String? selectedColor;
  final String? selectedSkin;
  final double? minPrice;
  final double? maxPrice;
  final ValueChanged<String?>? onBrandChanged;
  final ValueChanged<String?>? onCCChanged;
  final ValueChanged<String?>? onStatusChanged;
  final ValueChanged<String?>? onConditionChanged;
  final ValueChanged<String?>? onColorChanged;
  final ValueChanged<String?>? onSkinChanged;
  final ValueChanged<double?>? onMinPriceChanged;
  final ValueChanged<double?>? onMaxPriceChanged;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onClearFilters;
  final VoidCallback? onAddBike;

  const BikeFilterBar({
    super.key,
    required this.searchController,
    this.selectedBrand,
    this.selectedCC,
    this.selectedStatus,
    this.selectedCondition,
    this.selectedColor,
    this.selectedSkin,
    this.minPrice,
    this.maxPrice,
    this.onBrandChanged,
    this.onCCChanged,
    this.onStatusChanged,
    this.onConditionChanged,
    this.onColorChanged,
    this.onSkinChanged,
    this.onMinPriceChanged,
    this.onMaxPriceChanged,
    this.onSearchChanged,
    this.onClearFilters,
    this.onAddBike,
  });

  // Sample data
  static const List<String> brands = ['Honda', 'Suzuki', 'Yamaha', 'Road Prince', 'United'];
  static const List<String> engineCCs = ['70cc', '100cc', '110cc', '125cc', '150cc'];
  static const List<String> statuses = ['Available', 'Sold', 'Pending'];
  static const List<String> conditions = ['New', 'Used'];
  static const List<String> colors = [
    'Red', 'Black', 'Blue', 'Silver', 'White', 'Grey', 'Green',
    'Yellow', 'Orange', 'Purple', 'Maroon',
  ];
  static const List<String> skins = [
    'Lion Skin', 'Zebra Skin', 'Cheetah Skin',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Row: High-level Search and Actions
        Row(
          children: [
            // Search Bar
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface.withOpacity(0.5) : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      LucideIcons.search,
                      size: 20,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by model, engine, chassis...',
                          hintStyle: TextStyle(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          suffixIcon: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: searchController,
                            builder: (context, value, child) {
                              if (value.text.isNotEmpty) {
                                return IconButton(
                                  icon: const Icon(LucideIcons.x, size: 16),
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  onPressed: () {
                                    searchController.clear();
                                    if (onSearchChanged != null) {
                                      onSearchChanged!('');
                                    }
                                  },
                                  tooltip: 'Clear Search',
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Clear Filters Button
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(LucideIcons.filterX, size: 18),
                label: const Text(
                  'Clear Filters',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.redAccent.shade200 : Colors.redAccent,
                  side: BorderSide(
                    color: (isDark ? Colors.redAccent.shade200 : Colors.redAccent).withOpacity(0.5)
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Add Bike Button
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onAddBike,
                icon: const Icon(LucideIcons.plus, size: 18),
                label: const Text(
                  'Add Bike',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Bottom Row: Specific Filters
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildDropdown(
                value: selectedBrand,
                hint: 'Brand',
                items: brands,
                onChanged: onBrandChanged,
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildDropdown(
                value: selectedCC,
                hint: 'Engine CC',
                items: engineCCs,
                onChanged: onCCChanged,
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildDropdown(
                value: selectedStatus,
                hint: 'Status',
                items: statuses,
                onChanged: onStatusChanged,
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildDropdown(
                value: selectedCondition,
                hint: 'Condition',
                items: conditions,
                onChanged: onConditionChanged,
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildDropdown(
                value: selectedColor,
                hint: 'Color',
                items: colors,
                onChanged: onColorChanged,
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildDropdown(
                value: selectedSkin,
                hint: 'Skin/Pattern',
                items: skins,
                onChanged: onSkinChanged,
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
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
            ],
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
    // Determine active state to apply primary color hue
    final bool isActive = value != null;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isActive 
            ? (isDark ? AppColors.darkPrimary.withOpacity(0.15) : AppColors.lightPrimary.withOpacity(0.1))
            : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
        borderRadius: BorderRadius.circular(AppRadius.full), // Pill shape for modern look
        border: Border.all(
          color: isActive
              ? (isDark ? AppColors.darkPrimary.withOpacity(0.5) : AppColors.lightPrimary.withOpacity(0.5))
              : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
          width: isActive ? 1.5 : 1.0,
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
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Icon(
              LucideIcons.chevronDown,
              size: 14,
              color: isActive 
                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            ),
          ),
          dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
          focusColor: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
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
                  fontWeight: value == item ? FontWeight.w600 : FontWeight.normal,
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
    final bool isActive = value != null;

    return Container(
      width: 120, // Slightly wider to hold large numbers clearly
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isActive 
            ? (isDark ? AppColors.darkPrimary.withOpacity(0.15) : AppColors.lightPrimary.withOpacity(0.1))
            : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: isActive
              ? (isDark ? AppColors.darkPrimary.withOpacity(0.5) : AppColors.lightPrimary.withOpacity(0.5))
              : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Center(
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _ThousandsSeparatorInputFormatter(),
          ],
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
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
