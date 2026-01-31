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
        
        // Grid
        Expanded(
          child: Obx(() {
            // Filter only available bikes
            final bikes = invController.filteredBikes
                .where((b) => b.status == 'available')
                .toList();

            if (bikes.isEmpty) {
              return const Center(child: Text('No available bikes found.'));
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 3,
                 childAspectRatio: 0.8,
                 crossAxisSpacing: 16,
                 mainAxisSpacing: 16,
              ),
              itemCount: bikes.length,
              itemBuilder: (context, index) {
                final bike = bikes[index];
                return Obx(() {
                    final isSelected = saleController.selectedBike.value == bike;
                    return GestureDetector(
                      onTap: () => saleController.selectedBike.value = bike,
                      child: Container(
                        decoration: BoxDecoration(
                          border: isSelected ? Border.all(color: AppColors.darkPrimary, width: 3) : null,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: BikeCard(bike: bike),
                      ),
                    );
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
