import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';

/// Reusable Widget for Bike Images with stylized fallback
class AppBikeImage extends StatelessWidget {
  final String? imagePath;
  final double height;
  final double width;
  final double borderRadius;
  final double iconSize;
  final BoxFit fit;
  final Color? placeholderBg;
  final String? heroTag;

  const AppBikeImage({
    super.key,
    this.imagePath,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = AppRadius.lg,
    this.iconSize = 48,
    this.fit = BoxFit.cover,
    this.placeholderBg,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget imageWidget;
    
    if (imagePath == null || imagePath!.isEmpty) {
      imageWidget = _buildPlaceholder(isDark);
    } else {
      final file = File(imagePath!);
      if (file.existsSync()) {
        imageWidget = Image.file(
          file,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(isDark),
        );
      } else {
        imageWidget = _buildPlaceholder(isDark);
      }
    }

    if (heroTag != null) {
      imageWidget = Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: imageWidget,
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      width: width,
      height: height,
      color: placeholderBg ?? (isDark ? const Color(0xFF0F172A) : Colors.grey.shade200),
      child: Center(
        child: Icon(
          LucideIcons.bike,
          size: iconSize,
          color: isDark ? Colors.white12 : Colors.grey.shade400,
        ),
      ),
    );
  }
}
