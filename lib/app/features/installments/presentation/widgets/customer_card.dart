import 'package:flutter/material.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/installments/presentation/controllers/installments_controller.dart';
import 'package:tahir_showroom/app/features/installments/presentation/widgets/progress_ring.dart';

/// Customer card for the installments list
/// Shows customer info, progress ring, and status badge
class CustomerCard extends StatelessWidget {
  final ContractDisplayData data;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomerCard({
    super.key,
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Avatar, Name, Status
            Row(
              children: [
                // Avatar with initials
                _buildAvatar(isDark, primaryColor),
                const SizedBox(width: AppSpacing.sm),
                // Name and CNIC
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.customer.fullName,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'CNIC: ${data.customer.cnicNumber}',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Status Badge
                StatusBadge(status: data.contract.status),
              ],
            ),
            const SizedBox(height: AppSpacing.base),
            // Progress Ring - Centered
            Center(
              child: ProgressRing(
                paymentsMade: data.contract.paymentsMade,
                totalMonths: data.contract.months,
                size: 70,
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            // Bike Model Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                data.bike.model,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isDark, Color primaryColor) {
    final initials = _getInitials(data.customer.fullName);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return '?';
    
    final parts = cleanName.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    
    return cleanName.substring(0, cleanName.length >= 2 ? 2 : 1).toUpperCase();
  }
}

// Authored by: Moazzam Samoo
