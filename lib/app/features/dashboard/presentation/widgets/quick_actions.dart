import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';

class QuickActionButton {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });
}

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    final actions = [
      QuickActionButton(
        label: 'New Sale',
        icon: LucideIcons.shoppingCart,
        color: const Color(0xFF10B981),
        onTap: () => Get.offNamed('/sales'),
      ),
      QuickActionButton(
        label: 'Add Bike',
        icon: LucideIcons.plusCircle,
        color: primaryColor,
        onTap: () => Get.offNamed('/procurement'),
      ),
      QuickActionButton(
        label: 'Record Payment',
        icon: LucideIcons.wallet,
        color: const Color(0xFFF59E0B),
        onTap: () => Get.offNamed('/installments'),
      ),
      QuickActionButton(
        label: 'Add Expense',
        icon: LucideIcons.receipt,
        color: const Color(0xFFEF4444),
        onTap: () => Get.offNamed('/reports'),
      ),
      QuickActionButton(
        label: 'Customers',
        icon: LucideIcons.users,
        color: const Color(0xFF8B5CF6),
        onTap: () => Get.offNamed('/customers'),
      ),
      QuickActionButton(
        label: 'Installments',
        icon: LucideIcons.landmark,
        color: const Color(0xFF06B6D4),
        onTap: () => Get.offNamed('/installments'),
      ),
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _QuickActionCard(action: action, isDark: isDark),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final QuickActionButton action;
  final bool isDark;

  const _QuickActionCard({required this.action, required this.isDark});

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.action.color ?? AppColors.darkPrimary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.action.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? color.withOpacity(0.15)
                : (widget.isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _isHovered
                  ? color.withOpacity(0.5)
                  : (widget.isDark ? AppColors.darkBorder : Colors.grey.shade300),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered ? [
              BoxShadow(
                color: color.withOpacity(widget.isDark ? 0.4 : 0.25),
                blurRadius: widget.isDark ? 25 : 20,
                spreadRadius: widget.isDark ? 2 : 1,
                offset: const Offset(0, 8),
              ),
            ] : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.action.icon,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.action.label,
                style: TextStyle(
                  color: widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
