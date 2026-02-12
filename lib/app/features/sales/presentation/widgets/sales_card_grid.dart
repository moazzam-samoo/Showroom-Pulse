import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sale_card.dart';

class SalesCardGrid extends StatelessWidget {
  const SalesCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalesController>();

    return Obx(() {
        // Show loading indicator while fetching data
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Use real sales data from controller
        // Use filtered sales data from controller
        final filteredSales = List<SaleCardData>.from(controller.filteredSales);

        // Sort Data by Date Descending
        filteredSales.sort((a, b) {
           final dateA = _parseDate(a.saleDate);
           final dateB = _parseDate(b.saleDate);
           return dateB.compareTo(dateA);
        });
        
        // Filter by Status
        final status = controller.selectedStatus.value;
        
        var cashSales = filteredSales.where((s) => s.isCash).toList();
        var installmentSales = filteredSales.where((s) => !s.isCash).toList();
        
        // Sort each list by date first, then by price within same date
        cashSales.sort((a, b) {
          final dateA = _parseDate(a.saleDate);
          final dateB = _parseDate(b.saleDate);
          final dateComparison = dateB.compareTo(dateA);
          
          if (dateComparison == 0) {
            // For cash sales, use bikePrice (which is sale.totalAmount for cash)
            // Fall back to amountPaid if bikePrice is null
            final priceA = a.bikePrice ?? a.amountPaid;
            final priceB = b.bikePrice ?? b.amountPaid;
            return priceB.compareTo(priceA);
          }
          
          return dateComparison;
        });
        
        installmentSales.sort((a, b) {
          final dateA = _parseDate(a.saleDate);
          final dateB = _parseDate(b.saleDate);
          final dateComparison = dateB.compareTo(dateA);
          
          if (dateComparison == 0) {
            // For installment sales, use sellingPrice (contract.totalAmount)
            // Fall back to bikePrice if sellingPrice is null
            final priceA = a.sellingPrice ?? a.bikePrice ?? a.amountPaid;
            final priceB = b.sellingPrice ?? b.bikePrice ?? b.amountPaid;
            return priceB.compareTo(priceA);
          }
          
          return dateComparison;
        });
        
        final isDark = Theme.of(context).brightness == Brightness.dark;

        // If filtering by specific status, we show full width
        // If All Status, we show split view
        if (status == 'All Status') {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cash Sales Column
              Expanded(
                child: Column(
                  children: [
                    _buildColumnHeader('Cash Sales', const Color(0xFFEF4444), isDark),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: _buildGroupedList(cashSales, isDark, crossAxisCount: 2),
                    ),
                  ],
                ),
              ),

              // Center Divider
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300,
              ),

              // Installment Sales Column
              Expanded(
                child: Column(
                  children: [
                    _buildColumnHeader('Installment Sales', const Color(0xFFF59E0B), isDark),
                     const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: _buildGroupedList(installmentSales, isDark, crossAxisCount: 2),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          // Single Column View (Full Width)
          final salesToShow = status == 'Cash' ? cashSales : installmentSales;
          final color = status == 'Cash' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);
          
          return Column(
             children: [
                _buildColumnHeader('$status Sales', color, isDark),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: _buildGroupedList(salesToShow, isDark, crossAxisCount: 4),
                ),
             ],
          );
        }
      });
  }

  Widget _buildColumnHeader(String title, Color color, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGroupedList(List<SaleCardData> salesList, bool isDark, {required int crossAxisCount}) {
    // Grouping Logic
    final Map<String, List<SaleCardData>> groupedSales = {};
    for (var sale in salesList) {
      final parts = sale.saleDate.split('/');
      if (parts.length == 3) {
        final monthKey = _getMonthName(int.parse(parts[1])) + ' ' + parts[2];
        if (groupedSales[monthKey] == null) {
          groupedSales[monthKey] = [];
        }
        groupedSales[monthKey]!.add(sale);
      }
    }

    if (groupedSales.isEmpty) {
      return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.inbox_outlined, size: 48, color: isDark ? Colors.white24 : Colors.black26),
             const SizedBox(height: 16),
             Text(
               "No sales found",
               style: TextStyle(
                 color: isDark ? Colors.white54 : Colors.black45,
                 fontSize: 16,
               ),
             ),
           ],
         ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      itemCount: groupedSales.keys.length,
      itemBuilder: (context, index) {
        final month = groupedSales.keys.elementAt(index);
        final monthSales = groupedSales[month]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Divider(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
            ),

            // Masonry Grid
            MasonryGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount, 
              mainAxisSpacing: AppSpacing.lg,
              crossAxisSpacing: AppSpacing.lg,
              itemCount: monthSales.length,
              itemBuilder: (context, idx) {
                return SaleCard(data: monthSales[idx])
                  .animate(delay: (50 * idx).ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
              },
            ),
             const SizedBox(height: AppSpacing.sm),
          ],
        );
      },
    );
  }

  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        // DD/MM/YYYY -> YYYY-MM-DD
        return DateTime(
          int.parse(parts[2]), 
          int.parse(parts[1]), 
          int.parse(parts[0])
        );
      }
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return 'Unknown';
  }
}
