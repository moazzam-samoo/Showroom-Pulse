import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_overlay.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_target.dart';
import 'supplier_history_view.dart';

class ProcurementView extends StatefulWidget {
  const ProcurementView({super.key});

  @override
  State<ProcurementView> createState() => _ProcurementViewState();
}

class _ProcurementViewState extends State<ProcurementView> {
  // Coach mark keys
  final GlobalKey _addSupplierKey = GlobalKey();
  final GlobalKey _supplierListKey = GlobalKey();
  final GlobalKey _historyPanelKey = GlobalKey();
  
  bool _showCoachMarks = false;

  @override
  void initState() {
    super.initState();
    _checkWalkthroughStatus();
  }

  Future<void> _checkWalkthroughStatus() async {
    final walkthroughService = Get.find<WalkthroughService>();
    if (!walkthroughService.hasCompletedTab('procurement')) {
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
    Get.find<WalkthroughService>().markTabComplete('procurement');
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          Get.offNamed('/dashboard');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                SidebarNavigation(
                  selectedIndex: 1, // Dealers is now index 1
                  onItemSelected: (index) {
                    switch (index) {
                      case 0:
                        Get.offNamed('/dashboard');
                        break;
                      case 1:
                        // Already on Procurement
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
                  },
                ),
                Expanded(
                  child: SupplierHistoryView(
                    addSupplierKey: _addSupplierKey,
                    supplierListKey: _supplierListKey,
                    historyPanelKey: _historyPanelKey,
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
                      targetKey: _addSupplierKey,
                      title: 'Add New Dealer',
                      description: 'Register new suppliers and dealers here.',
                      position: CoachMarkPosition.bottom,
                    ),
                    CoachMarkTarget(
                      targetKey: _supplierListKey,
                      title: 'Dealer Directory',
                      description: 'Browse and search all your registered dealers.',
                      position: CoachMarkPosition.right,
                    ),
                    CoachMarkTarget(
                      targetKey: _historyPanelKey,
                      title: 'Purchase History',
                      description: 'View detailed procurement records for each dealer.',
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
