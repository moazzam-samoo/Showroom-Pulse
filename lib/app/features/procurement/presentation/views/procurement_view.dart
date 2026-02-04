import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'supplier_history_view.dart';

class ProcurementView extends StatelessWidget {
  const ProcurementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
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
                  Get.offNamed('/customers');
                  break;
                case 5:
                  Get.offNamed('/reports');
                  break;
                case 6:
                  Get.offNamed('/settings');
                  break;
              }
            },
          ),
          const Expanded(
            child: SupplierHistoryView(),
          ),
        ],
      ),
    );
  }
}
