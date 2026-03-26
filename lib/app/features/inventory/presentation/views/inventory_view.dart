import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/data/models/bike.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/widgets/bike_card.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/widgets/bike_filter_bar.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/widgets/add_bike_dialog.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/widgets/edit_bike_dialog.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/widgets/bike_detail_dialog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tahir_showroom/app/core/services/walkthrough_service.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_overlay.dart';
import 'package:tahir_showroom/app/features/walkthrough/presentation/widgets/coach_mark_target.dart';

/// Inventory View
///
/// Analyzed from: Dark Theme UI/Inventory Page.png
/// Layout:
/// - Sidebar navigation (left)
/// - Main content:
///   - Filter bar (search, add button, dropdowns)
///   - Grid of bike cards (4 columns)
class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  late final FocusNode _focusNode;

  // Coach mark keys
  final GlobalKey _filterBarKey = GlobalKey();
  final GlobalKey _addBtnKey = GlobalKey();
  final GlobalKey _bikeGridKey = GlobalKey();
  
  bool _showCoachMarks = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Request focus after the first frame so we don't steal it from transitions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
    _checkWalkthroughStatus();
  }

  Future<void> _checkWalkthroughStatus() async {
    final walkthroughService = Get.find<WalkthroughService>();
    if (!walkthroughService.hasCompletedTab('inventory')) {
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
    Get.find<WalkthroughService>().markTabComplete('inventory');
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KeyboardListener(
      focusNode: _focusNode,
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
                  selectedIndex: 2, // Inventory is now index 2
                  onItemSelected: (index) {
                    // Navigate based on index
                    switch (index) {
                      case 0:
                        Get.offNamed('/dashboard');
                        break;
                      case 1:
                         Get.offNamed('/procurement');
                         break;
                      case 2:
                        // Already on inventory
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
                // Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inventory Management',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Filter Bar
                        Container(
                          key: _filterBarKey,
                          child: Obx(() => BikeFilterBar(
                            searchController: controller.searchController,
                            selectedBrand: controller.selectedBrand.value,
                            selectedCC: controller.selectedCC.value,
                            selectedStatus: controller.selectedStatus.value,
                            selectedCondition: controller.selectedCondition.value,
                            selectedColor: controller.selectedColor.value,
                            selectedSkin: controller.selectedSkin.value,
                            minPrice: controller.minPrice.value,
                            maxPrice: controller.maxPrice.value,
                            onBrandChanged: (v) => controller.selectedBrand.value = v,
                            onCCChanged: (v) => controller.selectedCC.value = v,
                            onStatusChanged: (v) => controller.selectedStatus.value = v,
                            onConditionChanged: (v) => controller.selectedCondition.value = v,
                            onColorChanged: (v) {
                              controller.selectedColor.value = v;
                              if (v != null) controller.selectedSkin.value = null;
                            },
                            onSkinChanged: (v) {
                              controller.selectedSkin.value = v;
                              if (v != null) controller.selectedColor.value = null;
                            },
                            onMinPriceChanged: (v) => controller.minPrice.value = v,
                            onMaxPriceChanged: (v) => controller.maxPrice.value = v,
                            onClearFilters: () {
                              controller.searchController.clear();
                              controller.selectedBrand.value = null;
                              controller.selectedCC.value = null;
                              controller.selectedStatus.value = null;
                              controller.selectedCondition.value = null;
                              controller.selectedColor.value = null;
                              controller.selectedSkin.value = null;
                              controller.minPrice.value = null;
                              controller.maxPrice.value = null;
                            },
                            onAddBike: () => _showAddBikeDialog(context, controller),
                            addBtnKey: _addBtnKey,
                          )),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Bike Grid
                        Expanded(
                          key: _bikeGridKey,
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            
                            return _buildBikeGrid(context, controller, isDark);
                          }),
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
                      targetKey: _filterBarKey,
                      title: 'Search & Filters',
                      description: 'Find bikes instantly by brand, CC, status, or price.',
                      position: CoachMarkPosition.bottom,
                    ),
                    CoachMarkTarget(
                      targetKey: _addBtnKey,
                      title: 'Add New Bike',
                      description: 'Add new bikes to your inventory with full details.',
                      position: CoachMarkPosition.bottom,
                    ),
                    CoachMarkTarget(
                      targetKey: _bikeGridKey,
                      title: 'Inventory Grid',
                      description: 'View all bikes at a glance. Tap any card for details or editing.',
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

  Widget _buildBikeGrid(BuildContext context, InventoryController controller, bool isDark) {
    final filteredBikes = controller.filteredBikes;

    if (filteredBikes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.packageX,
              size: 64,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'No bikes found',
              style: TextStyle(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or add a new bike',
              style: TextStyle(
                color: isDark ? AppColors.darkTextDisabled : AppColors.lightTextMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive columns: 4 for wide screens, 3 for smaller, 2 for very small
        int crossAxisCount = 4;
        if (constraints.maxWidth < 700) {
          crossAxisCount = 2;
        } else if (constraints.maxWidth < 1000) crossAxisCount = 3;

        return Scrollbar(
          child: MasonryGridView.count(
          padding: const EdgeInsets.only(right: AppSpacing.md, bottom: AppSpacing.xl),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.base,
          mainAxisSpacing: AppSpacing.base,
          itemCount: filteredBikes.length,
          itemBuilder: (context, index) {
            final bike = filteredBikes[index];
            return BikeCard(
              bike: bike,
              onTap: () => _showBikeDetails(bike),
              // Only prevent editing for sold bikes
              onEdit: bike.status != BikeStatusEnum.sold 
                  ? () => _editBike(context, bike) 
                  : null,
              onDelete: () => _deleteBike(context, controller, bike),
            );
          },
        ),
        );
      },
    );
  }

  void _showAddBikeDialog(BuildContext context, InventoryController controller) {
    showDialog(
      context: context,
      builder: (context) => AddBikeDialog(
        onSave: (data) {
          controller.addBike(data);
        },
      ),
    );
  }

  void _showBikeDetails(Bike bike) async {
    final controller = Get.find<InventoryController>();
    
    // Quick lookups
    final sale = await controller.getSaleForBike(bike.id);
    final customer = await controller.getCustomerBySale(sale);
    final supplier = await controller.getSupplierForBike(bike);

    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        builder: (context) => BikeDetailDialog(
          bike: bike,
          sale: sale,
          customer: customer,
          supplier: supplier,
        ),
      );
    }
  }

  void _editBike(BuildContext context, Bike bike) {
    showDialog(
      context: context,
      builder: (context) => EditBikeDialog(
        bike: bike,
        onSave: (data) {
          final controller = Get.find<InventoryController>();
          controller.updateBikeDetails(bike, data);
        },
      ),
    );
  }


  void _deleteBike(BuildContext context, InventoryController controller, Bike bike) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bike'),
        content: Text('Are you sure you want to delete ${bike.model}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteBike(bike);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
