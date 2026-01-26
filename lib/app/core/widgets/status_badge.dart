import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_colors.dart';

/// Status Badge for displaying availability status
/// 
/// Statuses: available, sold, pending (installment)
enum BikeStatus { available, sold, pending }

class StatusBadge extends StatelessWidget {
  final BikeStatus status;
  final bool isCompact;

  const StatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          color: _getTextColor(),
          fontSize: isCompact ? 10 : 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getLabel() {
    switch (status) {
      case BikeStatus.available:
        return 'Available';
      case BikeStatus.sold:
        return 'Sold';
      case BikeStatus.pending:
        return 'Pending';
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case BikeStatus.available:
        return AppColors.badgeAvailableBg;
      case BikeStatus.sold:
        return AppColors.badgeSoldBg;
      case BikeStatus.pending:
        return AppColors.badgePendingBg;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case BikeStatus.available:
        return AppColors.badgeAvailableText;
      case BikeStatus.sold:
        return AppColors.badgeSoldText;
      case BikeStatus.pending:
        return AppColors.badgePendingText;
    }
  }
}

// Authored by: Moazzam Samoo
