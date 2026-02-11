import 'package:flutter/material.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/data/models/installment_contract.dart';

/// Circular progress ring showing payment progress
class ProgressRing extends StatelessWidget {
  final int paymentsMade;
  final int totalMonths;
  final double size;

  const ProgressRing({
    super.key,
    required this.paymentsMade,
    required this.totalMonths,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final progress = totalMonths > 0 ? paymentsMade / totalMonths : 0.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 4,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$paymentsMade/$totalMonths',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'months',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: size * 0.15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Status badge for contract status
class StatusBadge extends StatelessWidget {
  final ContractStatusEnum status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case ContractStatusEnum.active:
        backgroundColor = (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.15);
        textColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
        text = 'Active';
        break;
      case ContractStatusEnum.partiallyPaid:
        backgroundColor = (isDark ? AppColors.darkInfo : AppColors.lightPrimary).withOpacity(0.15);
        textColor = isDark ? AppColors.darkInfo : AppColors.lightPrimary;
        text = 'Partial';
        break;
      case ContractStatusEnum.overdue:
        backgroundColor = (isDark ? AppColors.darkWarning : AppColors.lightWarning).withOpacity(0.15);
        textColor = isDark ? AppColors.darkWarning : AppColors.lightWarning;
        text = 'Overdue';
        break;
      case ContractStatusEnum.completed:
        backgroundColor = (isDark ? AppColors.darkSuccess : AppColors.lightSuccess).withOpacity(0.15);
        textColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
        text = 'Completed';
        break;
      case ContractStatusEnum.defaulted:
        backgroundColor = (isDark ? AppColors.darkError : AppColors.lightError).withOpacity(0.15);
        textColor = isDark ? AppColors.darkError : AppColors.lightError;
        text = 'Defaulted';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Authored by: Moazzam Samoo
