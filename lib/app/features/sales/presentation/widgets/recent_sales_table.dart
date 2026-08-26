import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tahir_showroom/app/core/widgets/app_notification_dialog.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/sales/domain/sales_service.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sale_card.dart';

class RecentSalesTable extends StatefulWidget {
  const RecentSalesTable({super.key});

  @override
  State<RecentSalesTable> createState() => _RecentSalesTableState();
}

class _RecentSalesTableState extends State<RecentSalesTable> {
  final SalesService _salesService = SalesService();
  List<SaleCardData> _recentSales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentSales();
  }

  Future<void> _loadRecentSales() async {
    try {
      final sales = await _salesService.getRecentSales(5);
      
      // Sort: Date Descending -> Price Descending
      sales.sort((a, b) {
        final dateA = _parseDate(a.saleDate);
        final dateB = _parseDate(b.saleDate);
        final dateComparison = dateB.compareTo(dateA);
        
        if (dateComparison == 0) {
          // Secondary Sort: Price Descending
          // Use sellingPrice (Installment) or amountPaid/bikePrice (Cash)
          final priceA = a.sellingPrice ?? a.bikePrice ?? a.amountPaid;
          final priceB = b.sellingPrice ?? b.bikePrice ?? b.amountPaid;
          return priceB.compareTo(priceA);
        }
        return dateComparison;
      });

      setState(() {
        _recentSales = sales;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppNotificationDialog.showError(
        title: 'Error',
        message: 'Failed to load recent sales: $e',
      );
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _loadRecentSales,
                    icon: const Icon(LucideIcons.refreshCw, size: 16),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Table Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  _headerCell('Date', 2),
                  _headerCell('Customer', 3),
                  _headerCell('Bike', 3),
                  _headerCell('Type', 2),
                  _headerCell('Amount', 2),
                  _headerCell('Status', 2),
                ],
              ),
            ),
            const Divider(height: 1),
            // List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _recentSales.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.inbox,
                                size: 48,
                                color: isDark ? Colors.white24 : Colors.black26,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No recent sales',
                                style: TextStyle(
                                  color: isDark ? Colors.white54 : Colors.black45,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          itemCount: _recentSales.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return _buildRow(context, _recentSales[index], isDark)
                                .animate(delay: (50 * index).ms)
                                .fadeIn(duration: 300.ms)
                                .slideX(begin: 0.05, end: 0, curve: Curves.easeOut);
                          },
                        ),
            ),
          ],
        ),
    );
  }

  Widget _headerCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, SaleCardData sale, bool isDark) {
    // Extract initials from customer name
    String getInitials(String name) {
      final cleanName = name.trim();
      if (cleanName.isEmpty) return 'NA';
      
      final parts = cleanName.split(RegExp(r'\s+'));
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      
      return cleanName.substring(0, cleanName.length >= 2 ? 2 : 1).toUpperCase();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              sale.saleDate,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    getInitials(sale.customerName),
                    style: const TextStyle(fontSize: 10, color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    sale.customerName,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              sale.bikeModel,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: sale.isCash
                      ? Colors.green.withOpacity(0.1)
                      : Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full), // Pill shape
                  border: Border.all(
                    color: sale.isCash
                        ? Colors.green.withOpacity(0.2)
                        : Colors.purple.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  sale.isCash ? 'Cash' : 'Installment',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: sale.isCash ? Colors.green : Colors.purple,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Rs ${sale.amountPaid.toStringAsFixed(0)}',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Completed',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
