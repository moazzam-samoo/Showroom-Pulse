import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sale_card.dart';

class SalesCardGrid extends StatelessWidget {
  const SalesCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data simulating real Sales
    final List<SaleCardData> mockSales = [
      SaleCardData(
        bikeModel: 'Honda CG125 2024',
        bikeImage: 'assets/Placeholders/bike_placeholder.png', 
        customerName: 'Ali Khan',
        customerCnic: '35201-1234567-8',
        customerContact: '0300-1234567',
        saleDate: '24/10/2023',
        amountPaid: 280000,
        isCash: true,
      ),
      SaleCardData(
        bikeModel: 'United US70 2023',
        bikeImage: 'assets/Placeholders/bike_placeholder.png',
        customerName: 'Muhammad Hamza',
        customerCnic: '35201-9876543-1',
        customerContact: '0321-9876543',
        saleDate: '28/01/2026',
        amountPaid: 45000,
        amountRemaining: 85000,
        installmentDuration: 12,
        installmentMonthlyPayment: 7100,
        installmentDueDate: '10/02/2026',
        isCash: false,
      ),
      SaleCardData(
        bikeModel: 'Suzuki GS150 SE',
        bikeImage: 'assets/Placeholders/bike_placeholder.png',
        customerName: 'Bilal Ahmed',
        customerCnic: '35202-5555555-5',
        customerContact: '0333-5555555',
        saleDate: '29/01/2026',
        amountPaid: 365000,
        isCash: true,
      ),
       SaleCardData(
        bikeModel: 'Honda CD70 Dream',
        bikeImage: 'assets/Placeholders/bike_placeholder.png',
        customerName: 'Tahir Mehmood',
        customerCnic: '35201-1112223-4',
        customerContact: '0301-1112223',
        saleDate: '30/01/2026',
        amountPaid: 158000,
        isCash: true,
      ),
      SaleCardData(
        bikeModel: 'Road Prince 70',
        bikeImage: 'assets/Placeholders/bike_placeholder.png',
        customerName: 'Usman Ghani',
        customerCnic: '35201-7778889-0',
        customerContact: '0345-7778889',
        saleDate: '15/12/2025',
        amountPaid: 25000,
        amountRemaining: 95000,
        installmentDuration: 10,
        installmentMonthlyPayment: 9500,
        installmentDueDate: '15/01/2026',
        isCash: false,
      ),
    ];

    // 1. Sort Data by Date Descending
    mockSales.sort((a, b) {
       final dateA = _parseDate(a.saleDate);
       final dateB = _parseDate(b.saleDate);
       return dateB.compareTo(dateA);
    });

    final cashSales = mockSales.where((s) => s.isCash).toList();
    final installmentSales = mockSales.where((s) => !s.isCash).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cash Sales Column
          Expanded(
            child: Column(
              children: [
                _buildColumnHeader('Cash Sales', const Color(0xFF22C55E), isDark),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: _buildGroupedList(cashSales, isDark),
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
                _buildColumnHeader('Installment Sales', const Color(0xFFD946EF), isDark),
                 const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: _buildGroupedList(installmentSales, isDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildGroupedList(List<SaleCardData> salesList, bool isDark) {
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
              crossAxisCount: 2, // 2 column within the half-screen split = 4 total effectively? No, split screen is smaller. 2 cols is safe.
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
