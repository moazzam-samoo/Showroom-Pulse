import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';

// Intents
class SubmitIntent extends Intent {
  const SubmitIntent();
}

class CancelIntent extends Intent {
  const CancelIntent();
}

/// AppDialog
/// 
/// A standardized Dialog wrapper that provides:
/// - Consistent width (800px) and padding
/// - Themed background and colors
/// - Keyboard Shortcuts:
///   - ESC -> Close
///   - ENTER -> Primary Action (Submit)
class AppDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel; // Explicit cancel action, defaults to pop
  final List<Widget>? actions;
  final double width;

  const AppDialog({
    super.key,
    required this.title,
    this.subtitle = 'AL-AL-TAHIR Showroom Management',
    required this.child,
    this.onSubmit,
    this.onCancel,
    this.actions,
    this.width = 800,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme Colors
    final dialogBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final subtitleColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final closeIconColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Dialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
            if (onCancel != null) {
              onCancel!();
            } else {
              Navigator.of(context).pop();
            }
          }
        },
        child: Container(
          width: width,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.bike, color: primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            title,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    tooltip: 'Close (Esc)',
                    icon: Icon(Icons.close, color: closeIconColor),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Content
              Flexible(
                child: SingleChildScrollView(
                  child: child,
                ),
              ),

              if (actions != null) ...[
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
