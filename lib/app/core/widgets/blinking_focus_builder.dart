import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BlinkingFocusBuilder extends StatelessWidget {
  final FocusNode focusNode;
  final Widget child;
  final BorderRadius? borderRadius;
  final Color? activeColor;

  const BlinkingFocusBuilder({
    super.key,
    required this.focusNode,
    required this.child,
    this.borderRadius,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
