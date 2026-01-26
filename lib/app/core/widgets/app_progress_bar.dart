import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_colors.dart';

/// Progress Bar for displaying payment progress
class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ?? 
        (isDark ? AppColors.darkElevated : AppColors.lightBorder);
    final fgColor = progressColor ?? 
        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: fgColor,
              ),
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                      height: height,
                      decoration: BoxDecoration(
                        color: fgColor,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Authored by: Moazzam Samoo
