import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tahir_showroom/app/core/widgets/app_showroom_logo.dart';

/// Sidebar Navigation Widget
/// 
/// Analyzed from: Dark Theme UI/Dashboard Page.png
/// - Collapsed sidebar (64px width)
/// - Icon-only navigation
/// - Active state with cyan glow (Dark) / light blue (Light)
class SidebarNavigation extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    this.onItemSelected,
  });

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  final List<FocusNode> _focusNodes = List.generate(10, (_) => FocusNode());
  final FocusScopeNode _scopeNode = FocusScopeNode();

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    _scopeNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return FocusScope(
      node: _scopeNode,
      child: Focus(
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.tab) {
            final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
            final currentFocus = _scopeNode.focusedChild;
            
            if (currentFocus != null) {
              final currentIndex = _focusNodes.indexOf(currentFocus);
              
              if (currentIndex == _focusNodes.length - 1 && !isShiftPressed) {
                // Loop to first from last
                _focusNodes[0].requestFocus();
                return KeyEventResult.handled;
              } else if (currentIndex == 0 && isShiftPressed) {
                // Loop to last from first
                _focusNodes[_focusNodes.length - 1].requestFocus();
                return KeyEventResult.handled;
              }
            }
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          width: 64,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            border: Border(
              right: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.base),
              // Logo
              _buildLogo(isDark),
              const SizedBox(height: AppSpacing.md),
              // Navigation Items
              Expanded(
                child: Column(
                  children: [
                    _buildNavItem(0, LucideIcons.layoutDashboard, 'Dashboard', isDark),
                    _buildNavItem(1, LucideIcons.truck, 'Dealers', isDark),
                    _buildNavItem(2, LucideIcons.bike, 'Inventory', isDark),
                    _buildNavItem(3, LucideIcons.shoppingCart, 'Sales', isDark),
                    _buildNavItem(4, LucideIcons.wallet, 'Installments', isDark),
                    _buildNavItem(5, LucideIcons.users, 'Customers', isDark),
                    _buildNavItem(6, LucideIcons.barChart3, 'Reports', isDark),
                    _buildNavItem(7, LucideIcons.piggyBank, 'Investment', isDark),
                  ],
                ),
              ),
              // Bottom Items
              _buildNavItem(8, LucideIcons.settings, 'Settings', isDark),
              const SizedBox(height: AppSpacing.sm),
              _buildNavItem(9, LucideIcons.logOut, 'Logout', isDark, isLogout: true),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSelectedIcon(int index) {
    switch (index) {
      case 0:
        return LucideIcons.layoutDashboard;
      case 1:
        return LucideIcons.truck;
      case 2:
        return LucideIcons.bike;
      case 3:
        return LucideIcons.shoppingCart;
      case 4:
        return LucideIcons.wallet;
      case 5:
        return LucideIcons.users;
      case 6:
        return LucideIcons.barChart3;
      case 7:
        return LucideIcons.settings;
      default:
        return LucideIcons.bike;
    }
  }

  Widget _buildLogo(bool isDark) {
    return const AppShowroomLogo(
      size: 44,
      borderRadius: 10,
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String tooltip,
    bool isDark, {
    bool isLogout = false,
  }) {
    final isSelected = widget.selectedIndex == index && !isLogout;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    
    final isFocused = _focusNodes[index].hasFocus;
    final showIndicator = isSelected || isFocused;
    
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: InkWell(
        focusNode: _focusNodes[index],
        autofocus: isSelected,
        onFocusChange: (hasFocus) {
          setState(() {}); // Rebuild to show focus indicator
        },
        onTap: () {
          if (isLogout) {
            _handleLogout();
          } else if (widget.onItemSelected != null) {
            widget.onItemSelected!(index);
          } else {
            _handleNavigation(index);
          }
        },
        // Visual focus indicator
        focusColor: primaryColor.withOpacity(0.12),
        hoverColor: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: showIndicator
                ? (isDark
                    ? primaryColor.withOpacity(0.15)
                    : AppColors.lightPrimaryLight)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: showIndicator
                ? Border.all(
                    color: primaryColor.withOpacity(isFocused ? 0.6 : 0.3),
                    width: isFocused ? 2 : 1,
                  )
                : null,
            boxShadow: isFocused ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              )
            ] : null,
          ),
          child: Icon(
            icon,
            size: 20,
            color: showIndicator
                ? primaryColor
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  void _handleLogout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      Get.offAllNamed('/login');
    }
  }

  void _handleNavigation(int index) {
    if (index == widget.selectedIndex) return;
    
    switch (index) {
      case 0:
        Get.offNamed('/dashboard');
        break;
      case 1:
        Get.offNamed('/procurement');
        break;
      case 2:
        Get.offNamed('/inventory');
        break;
      case 3:
        Get.offNamed('/sales');
        break;
      case 4:
        Get.offNamed('/installments');
        break;
      case 5:
        Get.offNamed('/customers');
        break;
      case 6:
        Get.offNamed('/reports');
        break;
      case 7:
        Get.offNamed('/investment');
        break;
      case 8:
        Get.offNamed('/settings');
        break;
    }
  }
}

// Authored by: Moazzam Samoo
