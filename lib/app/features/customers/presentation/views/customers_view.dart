import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tahir_showroom/app/core/constants/app_colors.dart';
import 'package:tahir_showroom/app/core/constants/app_spacing.dart';
import 'package:tahir_showroom/app/core/widgets/sidebar_navigation.dart';
import 'package:tahir_showroom/app/features/customers/presentation/controllers/customers_controller.dart';
import 'package:tahir_showroom/app/features/customers/presentation/widgets/customer_list_sidebar.dart';
import 'package:tahir_showroom/app/features/customers/presentation/widgets/customer_history_panel.dart';

/// Customers View - Customer data with sidebar and transaction history
class CustomersView extends StatelessWidget {
  const CustomersView({super.key});

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
        body: Row(
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
                    const CustomerListSidebar(),
                    const SizedBox(width: AppSpacing.lg),
                    // Main Panel: Customer History & Details
                    const CustomerHistoryPanel(),
                 ],
               ),
             ),
          ),
        ],
      ),
      ),
    );
  }
}
