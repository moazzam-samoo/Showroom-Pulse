import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/widgets/app_toast.dart';
import '../controllers/settings_controller.dart';

class InventorySettingsView extends GetView<SettingsController> {
  final GlobalKey? bikeBrandsKey;
  final GlobalKey? bikeModelsKey;

  const InventorySettingsView({
    super.key,
    this.bikeBrandsKey,
    this.bikeModelsKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final settings = controller.settings.value;
      if (settings == null) return const SizedBox.shrink();

      return ListView(
        primary: false,
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Inventory Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Bike Brands Section
          _buildManageSection(
            key: bikeBrandsKey,
            title: '🏭 Bike Brands',
            subtitle: 'Manage custom brands shown in the Brand dropdowns.',
            items: controller.getBikeBrandsList(),
            onAdd: (val) {
              controller.addBikeBrand(val);
              AppToast.showSuccess(title: 'Brand Added', message: '$val has been added.');
            },
            onDelete: (val) {
              controller.removeBikeBrand(val);
              AppToast.showInfo(title: 'Brand Removed', message: '$val has been removed.');
            },
            isDark: isDark,
            context: context,
            addHint: 'Enter new brand name (e.g. Honda)',
          ),
          
          _divider(isDark),

          // Bike Models Section
          _buildManageSection(
            key: bikeModelsKey,
            title: '🏍️ Bike Models',
            subtitle: 'Manage custom models shown in the Model dropdowns.',
            items: controller.getBikeModelsList(),
            onAdd: (val) {
              controller.addBikeModel(val);
              AppToast.showSuccess(title: 'Model Added', message: '$val has been added.');
            },
            onDelete: (val) {
              controller.removeBikeModel(val);
              AppToast.showInfo(title: 'Model Removed', message: '$val has been removed.');
            },
            isDark: isDark,
            context: context,
            addHint: 'Enter new model name (e.g. CG125)',
          ),

          _divider(isDark),

          // Bike Years Section
          _buildManageSection(
            key: null,
            title: '📅 Bike Models (Year)',
            subtitle: 'Manage custom years shown in the Year dropdowns.',
            items: controller.getBikeYearsList(),
            onAdd: (val) {
              controller.addBikeYear(val);
              AppToast.showSuccess(title: 'Year Added', message: '$val has been added.');
            },
            onDelete: (val) {
              controller.removeBikeYear(val);
              AppToast.showInfo(title: 'Year Removed', message: '$val has been removed.');
            },
            isDark: isDark,
            context: context,
            addHint: 'Enter new year (e.g. 2024)',
          ),
        ],
      );
    });
  }

  Widget _buildManageSection({
    required GlobalKey? key,
    required String title,
    required String subtitle,
    required List<String> items,
    required Function(String) onAdd,
    required Function(String) onDelete,
    required bool isDark,
    required BuildContext context,
    required String addHint,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
               ...items.map((item) => InputChip(
                 label: Text(item, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 13)),
                 backgroundColor: isDark ? AppColors.darkElevated : Colors.grey[200],
                 deleteIconColor: isDark ? Colors.white70 : Colors.black54,
                 deleteIcon: const Icon(LucideIcons.x, size: 16),
                 onDeleted: () => onDelete(item),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(AppRadius.md),
                   side: BorderSide(color: isDark ? AppColors.darkBorder : Colors.transparent),
                 ),
               )),
               ActionChip(
                 label: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Icon(LucideIcons.plus, size: 16, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                     const SizedBox(width: 4),
                     Text('Add', style: TextStyle(color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary)),
                   ],
                 ),
                 backgroundColor: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withValues(alpha: 0.1),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(AppRadius.md),
                   side: BorderSide(color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                 ),
                 onPressed: () => _showAddDialog(context, title, addHint, onAdd, isDark),
               ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, String title, String hint, Function(String) onAdd, bool isDark) {
    final textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text('Add to $title', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary)),
          ),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              Get.back();
              onAdd(val.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final val = textController.text.trim();
               if (val.isNotEmpty) {
                  Get.back();
                  onAdd(val);
               }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Divider(
        color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        height: 1,
      ),
    );
  }
}
