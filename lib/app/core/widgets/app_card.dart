import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

/// AppCard - Standard card component with theme support
/// 
/// Follows design system specifications for both Light and Dark themes
class AppCard extends StatefulWidget {
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
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF00ACC1); // Cyan
    
    // Pro Max Aesthetic: Slate 800 for Dark, White for Light
    final defaultColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardColor = widget.color ?? defaultColor;

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: widget.margin,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? AppRadius.lg),
        border: isDark 
            ? (isHovered ? Border.all(color: primaryColor.withOpacity(0.5), width: 1.0) : Border.all(color: Colors.white.withOpacity(0.1), width: 1.0))
            : (isHovered ? Border.all(color: primaryColor.withOpacity(0.5), width: 1.0) : Border.all(color: Colors.black.withOpacity(0.05))),
        boxShadow: widget.hasShadow 
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              if (isHovered)
                BoxShadow(
                  color: primaryColor.withOpacity(isDark ? 0.4 : 0.25),
                  blurRadius: isDark ? 25 : 20,
                  spreadRadius: isDark ? 2 : 1,
                  offset: const Offset(0, 8),
                ),
            ]
          : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? AppRadius.lg),
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(AppSpacing.base),
          child: widget.child,
        ),
      ),
    );

    if (widget.onTap != null) {
      return MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: isHovered ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: card,
          ),
        ),
      );
    }

    return card;
  }
}

// Authored by: Moazzam Samoo
