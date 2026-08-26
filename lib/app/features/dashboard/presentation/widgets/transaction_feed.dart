import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';

/// Transaction Model for Live Feed
class Transaction {
  final String id;
  final String assetModel;
  final String? vin;
  final String stakeholder;
  final String stakeholderContact;
  final String reference;
  final String referenceDate;
  final String value;
  final String valueType;
  final String status;

  const Transaction({
    required this.id,
    required this.assetModel,
    this.vin,
    required this.stakeholder,
    required this.stakeholderContact,
    required this.reference,
    required this.referenceDate,
    required this.value,
    required this.valueType,
    required this.status,
  });
}

/// Live Transaction Feed Widget
/// 
/// Analyzed from: Dark Theme UI/Dashboard Page.png
/// - Table layout with 5 columns
/// - Status badges (Completed, Pending, etc.)
/// - Filter by status
class LiveTransactionFeed extends StatelessWidget {
  final List<Transaction> transactions;
  final String? statusFilter;
  final ValueChanged<String?>? onFilterChanged;

  const LiveTransactionFeed({
    super.key,
    this.transactions = const [],
    this.statusFilter,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.activity,
                    size: 16,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Live Transaction Feed',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildFilterButton('ALL STATUS', statusFilter == null, isDark, () {
                    onFilterChanged?.call(null);
                  }),
                  const SizedBox(width: 8),
                  Icon(
                    LucideIcons.filter,
                    size: 16,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'ASSET / MODEL',
                    style: _headerTextStyle(isDark),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'STAKEHOLDER',
                    style: _headerTextStyle(isDark),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'REFERENCE',
                    style: _headerTextStyle(isDark),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'VALUE',
                    style: _headerTextStyle(isDark),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'STATUS',
                    style: _headerTextStyle(isDark),
                  ),
                ),
                const SizedBox(width: 40), // Action column
              ],
            ),
          ),
          // Table Body
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.inbox,
                          size: 48,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No transactions found',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionRow(transactions[index], isDark, primaryColor);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerTextStyle(bool isDark) {
    return TextStyle(
      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  Widget _buildFilterButton(String text, bool isActive, bool isDark, VoidCallback onTap) {
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isActive ? null : Border.all(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive 
                ? Colors.white 
                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionRow(Transaction transaction, bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade100,
          ),
        ),
      ),
      child: Row(
        children: [
          // Asset / Model
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    LucideIcons.bike,
                    size: 18,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.assetModel,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (transaction.vin != null)
                        Text(
                          'VIN: ${transaction.vin}',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Stakeholder
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.stakeholder,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  transaction.stakeholderContact,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Reference
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.reference,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  transaction.referenceDate,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Value
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.value,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  transaction.valueType,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Status
          Expanded(
            flex: 1,
            child: _buildStatusBadge(transaction.status, isDark),
          ),
          // Action
          SizedBox(
            width: 40,
            child: IconButton(
              icon: Icon(
                LucideIcons.moreHorizontal,
                size: 16,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              onPressed: () {
                // TODO: Show action menu
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color bgColor;
    Color textColor;
    
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        bgColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green;
        break;
      case 'PENDING':
        bgColor = Colors.amber.withOpacity(0.15);
        textColor = Colors.amber;
        break;
      case 'CANCELLED':
      case 'FAILED':
        bgColor = Colors.red.withOpacity(0.15);
        textColor = Colors.red;
        break;
      default:
        bgColor = isDark ? AppColors.darkElevated : Colors.grey.shade100;
        textColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Authored by: Moazzam Samoo
