import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/widgets/bike_card.dart';
import 'package:tahir_showroom/app/core/widgets/blinking_focus_builder.dart';

class BikeSelector extends StatelessWidget {
  const BikeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Put InventoryController if not exists, to fetch bikes
    final invController = Get.put(InventoryController());
    final saleController = Get.find<NewSaleController>();

    return Column(
      children: [
        // Search & Filter
        BlinkingFocusBuilder(
          focusNode: saleController.searchBikeFocus,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: invController.searchController,
            builder: (context, value, child) {
              return AppTextField(
                hint: 'Search by Model, Engine #, or Chassis #',
                prefixIcon: LucideIcons.search,
                focusNode: saleController.searchBikeFocus,
                controller: invController.searchController,
                textInputAction: TextInputAction.next,
                formNavigationManager: saleController.formNavigationManager,
                showClearIcon: value.text.isNotEmpty,
                onClear: () {
                  invController.searchController.clear();
                  invController.bikes.refresh(); // Trigger Obx in filteredBikes
                },
                onChanged: (val) {
                  // AppTextField inherently updates the controller
                  invController.bikes.refresh(); // Trigger Obx in filteredBikes
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Grouped List
        Obx(() {
            final groupedBikes = saleController.groupedBikes;

            if (groupedBikes.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('No available bikes found.')),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupedBikes.length,
              itemBuilder: (context, index) {
                final model = groupedBikes.keys.elementAt(index);
                final bikes = groupedBikes[model]!;

                return Obx(
                  () {
                    final isExpanded =
                        saleController.expandedModel.value == model;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        // Force rebuild when expansion state changes to respect initiallyExpanded
                        key: Key('${model}_${isExpanded}'),
                        initiallyExpanded: isExpanded,
                        onExpansionChanged: (expanded) {
                          if (expanded) {
                            saleController.expandedModel.value = model;
                          } else {
                            // Only clear if we are closing the currently expanded one
                            if (saleController.expandedModel.value == model) {
                              saleController.expandedModel.value = null;
                            }
                          }
                        },
                        title: Text(model,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (Get.isDarkMode
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('${bikes.length}',
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                                  fontWeight: FontWeight.bold)),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Responsive columns: 4 for wide screens, 3 for smaller, 2 for very small
                                int crossAxisCount = 4;
                                if (constraints.maxWidth < 700) {
                                  crossAxisCount = 2;
                                } else if (constraints.maxWidth < 1000) {
                                  crossAxisCount = 3;
                                }

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisExtent: 295, // Increased height to prevent overflow
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemCount: bikes.length,
                                  itemBuilder: (context, bikeIndex) {
                                    final bike = bikes[bikeIndex];
                                    return Obx(() {
                                      final isSelected =
                                          saleController.selectedBike.value == bike;
                                      return GestureDetector(
                                        onTap: () {
                                          saleController.selectedBike.value = bike;
                                          // Auto-scroll to customer section
                                          Future.delayed(
                                              const Duration(milliseconds: 300),
                                              () {
                                            if (saleController.customerSectionKey
                                                    .currentContext !=
                                                null) {
                                              Scrollable.ensureVisible(
                                                saleController.customerSectionKey
                                                    .currentContext!,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeInOut,
                                              );
                                            }
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: isSelected
                                                    ? Border.all(
                                                        color: AppColors.darkPrimary,
                                                        width: 3)
                                                    : Border.all(color: Colors.transparent, width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(AppRadius.md),
                                              ),
                                              child: BikeCard(bike: bike, compact: true),
                                            ),
                                            if (isSelected)
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.darkPrimary,
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }),
      ],
    );
  }
}
