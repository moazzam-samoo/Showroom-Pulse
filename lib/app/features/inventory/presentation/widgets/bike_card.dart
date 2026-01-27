import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/widgets/status_badge.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';

/// Bike Card Widget for Inventory Grid
/// 
/// Analyzed from: Dark Theme UI/Inventory Page.png
/// Layout:
/// - Bike image (hero style)
/// - Model Name label
/// - Engine No label
/// - Status badge (Available, Sold, Pending)
class BikeCard extends StatelessWidget {
  final Bike bike;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BikeCard({
    super.key,
    required this.bike,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bike Image
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(isDark, primaryColor),
                  // Actions overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        if (onEdit != null)
                          _buildActionButton(
                            icon: LucideIcons.pencil,
                            onTap: onEdit!,
                            isDark: isDark,
                          ),
                        if (onDelete != null) ...[
                          const SizedBox(width: 4),
                          _buildActionButton(
                            icon: LucideIcons.trash2,
                            onTap: onDelete!,
                            isDark: isDark,
                            isDestructive: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Model Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Model Name:',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          bike.model,
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // Engine No + Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Engine No.',
                                style: TextStyle(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                bike.engineNumber,
                                style: TextStyle(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(
                          status: _mapStatus(bike.status),
                          isCompact: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BikeStatus _mapStatus(BikeStatusEnum status) {
    switch (status) {
      case BikeStatusEnum.available:
        return BikeStatus.available;
      case BikeStatusEnum.sold:
        return BikeStatus.sold;
      case BikeStatusEnum.installment:
        return BikeStatus.pending;
    }
  }

  Widget _buildImage(bool isDark, Color primaryColor) {
    if (bike.imageFilename != null && bike.imageFilename!.isNotEmpty) {
      // Check if file exists
      final file = File(bike.imageFilename!);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(isDark, primaryColor);
          },
        );
      }
    }
    return _buildPlaceholder(isDark, primaryColor);
  }

  Widget _buildPlaceholder(bool isDark, Color primaryColor) {
    return Container(
      color: isDark ? AppColors.darkElevated : Colors.grey.shade100,
      child: Center(
        child: Icon(
          LucideIcons.bike,
          size: 48,
          color: primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.darkSurface : Colors.white).withOpacity(0.9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 14,
          color: isDestructive 
              ? (isDark ? AppColors.darkError : AppColors.lightError)
              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
      ),
    );
  }
}

// Authored by: Moazzam Samoo
