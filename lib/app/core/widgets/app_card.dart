import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_shadows.dart';
import '../constants/app_spacing.dart';

/// AppCard - Standard card component with theme support
/// 
/// Follows design system specifications for both Light and Dark themes
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? color;
  final VoidCallback? onTap;
  final bool hasShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.onTap,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = color ?? Theme.of(context).cardTheme.color;
    
    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
        border: isDark 
            ? Border.all(color: Theme.of(context).dividerColor)
            : null,
        boxShadow: hasShadow && !isDark ? AppShadows.sm : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.base),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: card,
        ),
      );
    }

    return card;
  }
}

// Authored by: Moazzam Samoo
