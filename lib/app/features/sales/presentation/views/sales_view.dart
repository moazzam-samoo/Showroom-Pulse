import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/sales_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/views/new_sale_view.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sales_filter_bar.dart';
import 'package:tahir_showroom/app/features/sales/presentation/widgets/sales_card_grid.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_overlay.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_target.dart';

class SalesView extends StatefulWidget {
  const SalesView({super.key});

  @override
  State<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  // Coach mark keys
  final GlobalKey _newSaleBtnKey = GlobalKey();
  final GlobalKey _filterBarKey = GlobalKey();
  final GlobalKey _salesGridKey = GlobalKey();
  
  bool _showCoachMarks = false;

  @override
  void initState() {
    super.initState();
    _checkWalkthroughStatus();
  }

  Future<void> _checkWalkthroughStatus() async {
    final walkthroughService = Get.find<WalkthroughService>();
    if (!walkthroughService.hasCompletedTab('sales')) {
      // Delay slightly to ensure layout is built
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _showCoachMarks = true;
          });
        }
      });
    }
  }

  void _completeTour() {
    setState(() {
      _showCoachMarks = false;
    });
    Get.find<WalkthroughService>().markTabComplete('sales');
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we need to manually find the controller since it's no longer a GetView
    final SalesController controller = Get.find<SalesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          Get.offNamed('/dashboard');
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Stack(
          children: [
            Row(
              children: [
                // Sidebar
                SidebarNavigation(
                  selectedIndex: 3, // Sales Index
                  onItemSelected: (index) {
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
                        // Already on Sales
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
                        Get.offNamed('/settings');
                        break;
                    }
                  },
                ),
                
                // Main Content
                Expanded(
                  child: Column(
                    children: [
                       Expanded(
                         child: Scrollbar(
                           child: SingleChildScrollView(
                           padding: const EdgeInsets.all(AppSpacing.lg),
                           child: Column(
                             children: [
                               // Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Sales Management',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Manage invoices, payments, and installment contracts',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    key: _newSaleBtnKey,
                                    onPressed: () {
                                      Get.toNamed('/sales/new');
                                    },
                                    icon: const Icon(LucideIcons.plusCircle, size: 20),
                                    label: const Text('New Sale'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppRadius.md),
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xl),

                              // Filters
                              Container(
                                key: _filterBarKey,
                                child: const SalesFilterBar(),
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              const SizedBox(height: AppSpacing.lg),

                              // Sales Grid
                              SizedBox(
                                key: _salesGridKey,
                                height: MediaQuery.of(context).size.height - 250, // Approximate remaining height
                                child: const SalesCardGrid(),
                              ),
                             ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Coach Marks Overlay
            if (_showCoachMarks)
              Positioned.fill(
                child: CoachMarkOverlay(
                  targets: [
                    CoachMarkTarget(
                      targetKey: _newSaleBtnKey,
                      title: 'Create New Sale',
                      description: 'Start a cash or installment sale in just a few steps.',
                      position: CoachMarkPosition.bottom,
                    ),
                    CoachMarkTarget(
                      targetKey: _filterBarKey,
                      title: 'Filters & Search',
                      description: 'Filter sales by date, type, or customer name.',
                      position: CoachMarkPosition.bottom,
                    ),
                    CoachMarkTarget(
                      targetKey: _salesGridKey,
                      title: 'Sales Records',
                      description: 'View all sales. Tap a card for invoice details and downloads.',
                      position: CoachMarkPosition.top,
                    ),
                  ],
                  onComplete: _completeTour,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
