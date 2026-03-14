import 'package:flutter/material.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'coach_mark_target.dart';

class CoachMarkOverlay extends StatefulWidget {
  final List<CoachMarkTarget> targets;
  final VoidCallback onComplete;

  const CoachMarkOverlay({
    super.key,
    required this.targets,
    required this.onComplete,
  });

  @override
  State<CoachMarkOverlay> createState() => _CoachMarkOverlayState();
}

class _CoachMarkOverlayState extends State<CoachMarkOverlay> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    
    // Defer the initial measurement to allow layout to settle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTargetRect();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _calculateTargetRect() async {
    if (_currentIndex >= widget.targets.length) return;
    
    final target = widget.targets[_currentIndex];

    // If there is an action to perform before showing the target (e.g. switching tabs)
    if (target.onBeforeTarget != null) {
      await target.onBeforeTarget!();
      // Wait a moment for UI to rebuild and settle
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 400));
    }

    if (!mounted) return;

    final context = target.targetKey.currentContext;
    
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      setState(() {
        _targetRect = position & box.size;
      });
      _controller.forward(from: 0.0);
    } else {
      // If target not found (e.g., scrolled off screen), just skip to next
      _nextTarget();
    }
  }

  void _nextTarget() {
    if (_currentIndex < widget.targets.length - 1) {
      setState(() {
        _currentIndex++;
        _targetRect = null; // Hide temporarily while measuring
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateTargetRect();
      });
    } else {
      widget.onComplete();
    }
  }

  void _skip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    if (_targetRect == null) {
      return const SizedBox.shrink(); // Wait for measurement
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final target = widget.targets[_currentIndex];

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Semi-transparent backdrop with cutout
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _OverlayPainter(
                  targetRect: _targetRect!,
                  progress: _animation.value,
                ),
              );
            },
          ),
          
          // Tooltip Position Logic
          ..._buildTooltip(target, _targetRect!, isDark),
        ],
      ),
    );
  }

  List<Widget> _buildTooltip(CoachMarkTarget target, Rect rect, bool isDark) {
    // Determine positioning based on target.position
    double? top, bottom, left, right;
    
    const spacing = 20.0;
    
    switch (target.position) {
      case CoachMarkPosition.bottom:
        top = rect.bottom + spacing;
        left = rect.center.dx - 150; // Center tooltip horizonally (300 width / 2)
        break;
      case CoachMarkPosition.top:
        bottom = (MediaQuery.of(context).size.height - rect.top) + spacing;
        left = rect.center.dx - 150;
        break;
      case CoachMarkPosition.right:
        left = rect.right + spacing;
        top = rect.center.dy - 60; // Approximate vertical centering
        break;
      case CoachMarkPosition.left:
        right = (MediaQuery.of(context).size.width - rect.left) + spacing;
        top = rect.center.dy - 60;
        break;
    }
    
    // Viewport constraints (basic)
    if (left != null && left < 16) left = 16;
    if (right != null && right < 16) right = 16;
    final screenWidth = MediaQuery.of(context).size.width;
    if (left != null && left + 300 > screenWidth - 16) left = screenWidth - 316;

    return [
      Positioned(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkElevated : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        target.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '${_currentIndex + 1} of ${widget.targets.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  target.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _skip,
                      style: TextButton.styleFrom(
                        foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      child: const Text('Skip Tour'),
                    ),
                    ElevatedButton(
                      onPressed: _nextTarget,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(_currentIndex == widget.targets.length - 1 ? 'Done' : 'Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect targetRect;
  final double progress;

  _OverlayPainter({
    required this.targetRect,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7 * progress)
      ..style = PaintingStyle.fill;

    // Create a path that covers the whole screen except the target rect
    final screenPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Add some padding to the cutout and round the corners
    final cutoutRect = targetRect.inflate(8.0);
    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cutoutRect, const Radius.circular(8.0)));

    final finalPath = Path.combine(PathOperation.difference, screenPath, cutoutPath);

    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect || oldDelegate.progress != progress;
  }
}
