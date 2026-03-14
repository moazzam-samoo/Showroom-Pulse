import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/features/customers/presentation/controllers/customers_controller.dart';
import 'package:tahir_showroom/app/features/customers/presentation/widgets/customer_list_sidebar.dart';
import 'package:tahir_showroom/app/features/customers/presentation/widgets/customer_history_panel.dart';

import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_overlay.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_target.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart';

/// Customers View - Customer data with sidebar and transaction history
class CustomersView extends StatefulWidget {
  const CustomersView({super.key});

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  // Coach mark keys
  final GlobalKey _customerListKey = GlobalKey();
  final GlobalKey _customerHistoryKey = GlobalKey();
  final GlobalKey _globalDownloadBtnKey = GlobalKey();
  
  bool _showCoachMarks = false;

  @override
  void initState() {
    super.initState();
    _checkWalkthroughStatus();
  }

  Future<void> _checkWalkthroughStatus() async {
    final walkthroughService = Get.find<WalkthroughService>();
    if (!walkthroughService.hasCompletedTab('customers')) {
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
    Get.find<WalkthroughService>().markTabComplete('customers');
  }

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(CustomersController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                // Sidebar Navigation (Global App Nav)
                SidebarNavigation(
                  selectedIndex: 5, // Customers tab
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
                        Get.offNamed('/sales');
                        break;
                      case 4:
                        Get.offNamed('/installments');
                        break;
                      case 5:
                        // Already on Customers
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
                
                // Main Content Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          // Inner Sidebar: Customer List
                          Container(
                            key: _customerListKey,
                            child: CustomerListSidebar(
                              downloadBtnKey: _globalDownloadBtnKey,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          // Main Panel: Customer History & Details
                          Container(
                            key: _customerHistoryKey,
                            child: const CustomerHistoryPanel(),
                          ),
                      ],
                    ),
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
                      targetKey: _customerListKey,
                      title: 'Customer Directory',
                      description: 'Browse all customers, add new ones, or search existing profiles.',
                      position: CoachMarkPosition.right,
                    ),
                    CoachMarkTarget(
                      targetKey: _globalDownloadBtnKey,
                      title: 'Global Download',
                      description: 'Export all customers\' data and their images into a single ZIP file.',
                      position: CoachMarkPosition.bottom,
                    ),
                    CoachMarkTarget(
                      targetKey: _customerHistoryKey,
                      title: 'Purchase History',
                      description: 'View individual customer details, transactions, and download their specific statements.',
                      position: CoachMarkPosition.left,
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
