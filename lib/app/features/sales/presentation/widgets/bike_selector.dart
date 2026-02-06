import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_radius.dart';
import 'package:tahir_showroom/app/core/widgets/app_text_field.dart';
import 'package:tahir_showroom/app/features/sales/presentation/controllers/new_sale_controller.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/controllers/inventory_controller.dart';
import 'package:tahir_showroom/app/features/inventory/presentation/widgets/bike_card.dart';

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
        AppTextField(
          hint: 'Search by Model, Engine #, or Chassis #',
          prefixIcon: LucideIcons.search,
          onChanged: (val) {
            invController.searchController.text = val;
            invController.bikes.refresh(); // Trigger Obx in filteredBikes
          },
        ),
        const SizedBox(height: 16),
        
        // Grouped List
        Expanded(
          child: Obx(() {
            final groupedBikes = saleController.groupedBikes;

            if (groupedBikes.isEmpty) {
              return const Center(child: Text('No available bikes found.'));
            }

            return ListView.builder(
              itemCount: groupedBikes.length,
              itemBuilder: (context, index) {
                final model = groupedBikes.keys.elementAt(index);
                final bikes = groupedBikes[model]!;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ExpansionTile(
                    title: Text(model, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (Get.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${bikes.length}', 
                        style: TextStyle(
                          color: Get.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                             crossAxisCount: 3,
                             childAspectRatio: 1.0, // Balanced for compact but readable cards
                             crossAxisSpacing: 8,
                             mainAxisSpacing: 8,
                          ),
                          itemCount: bikes.length,
                          itemBuilder: (context, bikeIndex) {
                            final bike = bikes[bikeIndex];
                            return Obx(() {
                                final isSelected = saleController.selectedBike.value == bike;
                                return GestureDetector(
                                  onTap: () {
                                    saleController.selectedBike.value = bike;
                                    // Auto-scroll to customer section
                                    Future.delayed(const Duration(milliseconds: 300), () {
                                      if (saleController.customerSectionKey.currentContext != null) {
                                        Scrollable.ensureVisible(
                                          saleController.customerSectionKey.currentContext!,
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: isSelected ? Border.all(color: AppColors.darkPrimary, width: 3) : null,
                                      borderRadius: BorderRadius.circular(AppRadius.md),
                                    ),
                                    child: BikeCard(bike: bike, compact: true),
                                  ),
                                );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
